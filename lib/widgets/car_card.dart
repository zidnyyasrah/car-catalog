import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/car.dart';
import '../providers/car_provider.dart';
import '../data/brand_info.dart';
import '../theme/app_theme.dart';

class CarCard extends StatelessWidget {
  final Car car;
  final VoidCallback onTap;

  const CarCard({super.key, required this.car, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final brand = brandInfoFor(car.brand);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppTheme.border),
          ),
          clipBehavior: Clip.hardEdge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CarImage(car: car, brandColor: brand.primary),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _Badge(
                          label: car.bodyType,
                          color: brand.primary,
                        ),
                        if (car.isElectric) ...[
                          const SizedBox(width: 6),
                          const _Badge(
                            label: 'EV',
                            color: AppTheme.electric,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      car.type,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      car.variant,
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          car.isElectric
                              ? Icons.bolt_rounded
                              : Icons.local_gas_station_outlined,
                          size: 12,
                          color: car.isElectric
                              ? AppTheme.electric
                              : AppTheme.textMuted,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          car.fuelConsumptionLabel,
                          style: TextStyle(
                            color: car.isElectric
                                ? AppTheme.electric
                                : AppTheme.textMuted,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.people_outline,
                            size: 12, color: AppTheme.textMuted),
                        const SizedBox(width: 3),
                        Text(
                          '${car.seatingCapacity}',
                          style: const TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: brand.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        car.priceLabel,
                        style: TextStyle(
                          color: brand.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CarImage extends StatelessWidget {
  final Car car;
  final Color brandColor;
  const _CarImage({required this.car, required this.brandColor});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 16 / 10,
          child: Hero(
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
                    color: AppTheme.textMuted, size: 40),
              ),
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: _FavoriteButton(carId: car.id),
        ),
        Positioned(
          left: 8,
          bottom: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.55),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '${car.year}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  final String carId;
  const _FavoriteButton({required this.carId});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CarProvider>();
    final isFav = provider.isFavorite(carId);
    return Material(
      color: Colors.black.withOpacity(0.55),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => provider.toggleFavorite(carId),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(
            isFav ? Icons.favorite : Icons.favorite_border,
            size: 16,
            color: isFav ? AppTheme.accent : Colors.white,
          ),
        ),
      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: color.withOpacity(0.4), width: 0.5),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
