import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/car.dart';
import '../providers/car_provider.dart';
import '../theme/app_theme.dart';

class CarCard extends StatelessWidget {
  final Car car;
  final VoidCallback onTap;

  const CarCard({super.key, required this.car, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2A2A4E), width: 1),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CarImage(car: car),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _BodyTypeBadge(bodyType: car.bodyType),
                      if (car.isElectric) ...[
                        const SizedBox(width: 6),
                        _ElectricBadge(),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    car.brand,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    '${car.type} ${car.variant}',
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          size: 12, color: AppTheme.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        '${car.year}',
                        style: const TextStyle(
                            color: AppTheme.textSecondary, fontSize: 12),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        car.isElectric
                            ? Icons.bolt_outlined
                            : Icons.local_gas_station_outlined,
                        size: 12,
                        color: car.isElectric
                            ? AppTheme.electric
                            : AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        car.fuelConsumptionLabel,
                        style: TextStyle(
                          color: car.isElectric
                              ? AppTheme.electric
                              : AppTheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    car.priceLabel,
                    style: const TextStyle(
                      color: AppTheme.accent,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
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
}

class _CarImage extends StatelessWidget {
  final Car car;
  const _CarImage({required this.car});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 16 / 10,
          child: CachedNetworkImage(
            imageUrl: car.imageUrl,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(
              color: AppTheme.cardBg,
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppTheme.accent,
                ),
              ),
            ),
            errorWidget: (_, __, ___) => Container(
              color: AppTheme.cardBg,
              child: const Icon(Icons.directions_car, color: AppTheme.textSecondary, size: 40),
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: _FavoriteButton(carId: car.id),
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
    return GestureDetector(
      onTap: () => provider.toggleFavorite(carId),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppTheme.primary.withOpacity(0.7),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isFav ? Icons.favorite : Icons.favorite_border,
          size: 18,
          color: isFav ? AppTheme.accent : AppTheme.textSecondary,
        ),
      ),
    );
  }
}

class _BodyTypeBadge extends StatelessWidget {
  final String bodyType;
  const _BodyTypeBadge({required this.bodyType});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppTheme.accent.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppTheme.accent.withOpacity(0.4), width: 0.5),
      ),
      child: Text(
        bodyType,
        style: const TextStyle(
          color: AppTheme.accent,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _ElectricBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppTheme.electric.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppTheme.electric.withOpacity(0.4), width: 0.5),
      ),
      child: const Text(
        'EV',
        style: TextStyle(
          color: AppTheme.electric,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
