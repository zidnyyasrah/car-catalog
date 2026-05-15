import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/car.dart';
import '../providers/car_provider.dart';
import '../data/brand_info.dart';
import '../theme/app_theme.dart';

class CarDetailScreen extends StatelessWidget {
  final Car car;

  const CarDetailScreen({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    final brand = brandInfoFor(car.brand);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          _HeroAppBar(car: car, brandColor: brand.primary),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TitleSection(car: car, brandColor: brand.primary),
                  const SizedBox(height: 20),
                  _PriceAndStats(car: car, brandColor: brand.primary),
                  const SizedBox(height: 28),
                  const _SectionTitle('Tentang Mobil Ini'),
                  const SizedBox(height: 10),
                  Text(
                    car.description,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                      height: 1.65,
                    ),
                  ),
                  const SizedBox(height: 28),
                  const _SectionTitle('Spesifikasi Mesin'),
                  const SizedBox(height: 12),
                  _SpecsCard(specs: _engineSpecs(car)),
                  const SizedBox(height: 24),
                  const _SectionTitle('Spesifikasi Umum'),
                  const SizedBox(height: 12),
                  _SpecsCard(specs: _generalSpecs(car)),
                  const SizedBox(height: 28),
                  const _SectionTitle('Warna Tersedia'),
                  const SizedBox(height: 14),
                  _ColorsSection(colors: car.colors),
                  const SizedBox(height: 28),
                  const _SectionTitle('Fitur Unggulan'),
                  const SizedBox(height: 12),
                  _FeaturesSection(
                      features: car.features, accent: brand.primary),
                  const SizedBox(height: 40),
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
  final Color brandColor;
  const _HeroAppBar({required this.car, required this.brandColor});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: AppTheme.background,
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: Material(
          color: Colors.black.withOpacity(0.45),
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
      actions: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Consumer<CarProvider>(
            builder: (_, provider, __) {
              final isFav = provider.isFavorite(car.id);
              return Material(
                color: Colors.black.withOpacity(0.45),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => provider.toggleFavorite(car.id),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      size: 18,
                      color: isFav ? AppTheme.accent : Colors.white,
                    ),
                  ),
                ),
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
                placeholder: (_, __) => Container(
                  color: AppTheme.surfaceElevated,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: brandColor,
                    ),
                  ),
                ),
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
                    AppTheme.background.withOpacity(0.4),
                    AppTheme.background,
                  ],
                  stops: const [0.4, 0.8, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TitleSection extends StatelessWidget {
  final Car car;
  final Color brandColor;
  const _TitleSection({required this.car, required this.brandColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _Badge(label: car.bodyType, color: brandColor),
            if (car.isElectric) ...[
              const SizedBox(width: 8),
              const _Badge(label: 'Electric', color: AppTheme.electric),
            ],
            const SizedBox(width: 8),
            _Badge(label: '${car.year}', color: AppTheme.textSecondary),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          car.brand,
          style: TextStyle(
            color: brandColor,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          car.type,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 26,
            fontWeight: FontWeight.w800,
            height: 1.1,
            letterSpacing: -0.5,
          ),
        ),
        Text(
          car.variant,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            ...List.generate(
              5,
              (i) => Icon(
                i < car.safetyRatingStars ? Icons.star : Icons.star_border,
                size: 16,
                color: AppTheme.gold,
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              'ASEAN NCAP',
              style: TextStyle(color: AppTheme.textMuted, fontSize: 11),
            ),
          ],
        ),
      ],
    );
  }
}

class _PriceAndStats extends StatelessWidget {
  final Car car;
  final Color brandColor;
  const _PriceAndStats({required this.car, required this.brandColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Harga OTR',
                style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
              ),
              Text(
                car.priceLabel,
                style: TextStyle(
                  color: brandColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppTheme.border, height: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              _QuickStat(
                icon: Icons.speed_rounded,
                value: '${car.powerHp}',
                unit: 'HP',
                label: 'Tenaga',
              ),
              _QuickStat(
                icon: Icons.rotate_right_rounded,
                value: '${car.torqueNm}',
                unit: 'Nm',
                label: 'Torsi',
              ),
              _QuickStat(
                icon: car.isElectric
                    ? Icons.bolt_rounded
                    : Icons.local_gas_station_rounded,
                value: car.isElectric
                    ? 'EV'
                    : car.fuelConsumptionKmPerL.toStringAsFixed(0),
                unit: car.isElectric ? '' : 'km/L',
                label: 'Konsumsi',
                valueColor: car.isElectric ? AppTheme.electric : null,
              ),
              _QuickStat(
                icon: Icons.people_rounded,
                value: '${car.seatingCapacity}',
                unit: '',
                label: 'Kursi',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String unit;
  final String label;
  final Color? valueColor;

  const _QuickStat({
    required this.icon,
    required this.value,
    required this.unit,
    required this.label,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 22, color: valueColor ?? AppTheme.textSecondary),
          const SizedBox(height: 6),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    color: valueColor ?? AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (unit.isNotEmpty)
                  TextSpan(
                    text: ' $unit',
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: AppTheme.textMuted, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _SpecItem {
  final String label;
  final String value;
  const _SpecItem(this.label, this.value);
}

class _SpecsCard extends StatelessWidget {
  final List<_SpecItem> specs;
  const _SpecsCard({required this.specs});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: List.generate(specs.length, (i) {
          final spec = specs[i];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: i < specs.length - 1
                  ? const Border(
                      bottom: BorderSide(color: AppTheme.border, width: 0.5),
                    )
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  spec.label,
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: Text(
                    spec.value,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _ColorsSection extends StatelessWidget {
  final List<String> colors;
  const _ColorsSection({required this.colors});

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
      spacing: 16,
      runSpacing: 14,
      children: colors.map((color) {
        final c = _colorMap[color] ?? Colors.grey;
        return SizedBox(
          width: 64,
          child: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: c,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.border, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: c.withOpacity(0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                color,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 10,
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

class _FeaturesSection extends StatelessWidget {
  final List<String> features;
  final Color accent;

  const _FeaturesSection({required this.features, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: features.map((feature) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_rounded, size: 14, color: accent),
              const SizedBox(width: 6),
              Text(
                feature,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.accent, AppTheme.accentSoft],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
