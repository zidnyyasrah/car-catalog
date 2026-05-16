import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/car_provider.dart';
import '../data/brand_info.dart';
import '../theme/app_theme.dart';
import '../widgets/brand_logo.dart';
import 'brand_cars_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        bottom: false,
        child: Consumer<CarProvider>(
          builder: (_, provider, __) {
            if (provider.loading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppTheme.accent,
                  strokeWidth: 2,
                ),
              );
            }
            if (provider.error != null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.xl),
                  child: Text(
                    'Error: ${provider.error}',
                    style: const TextStyle(color: AppTheme.accent),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            return CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: _DisplayHeading()),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                      AppTheme.xl, AppTheme.sm, AppTheme.xl, 120),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.92,
                      crossAxisSpacing: AppTheme.md,
                      mainAxisSpacing: AppTheme.md,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final brand = provider.brands[index];
                        final count = provider.brandCounts[brand] ?? 0;
                        return _BrandCard(brand: brand, carCount: count);
                      },
                      childCount: provider.brands.length,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DisplayHeading extends StatelessWidget {
  const _DisplayHeading();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppTheme.xl, AppTheme.xxl, AppTheme.xl, AppTheme.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Katalog mobil', style: AppTheme.display(size: 44)),
          Text(
            'Indonesia.',
            style: AppTheme.display(color: AppTheme.accent, size: 44),
          ),
        ],
      ),
    );
  }
}

class _StatStrip extends StatelessWidget {
  final CarProvider provider;
  const _StatStrip({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppTheme.xl, AppTheme.xl, AppTheme.xl, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _BigStat(value: '${provider.brands.length}', label: 'BRAND'),
          const SizedBox(width: AppTheme.xl),
          Container(width: 1, height: 56, color: AppTheme.hairline),
          const SizedBox(width: AppTheme.xl),
          _BigStat(value: '${provider.totalCars}', label: 'MOBIL'),
          const Spacer(),
          _ElectricBadge(count: provider.totalElectric),
        ],
      ),
    );
  }
}

class _BigStat extends StatelessWidget {
  final String value;
  final String label;

  const _BigStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: AppTheme.numeral(size: 48)),
        const SizedBox(height: AppTheme.sx),
        Text(label, style: AppTheme.eyebrow()),
      ],
    );
  }
}

class _ElectricBadge extends StatelessWidget {
  final int count;
  const _ElectricBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.md, vertical: AppTheme.sm),
      decoration: BoxDecoration(
        color: AppTheme.electric.withOpacity(0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppTheme.electric.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bolt_rounded, size: 14, color: AppTheme.electric),
          const SizedBox(width: AppTheme.sx),
          Text(
            '$count EV',
            style: const TextStyle(
              color: AppTheme.electric,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final String? count;

  const _SectionLabel({required this.label, this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppTheme.xl, 0, AppTheme.xl, 0),
      child: Row(
        children: [
          Text(label, style: AppTheme.eyebrow(color: AppTheme.textPrimary)),
          const SizedBox(width: AppTheme.md),
          Expanded(child: Container(height: 1, color: AppTheme.hairline)),
          if (count != null) ...[
            const SizedBox(width: AppTheme.md),
            Text(count!, style: AppTheme.eyebrow()),
          ],
        ],
      ),
    );
  }
}

class _BrandCard extends StatelessWidget {
  final String brand;
  final int carCount;

  const _BrandCard({required this.brand, required this.carCount});

  @override
  Widget build(BuildContext context) {
    final info = brandInfoFor(brand);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: AppTheme.motionSlow,
            pageBuilder: (_, anim, __) => BrandCarsScreen(brand: brand),
            transitionsBuilder: (_, anim, __, child) {
              return FadeTransition(opacity: anim, child: child);
            },
          ),
        ),
        child: Hero(
          tag: 'brand-$brand',
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.surface.withOpacity(0.4),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppTheme.hairline),
              ),
              padding: const EdgeInsets.fromLTRB(
                  AppTheme.md, AppTheme.lg, AppTheme.md, AppTheme.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.sm, vertical: AppTheme.sm),
                      child: BrandLogo(
                        info: info,
                        tint: AppTheme.textPrimary,
                        fallbackFontSize: 28,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.md),
                  Container(height: 1, color: AppTheme.hairline),
                  const SizedBox(height: AppTheme.md),
                  Row(
                    children: [
                      Text(
                        brand.toUpperCase(),
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.4,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        carCount.toString().padLeft(2, '0'),
                        style: AppTheme.eyebrow(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
