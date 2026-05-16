import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/car.dart';
import '../models/car_generation.dart';
import '../providers/car_provider.dart';
import '../widgets/car_card.dart';
import '../theme/app_theme.dart';
import 'car_detail_screen.dart';

/// Step 4: tapped a generation → grid of variants in that generation.
class GenerationVariantsScreen extends StatelessWidget {
  final CarGeneration generation;
  const GenerationVariantsScreen({super.key, required this.generation});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CarProvider>();
    final variants = provider.variantsForGeneration(generation.id);

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
                    child: _GenerationHeader(
                      generation: generation,
                      variantCount: variants.length,
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: AppTheme.lg)),
                  if (variants.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: _EmptyState(),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                          AppTheme.lg, 0, AppTheme.lg, 120),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.66,
                          crossAxisSpacing: AppTheme.md,
                          mainAxisSpacing: AppTheme.md,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, i) {
                            final v = variants[i];
                            return CarCard(
                              car: v,
                              onTap: () => _open(context, v),
                            );
                          },
                          childCount: variants.length,
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

  void _open(BuildContext context, Car car) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CarDetailScreen(car: car)),
    );
  }
}

class _GenerationHeader extends StatelessWidget {
  final CarGeneration generation;
  final int variantCount;

  const _GenerationHeader({
    required this.generation,
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
          Row(
            children: [
              Text(generation.yearLabel.toUpperCase(),
                  style: AppTheme.eyebrow(color: AppTheme.textPrimary)),
              if (generation.isCurrent) ...[
                const SizedBox(width: AppTheme.md),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.accent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'AKTIF',
                    style: AppTheme.eyebrow(color: Colors.white),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppTheme.lg),
          Text(generation.name, style: AppTheme.display(size: 36)),
          const SizedBox(height: AppTheme.md),
          Text(
            '$variantCount varian tercatat di generasi ini.',
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
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
            Text('BELUM ADA VARIAN',
                style: AppTheme.eyebrow(color: AppTheme.textPrimary)),
            const SizedBox(height: AppTheme.md),
            const Text(
              'Generasi ini belum punya varian tercatat.',
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
