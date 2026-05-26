import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/car.dart';
import '../models/car_generation.dart';
import '../providers/car_provider.dart';
import '../theme/app_theme.dart';

/// Single-page variant browser within a generation.
///
/// Top half: swipeable hero (PageView of variant images) — sliding the slider
/// updates the index. Bottom half: full spec sheet for the currently-selected
/// variant. As the user swipes, the bottom content reactively rebuilds.
class GenerationDetailScreen extends StatefulWidget {
  final CarGeneration generation;
  final String? initialVariantId;

  const GenerationDetailScreen({
    super.key,
    required this.generation,
    this.initialVariantId,
  });

  @override
  State<GenerationDetailScreen> createState() => _GenerationDetailScreenState();
}

class _GenerationDetailScreenState extends State<GenerationDetailScreen> {
  late final List<Car> _variants;
  late final PageController _controller;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    // Stable order: cheapest first (same as before).
    _variants = [...widget.generation.variants]
      ..sort((a, b) => a.priceMinMillionIdr.compareTo(b.priceMinMillionIdr));

    if (widget.initialVariantId != null) {
      final i = _variants.indexWhere((v) => v.id == widget.initialVariantId);
      if (i >= 0) _index = i;
    }
    _controller = PageController(initialPage: _index);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_variants.isEmpty) {
      return const Scaffold(
        backgroundColor: AppTheme.background,
        body: SafeArea(
          child: Column(
            children: [
              _TopBar(carId: null),
              Expanded(child: _EmptyState()),
            ],
          ),
        ),
      );
    }

    final current = _variants[_index];

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _TopBar(carId: current.id),
            _Breadcrumb(generation: widget.generation, brand: current.brand),
            _HeroPager(
              variants: _variants,
              controller: _controller,
              onChanged: (i) => setState(() => _index = i),
            ),
            _PagerIndicator(count: _variants.length, index: _index),
            _VariantTitleStrip(car: current),
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                    AppTheme.xl, AppTheme.lg, AppTheme.xl, 120),
                child: _VariantDetail(car: current),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Hero pager (the slider itself) ─────────────────────────────────────────

class _HeroPager extends StatelessWidget {
  final List<Car> variants;
  final PageController controller;
  final ValueChanged<int> onChanged;

  const _HeroPager({
    required this.variants,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: PageView.builder(
        controller: controller,
        onPageChanged: onChanged,
        itemCount: variants.length,
        itemBuilder: (_, i) {
          final v = variants[i];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.lg),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.radiusCard),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: v.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        Container(color: AppTheme.surfaceElevated),
                    errorWidget: (_, __, ___) => Container(
                      color: AppTheme.surfaceElevated,
                      child: const Icon(Icons.directions_car,
                          color: AppTheme.textMuted, size: 50),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.55),
                        ],
                        stops: const [0.55, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    left: AppTheme.lg,
                    bottom: AppTheme.md,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0x33FFFFFF)),
                      ),
                      child: Text(
                        v.yearLabel.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.6,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Pager dot indicator (slim, animated) ───────────────────────────────────

class _PagerIndicator extends StatelessWidget {
  final int count;
  final int index;
  const _PagerIndicator({required this.count, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppTheme.lg, bottom: AppTheme.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(count, (i) {
          final active = i == index;
          return AnimatedContainer(
            duration: AppTheme.motionFast,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            height: 5,
            width: active ? 22 : 5,
            decoration: BoxDecoration(
              color: active ? AppTheme.accent : AppTheme.border,
              borderRadius: BorderRadius.circular(3),
            ),
          );
        }),
      ),
    );
  }
}

// ─── Variant title strip (trim name + variant counter) ──────────────────────

