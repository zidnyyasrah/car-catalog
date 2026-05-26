import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/car_provider.dart';
import '../data/brand_info.dart';
import '../theme/app_theme.dart';
import '../widgets/brand_logo.dart';
import '../widgets/admin_actions.dart';
import 'brand_models_screen.dart';
import 'forms/brand_form_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 76),
        child: FloatingActionButton.extended(
          backgroundColor: AppTheme.accent,
          foregroundColor: AppTheme.onAccent,
          elevation: 0,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BrandFormScreen()),
          ),
          icon: const Icon(Icons.add_rounded),
          label: Text('BRAND',
              style: AppTheme.eyebrow(color: AppTheme.onAccent)
                  .copyWith(fontSize: 12)),
        ),
      ),
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
          AppTheme.lg, AppTheme.xl, AppTheme.lg, AppTheme.lg),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusCard),
          ),
          padding: const EdgeInsets.fromLTRB(
              AppTheme.xl, AppTheme.xxl, AppTheme.xl, AppTheme.xl),
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              // Color blobs — the reference's signature decorative move.
              Positioned(
                top: -56,
                right: -40,
                child: _Blob(
                    size: 160, color: AppTheme.accent.withOpacity(0.95)),
              ),
              Positioned(
                top: 12,
                right: 90,
                child: _Blob(
                    size: 56, color: AppTheme.electric.withOpacity(0.9)),
              ),
              Positioned(
                bottom: -28,
                right: 28,
                child: _Diamond(
                    size: 22, color: AppTheme.accent.withOpacity(0.9)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('KATALOG',
                      style: AppTheme.eyebrow(color: AppTheme.accent)),
                  const SizedBox(height: AppTheme.lg),
                  Text('Mobil', style: AppTheme.display(size: 44)),
                  Text(
                    'Indonesia.',
                    style: AppTheme.display(
                        color: AppTheme.accent, size: 44),
                  ),
                  const SizedBox(height: AppTheme.md),
                  const SizedBox(
                    width: 220,
                    child: Text(
                      'Telusuri tiap brand, model, dan generasi — dari city hatch hingga SUV ladder-frame.',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                        height: 1.55,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  final double size;
  final Color color;
  const _Blob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _Diamond extends StatelessWidget {
  final double size;
  final Color color;
  const _Diamond({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.785398, // 45° — diamond
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
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
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
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
        onLongPress: () => AdminActionSheet.show(
          context,
          title: brand,
          subtitle: '$carCount varian dalam katalog',
          onEdit: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BrandFormScreen(
                existingName: brand,
                existingCountry: info.country,
              ),
            ),
          ),
          onDelete: () async {
            final provider = context.read<CarProvider>();
            final ok = await confirmDelete(
              context,
              title: 'Hapus $brand?',
              message:
                  'Semua model, generasi, dan varian di bawah brand ini akan ikut hilang.',
            );
            if (!ok) return;
            await provider.removeBrand(brand);
          },
        ),
        child: Hero(
          tag: 'brand-$brand',
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(AppTheme.radiusCard),
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
