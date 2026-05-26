import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
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
  static const _bucket = 'car-images';
  static const _uuid = Uuid();

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
        chassisCode: any.generationChassisCode,
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

  // ── Writes: storage ────────────────────────────────────────────────────────

  /// Uploads a local image to the `car-images` bucket under [folder], returns
  /// the public URL ready to store in `image_url` / `hero_image_url`.
  Future<String> uploadImage(File file, {required String folder}) async {
    final ext = file.path.split('.').last.toLowerCase();
    final key = '$folder/${_uuid.v4()}.$ext';
    await _db.storage.from(_bucket).upload(
          key,
          file,
          fileOptions: FileOptions(
            cacheControl: '3600',
            upsert: false,
            contentType: _mimeFor(ext),
          ),
        );
    return _db.storage.from(_bucket).getPublicUrl(key);
  }

  String? _mimeFor(String ext) {
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'heic':
        return 'image/heic';
      default:
        return null;
    }
  }

  // ── Writes: brands ─────────────────────────────────────────────────────────

  Future<String> upsertBrand({
    String? id,
    required String name,
    required String country,
  }) async {
    final rowId = id ?? _uuid.v4();
    await _db.from('brands').upsert({
      'id': rowId,
      'name': name,
      'country': country,
    });
    return rowId;
  }

  Future<void> deleteBrand(String id) async {
    final models = await _db.from('models').select('id').eq('brand_id', id);
    for (final m in models as List) {
      await deleteModel((m as Map)['id'] as String);
    }
    await _db.from('brands').delete().eq('id', id);
  }

  // ── Writes: models ─────────────────────────────────────────────────────────

  Future<String> upsertModel({
    String? id,
    required String brandId,
    required String name,
    required String bodyType,
    String? description,
    String? heroImageUrl,
  }) async {
    final rowId = id ?? _uuid.v4();
    await _db.from('models').upsert({
      'id': rowId,
      'brand_id': brandId,
      'name': name,
      'body_type': bodyType,
      'description': description,
      'hero_image_url': heroImageUrl,
    });
    return rowId;
  }

  Future<void> deleteModel(String id) async {
    final gens =
        await _db.from('generations').select('id').eq('model_id', id);
    for (final g in gens as List) {
      await deleteGeneration((g as Map)['id'] as String);
    }
    await _db.from('models').delete().eq('id', id);
  }

  // ── Writes: generations ────────────────────────────────────────────────────

  Future<String> upsertGeneration({
    String? id,
    required String modelId,
    required String name,
    String? chassisCode,
    required int yearStart,
    int? yearEnd,
    String? description,
    String? heroImageUrl,
  }) async {
    final rowId = id ?? _uuid.v4();
    await _db.from('generations').upsert({
      'id': rowId,
      'model_id': modelId,
      'name': name,
      'chassis_code': chassisCode,
      'year_start': yearStart,
      'year_end': yearEnd,
      'description': description,
      'hero_image_url': heroImageUrl,
    });
    return rowId;
  }

  Future<void> deleteGeneration(String id) async {
    final variants =
        await _db.from('variants').select('id').eq('generation_id', id);
    for (final v in variants as List) {
      await deleteVariant((v as Map)['id'] as String);
    }
    await _db.from('generations').delete().eq('id', id);
  }

  // ── Writes: variants (+ colors + features join tables) ─────────────────────

  Future<String> upsertVariant({
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
    final rowId = id ?? _uuid.v4();
    await _db.from('variants').upsert({
      'id': rowId,
      'generation_id': generationId,
      'trim_name': trimName,
      'year_start': yearStart,
      'year_end': yearEnd,
      'engine_type': engineType,
      'engine_displacement_cc': engineDisplacementCc,
      'power_hp': powerHp,
      'torque_nm': torqueNm,
      'transmission': transmission,
      'drive_system': driveSystem,
      'is_electric': isElectric,
      'fuel_consumption_km_per_l': fuelConsumptionKmPerL,
      'seating_capacity': seatingCapacity,
      'ground_clearance_mm': groundClearanceMm,
      'dimensions': dimensions,
      'safety_rating': safetyRating,
      'price_min_million_idr': priceMinMillionIdr,
      'price_max_million_idr': priceMaxMillionIdr,
      'image_url': imageUrl,
      'description': description,
    });

    // Replace join-table rows wholesale (simplest correct semantics for an
    // edit-everything UI: the form is the source of truth).
    await _db.from('variant_colors').delete().eq('variant_id', rowId);
    if (colors.isNotEmpty) {
      await _db.from('variant_colors').insert(
            colors.map((c) => {'variant_id': rowId, 'color': c}).toList(),
          );
    }
    await _db.from('variant_features').delete().eq('variant_id', rowId);
    if (features.isNotEmpty) {
      await _db.from('variant_features').insert(
            features.map((f) => {'variant_id': rowId, 'feature': f}).toList(),
          );
    }

    return rowId;
  }

  Future<void> deleteVariant(String id) async {
    await _db.from('variant_colors').delete().eq('variant_id', id);
    await _db.from('variant_features').delete().eq('variant_id', id);
    await _db.from('variants').delete().eq('id', id);
  }

  /// Lookup the brand id by display name (since the read-side flattens it).
  Future<String?> brandIdByName(String name) async {
    final row = await _db
        .from('brands')
        .select('id')
        .eq('name', name)
        .maybeSingle();
    return row == null ? null : row['id'] as String;
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
      generationChassisCode: gen['chassis_code'] as String?,
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
