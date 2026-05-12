import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/car.dart';
import '../models/car_filter.dart';

class CarRepository {
  SupabaseClient get _db => Supabase.instance.client;

  // ── Seed ──────────────────────────────────────────────────────────────────

  Future<void> seedIfEmpty(List<Car> cars) async {
    final existing = await _db.from('cars').select('id').limit(1);
    if (existing.isNotEmpty) return;

    // Insert cars
    await _db.from('cars').insert(cars.map(_carToRow).toList());

    // Insert colors (batch)
    final colors = cars
        .expand((c) => c.colors.map((color) => {'car_id': c.id, 'color': color}))
        .toList();
    await _db.from('car_colors').insert(colors);

    // Insert features (batch)
    final features = cars
        .expand((c) =>
            c.features.map((f) => {'car_id': c.id, 'feature': f}))
        .toList();
    await _db.from('car_features').insert(features);
  }

  // ── Read ──────────────────────────────────────────────────────────────────

  Future<List<Car>> getFiltered(CarFilter filter) async {
    var query = _db.from('cars').select(
      '*, car_colors(color), car_features(feature)',
    );

    if (filter.brand != null) {
      query = query.eq('brand', filter.brand!);
    }
    if (filter.bodyType != null) {
      query = query.eq('body_type', filter.bodyType!);
    }
    if (filter.transmission != null) {
      query = query.eq('transmission', filter.transmission!);
    }
    if (filter.driveSystem != null) {
      query = query.eq('drive_system', filter.driveSystem!);
    }
    if (filter.maxPriceMillion != null) {
      query = query.lte('price_min', filter.maxPriceMillion!);
    }
    if (filter.searchQuery.isNotEmpty) {
      final q = filter.searchQuery;
      query = query.or('brand.ilike.%$q%,type.ilike.%$q%,variant.ilike.%$q%');
    }

    final rows = await query.order('brand').order('type');
    return rows.map(_rowToCar).toList();
  }

  Future<List<String>> getDistinctBrands() async {
    final rows = await _db.from('cars').select('brand');
    return rows
        .map((r) => r['brand'] as String)
        .toSet()
        .toList()
      ..sort();
  }

  Future<List<String>> getDistinctBodyTypes() async {
    final rows = await _db.from('cars').select('body_type');
    return rows
        .map((r) => r['body_type'] as String)
        .toSet()
        .toList()
      ..sort();
  }

  Future<List<String>> getDistinctDriveSystems() async {
    final rows = await _db.from('cars').select('drive_system');
    return rows
        .map((r) => r['drive_system'] as String)
        .toSet()
        .toList()
      ..sort();
  }

  // ── Mapping ───────────────────────────────────────────────────────────────

  Car _rowToCar(Map<String, dynamic> row) {
    final colorRows = (row['car_colors'] as List<dynamic>? ?? []);
    final featureRows = (row['car_features'] as List<dynamic>? ?? []);

    return Car(
      id: row['id'] as String,
      brand: row['brand'] as String,
      type: row['type'] as String,
      variant: row['variant'] as String,
      year: row['year'] as int,
      bodyType: row['body_type'] as String,
      engineType: row['engine_type'] as String,
      engineDisplacementCc: row['engine_displacement_cc'] as int,
      transmission: row['transmission'] as String,
      driveSystem: row['drive_system'] as String,
      colors: colorRows.map((r) => r['color'] as String).toList(),
      fuelConsumptionKmPerL: (row['fuel_consumption'] as num).toDouble(),
      seatingCapacity: row['seating_capacity'] as int,
      priceMinMillionIdr: (row['price_min'] as num).toDouble(),
      priceMaxMillionIdr: (row['price_max'] as num).toDouble(),
      imageUrl: row['image_url'] as String,
      description: row['description'] as String,
      features: featureRows.map((r) => r['feature'] as String).toList(),
      safetyRatingStars: row['safety_rating'] as int,
      isElectric: row['is_electric'] as bool,
      powerHp: row['power_hp'] as int,
      torqueNm: row['torque_nm'] as int,
      groundClearanceMm: row['ground_clearance_mm'] as int,
      lengthWidthHeightMm: row['dimensions'] as String,
    );
  }

  Map<String, dynamic> _carToRow(Car car) => {
        'id': car.id,
        'brand': car.brand,
        'type': car.type,
        'variant': car.variant,
        'year': car.year,
        'body_type': car.bodyType,
        'engine_type': car.engineType,
        'engine_displacement_cc': car.engineDisplacementCc,
        'transmission': car.transmission,
        'drive_system': car.driveSystem,
        'fuel_consumption': car.fuelConsumptionKmPerL,
        'seating_capacity': car.seatingCapacity,
        'price_min': car.priceMinMillionIdr,
        'price_max': car.priceMaxMillionIdr,
        'image_url': car.imageUrl,
        'description': car.description,
        'safety_rating': car.safetyRatingStars,
        'is_electric': car.isElectric,
        'power_hp': car.powerHp,
        'torque_nm': car.torqueNm,
        'ground_clearance_mm': car.groundClearanceMm,
        'dimensions': car.lengthWidthHeightMm,
      };
}
