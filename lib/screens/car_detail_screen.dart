import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/car.dart';
import '../providers/car_provider.dart';
import '../theme/app_theme.dart';

class CarDetailScreen extends StatelessWidget {
  final Car car;

  const CarDetailScreen({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          _HeroAppBar(car: car),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppTheme.xl, AppTheme.xl, AppTheme.xl, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TitleBlock(car: car),
                  const SizedBox(height: AppTheme.xxl),
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
              ),
            ),
          ),
        ],
      ),
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

class _HeroAppBar extends StatelessWidget {
  final Car car;
  const _HeroAppBar({required this.car});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      backgroundColor: AppTheme.background,
      leading: Padding(
        padding: const EdgeInsets.all(AppTheme.sm),
        child: _CircleBtn(
          icon: Icons.arrow_back_rounded,
          onTap: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(AppTheme.sm),
          child: Consumer<CarProvider>(
            builder: (_, provider, __) {
              final isFav = provider.isFavorite(car.id);
              return _CircleBtn(
                icon: isFav
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                iconColor: isFav ? AppTheme.accent : Colors.white,
                onTap: () => provider.toggleFavorite(car.id),
              );
            },
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'car-image-${car.id}',
              child: CachedNetworkImage(
                imageUrl: car.imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    Container(color: AppTheme.surfaceElevated),
                errorWidget: (_, __, ___) => Container(
                  color: AppTheme.surfaceElevated,
                  child: const Icon(Icons.directions_car,
                      color: AppTheme.textMuted, size: 60),
                ),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppTheme.background.withOpacity(0.5),
                    AppTheme.background,
                  ],
                  stops: const [0.35, 0.8, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  const _CircleBtn({
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.45),
      shape: const CircleBorder(
        side: BorderSide(color: Color(0x33FFFFFF), width: 0.5),
      ),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.sm),
          child: Icon(icon, size: 16, color: iconColor ?? Colors.white),
        ),
      ),
    );
  }
}

class _TitleBlock extends StatelessWidget {
  final Car car;
  const _TitleBlock({required this.car});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(car.brand.toUpperCase(),
                style: AppTheme.eyebrow(color: AppTheme.textPrimary)),
            const SizedBox(width: AppTheme.md),
            Container(width: 1, height: 10, color: AppTheme.hairline),
            const SizedBox(width: AppTheme.md),
            Text(car.yearLabel, style: AppTheme.eyebrow()),
            const SizedBox(width: AppTheme.md),
            Container(width: 1, height: 10, color: AppTheme.hairline),
            const SizedBox(width: AppTheme.md),
            Text(car.bodyType.toUpperCase(), style: AppTheme.eyebrow()),
            if (car.isElectric) ...[
              const SizedBox(width: AppTheme.md),
              Container(width: 1, height: 10, color: AppTheme.hairline),
              const SizedBox(width: AppTheme.md),
              Text('ELECTRIC',
                  style: AppTheme.eyebrow(color: AppTheme.electric)),
            ],
          ],
        ),
        const SizedBox(height: AppTheme.lg),
        Text(car.type, style: AppTheme.display(size: 40)),
        const SizedBox(height: AppTheme.sx),
        Text(
          car.variant,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 15,
            height: 1.3,
          ),
        ),
        const SizedBox(height: AppTheme.lg),
        Row(
          children: [
            ...List.generate(
              5,
              (i) => Padding(
                padding: const EdgeInsets.only(right: 2),
                child: Icon(
                  i < car.safetyRatingStars
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  size: 16,
                  color: AppTheme.gold,
                ),
              ),
            ),
            const SizedBox(width: AppTheme.sm),
            Text('ASEAN NCAP', style: AppTheme.eyebrow()),
          ],
        ),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  final Car car;
  const _PriceRow({required this.car});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(height: 1, color: AppTheme.hairline),
        const SizedBox(height: AppTheme.lg),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('HARGA OTR', style: AppTheme.eyebrow()),
                  const SizedBox(height: AppTheme.sm),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      car.priceLabel,
                      style: AppTheme.display(
                          color: AppTheme.accent, size: 28),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.lg),
        Container(height: 1, color: AppTheme.hairline),
      ],
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
              ? _QuickStat(
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
            Text(label,
                style: AppTheme.eyebrow(color: AppTheme.textPrimary)),
            const SizedBox(width: AppTheme.md),
            Expanded(
                child: Container(height: 1, color: AppTheme.hairline)),
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
    'Hitam': Color(0xFF1A1A1A),
    'Silver': Color(0xFFC0C0C0),
    'Abu-abu': Color(0xFF808080),
    'Merah': Color(0xFFCC2222),
    'Biru': Color(0xFF1E5FA8),
    'Hijau': Color(0xFF2E7D32),
    'Coklat': Color(0xFF6D4C41),
    'Bronze': Color(0xFF8C5E2A),
    'Krem': Color(0xFFF5E6C8),
    'Kuning': Color(0xFFFDD835),
    'Ungu': Color(0xFF6A1B9A),
    'Championship White': Color(0xFFF8F8F8),
    'Sonic Grey Pearl': Color(0xFF6E7070),
    'Rallye Red': Color(0xFFCC1A1A),
  };

  @override
  Widget build(BuildContext context) {
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
