import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/car.dart';
import '../providers/car_provider.dart';
import '../data/brand_info.dart';
import '../widgets/car_card.dart';
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
      body: CustomScrollView(
        slivers: [
          _BrandHeader(brand: widget.brand, info: info, count: brandCars.length),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: TextField(
                onChanged: (v) => setState(() => _search = v),
                style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Cari di ${widget.brand}...',
                  prefixIcon: const Icon(Icons.search,
                      color: AppTheme.textMuted, size: 20),
                ),
              ),
            ),
          ),
          if (bodyTypes.length > 1)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: bodyTypes.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    if (i == 0) {
                      return _BodyTypeChip(
                        label: 'Semua',
                        selected: _bodyTypeFilter == null,
                        color: info.primary,
                        onTap: () => setState(() => _bodyTypeFilter = null),
                      );
                    }
                    final bt = bodyTypes[i - 1];
                    return _BodyTypeChip(
                      label: bt,
                      selected: _bodyTypeFilter == bt,
                      color: info.primary,
                      onTap: () => setState(() => _bodyTypeFilter = bt),
                    );
                  },
                ),
              ),
            ),
          if (filtered.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off,
                          size: 56, color: AppTheme.textMuted),
                      SizedBox(height: 12),
                      Text(
                        'Tidak ada mobil cocok',
                        style: TextStyle(
                            color: AppTheme.textSecondary, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.66,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
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
    );
  }

  void _openDetail(BuildContext context, Car car) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CarDetailScreen(car: car)),
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
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: info.primary,
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: Material(
          color: Colors.black.withOpacity(0.25),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => Navigator.pop(context),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.arrow_back_ios_new,
                  size: 16, color: Colors.white),
            ),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'brand-$brand',
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [info.primary, info.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -40,
                  top: -40,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                ),
                Positioned(
                  right: 60,
                  bottom: -30,
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.06),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          info.country,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        brand,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        info.tagline,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _HeaderPill(
                            icon: Icons.directions_car_rounded,
                            label: '$count mobil',
                          ),
                          const SizedBox(width: 8),
                          _HeaderPill(
                            icon: Icons.history_rounded,
                            label: 'Sejak ${info.foundedYear}',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeaderPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _BodyTypeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _BodyTypeChip({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? color : AppTheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? color : AppTheme.border,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : AppTheme.textSecondary,
              fontSize: 12,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