class _VariantTitleStrip extends StatelessWidget {
  final Car car;
  const _VariantTitleStrip({required this.car});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppTheme.xl, AppTheme.sm, AppTheme.xl, AppTheme.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            car.variant,
            textAlign: TextAlign.center,
            style: AppTheme.display(size: 22),
          ),
          const SizedBox(height: AppTheme.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(car.transmission.toUpperCase(), style: AppTheme.eyebrow()),
              const SizedBox(width: AppTheme.md),
              Container(width: 1, height: 10, color: AppTheme.hairline),
              const SizedBox(width: AppTheme.md),
              Text(car.driveSystem.toUpperCase(), style: AppTheme.eyebrow()),
              if (car.isElectric) ...[
                const SizedBox(width: AppTheme.md),
                Container(width: 1, height: 10, color: AppTheme.hairline),
                const SizedBox(width: AppTheme.md),
                Text('ELECTRIC',
                    style: AppTheme.eyebrow(color: AppTheme.electric)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Below-the-fold spec sheet, fully reactive to current variant ───────────

class _VariantDetail extends StatelessWidget {
  final Car car;
  const _VariantDetail({required this.car});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PriceRow(car: car),
        const SizedBox(height: AppTheme.xxl),
        _QuickStatsGrid(car: car),
        const SizedBox(height: AppTheme.xxl),
        _Section(
          label: 'DESKRIPSI',
          child: Text(
            car.description,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
              height: 1.7,
            ),
          ),
        ),
        const SizedBox(height: AppTheme.xxl),
        _Section(
          label: 'MESIN',
          child: _SpecList(specs: _engineSpecs(car)),
        ),
        const SizedBox(height: AppTheme.xxl),
        _Section(
          label: 'UMUM',
          child: _SpecList(specs: _generalSpecs(car)),
        ),
        const SizedBox(height: AppTheme.xxl),
        _Section(
          label: 'WARNA',
          child: _ColorPalette(colors: car.colors),
        ),
        const SizedBox(height: AppTheme.xxl),
        _Section(
          label: 'FITUR',
          child: _FeatureList(features: car.features),
        ),
      ],
    );
  }

  List<_SpecItem> _engineSpecs(Car car) => [
        _SpecItem('Mesin', car.engineType),
        if (!car.isElectric)
          _SpecItem('Kapasitas', '${car.engineDisplacementCc} cc'),
        _SpecItem('Transmisi', car.transmission),
        _SpecItem('Penggerak', car.driveSystem),
        _SpecItem('Tenaga Max', '${car.powerHp} HP'),
        _SpecItem('Torsi Max', '${car.torqueNm} Nm'),
      ];

  List<_SpecItem> _generalSpecs(Car car) => [
        _SpecItem('Tipe Bodi', car.bodyType),
        _SpecItem('Kapasitas', '${car.seatingCapacity} penumpang'),
        _SpecItem('Ground Clearance', '${car.groundClearanceMm} mm'),
        _SpecItem('Dimensi (P×L×T)', '${car.lengthWidthHeightMm} mm'),
        if (!car.isElectric)
          _SpecItem('Konsumsi BBM', '${car.fuelConsumptionKmPerL} km/L'),
      ];
}

// ─── Reusable spec pieces (mirrors the old detail screen) ───────────────────

class _PriceRow extends StatelessWidget {
  final Car car;
  const _PriceRow({required this.car});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cream,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
      ),
      padding: const EdgeInsets.fromLTRB(
          AppTheme.xl, AppTheme.lg, AppTheme.lg, AppTheme.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HARGA OTR',
                  style: AppTheme.eyebrow(color: AppTheme.onCream)
                      .copyWith(color: AppTheme.onCream.withOpacity(0.55)),
                ),
                const SizedBox(height: AppTheme.sm),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    car.priceLabel,
                    style: AppTheme.display(
                        color: AppTheme.onCream, size: 26),
                  ),
                ),
                const SizedBox(height: AppTheme.sm),
                Row(
                  children: List.generate(
                    5,
                    (i) => Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: Icon(
                        i < car.safetyRatingStars
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        size: 14,
                        color: AppTheme.onCream.withOpacity(
                            i < car.safetyRatingStars ? 0.9 : 0.25),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppTheme.md),
          // Lime pill — the "primary action" tile.
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppTheme.accent,
              borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            ),
            child: const Icon(
              Icons.local_offer_rounded,
              color: AppTheme.onAccent,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickStatsGrid extends StatelessWidget {
  final Car car;
  const _QuickStatsGrid({required this.car});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _QuickStat(value: '${car.powerHp}', unit: 'HP', label: 'TENAGA'),
        ),
        Container(width: 1, height: 56, color: AppTheme.hairline),
        Expanded(
          child: _QuickStat(value: '${car.torqueNm}', unit: 'Nm', label: 'TORSI'),
        ),
        Container(width: 1, height: 56, color: AppTheme.hairline),
        Expanded(
          child: car.isElectric
              ? const _QuickStat(
                  value: 'EV',
                  unit: '',
                  label: 'TENAGA',
                  valueColor: AppTheme.electric,
                )
              : _QuickStat(
                  value: car.fuelConsumptionKmPerL.toStringAsFixed(0),
                  unit: 'km/L',
                  label: 'BBM',
                ),
        ),
        Container(width: 1, height: 56, color: AppTheme.hairline),
        Expanded(
          child:
              _QuickStat(value: '${car.seatingCapacity}', unit: '', label: 'KURSI'),
        ),
      ],
    );
  }
}

class _QuickStat extends StatelessWidget {
  final String value;
  final String unit;
  final String label;
  final Color? valueColor;

  const _QuickStat({
    required this.value,
    required this.unit,
    required this.label,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: AppTheme.numeral(
                    color: valueColor ?? AppTheme.textPrimary,
                    size: 22,
                  ),
                ),
                if (unit.isNotEmpty)
                  TextSpan(
                    text: ' $unit',
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.sm),
          Text(label, style: AppTheme.eyebrow()),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String label;
  final Widget child;
  const _Section({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: AppTheme.eyebrow(color: AppTheme.textPrimary)),
            const SizedBox(width: AppTheme.md),
            Expanded(child: Container(height: 1, color: AppTheme.hairline)),
          ],
        ),
        const SizedBox(height: AppTheme.lg),
        child,
      ],
    );
  }
}

