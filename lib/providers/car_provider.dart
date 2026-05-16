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
    _loading = true;
    notifyListeners();
    await init();
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
