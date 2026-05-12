import 'package:sqflite/sqflite.dart';
import '../models/car.dart';
import '../models/car_filter.dart';
import 'database_helper.dart';

class CarRepository {
  Future<Database> get _db => DatabaseHelper.database;

  // ── Seed ──────────────────────────────────────────────────────────────────

  Future<void> seedIfEmpty(List<Car> cars) async {
    final db = await _db;
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM ${DatabaseHelper.tableCars}'),
    );
    if (count != null && count > 0) return;
    await insertMany(cars);
  }

  // ── Write ─────────────────────────────────────────────────────────────────

  Future<void> insertMany(List<Car> cars) async {
    final db = await _db;
    final batch = db.batch();
    for (final car in cars) {
      batch.insert(
        DatabaseHelper.tableCars,
        _carToRow(car),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      for (final color in car.colors) {
        batch.insert(
          DatabaseHelper.tableColors,
          {'car_id': car.id, 'color': color},
        );
      }
      for (final feature in car.features) {
        batch.insert(
          DatabaseHelper.tableFeatures,
          {'car_id': car.id, 'feature': feature},
        );
      }
    }
    await batch.commit(noResult: true);
  }

  // ── Read ──────────────────────────────────────────────────────────────────

  Future<List<Car>> getAll() async => _queryWithFilter(const CarFilter());

  Future<List<Car>> getFiltered(CarFilter filter) async =>
      _queryWithFilter(filter);

  Future<Car?> getById(String id) async {
    final db = await _db;
    final rows = await db.query(
      DatabaseHelper.tableCars,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (rows.isEmpty) return null;
    return _rowToCar(db, rows.first);
  }

  Future<List<String>> getDistinctBrands() async {
    final db = await _db;
    final rows = await db.rawQuery(
      'SELECT DISTINCT brand FROM ${DatabaseHelper.tableCars} ORDER BY brand',
    );
    return rows.map((r) => r['brand'] as String).toList();
  }

  Future<List<String>> getDistinctBodyTypes() async {
    final db = await _db;
    final rows = await db.rawQuery(
      'SELECT DISTINCT body_type FROM ${DatabaseHelper.tableCars} ORDER BY body_type',
    );
    return rows.map((r) => r['body_type'] as String).toList();
  }

  Future<List<String>> getDistinctDriveSystems() async {
    final db = await _db;
    final rows = await db.rawQuery(
      'SELECT DISTINCT drive_system FROM ${DatabaseHelper.tableCars} ORDER BY drive_system',
    );
    return rows.map((r) => r['drive_system'] as String).toList();
  }

  // ── Favorites ─────────────────────────────────────────────────────────────

  Future<void> addFavorite(String carId) async {
    final db = await _db;
    await db.insert(
      DatabaseHelper.tableFavorites,
      {'car_id': carId},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> removeFavorite(String carId) async {
    final db = await _db;
    await db.delete(
      DatabaseHelper.tableFavorites,
      where: 'car_id = ?',
      whereArgs: [carId],
    );
  }

  Future<Set<String>> getFavoriteIds() async {
    final db = await _db;
    final rows = await db.query(DatabaseHelper.tableFavorites);
    return rows.map((r) => r['car_id'] as String).toSet();
  }

  Future<List<Car>> getFavoriteCars() async {
    final db = await _db;
    final favRows = await db.query(DatabaseHelper.tableFavorites);
    if (favRows.isEmpty) return [];
    final ids = favRows.map((r) => "'${r['car_id']}'").join(',');
    final carRows = await db.rawQuery(
      'SELECT * FROM ${DatabaseHelper.tableCars} WHERE id IN ($ids)',
    );
    return Future.wait(carRows.map((row) => _rowToCar(db, row)));
  }

  // ── Internal ──────────────────────────────────────────────────────────────

  Future<List<Car>> _queryWithFilter(CarFilter filter) async {
    final db = await _db;
    final where = <String>[];
    final args = <Object>[];

    if (filter.brand != null) {
      where.add('brand = ?');
      args.add(filter.brand!);
    }
    if (filter.bodyType != null) {
      where.add('body_type = ?');
      args.add(filter.bodyType!);
    }
    if (filter.transmission != null) {
      where.add('transmission = ?');
      args.add(filter.transmission!);
    }
    if (filter.driveSystem != null) {
      where.add('drive_system = ?');
      args.add(filter.driveSystem!);
    }
    if (filter.maxPriceMillion != null) {
      where.add('price_min <= ?');
      args.add(filter.maxPriceMillion!);
    }
    if (filter.searchQuery.isNotEmpty) {
      where.add('(brand LIKE ? OR type LIKE ? OR variant LIKE ?)');
      final q = '%${filter.searchQuery}%';
      args.addAll([q, q, q]);
    }

    final rows = await db.query(
      DatabaseHelper.tableCars,
      where: where.isEmpty ? null : where.join(' AND '),
      whereArgs: args.isEmpty ? null : args,
      orderBy: 'brand, type',
    );

    return Future.wait(rows.map((row) => _rowToCar(db, row)));
  }

  Future<Car> _rowToCar(Database db, Map<String, Object?> row) async {
    final id = row['id'] as String;

    final colorRows = await db.query(
      DatabaseHelper.tableColors,
      columns: ['color'],
      where: 'car_id = ?',
      whereArgs: [id],
    );
    final featureRows = await db.query(
      DatabaseHelper.tableFeatures,
      columns: ['feature'],
      where: 'car_id = ?',
      whereArgs: [id],
    );

    return Car(
      id: id,
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
      fuelConsumptionKmPerL: row['fuel_consumption'] as double,
      seatingCapacity: row['seating_capacity'] as int,
      priceMinMillionIdr: row['price_min'] as double,
      priceMaxMillionIdr: row['price_max'] as double,
      imageUrl: row['image_url'] as String,
      description: row['description'] as String,
      features: featureRows.map((r) => r['feature'] as String).toList(),
      safetyRatingStars: row['safety_rating'] as int,
      isElectric: (row['is_electric'] as int) == 1,
      powerHp: row['power_hp'] as int,
      torqueNm: row['torque_nm'] as int,
      groundClearanceMm: row['ground_clearance_mm'] as int,
      lengthWidthHeightMm: row['dimensions'] as String,
    );
  }

  Map<String, Object?> _carToRow(Car car) => {
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
        'is_electric': car.isElectric ? 1 : 0,
        'power_hp': car.powerHp,
        'torque_nm': car.torqueNm,
        'ground_clearance_mm': car.groundClearanceMm,
        'dimensions': car.lengthWidthHeightMm,
      };
}
