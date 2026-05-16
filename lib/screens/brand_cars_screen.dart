import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/car.dart';
import '../providers/car_provider.dart';
import '../data/brand_info.dart';
import '../widgets/car_card.dart';
import '../widgets/brand_logo.dart';
import '../theme/app_theme.dart';
import 'car_detail_screen.dart';

class BrandCarsScreen extends StatefulWidget {
  final String brand;
  const BrandCarsScreen({super.key, required this.brand});

  @override
  State<BrandCarsScreen> createState() => _BrandCarsScreenState();
}

class _BrandCarsScreenState extends State<BrandCarsScreen> {
  String _search = '';
  String? _bodyTypeFilter;

  @override
  Widget build(BuildContext context) {
    final info = brandInfoFor(widget.brand);
    final provider = context.watch<CarProvider>();
    final brandCars = provider.carsForBrand(widget.brand);
    final bodyTypes = brandCars.map((c) => c.bodyType).toSet().toList()..sort();

    final filtered = brandCars.where((c) {
      if (_bodyTypeFilter != null && c.bodyType != _bodyTypeFilter) return false;
      if (_search.isNotEmpty) {
        final q = _search.toLowerCase();
        return c.type.toLowerCase().contains(q) ||
            c.variant.toLowerCase().contains(q);
      }
      return true;
    }).toList();

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
                      brand: widget.brand,
                      info: info,
                      count: brandCars.length,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                          AppTheme.xl, AppTheme.xl, AppTheme.xl, AppTheme.md),
                      child: _SearchField(
                        hint: 'Cari di ${widget.brand}...',
                        onChanged: (v) => setState(() => _search = v),
                      ),
                    ),
                  ),
                  if (bodyTypes.length > 1)
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 36,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.xl),
                          itemCount: bodyTypes.length + 1,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: AppTheme.sm),
                          itemBuilder: (_, i) {
                            if (i == 0) {
                              return _FilterChip(
                                label: 'Semua',
                                selected: _bodyTypeFilter == null,
                                onTap: () =>
                                    setState(() => _bodyTypeFilter = null),
                              );
                            }
                            final bt = bodyTypes[i - 1];
                            return _FilterChip(
                              label: bt,
                              selected: _bodyTypeFilter == bt,
                              onTap: () =>
                                  setState(() => _bodyTypeFilter = bt),
                            );
                          },
                        ),
                      ),
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: AppTheme.lg)),
                  if (filtered.isEmpty)
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
                          (context, index) {
                            final car = filtered[index];
                            return CarCard(
                              car: car,
                              onTap: () => _openDetail(context, car),
                            );
                          },
                          childCount: filtered.length,
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

  void _openDetail(BuildContext context, Car car) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CarDetailScreen(car: car)),
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
          _IconBtn(
            icon: Icons.arrow_back_rounded,
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.surface.withOpacity(0.6),
      shape: const CircleBorder(
        side: BorderSide(color: AppTheme.hairline),
      ),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, size: 18, color: AppTheme.textPrimary),
        ),
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  final String brand;
  final BrandInfo info;
  final int count;

  const _BrandHeader({
    required this.brand,
    required this.info,
    required this.count,
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
          Text(
            brand,
            style: AppTheme.display(size: 44),
          ),
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
              _MetaStat(value: '$count', label: 'MOBIL'),
              const SizedBox(width: AppTheme.xl),
              Container(width: 1, height: 40, color: AppTheme.hairline),
              const SizedBox(width: AppTheme.xl),
              _MetaStat(value: '${info.foundedYear}', label: 'SEJAK'),
              const SizedBox(width: AppTheme.xl),
              Container(width: 1, height: 40, color: AppTheme.hairline),
              const SizedBox(width: AppTheme.xl),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      info.country.toUpperCase(),
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('ASAL', style: AppTheme.eyebrow()),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetaStat extends StatelessWidget {
  final String value;
  final String label;

  const _MetaStat({required this.value, required this.label});

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

class _SearchField extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;

  const _SearchField({required this.hint, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.hairline),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.lg),
      child: Row(
        children: [
          const Icon(Icons.search_rounded,
              size: 18, color: AppTheme.textMuted),
          const SizedBox(width: AppTheme.md),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              style: const TextStyle(
                  color: AppTheme.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                    color: AppTheme.textMuted, fontSize: 14),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isCollapsed: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: AppTheme.lg),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppTheme.motionFast,
          padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.lg, vertical: AppTheme.sm),
          decoration: BoxDecoration(
            color: selected ? AppTheme.textPrimary : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected ? AppTheme.textPrimary : AppTheme.hairline,
            ),
          ),
          child: Text(
            label.toUpperCase(),
            style: TextStyle(
              color: selected ? AppTheme.background : AppTheme.textSecondary,
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
        ),
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
            Text('TIDAK ADA HASIL',
                style: AppTheme.eyebrow(color: AppTheme.textPrimary)),
            const SizedBox(height: AppTheme.md),
            Text(
              'Tidak ada mobil yang cocok\ndengan pencarianmu.',
              textAlign: TextAlign.center,
              style: const TextStyle(
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
