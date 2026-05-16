import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/car_model.dart';
import '../providers/car_provider.dart';
import '../data/brand_info.dart';
import '../widgets/brand_logo.dart';
import '../theme/app_theme.dart';
import 'model_generations_screen.dart';

/// Step 2 of the user journey: tapped a brand → list of models for it.
class BrandModelsScreen extends StatelessWidget {
  final String brand;
  const BrandModelsScreen({super.key, required this.brand});

  @override
  Widget build(BuildContext context) {
    final info = brandInfoFor(brand);
    final provider = context.watch<CarProvider>();
    final models = provider.modelsForBrand(brand);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _TopBar(),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: _BrandHeader(
                      brand: brand,
                      info: info,
                      modelCount: models.length,
                      variantCount: provider.brandCounts[brand] ?? 0,
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: AppTheme.lg)),
                  if (models.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: _EmptyState(),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                          AppTheme.xl, 0, AppTheme.xl, 120),
                      sliver: SliverList.separated(
                        itemCount: models.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppTheme.md),
                        itemBuilder: (_, i) => _ModelCard(model: models[i]),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModelCard extends StatelessWidget {
  final CarModel model;
  const _ModelCard({required this.model});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: AppTheme.motionSlow,
            pageBuilder: (_, anim, __) => ModelGenerationsScreen(model: model),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.surface.withOpacity(0.5),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppTheme.hairline),
          ),
          clipBehavior: Clip.hardEdge,
          child: Row(
            children: [
              SizedBox(
                width: 132,
                height: 132,
                child: CachedNetworkImage(
                  imageUrl: model.heroImageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) =>
                      Container(color: AppTheme.surfaceElevated),
                  errorWidget: (_, __, ___) => Container(
                    color: AppTheme.surfaceElevated,
                    child: const Icon(Icons.directions_car_outlined,
                        color: AppTheme.textMuted, size: 32),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(model.bodyType.toUpperCase(),
                          style: AppTheme.eyebrow()),
                      const SizedBox(height: AppTheme.sm),
                      Text(
                        model.name,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                          height: 1.05,
                        ),
                      ),
                      const SizedBox(height: AppTheme.sm),
                      Text(
                        model.yearSpanLabel,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: AppTheme.md),
                      Row(
                        children: [
                          _MiniStat(
                              value: '${model.generationCount}',
                              label: 'GEN'),
                          const SizedBox(width: AppTheme.lg),
                          Container(
                              width: 1, height: 22, color: AppTheme.hairline),
                          const SizedBox(width: AppTheme.lg),
                          _MiniStat(
                              value: '${model.variantCount}',
                              label: 'VARIAN'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: AppTheme.lg),
                child: Icon(Icons.chevron_right_rounded,
                    color: AppTheme.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String value;
  final String label;
  const _MiniStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: AppTheme.numeral(size: 18)),
        const SizedBox(height: 2),
        Text(label, style: AppTheme.eyebrow()),
      ],
    );
  }
}

class _BrandHeader extends StatelessWidget {
  final String brand;
  final BrandInfo info;
  final int modelCount;
  final int variantCount;

  const _BrandHeader({
    required this.brand,
    required this.info,
    required this.modelCount,
    required this.variantCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppTheme.xl, AppTheme.xl, AppTheme.xl, AppTheme.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'brand-$brand',
            child: Material(
              color: Colors.transparent,
              child: SizedBox(
                height: 56,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: BrandLogo(
                    info: info,
                    tint: AppTheme.textPrimary,
                    fallbackFontSize: 36,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppTheme.xl),
          Text(brand, style: AppTheme.display(size: 44)),
          const SizedBox(height: AppTheme.sm),
          Text(
            info.tagline,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 13,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: AppTheme.xl),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _Stat(value: '$modelCount', label: 'MODEL'),
              const SizedBox(width: AppTheme.xl),
              Container(width: 1, height: 40, color: AppTheme.hairline),
              const SizedBox(width: AppTheme.xl),
              _Stat(value: '$variantCount', label: 'VARIAN'),
              const SizedBox(width: AppTheme.xl),
              Container(width: 1, height: 40, color: AppTheme.hairline),
              const SizedBox(width: AppTheme.xl),
              _Stat(value: '${info.foundedYear}', label: 'SEJAK'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  const _Stat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: AppTheme.numeral(size: 28)),
        const SizedBox(height: 4),
        Text(label, style: AppTheme.eyebrow()),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppTheme.lg, AppTheme.md, AppTheme.lg, 0),
      child: Row(
        children: [
          Material(
            color: AppTheme.surface.withOpacity(0.6),
            shape: const CircleBorder(
              side: BorderSide(color: AppTheme.hairline),
            ),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => Navigator.pop(context),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.arrow_back_rounded,
                    size: 18, color: AppTheme.textPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('BELUM ADA MODEL',
                style: AppTheme.eyebrow(color: AppTheme.textPrimary)),
            const SizedBox(height: AppTheme.md),
            const Text(
              'Brand ini belum punya model dalam katalog.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textMuted,
                fontSize: 13,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
