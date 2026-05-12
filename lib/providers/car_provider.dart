import 'package:flutter/foundation.dart';
import '../models/car.dart';
import '../models/car_filter.dart';
import '../data/car_data.dart';

class CarProvider extends ChangeNotifier {
  CarFilter _filter = const CarFilter();
  final Set<String> _favorites = {};

  CarFilter get filter => _filter;

  List<Car> get filteredCars {
    return dummyCars.where((car) {
      if (_filter.brand != null && car.brand != _filter.brand) return false;
      if (_filter.bodyType != null && car.bodyType != _filter.bodyType) return false;
      if (_filter.transmission != null && car.transmission != _filter.transmission) return false;
      if (_filter.driveSystem != null && car.driveSystem != _filter.driveSystem) return false;
      if (_filter.maxPriceMillion != null &&
          car.priceMinMillionIdr > _filter.maxPriceMillion!) return false;
      if (_filter.searchQuery.isNotEmpty) {
        final q = _filter.searchQuery.toLowerCase();
        if (!car.brand.toLowerCase().contains(q) &&
            !car.type.toLowerCase().contains(q) &&
            !car.variant.toLowerCase().contains(q)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  bool isFavorite(String carId) => _favorites.contains(carId);

  void toggleFavorite(String carId) {
    if (_favorites.contains(carId)) {
      _favorites.remove(carId);
    } else {
      _favorites.add(carId);
    }
    notifyListeners();
  }

  List<Car> get favoriteCars =>
      dummyCars.where((c) => _favorites.contains(c.id)).toList();

  void updateFilter(CarFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  void clearFilters() {
    _filter = const CarFilter();
    notifyListeners();
  }

  void updateSearch(String query) {
    _filter = _filter.copyWith(searchQuery: query);
    notifyListeners();
  }
}
