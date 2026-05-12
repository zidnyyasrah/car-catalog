import 'package:flutter/foundation.dart';
import '../models/car.dart';
import '../models/car_filter.dart';
import '../data/car_data.dart';
import '../database/car_repository.dart';

class CarProvider extends ChangeNotifier {
  final _repo = CarRepository();

  CarFilter _filter = const CarFilter();
  List<Car> _cars = [];
  Set<String> _favorites = {};
  bool _loading = true;
  String? _error;

  // Filter options loaded from DB
  List<String> brands = [];
  List<String> bodyTypes = [];
  List<String> driveSystems = [];
  static const transmissions = ['Manual', 'Automatic', 'CVT'];

  CarFilter get filter => _filter;
  List<Car> get cars => _cars;
  bool get loading => _loading;
  String? get error => _error;

  List<Car> get favoriteCars =>
      _cars.where((c) => _favorites.contains(c.id)).toList();

  bool isFavorite(String id) => _favorites.contains(id);

  Future<void> init() async {
    try {
      await _repo.seedIfEmpty(dummyCars);
      _favorites = await _repo.getFavoriteIds();
      brands = await _repo.getDistinctBrands();
      bodyTypes = await _repo.getDistinctBodyTypes();
      driveSystems = await _repo.getDistinctDriveSystems();
      await _reload();
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

  Future<void> toggleFavorite(String carId) async {
    if (_favorites.contains(carId)) {
      await _repo.removeFavorite(carId);
      _favorites.remove(carId);
    } else {
      await _repo.addFavorite(carId);
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
}
