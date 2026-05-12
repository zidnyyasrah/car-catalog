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
      backgroundColor: AppTheme.primary,
      body: CustomScrollView(
        slivers: [
          _HeroAppBar(car: car),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TitleSection(car: car),
                  const SizedBox(height: 20),
                  _PriceAndStats(car: car),
                  const SizedBox(height: 24),
                  const _SectionTitle(title: 'Tentang Mobil Ini'),
                  const SizedBox(height: 8),
                  Text(
                    car.description,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const _SectionTitle(title: 'Spesifikasi Mesin'),
                  const SizedBox(height: 12),
                  _EngineSpecs(car: car),
                  const SizedBox(height: 24),
                  const _SectionTitle(title: 'Spesifikasi Umum'),
                  const SizedBox(height: 12),
                  _GeneralSpecs(car: car),
                  const SizedBox(height: 24),
                  const _SectionTitle(title: 'Warna Tersedia'),
                  const SizedBox(height: 12),
                  _ColorsSection(colors: car.colors),
                  const SizedBox(height: 24),
                  const _SectionTitle(title: 'Fitur Unggulan'),
                  const SizedBox(height: 12),
                  _FeaturesSection(features: car.features),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroAppBar extends StatelessWidget {
  final Car car;
  const _HeroAppBar({required this.car});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 240,
      pinned: true,
      backgroundColor: AppTheme.primary,
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppTheme.textPrimary),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Consumer<CarProvider>(
            builder: (_, provider, __) {
              final isFav = provider.isFavorite(car.id);
              return GestureDetector(
                onTap: () => provider.toggleFavorite(car.id),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    size: 20,
                    color: isFav ? AppTheme.accent : AppTheme.textSecondary,
                  ),
                ),
              );
            },
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: CachedNetworkImage(
          imageUrl: car.imageUrl,
          fit: BoxFit.cover,
          placeholder: (_, __) => Container(
            color: AppTheme.surface,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.accent),
            ),
          ),
          errorWidget: (_, __, ___) => Container(
            color: AppTheme.surface,
            child: const Icon(Icons.directions_car, color: AppTheme.textSecondary, size: 60),
          ),
        ),
      ),
    );
  }
}

class _TitleSection extends StatelessWidget {
  final Car car;
  const _TitleSection({required this.car});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _Badge(
              label: car.bodyType,
              color: AppTheme.accent,
            ),
            if (car.isElectric) ...[
              const SizedBox(width: 8),
              const _Badge(label: 'Electric', color: AppTheme.electric),
            ],
            const SizedBox(width: 8),
            _Badge(
              label: '${car.year}',
              color: AppTheme.textSecondary,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          car.brand,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 14,
            letterSpacing: 0.5,
          ),
        ),
        Text(
          '${car.type} ${car.variant}',
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            ...List.generate(5, (i) => Icon(
              i < car.safetyRatingStars ? Icons.star : Icons.star_border,
              size: 16,
              color: Colors.amber,
            )),
            const SizedBox(width: 6),
            Text(
              '${car.safetyRatingStars}/5 ASEAN NCAP',
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}

class _PriceAndStats extends StatelessWidget {
  final Car car;
  const _PriceAndStats({required this.car});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A4E)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Harga OTR',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
              ),
              Text(
                car.priceLabel,
                style: const TextStyle(
                  color: AppTheme.accent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _QuickStat(
                icon: Icons.speed,
                value: '${car.powerHp} HP',
                label: 'Tenaga',
              ),
              _QuickStat(
                icon: Icons.rotate_right,
                value: '${car.torqueNm} Nm',
                label: 'Torsi',
              ),
              _QuickStat(
                icon: car.isElectric ? Icons.bolt : Icons.local_gas_station,
                value: car.fuelConsumptionLabel,
                label: 'Konsumsi',
                valueColor: car.isElectric ? AppTheme.electric : null,
              ),
              _QuickStat(
                icon: Icons.people,
                value: '${car.seatingCapacity}',
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
  final String label;
  final Color? valueColor;

  const _QuickStat({
    required this.icon,
    required this.value,
    required this.label,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 20, color: valueColor ?? AppTheme.textSecondary),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? AppTheme.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            label,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _EngineSpecs extends StatelessWidget {
  final Car car;
  const _EngineSpecs({required this.car});

  @override
  Widget build(BuildContext context) {
    return _SpecsGrid(specs: [
      _SpecItem('Mesin', car.engineType),
      if (!car.isElectric) _SpecItem('Kapasitas', '${car.engineDisplacementCc} cc'),
      _SpecItem('Transmisi', car.transmission),
      _SpecItem('Penggerak', car.driveSystem),
      _SpecItem('Tenaga Max', '${car.powerHp} HP'),
      _SpecItem('Torsi Max', '${car.torqueNm} Nm'),
    ]);
  }
}

class _GeneralSpecs extends StatelessWidget {
  final Car car;
  const _GeneralSpecs({required this.car});

  @override
  Widget build(BuildContext context) {
    return _SpecsGrid(specs: [
      _SpecItem('Tipe Bodi', car.bodyType),
      _SpecItem('Kapasitas', '${car.seatingCapacity} penumpang'),
      _SpecItem('Ground Clearance', '${car.groundClearanceMm} mm'),
      _SpecItem('Dimensi (P×L×T)', '${car.lengthWidthHeightMm} mm'),
      if (!car.isElectric)
        _SpecItem('Konsumsi BBM', '${car.fuelConsumptionKmPerL} km/L'),
    ]);
  }
}

class _SpecItem {
  final String label;
  final String value;
  const _SpecItem(this.label, this.value);
}

class _SpecsGrid extends StatelessWidget {
  final List<_SpecItem> specs;
  const _SpecsGrid({required this.specs});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: specs.map((spec) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 1),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xFF2A2A4E).withOpacity(0.5),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  spec.label,
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: Text(
                    spec.value,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
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
      spacing: 12,
      runSpacing: 12,
      children: colors.map((color) {
        final c = _colorMap[color] ?? Colors.grey;
        return Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: c,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF2A2A4E), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: c.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              color,
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        );
      }).toList(),
    );
  }
}

class _FeaturesSection extends StatelessWidget {
  final List<String> features;
  const _FeaturesSection({required this.features});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: features.map((feature) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF2A2A4E)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, size: 14, color: AppTheme.electric),
              const SizedBox(width: 6),
              Text(
                feature,
                style: const TextStyle(color: AppTheme.textPrimary, fontSize: 12),
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
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: AppTheme.accent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
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
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