class _SpecItem {
  final String label;
  final String value;
  const _SpecItem(this.label, this.value);
}

class _SpecList extends StatelessWidget {
  final List<_SpecItem> specs;
  const _SpecList({required this.specs});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < specs.length; i++) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                specs[i].label,
                style: const TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: AppTheme.lg),
              Flexible(
                child: Text(
                  specs[i].value,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          if (i < specs.length - 1) ...[
            const SizedBox(height: AppTheme.md),
            Container(height: 1, color: AppTheme.hairline),
            const SizedBox(height: AppTheme.md),
          ],
        ],
      ],
    );
  }
}

class _ColorPalette extends StatelessWidget {
  final List<String> colors;
  const _ColorPalette({required this.colors});

  static const _colorMap = <String, Color>{
    'Putih': Color(0xFFF5F5F5),
    'Putih Mutiara': Color(0xFFF0EEE8),
    'Championship White': Color(0xFFF8F8F8),
    'Hitam': Color(0xFF1A1A1A),
    'Attitude Black': Color(0xFF101010),
    'Silver': Color(0xFFC0C0C0),
    'Abu-abu': Color(0xFF808080),
    'Sonic Gray': Color(0xFF6E7070),
    'Sonic Grey Pearl': Color(0xFF6E7070),
    'Merah': Color(0xFFCC2222),
    'Rallye Red': Color(0xFFCC1A1A),
    'Biru': Color(0xFF1E5FA8),
    'Hijau': Color(0xFF2E7D32),
    'Coklat': Color(0xFF6D4C41),
    'Cokelat': Color(0xFF6D4C41),
    'Cokelat Metalik': Color(0xFF7A5A4A),
    'Phantom Brown': Color(0xFF5C4434),
    'Bronze': Color(0xFF8C5E2A),
    'Champagne': Color(0xFFD4B98A),
    'Krem': Color(0xFFF5E6C8),
    'Kuning': Color(0xFFFDD835),
    'Kuning Phoenix': Color(0xFFF5C518),
    'Ungu': Color(0xFF6A1B9A),
  };

  @override
  Widget build(BuildContext context) {
    if (colors.isEmpty) {
      return Text('Tidak ada data warna.',
          style: AppTheme.eyebrow());
    }
    return Wrap(
      spacing: AppTheme.lg,
      runSpacing: AppTheme.lg,
      children: colors.map((color) {
        final c = _colorMap[color] ?? Colors.grey;
        return SizedBox(
          width: 64,
          child: Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: c,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.hairline, width: 1.5),
                ),
              ),
              const SizedBox(height: AppTheme.sm),
              Text(
                color,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 10,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _FeatureList extends StatelessWidget {
  final List<String> features;
  const _FeatureList({required this.features});

  @override
  Widget build(BuildContext context) {
    if (features.isEmpty) {
      return Text('Tidak ada data fitur.', style: AppTheme.eyebrow());
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final f in features)
          Padding(
            padding: const EdgeInsets.only(bottom: AppTheme.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 7),
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: AppTheme.accent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppTheme.md),
                Expanded(
                  child: Text(
                    f,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 13.5,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ─── Top bar (back + favorite for current variant) ──────────────────────────

class _TopBar extends StatelessWidget {
  /// Null while the variant list is empty.
  final String? carId;
  const _TopBar({required this.carId});

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
          const Spacer(),
          if (carId != null)
            Consumer<CarProvider>(
              builder: (_, provider, __) {
                final isFav = provider.isFavorite(carId!);
                return _IconBtn(
                  icon: isFav
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  iconColor: isFav ? AppTheme.accent : AppTheme.textPrimary,
                  onTap: () => provider.toggleFavorite(carId!),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  const _IconBtn({
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

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
          child: Icon(icon, size: 18, color: iconColor ?? AppTheme.textPrimary),
        ),
      ),
    );
  }
}

class _Breadcrumb extends StatelessWidget {
  final CarGeneration generation;
  final String brand;
  const _Breadcrumb({required this.generation, required this.brand});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppTheme.xl, AppTheme.lg, AppTheme.xl, AppTheme.md),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${brand.toUpperCase()}  ·  ${generation.name.toUpperCase()}',
              style: AppTheme.eyebrow(color: AppTheme.textPrimary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppTheme.md),
          Text(
            generation.yearLabel,
            style: AppTheme.eyebrow(),
          ),
          if (generation.isCurrent) ...[
            const SizedBox(width: AppTheme.sm),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: AppTheme.accent,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text('AKTIF',
                  style: AppTheme.eyebrow(color: AppTheme.onAccent)),
            ),
          ],
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
