import 'car.dart';

/// A car model line (e.g. Fortuner, Civic) within a brand.
/// Aggregates all generations + variants for navigation.
class CarModel {
  final String id;           // 'toyota-fortuner'
  final String brand;        // 'Toyota'
  final String name;         // 'Fortuner'
  final String bodyType;     // 'SUV'
  final String description;
  final String heroImageUrl;
  final List<Car> variants;

  CarModel({
    required this.id,
    required this.brand,
    required this.name,
    required this.bodyType,
    required this.description,
    required this.heroImageUrl,
    required this.variants,
  });

  int get generationCount =>
      variants.map((v) => v.generationId).toSet().length;

  int get variantCount => variants.length;

  /// Earliest year this model has been produced.
  int? get firstYear {
    if (variants.isEmpty) return null;
    return variants.map((v) => v.yearStart).reduce((a, b) => a < b ? a : b);
  }

  /// Latest year (null = still in production).
  int? get latestYearEnd {
    if (variants.isEmpty) return null;
    if (variants.any((v) => v.yearEnd == null)) return null;
    return variants
        .map((v) => v.yearEnd!)
        .reduce((a, b) => a > b ? a : b);
  }

  String get yearSpanLabel {
    final s = firstYear;
    final e = latestYearEnd;
    if (s == null) return '';
    if (e == null) return '$s - sekarang';
    return '$s - $e';
  }

  /// Lowest price across all variants (for "from" pricing).
  double? get priceFrom {
    if (variants.isEmpty) return null;
    return variants
        .map((v) => v.priceMinMillionIdr)
        .reduce((a, b) => a < b ? a : b);
  }
}
