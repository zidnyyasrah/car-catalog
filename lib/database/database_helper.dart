import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _dbName = 'carcat.db';
  static const _dbVersion = 1;

  // Table names
  static const tableCars = 'cars';
  static const tableColors = 'car_colors';
  static const tableFeatures = 'car_features';
  static const tableFavorites = 'favorites';

  static Database? _db;

  static Future<Database> get database async {
    _db ??= await _open();
    return _db!;
  }

  static Future<Database> _open() async {
    final path = join(await getDatabasesPath(), _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableCars (
        id                      TEXT PRIMARY KEY,
        brand                   TEXT NOT NULL,
        type                    TEXT NOT NULL,
        variant                 TEXT NOT NULL,
        year                    INTEGER NOT NULL,
        body_type               TEXT NOT NULL,
        engine_type             TEXT NOT NULL,
        engine_displacement_cc  INTEGER NOT NULL,
        transmission            TEXT NOT NULL,
        drive_system            TEXT NOT NULL,
        fuel_consumption        REAL NOT NULL,
        seating_capacity        INTEGER NOT NULL,
        price_min               REAL NOT NULL,
        price_max               REAL NOT NULL,
        image_url               TEXT NOT NULL,
        description             TEXT NOT NULL,
        safety_rating           INTEGER NOT NULL,
        is_electric             INTEGER NOT NULL DEFAULT 0,
        power_hp                INTEGER NOT NULL,
        torque_nm               INTEGER NOT NULL,
        ground_clearance_mm     INTEGER NOT NULL,
        dimensions              TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableColors (
        id      INTEGER PRIMARY KEY AUTOINCREMENT,
        car_id  TEXT NOT NULL,
        color   TEXT NOT NULL,
        FOREIGN KEY (car_id) REFERENCES $tableCars(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableFeatures (
        id       INTEGER PRIMARY KEY AUTOINCREMENT,
        car_id   TEXT NOT NULL,
        feature  TEXT NOT NULL,
        FOREIGN KEY (car_id) REFERENCES $tableCars(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableFavorites (
        car_id TEXT PRIMARY KEY,
        FOREIGN KEY (car_id) REFERENCES $tableCars(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('CREATE INDEX idx_cars_brand ON $tableCars(brand)');
    await db.execute('CREATE INDEX idx_cars_body_type ON $tableCars(body_type)');
    await db.execute('CREATE INDEX idx_colors_car_id ON $tableColors(car_id)');
    await db.execute('CREATE INDEX idx_features_car_id ON $tableFeatures(car_id)');
  }
}
