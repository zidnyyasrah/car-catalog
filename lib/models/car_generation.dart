import 'car.dart';

/// A design era / facelift of a model (e.g. Civic Gen 10, Fortuner Gen 2 Facelift).
class CarGeneration {
  final String id;              // 'toyota-fortuner-gen2-fl'
  final String modelId;         // 'toyota-fortuner'
  final String name;            // 'Gen 2 Facelift'
  final String? chassisCode;    // 'AN150/AN160'
  final int yearStart;
  final int? yearEnd;           // null = still produced
  final String description;
  final String heroImageUrl;
  final List<Car> variants;

  CarGeneration({
    required this.id,
    required this.modelId,
    required this.name,
    required this.chassisCode,
    required this.yearStart,
    required this.yearEnd,
    required this.description,
    required this.heroImageUrl,
    required this.variants,
  });

  bool get isCurrent => yearEnd == null;

  String get yearLabel {
    if (yearEnd == null) return '$yearStart - sekarang';
    return '$yearStart - $yearEnd';
  }

  int get variantCount => variants.length;

  /// Lowest variant price within this generation.
  double? get priceFrom {
    if (variants.isEmpty) return null;
    return variants
        .map((v) => v.priceMinMillionIdr)
        .reduce((a, b) => a < b ? a : b);
  }
}
