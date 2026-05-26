import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/car.dart';
import '../models/car_generation.dart';
import '../models/car_model.dart';
import '../database/car_repository.dart';

class CarProvider extends ChangeNotifier {
  final _repo = CarRepository();

  List<Car> _allCars = [];
  final Set<String> _favorites = {};
  bool _loading = true;
  String? _error;

  List<String> brands = [];
  Map<String, int> brandCounts = {}; // variant count per brand

  List<Car> get allCars => _allCars;
  bool get loading => _loading;
  String? get error => _error;

  List<Car> get favoriteCars =>
      _allCars.where((c) => _favorites.contains(c.id)).toList();

  bool isFavorite(String id) => _favorites.contains(id);

  // ── Hierarchy queries ──────────────────────────────────────────────────────

  List<CarModel> modelsForBrand(String brand) =>
      CarRepository.modelsForBrand(_allCars, brand);

  List<CarGeneration> generationsForModel(String modelId) =>
      CarRepository.generationsForModel(_allCars, modelId);

  List<Car> variantsForGeneration(String generationId) =>
      CarRepository.variantsForGeneration(_allCars, generationId);

  Car? variantById(String id) {
    for (final c in _allCars) {
      if (c.id == id) return c;
    }
    return null;
  }

  /// Returns the CarGeneration object that contains the given variant.
  /// Used to open the combined generation-detail page from favorites.
  CarGeneration? generationContaining(String variantId) {
    final variant = variantById(variantId);
    if (variant == null) return null;
    final gens = generationsForModel(variant.modelId);
    for (final g in gens) {
      if (g.id == variant.generationId) return g;
    }
    return null;
  }

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  Future<void> init() async {
    try {
      _allCars = await _repo.fetchAllVariants();
      brands = CarRepository.brandsOf(_allCars);
      brandCounts = _countByBrand(_allCars);
      _loading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    try {
      _allCars = await _repo.fetchAllVariants();
      brands = CarRepository.brandsOf(_allCars);
      brandCounts = _countByBrand(_allCars);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // ── Writes ─────────────────────────────────────────────────────────────────

  /// Uploads an image file to Supabase Storage, returns the public URL.
  Future<String> uploadImage(File file, {required String folder}) =>
      _repo.uploadImage(file, folder: folder);

  /// Resolves a brand row id from its display name.
  Future<String?> brandIdByName(String name) => _repo.brandIdByName(name);

  Future<void> saveBrand({
    String? id,
    required String name,
    required String country,
  }) async {
    await _repo.upsertBrand(id: id, name: name, country: country);
    await refresh();
  }

  Future<void> removeBrand(String name) async {
    final id = await _repo.brandIdByName(name);
    if (id == null) return;
    await _repo.deleteBrand(id);
    await refresh();
  }

  Future<void> saveModel({
    String? id,
    required String brandName,
    required String name,
    required String bodyType,
    String? description,
    String? heroImageUrl,
  }) async {
    final brandId = await _repo.brandIdByName(brandName);
    if (brandId == null) {
      throw StateError('Brand "$brandName" not found.');
    }
    await _repo.upsertModel(
      id: id,
      brandId: brandId,
      name: name,
      bodyType: bodyType,
      description: description,
      heroImageUrl: heroImageUrl,
    );
    await refresh();
  }

  Future<void> removeModel(String modelId) async {
    await _repo.deleteModel(modelId);
    await refresh();
  }

  Future<void> saveGeneration({
    String? id,
    required String modelId,
    required String name,
    String? chassisCode,
    required int yearStart,
    int? yearEnd,
    String? description,
    String? heroImageUrl,
  }) async {
    await _repo.upsertGeneration(
      id: id,
      modelId: modelId,
      name: name,
      chassisCode: chassisCode,
      yearStart: yearStart,
      yearEnd: yearEnd,
      description: description,
      heroImageUrl: heroImageUrl,
    );
    await refresh();
  }

  Future<void> removeGeneration(String generationId) async {
    await _repo.deleteGeneration(generationId);
    await refresh();
  }

  Future<void> saveVariant({
    String? id,
    required String generationId,
    required String trimName,
    required int yearStart,
    int? yearEnd,
    required String engineType,
    int engineDisplacementCc = 0,
    int powerHp = 0,
    int torqueNm = 0,
    required String transmission,
    required String driveSystem,
    bool isElectric = false,
    double fuelConsumptionKmPerL = 0,
    int seatingCapacity = 5,
    int groundClearanceMm = 0,
    String? dimensions,
    int safetyRating = 0,
    required double priceMinMillionIdr,
    required double priceMaxMillionIdr,
    String? imageUrl,
    String? description,
    List<String> colors = const [],
    List<String> features = const [],
  }) async {
    await _repo.upsertVariant(
      id: id,
      generationId: generationId,
      trimName: trimName,
      yearStart: yearStart,
      yearEnd: yearEnd,
      engineType: engineType,
      engineDisplacementCc: engineDisplacementCc,
      powerHp: powerHp,
      torqueNm: torqueNm,
      transmission: transmission,
      driveSystem: driveSystem,
      isElectric: isElectric,
      fuelConsumptionKmPerL: fuelConsumptionKmPerL,
      seatingCapacity: seatingCapacity,
      groundClearanceMm: groundClearanceMm,
      dimensions: dimensions,
      safetyRating: safetyRating,
      priceMinMillionIdr: priceMinMillionIdr,
      priceMaxMillionIdr: priceMaxMillionIdr,
      imageUrl: imageUrl,
      description: description,
      colors: colors,
      features: features,
    );
    await refresh();
  }

  Future<void> removeVariant(String variantId) async {
    await _repo.deleteVariant(variantId);
    _favorites.remove(variantId);
    await refresh();
  }

  void toggleFavorite(String carId) {
    if (_favorites.contains(carId)) {
      _favorites.remove(carId);
    } else {
      _favorites.add(carId);
    }
    notifyListeners();
  }

  Map<String, int> _countByBrand(List<Car> cars) {
    final m = <String, int>{};
    for (final c in cars) {
      m[c.brand] = (m[c.brand] ?? 0) + 1;
    }
    return m;
  }
}
