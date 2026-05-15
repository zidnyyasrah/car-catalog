import 'package:flutter/foundation.dart';
import '../models/car.dart';
import '../models/car_filter.dart';
import '../data/car_data.dart';
import '../database/car_repository.dart';

class CarProvider extends ChangeNotifier {
  final _repo = CarRepository();

  CarFilter _filter = const CarFilter();
  List<Car> _allCars = [];
  List<Car> _cars = [];
  final Set<String> _favorites = {};
  bool _loading = true;
  String? _error;

  List<String> brands = [];
  List<String> bodyTypes = [];
  List<String> driveSystems = [];
  Map<String, int> brandCounts = {};
  static const transmissions = ['Manual', 'Automatic', 'CVT'];

  CarFilter get filter => _filter;
  List<Car> get cars => _cars;
  List<Car> get allCars => _allCars;
  bool get loading => _loading;
  String? get error => _error;
  int get totalCars => _allCars.length;
  int get totalElectric => _allCars.where((c) => c.isElectric).length;

  List<Car> get favoriteCars =>
      _allCars.where((c) => _favorites.contains(c.id)).toList();

  bool isFavorite(String id) => _favorites.contains(id);

  List<Car> carsForBrand(String brand) =>
      _allCars.where((c) => c.brand == brand).toList();

  Future<void> init() async {
    try {
      await _repo.seedIfEmpty(dummyCars);
      _allCars = await _repo.getFiltered(const CarFilter());
      brandCounts = _computeBrandCounts(_allCars);
      brands = await _repo.getDistinctBrands();
      bodyTypes = await _repo.getDistinctBodyTypes();
      driveSystems = await _repo.getDistinctDriveSystems();
      _cars = _allCars;
      _loading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> updateFilter(CarFilter filter) async {
    _filter = filter;
    await _reload();
  }

  Future<void> clearFilters() async {
    _filter = const CarFilter();
    await _reload();
  }

  Future<void> updateSearch(String query) async {
    _filter = _filter.copyWith(searchQuery: query);
    await _reload();
  }

  void toggleFavorite(String carId) {
    if (_favorites.contains(carId)) {
      _favorites.remove(carId);
    } else {
      _favorites.add(carId);
    }
    notifyListeners();
  }

  Future<void> _reload() async {
    _loading = true;
    notifyListeners();
    _cars = await _repo.getFiltered(_filter);
    _loading = false;
    notifyListeners();
  }

  Map<String, int> _computeBrandCounts(List<Car> cars) {
    final counts = <String, int>{};
    for (final car in cars) {
      counts[car.brand] = (counts[car.brand] ?? 0) + 1;
    }
    return counts;
  }
}
