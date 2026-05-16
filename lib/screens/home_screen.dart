import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/car_provider.dart';
import '../data/brand_info.dart';
import '../theme/app_theme.dart';
import '../widgets/brand_logo.dart';
import 'brand_models_screen.dart';

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
            pageBuilder: (_, anim, __) => BrandModelsScreen(brand: brand),
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
