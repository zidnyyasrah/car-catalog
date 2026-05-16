import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/car.dart';
import '../models/car_generation.dart';
import '../models/car_model.dart';

/// Fetches the brand → model → generation → variant hierarchy from Supabase
/// in a single nested PostgREST query, then builds Dart objects.
///
/// Schema expected:
///   brands(id, name, country)
///   models(id, brand_id, name, body_type, description, hero_image_url)
///   generations(id, model_id, name, chassis_code, year_start, year_end,
///               description, hero_image_url)
///   variants(id, generation_id, trim_name, year_start, year_end,
///            engine_type, engine_displacement_cc, power_hp, torque_nm,
///            transmission, drive_system, is_electric,
///            fuel_consumption_km_per_l, seating_capacity,
///            ground_clearance_mm, dimensions, safety_rating,
///            price_min_million_idr, price_max_million_idr,
///            image_url, description)
///   variant_colors(variant_id, color)
///   variant_features(variant_id, feature)
class CarRepository {
  SupabaseClient get _db => Supabase.instance.client;

  /// One-shot fetch of everything. The dataset is small enough that we hydrate
  /// the full hierarchy client-side and group from there.
  Future<List<Car>> fetchAllVariants() async {
    final rows = await _db.from('variants').select('''
      id, trim_name, year_start, year_end,
      engine_type, engine_displacement_cc, power_hp, torque_nm,
      transmission, drive_system, is_electric,
      fuel_consumption_km_per_l, seating_capacity,
      ground_clearance_mm, dimensions, safety_rating,
      price_min_million_idr, price_max_million_idr,
      image_url, description,
      generations!inner (
        id, name, chassis_code, year_start, year_end,
        description, hero_image_url,
        models!inner (
          id, name, body_type, description, hero_image_url,
          brands!inner ( id, name, country )
        )
      ),
      variant_colors ( color ),
      variant_features ( feature )
    ''');

    return (rows as List).map((r) => _rowToCar(r as Map<String, dynamic>)).toList();
  }

  // ── Grouping helpers (pure functions over a Car list) ───────────────────────

  static List<String> brandsOf(List<Car> cars) {
    final set = <String>{};
    for (final c in cars) {
      set.add(c.brand);
    }
    final list = set.toList()..sort();
    return list;
  }

  static List<CarModel> modelsForBrand(List<Car> cars, String brand) {
    final filtered = cars.where((c) => c.brand == brand).toList();
    final byModel = <String, List<Car>>{};
    for (final c in filtered) {
      byModel.putIfAbsent(c.modelId, () => []).add(c);
    }

    final models = byModel.entries.map((e) {
      final variants = e.value;
      final any = variants.first;
      return CarModel(
        id: e.key,
        brand: any.brand,
        name: any.type,
        bodyType: any.bodyType,
        description: any.description,
        heroImageUrl: variants.first.imageUrl,
        variants: variants,
      );
    }).toList();

    models.sort((a, b) => a.name.compareTo(b.name));
    return models;
  }

  static List<CarGeneration> generationsForModel(
      List<Car> cars, String modelId) {
    final filtered = cars.where((c) => c.modelId == modelId).toList();
    final byGen = <String, List<Car>>{};
    for (final c in filtered) {
      byGen.putIfAbsent(c.generationId, () => []).add(c);
    }

    final gens = byGen.entries.map((e) {
      final variants = e.value;
      final any = variants.first;
      return CarGeneration(
        id: e.key,
        modelId: any.modelId,
        name: any.generationName,
        chassisCode: null, // not on Car; would need a separate fetch if needed
        yearStart: any.generationYearStart ?? any.yearStart,
        yearEnd: any.generationYearEnd,
        description: '',
        heroImageUrl: variants.first.imageUrl,
        variants: variants,
      );
    }).toList();

    // Newest generation first.
    gens.sort((a, b) => b.yearStart.compareTo(a.yearStart));
    return gens;
  }

  static List<Car> variantsForGeneration(List<Car> cars, String generationId) {
    final filtered =
        cars.where((c) => c.generationId == generationId).toList();
    filtered.sort((a, b) => a.priceMinMillionIdr.compareTo(b.priceMinMillionIdr));
    return filtered;
  }

  // ── Mapping ────────────────────────────────────────────────────────────────

  Car _rowToCar(Map<String, dynamic> row) {
    final gen = row['generations'] as Map<String, dynamic>;
    final model = gen['models'] as Map<String, dynamic>;
    final brand = model['brands'] as Map<String, dynamic>;

    final colors = ((row['variant_colors'] as List?) ?? const [])
        .map((e) => (e as Map)['color'] as String)
        .toList();
    final features = ((row['variant_features'] as List?) ?? const [])
        .map((e) => (e as Map)['feature'] as String)
        .toList();

    return Car(
      id: row['id'] as String,
      brand: brand['name'] as String,
      modelId: model['id'] as String,
      type: model['name'] as String,
      generationId: gen['id'] as String,
      generationName: gen['name'] as String,
      generationYearStart: gen['year_start'] as int?,
      generationYearEnd: gen['year_end'] as int?,
      variant: row['trim_name'] as String,
      yearStart: row['year_start'] as int,
      yearEnd: row['year_end'] as int?,
      bodyType: (model['body_type'] as String?) ?? '-',
      engineType: (row['engine_type'] as String?) ?? '-',
      engineDisplacementCc: (row['engine_displacement_cc'] as int?) ?? 0,
      transmission: (row['transmission'] as String?) ?? '-',
      driveSystem: (row['drive_system'] as String?) ?? '-',
      colors: colors,
      fuelConsumptionKmPerL:
          ((row['fuel_consumption_km_per_l'] as num?) ?? 0).toDouble(),
      seatingCapacity: (row['seating_capacity'] as int?) ?? 0,
      priceMinMillionIdr:
          ((row['price_min_million_idr'] as num?) ?? 0).toDouble(),
      priceMaxMillionIdr:
          ((row['price_max_million_idr'] as num?) ?? 0).toDouble(),
      imageUrl: (row['image_url'] as String?) ?? '',
      description: ((row['description'] as String?) ??
          (gen['description'] as String?) ??
          (model['description'] as String?) ??
          ''),
      features: features,
      safetyRatingStars: (row['safety_rating'] as int?) ?? 0,
      isElectric: (row['is_electric'] as bool?) ?? false,
      powerHp: (row['power_hp'] as int?) ?? 0,
      torqueNm: (row['torque_nm'] as int?) ?? 0,
      groundClearanceMm: (row['ground_clearance_mm'] as int?) ?? 0,
      lengthWidthHeightMm: (row['dimensions'] as String?) ?? '-',
    );
  }
}
