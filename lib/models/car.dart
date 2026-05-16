class Car {
  final String id;
  final String brand;
  final String modelId;           // 'toyota-fortuner'
  final String type;              // 'Fortuner'  (model name)
  final String generationId;      // 'toyota-fortuner-gen2-fl'
  final String generationName;    // 'Gen 2 Facelift'
  final int? generationYearStart;
  final int? generationYearEnd;
  final String variant;           // '2.8 VRZ Diesel A/T'
  final int yearStart;
  final int? yearEnd;
  final String bodyType;
  final String engineType;
  final int engineDisplacementCc;
  final String transmission;
  final String driveSystem;
  final List<String> colors;
  final double fuelConsumptionKmPerL;
  final int seatingCapacity;
  final double priceMinMillionIdr;
  final double priceMaxMillionIdr;
  final String imageUrl;
  final String description;
  final List<String> features;
  final int safetyRatingStars;
  final bool isElectric;
  final int powerHp;
  final int torqueNm;
  final int groundClearanceMm;
  final String lengthWidthHeightMm;

  const Car({
    required this.id,
    required this.brand,
    required this.modelId,
    required this.type,
    required this.generationId,
    required this.generationName,
    required this.generationYearStart,
    required this.generationYearEnd,
    required this.variant,
    required this.yearStart,
    required this.yearEnd,
    required this.bodyType,
    required this.engineType,
    required this.engineDisplacementCc,
    required this.transmission,
    required this.driveSystem,
    required this.colors,
    required this.fuelConsumptionKmPerL,
    required this.seatingCapacity,
    required this.priceMinMillionIdr,
    required this.priceMaxMillionIdr,
    required this.imageUrl,
    required this.description,
    required this.features,
    required this.safetyRatingStars,
    required this.isElectric,
    required this.powerHp,
    required this.torqueNm,
    required this.groundClearanceMm,
    required this.lengthWidthHeightMm,
  });

  String get fullName => '$brand $type $variant';

  String get yearLabel => _yearRange(yearStart, yearEnd);
  String get generationYearLabel =>
      _yearRange(generationYearStart ?? yearStart, generationYearEnd);

  String get fuelConsumptionLabel => isElectric
      ? 'Electric'
      : '${fuelConsumptionKmPerL.toStringAsFixed(0)} km/L';

  String get priceLabel {
    if (priceMinMillionIdr == priceMaxMillionIdr) {
      return 'Rp ${priceMinMillionIdr.toStringAsFixed(0)} Jt';
    }
    return 'Rp ${priceMinMillionIdr.toStringAsFixed(0)} - ${priceMaxMillionIdr.toStringAsFixed(0)} Jt';
  }
}

String _yearRange(int? start, int? end) {
  if (start == null) return '';
  if (end == null) return '$start - sekarang';
  if (end == start) return '$start';
  return '$start - $end';
}
