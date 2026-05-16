import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/car_generation.dart';
import '../models/car_model.dart';
import '../providers/car_provider.dart';
import '../theme/app_theme.dart';
import 'generation_detail_screen.dart';

/// Step 3: tapped a model → vertical timeline of its generations
/// (newest first), each tappable to view variants.
class ModelGenerationsScreen extends StatelessWidget {
  final CarModel model;
  const ModelGenerationsScreen({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CarProvider>();
    final generations = provider.generationsForModel(model.id);

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
                    child: _ModelHeader(
                      model: model,
                      generationCount: generations.length,
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: AppTheme.lg)),
                  if (generations.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: _EmptyState(),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                          AppTheme.xl, 0, AppTheme.xl, 120),
                      sliver: SliverList.builder(
                        itemCount: generations.length,
                        itemBuilder: (_, i) => _TimelineRow(
                          generation: generations[i],
                          index: i,
                          isLast: i == generations.length - 1,
                        ),
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

/// A vertical timeline-style row: small year stripe on the left, big card on the right.
class _TimelineRow extends StatelessWidget {
  final CarGeneration generation;
  final int index;
  final bool isLast;

  const _TimelineRow({
    required this.generation,
    required this.index,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Timeline rail ─────────────────────────────────────────────────
          SizedBox(
            width: 72,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: AppTheme.lg),
                Text(
                  '${generation.yearStart}',
                  style: AppTheme.numeral(size: 18),
                ),
                const SizedBox(height: 2),
                Text(
                  generation.yearEnd == null ? 'SEKARANG' : '${generation.yearEnd}',
                  style: AppTheme.eyebrow(
                      color: generation.isCurrent
                          ? AppTheme.accent
                          : AppTheme.textMuted),
                ),
                const SizedBox(height: AppTheme.sm),
                Expanded(
                  child: Container(
                    width: 1,
                    color: isLast ? Colors.transparent : AppTheme.hairline,
                  ),
                ),
              ],
            ),
          ),
          // ── Card ──────────────────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: isLast ? 0 : AppTheme.md, left: AppTheme.sm),
              child: _GenerationCard(generation: generation),
            ),
          ),
        ],
      ),
    );
  }
}

class _GenerationCard extends StatelessWidget {
  final CarGeneration generation;
  const _GenerationCard({required this.generation});

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
            pageBuilder: (_, anim, __) =>
                GenerationDetailScreen(generation: generation),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.surface.withOpacity(0.5),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: generation.isCurrent
                  ? AppTheme.accent.withOpacity(0.35)
                  : AppTheme.hairline,
            ),
          ),
          clipBehavior: Clip.hardEdge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: generation.heroImageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          Container(color: AppTheme.surfaceElevated),
                      errorWidget: (_, __, ___) => Container(
                        color: AppTheme.surfaceElevated,
                        child: const Icon(Icons.directions_car_outlined,
                            color: AppTheme.textMuted, size: 36),
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                          stops: const [0.5, 1.0],
                        ),
                      ),
                    ),
                    if (generation.isCurrent)
                      Positioned(
                        top: AppTheme.md,
                        right: AppTheme.md,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.accent,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'AKTIF',
                            style: AppTheme.eyebrow(color: Colors.white),
                          ),
                        ),
                      ),
                    Positioned(
                      left: AppTheme.md,
                      bottom: AppTheme.md,
                      right: AppTheme.md,
                      child: Text(
                        generation.yearLabel.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppTheme.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(generation.name,
                        style: AppTheme.display(size: 22)),
                    const SizedBox(height: AppTheme.md),
                    Row(
                      children: [
                        Text('${generation.variantCount}',
                            style: AppTheme.numeral(size: 18)),
                        const SizedBox(width: AppTheme.sm),
                        Text('VARIAN', style: AppTheme.eyebrow()),
                        const Spacer(),
                        const Icon(Icons.chevron_right_rounded,
                            color: AppTheme.textMuted),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModelHeader extends StatelessWidget {
  final CarModel model;
  final int generationCount;

  const _ModelHeader({
    required this.model,
    required this.generationCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppTheme.xl, AppTheme.xl, AppTheme.xl, AppTheme.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${model.brand.toUpperCase()}  ·  ${model.bodyType.toUpperCase()}',
            style: AppTheme.eyebrow(color: AppTheme.textPrimary),
          ),
          const SizedBox(height: AppTheme.lg),
          Text(model.name, style: AppTheme.display(size: 44)),
          const SizedBox(height: AppTheme.sm),
          Text(
            model.yearSpanLabel,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: AppTheme.lg),
          if (model.description.isNotEmpty)
            Text(
              model.description,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
                height: 1.6,
              ),
            ),
          const SizedBox(height: AppTheme.xl),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _Stat(value: '$generationCount', label: 'GENERASI'),
              const SizedBox(width: AppTheme.xl),
              Container(width: 1, height: 40, color: AppTheme.hairline),
              const SizedBox(width: AppTheme.xl),
              _Stat(value: '${model.variantCount}', label: 'VARIAN'),
            ],
          ),
          const SizedBox(height: AppTheme.xl),
          Container(height: 1, color: AppTheme.hairline),
          const SizedBox(height: AppTheme.md),
          Text('LINIMASA GENERASI',
              style: AppTheme.eyebrow(color: AppTheme.textPrimary)),
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
            Text('BELUM ADA GENERASI',
                style: AppTheme.eyebrow(color: AppTheme.textPrimary)),
            const SizedBox(height: AppTheme.md),
            const Text(
              'Model ini belum punya generasi tercatat.',
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
