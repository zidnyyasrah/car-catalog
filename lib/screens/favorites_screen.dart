import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/car_provider.dart';
import '../widgets/car_card.dart';
import '../theme/app_theme.dart';
import 'car_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        bottom: false,
        child: Consumer<CarProvider>(
          builder: (_, provider, __) {
            final cars = provider.favoriteCars;

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        AppTheme.xl, AppTheme.xxl, AppTheme.xl, AppTheme.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mobil', style: AppTheme.display(size: 44)),
                        Text(
                          'favorit.',
                          style: AppTheme.display(
                              color: AppTheme.accent, size: 44),
                        ),
                        const SizedBox(height: AppTheme.lg),
                        Text(
                          cars.length.toString().padLeft(2, '0'),
                          style: AppTheme.numeral(size: 28),
                        ),
                        const SizedBox(height: AppTheme.sx),
                        Text('DISIMPAN', style: AppTheme.eyebrow()),
                      ],
                    ),
                  ),
                ),
                if (cars.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyState(),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                        AppTheme.lg, AppTheme.lg, AppTheme.lg, 120),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.66,
                        crossAxisSpacing: AppTheme.md,
                        mainAxisSpacing: AppTheme.md,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final car = cars[index];
                          return CarCard(
                            car: car,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CarDetailScreen(car: car),
                              ),
                            ),
                          );
                        },
                        childCount: cars.length,
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

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('BELUM ADA',
              style: AppTheme.eyebrow(color: AppTheme.textPrimary)),
          const SizedBox(height: AppTheme.md),
          const Text(
            'Tap ikon hati pada mobil\nuntuk menyimpan ke favorit.',
            style: TextStyle(
              color: AppTheme.textMuted,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
