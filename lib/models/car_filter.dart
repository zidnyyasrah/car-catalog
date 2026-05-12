class CarFilter {
  final String? brand;
  final String? bodyType;
  final String? transmission;
  final String? driveSystem;
  final int? minYear;
  final int? maxYear;
  final double? maxPriceMillion;
  final String searchQuery;

  const CarFilter({
    this.brand,
    this.bodyType,
    this.transmission,
    this.driveSystem,
    this.minYear,
    this.maxYear,
    this.maxPriceMillion,
    this.searchQuery = '',
  });

  CarFilter copyWith({
    String? brand,
    String? bodyType,
    String? transmission,
    String? driveSystem,
    int? minYear,
    int? maxYear,
    double? maxPriceMillion,
    String? searchQuery,
    bool clearBrand = false,
    bool clearBodyType = false,
    bool clearTransmission = false,
    bool clearDriveSystem = false,
    bool clearMaxPrice = false,
  }) {
    return CarFilter(
      brand: clearBrand ? null : (brand ?? this.brand),
      bodyType: clearBodyType ? null : (bodyType ?? this.bodyType),
      transmission: clearTransmission ? null : (transmission ?? this.transmission),
      driveSystem: clearDriveSystem ? null : (driveSystem ?? this.driveSystem),
      minYear: minYear ?? this.minYear,
      maxYear: maxYear ?? this.maxYear,
      maxPriceMillion: clearMaxPrice ? null : (maxPriceMillion ?? this.maxPriceMillion),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  bool get hasActiveFilters =>
      brand != null ||
      bodyType != null ||
      transmission != null ||
      driveSystem != null ||
      maxPriceMillion != null ||
      searchQuery.isNotEmpty;
}
