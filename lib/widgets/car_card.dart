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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.surface.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.hairline),
          ),
          clipBehavior: Clip.hardEdge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CarImage(car: car),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppTheme.md, AppTheme.md, AppTheme.md, AppTheme.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      car.brand.toUpperCase(),
                      style: AppTheme.eyebrow(),
                    ),
                    const SizedBox(height: AppTheme.sm),
                    Text(
                      car.type,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                        letterSpacing: -0.3,
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
                    const SizedBox(height: AppTheme.md),
                    Container(height: 1, color: AppTheme.hairline),
                    const SizedBox(height: AppTheme.md),
                    Text(
                      car.priceLabel,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
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
  const _CarImage({required this.car});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 11,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: 'car-image-${car.id}',
            child: CachedNetworkImage(
              imageUrl: car.imageUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                color: AppTheme.surfaceElevated,
              ),
              errorWidget: (_, __, ___) => Container(
                color: AppTheme.surfaceElevated,
                child: const Icon(Icons.directions_car_outlined,
                    color: AppTheme.textMuted, size: 36),
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
                  Colors.black.withOpacity(0.55),
                ],
                stops: const [0.55, 1.0],
              ),
            ),
          ),
          Positioned(
            left: AppTheme.md,
            bottom: AppTheme.sm,
            right: AppTheme.md,
            child: Row(
              children: [
                Text(
                  car.yearLabel.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.6,
                  ),
                ),
                const SizedBox(width: AppTheme.sm),
                Container(width: 3, height: 3, decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                )),
                const SizedBox(width: AppTheme.sm),
                Expanded(
                  child: Text(
                    car.bodyType.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.6,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (car.isElectric)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.electric.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(4),
                      border:
                          Border.all(color: AppTheme.electric.withOpacity(0.5)),
                    ),
                    child: const Text(
                      'EV',
                      style: TextStyle(
                        color: AppTheme.electric,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            top: AppTheme.sm,
            right: AppTheme.sm,
            child: _FavoriteButton(carId: car.id),
          ),
        ],
      ),
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
      color: Colors.black.withOpacity(0.45),
      shape: const CircleBorder(
        side: BorderSide(color: Color(0x33FFFFFF), width: 0.5),
      ),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => provider.toggleFavorite(carId),
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: Icon(
            isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            size: 14,
            color: isFav ? AppTheme.accent : Colors.white,
          ),
        ),
      ),
    );
  }
}
