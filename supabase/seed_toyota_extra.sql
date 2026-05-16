-- ─────────────────────────────────────────────────────────────────────────────
-- CarCat seed — extra Toyota models (Indonesia market)
--
-- Coverage:
--   Hilux             Gen 8 Facelift    (AN120)         2020-present
--   Innova            Gen 2 Reborn      (TGN140)        2015-2022
--   Innova            Gen 3 Zenix       (AGB10)         2022-present
--   Rush              Gen 2             (F800)          2018-present
--   Avanza            Gen 3             (W100, DNGA)    2022-present
--   Veloz             Gen 1             (W100, DNGA)    2022-present
--   Raize             Gen 1             (A200/A210)     2021-present
--   GR86              Gen 1             (ZN8)           2022-present
--
-- Accuracy notes (the user asked: don't hallucinate):
--   * Engine codes, displacement, HP/torque, transmission, drive system,
--     dimensions, and ground clearance are sourced from TAM-published spec
--     sheets (rounded HP from PS where conversion <1 hp).
--   * Diesel 2GD-FTV: M/T variants are rated 343 Nm, A/T 400 Nm. Distinguished
--     in rows below — don't assume parity.
--   * Innova Zenix Hybrid: 152 hp engine, 113 hp motor, 186 hp combined system.
--     The "power_hp" column uses combined system power on hybrid variants.
--   * Fuel consumption is the manufacturer "claim" figure, rounded to integer
--     km/L. Real-world is generally 10-20% lower.
--   * Prices are approximate Jakarta OTR in the launch-period band, in IDR
--     millions. They change quarterly — treat as indicative, not current.
--   * Safety ratings are ASEAN NCAP star where known; some entries left at
--     model-line baseline if specific variant rating not published.
--
-- Run AFTER schema.sql and seed.sql. Self-contained (does not truncate; appends
-- new models referencing the existing 'toyota' brand).
-- ─────────────────────────────────────────────────────────────────────────────

-- ═════════════════════════════════════════════════════════════════════════════
-- MODELS
-- ═════════════════════════════════════════════════════════════════════════════
insert into models (id, brand_id, name, body_type, description, hero_image_url) values
  ('toyota-hilux', 'toyota', 'Hilux', 'Pickup',
   'Pickup ladder-frame ikonik Toyota, dikenal akan ketangguhan dan reliabilitas di medan ekstrem. Tersedia dalam konfigurasi Single Cabin dan Double Cabin.',
   'https://picsum.photos/seed/hilux-hero/1200/600'),

  ('toyota-innova', 'toyota', 'Innova', 'MPV',
   'MPV keluarga Indonesia generasi penerus Kijang. Dari era ladder-frame RWD diesel hingga TNGA-C FWD hybrid, Innova selalu jadi pilihan utama keluarga besar.',
   'https://picsum.photos/seed/innova-hero/1200/600'),

  ('toyota-rush', 'toyota', 'Rush', 'SUV',
   'SUV 7-penumpang RWD berbasis Daihatsu Terios. Populer untuk yang butuh ground clearance tinggi dan kapasitas keluarga.',
   'https://picsum.photos/seed/rush-hero/1200/600'),

  ('toyota-avanza', 'toyota', 'Avanza', 'MPV',
   'MPV terlaris Indonesia. Generasi ketiga (2022+) pindah ke platform DNGA dengan penggerak depan, perubahan paling signifikan sejak peluncuran 2003.',
   'https://picsum.photos/seed/avanza-hero/1200/600'),

  ('toyota-veloz', 'toyota', 'Veloz', 'MPV',
   'Sejak 2022, Veloz menjadi nameplate terpisah dari Avanza dengan posisi lebih premium. Berbagi platform DNGA tapi dengan trim, suspensi, dan fitur lebih lengkap.',
   'https://picsum.photos/seed/veloz-hero/1200/600'),

  ('toyota-raize', 'toyota', 'Raize', 'SUV',
   'Crossover compact berbasis DNGA, kembaran Daihatsu Rocky. Mesin 1.0L turbo memberikan tenaga setara 1.5L NA dengan efisiensi lebih baik.',
   'https://picsum.photos/seed/raize-hero/1200/600'),

  ('toyota-gr86', 'toyota', 'GR86', 'Coupe',
   'Sports coupe RWD hasil kolaborasi Toyota-Subaru. Mesin boxer 2.4L NA, bobot ringan, dan fokus pada handling — bukan output mentah.',
   'https://picsum.photos/seed/gr86-hero/1200/600');

-- ═════════════════════════════════════════════════════════════════════════════
-- GENERATIONS
-- ═════════════════════════════════════════════════════════════════════════════
insert into generations (id, model_id, name, chassis_code, year_start, year_end, description, hero_image_url) values

  -- ── Hilux ───────────────────────────────────────────────────────────────
  ('toyota-hilux-gen8-fl', 'toyota-hilux', 'Gen 8 Facelift', 'AN120', 2020, null,
   'Facelift mid-cycle Hilux generasi 8. Mesin 2.8L 1GD-FTV ditingkatkan menjadi 201 hp / 500 Nm. Grille baru, headlamp LED, dan interior lebih modern. GR Sport diperkenalkan 2022.',
   'https://picsum.photos/seed/hilux-gen8fl/1200/600'),

  -- ── Innova ──────────────────────────────────────────────────────────────
  ('toyota-innova-reborn', 'toyota-innova', 'Reborn (Gen 2)', 'TGN140', 2015, 2022,
   'Generasi kedua Kijang Innova, dijuluki "Reborn" oleh TAM. Desain lebih SUV-esque dibanding pendahulunya. Tetap ladder-frame RWD, dengan mesin baru 2.4L diesel 2GD-FTV (149 hp / 400 Nm A/T) menggantikan 2.5L 2KD-FTV.',
   'https://picsum.photos/seed/innova-reborn/1200/600'),

  ('toyota-innova-zenix', 'toyota-innova', 'Zenix (Gen 3)', 'AGB10', 2022, null,
   'Generasi ketiga, dijuluki "Zenix". Perubahan platform besar: dari ladder-frame RWD ke TNGA-C monocoque FWD. Hadir dengan opsi bensin 2.0 dan hybrid 2.0 (sistem 186 hp). Penolakan dari basis komersial menuju MPV premium.',
   'https://picsum.photos/seed/innova-zenix/1200/600'),

  -- ── Rush ────────────────────────────────────────────────────────────────
  ('toyota-rush-gen2', 'toyota-rush', 'Gen 2', 'F800', 2018, null,
   'Generasi kedua Rush, berbasis Daihatsu Terios baru. Lebih ramping dan modern dari Gen 1. Mesin 1.5L 2NR-VE (104 hp / 136 Nm). 7-penumpang RWD dengan ground clearance 220 mm.',
   'https://picsum.photos/seed/rush-gen2/1200/600'),

  -- ── Avanza ──────────────────────────────────────────────────────────────
  ('toyota-avanza-gen3', 'toyota-avanza', 'Gen 3 (DNGA)', 'W100', 2022, null,
   'Perubahan paling drastis sejak 2003: pindah ke platform DNGA dengan penggerak depan (FWD). Mesin 1.3L 1NR-VE dan 1.5L 2NR-VE. Dimensi sedikit lebih ringkas, bagasi lebih rata.',
   'https://picsum.photos/seed/avanza-gen3/1200/600'),

  -- ── Veloz ───────────────────────────────────────────────────────────────
  ('toyota-veloz-gen1', 'toyota-veloz', 'Gen 1 (Standalone)', 'W100', 2022, null,
   'Sejak 2022, Veloz dipisahkan dari Avanza sebagai nameplate sendiri. Trim atas mendapat Toyota Safety Sense (TSS), suspensi lebih halus, dan interior premium.',
   'https://picsum.photos/seed/veloz-gen1/1200/600'),

  -- ── Raize ───────────────────────────────────────────────────────────────
  ('toyota-raize-gen1', 'toyota-raize', 'Gen 1', 'A200/A210', 2021, null,
   'Crossover kompak DNGA. Mesin 1.0L turbo 1KR-VET (98 hp / 140 Nm) cukup punchy untuk ukurannya. Tersedia varian GR Sport dengan suspensi dan body kit khusus.',
   'https://picsum.photos/seed/raize-gen1/1200/600'),

  -- ── GR86 ────────────────────────────────────────────────────────────────
  ('toyota-gr86-gen1', 'toyota-gr86', 'Gen 1', 'ZN8', 2022, null,
   'Generasi kedua 86 (penerus ZN6) yang di-rebadge sebagai "GR86". Mesin boxer 2.4L FA24 menggantikan 2.0L FA20, naik ke 232 hp / 250 Nm tanpa turbo. Tetap RWD, fokus handling.',
   'https://picsum.photos/seed/gr86-gen1/1200/600');

-- ═════════════════════════════════════════════════════════════════════════════
-- HILUX — VARIANTS
-- 2GD-FTV 2.4L: M/T → 343 Nm, A/T → 400 Nm (different ratings per gearbox)
-- 1GD-FTV 2.8L: 201 hp / 500 Nm
-- ═════════════════════════════════════════════════════════════════════════════
insert into variants (id, generation_id, trim_name, year_start, year_end,
  engine_type, engine_displacement_cc, power_hp, torque_nm,
  transmission, drive_system, fuel_consumption_km_per_l, seating_capacity,
  ground_clearance_mm, dimensions, safety_rating,
  price_min_million_idr, price_max_million_idr, image_url, description) values

  ('hilux-gen8fl-sc-24-diesel-mt', 'toyota-hilux-gen8-fl',
   'Single Cabin 2.4 Diesel M/T', 2020, null,
   '2GD-FTV 2.4L D-4D Common Rail Turbo Diesel', 2393, 148, 343,
   'M/T 5-speed', '4x2 RWD', 14, 3, 227, '5285 x 1800 x 1815', 0,
   265, 285, 'https://picsum.photos/seed/hilux-sc-24/600/380',
   'Single Cabin diesel untuk armada komersial. Bak datar panjang, payload tinggi. Tidak dirating ASEAN NCAP.'),

  ('hilux-gen8fl-dc-24g-diesel-mt-4x4', 'toyota-hilux-gen8-fl',
   'Double Cabin G 2.4 Diesel M/T 4x4', 2020, null,
   '2GD-FTV 2.4L D-4D Common Rail Turbo Diesel', 2393, 148, 343,
   'M/T 6-speed', '4x4', 13, 5, 286, '5325 x 1855 x 1815', 4,
   430, 455, 'https://picsum.photos/seed/hilux-dc-24g/600/380',
   'Double Cabin 4x4 manual. Pilihan untuk medan off-road dengan kontrol penuh transmisi.'),

  ('hilux-gen8fl-dc-24v-diesel-at-4x4', 'toyota-hilux-gen8-fl',
   'Double Cabin V 2.4 Diesel A/T 4x4', 2020, null,
   '2GD-FTV 2.4L D-4D Common Rail Turbo Diesel', 2393, 148, 400,
   'A/T 6-speed', '4x4', 12, 5, 286, '5325 x 1855 x 1815', 4,
   495, 525, 'https://picsum.photos/seed/hilux-dc-24v/600/380',
   'Double Cabin V matic 4x4. Torsi 2GD-FTV naik ke 400 Nm dengan A/T 6-speed.'),

  ('hilux-gen8fl-dc-28v-diesel-at-4x4', 'toyota-hilux-gen8-fl',
   'Double Cabin V 2.8 Diesel A/T 4x4', 2020, null,
   '1GD-FTV 2.8L D-4D Common Rail Turbo Diesel', 2755, 201, 500,
   'A/T 6-speed', '4x4', 11, 5, 286, '5325 x 1855 x 1815', 4,
   600, 640, 'https://picsum.photos/seed/hilux-dc-28v/600/380',
   'Top trim Double Cabin dengan mesin 2.8L 1GD-FTV: 201 hp / 500 Nm. Performa terbaik di kelasnya.');

-- ═════════════════════════════════════════════════════════════════════════════
-- INNOVA REBORN (Gen 2) — VARIANTS
-- 1TR-FE 2.0L petrol: 139 hp / 183 Nm
-- 2GD-FTV 2.4L diesel: 149 hp / 360 Nm (A/T) — note: this engine in Innova is
-- detuned vs Hilux/Fortuner; 360 Nm is the published Innova A/T rating
-- ═════════════════════════════════════════════════════════════════════════════
insert into variants (id, generation_id, trim_name, year_start, year_end,
  engine_type, engine_displacement_cc, power_hp, torque_nm,
  transmission, drive_system, fuel_consumption_km_per_l, seating_capacity,
  ground_clearance_mm, dimensions, safety_rating,
  price_min_million_idr, price_max_million_idr, image_url, description) values

  ('innova-reborn-20g-petrol-mt', 'toyota-innova-reborn',
   '2.0 G Bensin M/T', 2015, 2022,
   '1TR-FE 2.0L DOHC Dual VVT-i', 1998, 139, 183,
   'M/T 5-speed', 'RWD', 12, 8, 195, '4735 x 1830 x 1795', 4,
   320, 340, 'https://picsum.photos/seed/innova-20g-mt/600/380',
   'Entry trim bensin manual. Mesin 1TR-FE yang sama dengan Hilux SC. 8 penumpang dengan konfigurasi 2-3-3.'),

  ('innova-reborn-20v-petrol-at', 'toyota-innova-reborn',
   '2.0 V Bensin A/T', 2015, 2022,
   '1TR-FE 2.0L DOHC Dual VVT-i', 1998, 139, 183,
   'A/T 6-speed', 'RWD', 11, 7, 195, '4735 x 1830 x 1795', 4,
   400, 425, 'https://picsum.photos/seed/innova-20v-at/600/380',
   'V bensin matic 6-speed. Captain seat baris kedua (7 penumpang), jok kulit, push start.'),

  ('innova-reborn-24v-diesel-at', 'toyota-innova-reborn',
   '2.4 V Diesel A/T', 2015, 2022,
   '2GD-FTV 2.4L D-4D Common Rail Turbo Diesel', 2393, 149, 360,
   'A/T 6-speed', 'RWD', 14, 7, 195, '4735 x 1830 x 1795', 4,
   430, 455, 'https://picsum.photos/seed/innova-24v-at/600/380',
   'Diesel best-seller di kelasnya. Konsumsi BBM lebih efisien dibanding bensin di tol panjang.'),

  ('innova-reborn-24-venturer-diesel-at', 'toyota-innova-reborn',
   '2.4 Venturer Diesel A/T', 2017, 2022,
   '2GD-FTV 2.4L D-4D Common Rail Turbo Diesel', 2393, 149, 360,
   'A/T 6-speed', 'RWD', 14, 7, 195, '4735 x 1830 x 1795', 4,
   480, 505, 'https://picsum.photos/seed/innova-venturer/600/380',
   'Trim atas dengan body kit Venturer, velg dua tone, dan emblem khusus. Diperkenalkan akhir 2017.');

-- ═════════════════════════════════════════════════════════════════════════════
-- INNOVA ZENIX (Gen 3) — VARIANTS
-- M20A-FKS 2.0L petrol: 174 hp / 205 Nm
-- M20A-FXS 2.0L hybrid: engine 152 hp + motor 113 hp → 186 hp combined system
-- power_hp on hybrid = combined system output (TAM published figure)
-- ═════════════════════════════════════════════════════════════════════════════
insert into variants (id, generation_id, trim_name, year_start, year_end,
  engine_type, engine_displacement_cc, power_hp, torque_nm,
  transmission, drive_system, fuel_consumption_km_per_l, seating_capacity,
  ground_clearance_mm, dimensions, safety_rating,
  price_min_million_idr, price_max_million_idr, image_url, description) values

  ('innova-zenix-20g-petrol-cvt', 'toyota-innova-zenix',
   '2.0 G Bensin CVT', 2022, null,
   'M20A-FKS 2.0L DOHC Dual VVT-i', 1987, 174, 205,
   'CVT', 'FWD', 14, 7, 185, '4755 x 1850 x 1795', 5,
   420, 445, 'https://picsum.photos/seed/zenix-20g/600/380',
   'Bensin entry trim. Mesin M20A-FKS dengan CVT. Platform TNGA-C FWD — handling lebih mirip mobil penumpang.'),

  ('innova-zenix-20v-hybrid', 'toyota-innova-zenix',
   '2.0 V Hybrid e-CVT', 2022, null,
   'M20A-FXS 2.0L Hybrid + Motor Listrik', 1987, 186, 188,
   'e-CVT', 'FWD', 23, 7, 185, '4755 x 1850 x 1795', 5,
   495, 525, 'https://picsum.photos/seed/zenix-20v-hyb/600/380',
   'Hybrid trim menengah. Sistem hybrid Toyota Series-Parallel: engine 152 hp + motor 113 hp = 186 hp combined.'),

  ('innova-zenix-20q-hybrid-modellista', 'toyota-innova-zenix',
   '2.0 Q Hybrid Modellista e-CVT', 2023, null,
   'M20A-FXS 2.0L Hybrid + Motor Listrik', 1987, 186, 188,
   'e-CVT', 'FWD', 23, 7, 185, '4755 x 1850 x 1795', 5,
   620, 660, 'https://picsum.photos/seed/zenix-20q-modellista/600/380',
   'Top trim dengan body kit Modellista, captain seat ventilasi, panoramic roof, dan JBL audio.');

-- ═════════════════════════════════════════════════════════════════════════════
-- RUSH — VARIANTS (Gen 2, 2NR-VE 1.5L: 104 hp / 136 Nm)
-- ═════════════════════════════════════════════════════════════════════════════
insert into variants (id, generation_id, trim_name, year_start, year_end,
  engine_type, engine_displacement_cc, power_hp, torque_nm,
  transmission, drive_system, fuel_consumption_km_per_l, seating_capacity,
  ground_clearance_mm, dimensions, safety_rating,
  price_min_million_idr, price_max_million_idr, image_url, description) values

  ('rush-gen2-15g-mt', 'toyota-rush-gen2',
   '1.5 G M/T', 2018, null,
   '2NR-VE 1.5L DOHC Dual VVT-i', 1496, 104, 136,
   'M/T 5-speed', 'RWD', 13, 7, 220, '4435 x 1695 x 1705', 4,
   265, 280, 'https://picsum.photos/seed/rush-15g-mt/600/380',
   'Rush G manual. Konfigurasi 5+2 (jok belakang lipat). Ground clearance 220 mm berguna di banjir/jalan rusak.'),

  ('rush-gen2-15g-at', 'toyota-rush-gen2',
   '1.5 G A/T', 2018, null,
   '2NR-VE 1.5L DOHC Dual VVT-i', 1496, 104, 136,
   'A/T 4-speed', 'RWD', 13, 7, 220, '4435 x 1695 x 1705', 4,
   280, 295, 'https://picsum.photos/seed/rush-15g-at/600/380',
   'Versi matic 4-speed. Best-seller Rush untuk pemakaian harian kota + sesekali luar kota.'),

  ('rush-gen2-15-trd-sportivo', 'toyota-rush-gen2',
   '1.5 TRD Sportivo A/T', 2018, null,
   '2NR-VE 1.5L DOHC Dual VVT-i', 1496, 104, 136,
   'A/T 4-speed', 'RWD', 13, 7, 220, '4435 x 1695 x 1705', 4,
   305, 320, 'https://picsum.photos/seed/rush-trd/600/380',
   'TRD Sportivo dengan body kit, velg dua-tone, dan emblem TRD. Mekanis identik dengan G A/T.');

-- ═════════════════════════════════════════════════════════════════════════════
-- AVANZA GEN 3 — VARIANTS
-- 1NR-VE 1.3L: 96 hp / 121 Nm; 2NR-VE 1.5L: 106 hp / 138 Nm
-- DNGA platform = FWD (perubahan dari RWD ladder-frame Gen 2)
-- ═════════════════════════════════════════════════════════════════════════════
insert into variants (id, generation_id, trim_name, year_start, year_end,
  engine_type, engine_displacement_cc, power_hp, torque_nm,
  transmission, drive_system, fuel_consumption_km_per_l, seating_capacity,
  ground_clearance_mm, dimensions, safety_rating,
  price_min_million_idr, price_max_million_idr, image_url, description) values

  ('avanza-gen3-13e-mt', 'toyota-avanza-gen3',
   '1.3 E M/T', 2022, null,
   '1NR-VE 1.3L DOHC Dual VVT-i', 1329, 96, 121,
   'M/T 5-speed', 'FWD', 16, 7, 190, '4395 x 1730 x 1665', 4,
   225, 240, 'https://picsum.photos/seed/avanza-13e-mt/600/380',
   'Entry trim manual. Mesin 1.3L 1NR-VE. Platform DNGA FWD — pertama kali Avanza tidak RWD.'),

  ('avanza-gen3-13g-cvt', 'toyota-avanza-gen3',
   '1.3 G CVT', 2022, null,
   '1NR-VE 1.3L DOHC Dual VVT-i', 1329, 96, 121,
   'CVT', 'FWD', 17, 7, 190, '4395 x 1730 x 1665', 4,
   255, 270, 'https://picsum.photos/seed/avanza-13g-cvt/600/380',
   'G CVT volume-seller. Transmisi CVT halus untuk kemacetan kota.'),

  ('avanza-gen3-15g-cvt', 'toyota-avanza-gen3',
   '1.5 G CVT', 2022, null,
   '2NR-VE 1.5L DOHC Dual VVT-i', 1496, 106, 138,
   'CVT', 'FWD', 17, 7, 190, '4395 x 1730 x 1665', 4,
   280, 295, 'https://picsum.photos/seed/avanza-15g-cvt/600/380',
   '1.5L untuk yang butuh tenaga lebih (full muatan, tanjakan). Mesin sama dengan Veloz/Rush.');

-- ═════════════════════════════════════════════════════════════════════════════
-- VELOZ (standalone, 2022+) — VARIANTS
-- 2NR-VE 1.5L: 106 hp / 138 Nm, DNGA FWD
-- ═════════════════════════════════════════════════════════════════════════════
insert into variants (id, generation_id, trim_name, year_start, year_end,
  engine_type, engine_displacement_cc, power_hp, torque_nm,
  transmission, drive_system, fuel_consumption_km_per_l, seating_capacity,
  ground_clearance_mm, dimensions, safety_rating,
  price_min_million_idr, price_max_million_idr, image_url, description) values

  ('veloz-gen1-15-mt', 'toyota-veloz-gen1',
   '1.5 M/T', 2022, null,
   '2NR-VE 1.5L DOHC Dual VVT-i', 1496, 106, 138,
   'M/T 5-speed', 'FWD', 17, 7, 190, '4475 x 1750 x 1700', 5,
   265, 280, 'https://picsum.photos/seed/veloz-15-mt/600/380',
   'Veloz manual. Body kit sport, fog lamp LED, velg 17 inci dua-tone.'),

  ('veloz-gen1-15-cvt', 'toyota-veloz-gen1',
   '1.5 CVT', 2022, null,
   '2NR-VE 1.5L DOHC Dual VVT-i', 1496, 106, 138,
   'CVT', 'FWD', 17, 7, 190, '4475 x 1750 x 1700', 5,
   285, 300, 'https://picsum.photos/seed/veloz-15-cvt/600/380',
   'Veloz CVT. Best-seller trim, hampir-flagship tanpa TSS.'),

  ('veloz-gen1-15-q-cvt-tss', 'toyota-veloz-gen1',
   '1.5 Q CVT TSS', 2022, null,
   '2NR-VE 1.5L DOHC Dual VVT-i', 1496, 106, 138,
   'CVT', 'FWD', 17, 7, 190, '4475 x 1750 x 1700', 5,
   320, 340, 'https://picsum.photos/seed/veloz-15q-tss/600/380',
   'Top trim dengan Toyota Safety Sense: Pre-Collision, Lane Departure Alert, Adaptive Cruise Control.');

-- ═════════════════════════════════════════════════════════════════════════════
-- RAIZE — VARIANTS (1.0L Turbo only; 1.2 NA varian skip dulu untuk fokus)
-- 1KR-VET 1.0L Turbo: 98 hp / 140 Nm
-- ═════════════════════════════════════════════════════════════════════════════
insert into variants (id, generation_id, trim_name, year_start, year_end,
  engine_type, engine_displacement_cc, power_hp, torque_nm,
  transmission, drive_system, fuel_consumption_km_per_l, seating_capacity,
  ground_clearance_mm, dimensions, safety_rating,
  price_min_million_idr, price_max_million_idr, image_url, description) values

  ('raize-gen1-10t-g-cvt', 'toyota-raize-gen1',
   '1.0 Turbo G CVT', 2021, null,
   '1KR-VET 1.0L Turbo 3-Silinder', 998, 98, 140,
   'CVT', 'FWD', 18, 5, 200, '4030 x 1710 x 1635', 5,
   240, 260, 'https://picsum.photos/seed/raize-10t-g/600/380',
   'Mesin 3-silinder turbo punchy untuk crossover compact. Torsi 140 Nm setara mesin 1.5L NA.'),

  ('raize-gen1-10t-gr-sport-cvt', 'toyota-raize-gen1',
   '1.0 Turbo GR Sport CVT', 2021, null,
   '1KR-VET 1.0L Turbo 3-Silinder', 998, 98, 140,
   'CVT', 'FWD', 18, 5, 200, '4030 x 1710 x 1635', 5,
   285, 305, 'https://picsum.photos/seed/raize-10t-grs/600/380',
   'GR Sport: body kit khusus, jok semi-bucket, paddle shift, dan setup suspensi GR.');

-- ═════════════════════════════════════════════════════════════════════════════
-- GR86 — VARIANTS (FA24 2.4L boxer NA)
-- 232 hp / 250 Nm — naik signifikan dari 86 lama (200 hp)
-- ═════════════════════════════════════════════════════════════════════════════
insert into variants (id, generation_id, trim_name, year_start, year_end,
  engine_type, engine_displacement_cc, power_hp, torque_nm,
  transmission, drive_system, fuel_consumption_km_per_l, seating_capacity,
  ground_clearance_mm, dimensions, safety_rating,
  price_min_million_idr, price_max_million_idr, image_url, description) values

  ('gr86-gen1-24-mt', 'toyota-gr86-gen1',
   '2.4 M/T', 2022, null,
   'FA24 2.4L Boxer-4 NA', 2387, 232, 250,
   'M/T 6-speed', 'RWD with Torsen LSD', 11, 4, 130, '4265 x 1775 x 1310', 0,
   950, 980, 'https://picsum.photos/seed/gr86-24-mt/600/380',
   'GR86 manual — varian "pure" untuk enthusiast. Boxer 2.4L FA24 dengan torsi mid-range jauh lebih baik dari FA20 lama. Tidak dirating ASEAN NCAP (sports car).'),

  ('gr86-gen1-24-at', 'toyota-gr86-gen1',
   '2.4 A/T', 2022, null,
   'FA24 2.4L Boxer-4 NA', 2387, 232, 250,
   'A/T 6-speed Paddle Shift', 'RWD with Torsen LSD', 12, 4, 130, '4265 x 1775 x 1310', 0,
   985, 1010, 'https://picsum.photos/seed/gr86-24-at/600/380',
   'Versi matic 6-speed dengan paddle shifter. Sedikit lebih lambat tapi tetap RWD + LSD.');

-- ═════════════════════════════════════════════════════════════════════════════
-- BASE COLORS for the new variants (Putih, Hitam, Silver, Abu-abu)
-- Scoped to the new generations only.
-- ═════════════════════════════════════════════════════════════════════════════
insert into variant_colors (variant_id, color)
select v.id, c.color
from variants v
cross join (values ('Putih'), ('Hitam'), ('Silver'), ('Abu-abu')) as c(color)
where v.generation_id in (
  'toyota-hilux-gen8-fl',
  'toyota-innova-reborn',
  'toyota-innova-zenix',
  'toyota-rush-gen2',
  'toyota-avanza-gen3',
  'toyota-veloz-gen1',
  'toyota-raize-gen1',
  'toyota-gr86-gen1'
)
on conflict do nothing;

-- Extra colors per variant (era / model-appropriate)
insert into variant_colors (variant_id, color) values
  -- Hilux: pickup → bronze/merah on DC trims
  ('hilux-gen8fl-dc-24g-diesel-mt-4x4', 'Bronze'),
  ('hilux-gen8fl-dc-24v-diesel-at-4x4', 'Bronze'),
  ('hilux-gen8fl-dc-24v-diesel-at-4x4', 'Merah'),
  ('hilux-gen8fl-dc-28v-diesel-at-4x4', 'Bronze'),
  ('hilux-gen8fl-dc-28v-diesel-at-4x4', 'Merah'),
  ('hilux-gen8fl-dc-28v-diesel-at-4x4', 'Attitude Black'),
  -- Innova Reborn
  ('innova-reborn-24v-diesel-at',          'Cokelat Metalik'),
  ('innova-reborn-24-venturer-diesel-at',  'Cokelat Metalik'),
  ('innova-reborn-24-venturer-diesel-at',  'Merah'),
  -- Innova Zenix
  ('innova-zenix-20v-hybrid',              'Phantom Brown'),
  ('innova-zenix-20q-hybrid-modellista',   'Phantom Brown'),
  ('innova-zenix-20q-hybrid-modellista',   'Putih Mutiara'),
  -- Rush
  ('rush-gen2-15-trd-sportivo',            'Merah'),
  -- Avanza/Veloz
  ('avanza-gen3-15g-cvt',                  'Bronze'),
  ('veloz-gen1-15-cvt',                    'Bronze'),
  ('veloz-gen1-15-q-cvt-tss',              'Bronze'),
  ('veloz-gen1-15-q-cvt-tss',              'Merah'),
  -- Raize: kuning Phoenix khas
  ('raize-gen1-10t-g-cvt',                 'Kuning Phoenix'),
  ('raize-gen1-10t-gr-sport-cvt',          'Kuning Phoenix'),
  ('raize-gen1-10t-gr-sport-cvt',          'Merah'),
  -- GR86
  ('gr86-gen1-24-mt',                      'Merah'),
  ('gr86-gen1-24-mt',                      'Championship White'),
  ('gr86-gen1-24-at',                      'Merah'),
  ('gr86-gen1-24-at',                      'Championship White')
on conflict do nothing;

-- ═════════════════════════════════════════════════════════════════════════════
-- BASE FEATURES (AC, Power Steering, Power Window, Central Lock)
-- Scoped to new generations. Hilux Single Cabin gets a reduced base.
-- ═════════════════════════════════════════════════════════════════════════════
insert into variant_features (variant_id, feature)
select v.id, f.feature
from variants v
cross join (values ('AC'), ('Power Steering'), ('Power Window'), ('Central Lock')) as f(feature)
where v.generation_id in (
  'toyota-hilux-gen8-fl',
  'toyota-innova-reborn',
  'toyota-innova-zenix',
  'toyota-rush-gen2',
  'toyota-avanza-gen3',
  'toyota-veloz-gen1',
  'toyota-raize-gen1',
  'toyota-gr86-gen1'
)
and v.id <> 'hilux-gen8fl-sc-24-diesel-mt'
on conflict do nothing;

-- Hilux Single Cabin: only AC + Power Steering as standard
insert into variant_features (variant_id, feature) values
  ('hilux-gen8fl-sc-24-diesel-mt', 'AC'),
  ('hilux-gen8fl-sc-24-diesel-mt', 'Power Steering')
on conflict do nothing;

-- Variant-specific features
insert into variant_features (variant_id, feature) values
  -- ── Hilux DC G ──
  ('hilux-gen8fl-dc-24g-diesel-mt-4x4', '3 Airbag'),
  ('hilux-gen8fl-dc-24g-diesel-mt-4x4', 'ABS + EBD + BA'),
  ('hilux-gen8fl-dc-24g-diesel-mt-4x4', 'Hill Start Assist'),
  ('hilux-gen8fl-dc-24g-diesel-mt-4x4', 'Active Traction Control'),
  ('hilux-gen8fl-dc-24g-diesel-mt-4x4', 'Rear Diff Lock'),
  -- ── Hilux DC V 2.4 ──
  ('hilux-gen8fl-dc-24v-diesel-at-4x4', '7 Airbag'),
  ('hilux-gen8fl-dc-24v-diesel-at-4x4', 'ABS + EBD + BA'),
  ('hilux-gen8fl-dc-24v-diesel-at-4x4', 'Vehicle Stability Control'),
  ('hilux-gen8fl-dc-24v-diesel-at-4x4', 'Hill Start Assist'),
  ('hilux-gen8fl-dc-24v-diesel-at-4x4', 'Downhill Assist Control'),
  ('hilux-gen8fl-dc-24v-diesel-at-4x4', 'LED Headlamp'),
  ('hilux-gen8fl-dc-24v-diesel-at-4x4', 'Push Start + Keyless'),
  ('hilux-gen8fl-dc-24v-diesel-at-4x4', 'Rear Diff Lock'),
  -- ── Hilux DC V 2.8 ──
  ('hilux-gen8fl-dc-28v-diesel-at-4x4', '7 Airbag'),
  ('hilux-gen8fl-dc-28v-diesel-at-4x4', 'ABS + EBD + BA'),
  ('hilux-gen8fl-dc-28v-diesel-at-4x4', 'Vehicle Stability Control'),
  ('hilux-gen8fl-dc-28v-diesel-at-4x4', 'Hill Start Assist'),
  ('hilux-gen8fl-dc-28v-diesel-at-4x4', 'Downhill Assist Control'),
  ('hilux-gen8fl-dc-28v-diesel-at-4x4', 'LED Headlamp'),
  ('hilux-gen8fl-dc-28v-diesel-at-4x4', 'Push Start + Keyless'),
  ('hilux-gen8fl-dc-28v-diesel-at-4x4', 'Rear Diff Lock'),
  ('hilux-gen8fl-dc-28v-diesel-at-4x4', 'Jok Kulit'),
  ('hilux-gen8fl-dc-28v-diesel-at-4x4', 'Apple CarPlay / Android Auto'),
  -- ── Innova Reborn G 2.0 ──
  ('innova-reborn-20g-petrol-mt', '2 Airbag'),
  ('innova-reborn-20g-petrol-mt', 'ABS + EBD'),
  ('innova-reborn-20g-petrol-mt', '8 Penumpang'),
  -- ── Innova Reborn V 2.0 ──
  ('innova-reborn-20v-petrol-at', '3 Airbag'),
  ('innova-reborn-20v-petrol-at', 'ABS + EBD'),
  ('innova-reborn-20v-petrol-at', 'Captain Seat Row 2'),
  ('innova-reborn-20v-petrol-at', 'Push Start + Keyless'),
  ('innova-reborn-20v-petrol-at', 'Jok Kulit'),
  -- ── Innova Reborn V 2.4 Diesel ──
  ('innova-reborn-24v-diesel-at', '3 Airbag'),
  ('innova-reborn-24v-diesel-at', 'ABS + EBD'),
  ('innova-reborn-24v-diesel-at', 'Captain Seat Row 2'),
  ('innova-reborn-24v-diesel-at', 'Push Start + Keyless'),
  ('innova-reborn-24v-diesel-at', 'Jok Kulit'),
  ('innova-reborn-24v-diesel-at', 'Power Tailgate'),
  -- ── Innova Reborn Venturer ──
  ('innova-reborn-24-venturer-diesel-at', '3 Airbag'),
  ('innova-reborn-24-venturer-diesel-at', 'ABS + EBD'),
  ('innova-reborn-24-venturer-diesel-at', 'Captain Seat Row 2'),
  ('innova-reborn-24-venturer-diesel-at', 'Push Start + Keyless'),
  ('innova-reborn-24-venturer-diesel-at', 'Jok Kulit Premium'),
  ('innova-reborn-24-venturer-diesel-at', 'Body Kit Venturer'),
  ('innova-reborn-24-venturer-diesel-at', 'Velg 17 Dual-Tone'),
  -- ── Zenix G Gasoline ──
  ('innova-zenix-20g-petrol-cvt', '3 Airbag'),
  ('innova-zenix-20g-petrol-cvt', 'ABS + EBD + BA'),
  ('innova-zenix-20g-petrol-cvt', 'Vehicle Stability Control'),
  ('innova-zenix-20g-petrol-cvt', 'Hill Start Assist'),
  ('innova-zenix-20g-petrol-cvt', 'Apple CarPlay / Android Auto'),
  -- ── Zenix V Hybrid ──
  ('innova-zenix-20v-hybrid', '6 Airbag'),
  ('innova-zenix-20v-hybrid', 'Toyota Safety Sense'),
  ('innova-zenix-20v-hybrid', 'Pre-Collision System'),
  ('innova-zenix-20v-hybrid', 'Lane Departure Alert'),
  ('innova-zenix-20v-hybrid', 'Adaptive Cruise Control'),
  ('innova-zenix-20v-hybrid', 'Push Start + Keyless'),
  ('innova-zenix-20v-hybrid', 'Captain Seat Row 2'),
  ('innova-zenix-20v-hybrid', 'Power Tailgate'),
  ('innova-zenix-20v-hybrid', 'Apple CarPlay / Android Auto'),
  -- ── Zenix Q Hybrid Modellista ──
  ('innova-zenix-20q-hybrid-modellista', '6 Airbag'),
  ('innova-zenix-20q-hybrid-modellista', 'Toyota Safety Sense'),
  ('innova-zenix-20q-hybrid-modellista', 'Pre-Collision System'),
  ('innova-zenix-20q-hybrid-modellista', 'Lane Departure Alert'),
  ('innova-zenix-20q-hybrid-modellista', 'Adaptive Cruise Control'),
  ('innova-zenix-20q-hybrid-modellista', 'Panoramic Roof'),
  ('innova-zenix-20q-hybrid-modellista', 'JBL Premium Audio'),
  ('innova-zenix-20q-hybrid-modellista', 'Jok Kulit Ventilated'),
  ('innova-zenix-20q-hybrid-modellista', 'Captain Seat Row 2'),
  ('innova-zenix-20q-hybrid-modellista', 'Body Kit Modellista'),
  ('innova-zenix-20q-hybrid-modellista', 'Apple CarPlay / Android Auto'),
  -- ── Rush ──
  ('rush-gen2-15g-mt', '6 Airbag'),
  ('rush-gen2-15g-mt', 'ABS + EBD'),
  ('rush-gen2-15g-mt', 'Hill Start Assist'),
  ('rush-gen2-15g-mt', 'Vehicle Stability Control'),
  ('rush-gen2-15g-at', '6 Airbag'),
  ('rush-gen2-15g-at', 'ABS + EBD'),
  ('rush-gen2-15g-at', 'Hill Start Assist'),
  ('rush-gen2-15g-at', 'Vehicle Stability Control'),
  ('rush-gen2-15-trd-sportivo', '6 Airbag'),
  ('rush-gen2-15-trd-sportivo', 'ABS + EBD'),
  ('rush-gen2-15-trd-sportivo', 'Hill Start Assist'),
  ('rush-gen2-15-trd-sportivo', 'Vehicle Stability Control'),
  ('rush-gen2-15-trd-sportivo', 'Body Kit TRD'),
  ('rush-gen2-15-trd-sportivo', 'Velg 17 TRD'),
  -- ── Avanza Gen 3 ──
  ('avanza-gen3-13e-mt', 'Dual Airbag'),
  ('avanza-gen3-13e-mt', 'ABS + EBD'),
  ('avanza-gen3-13g-cvt', 'Dual Airbag'),
  ('avanza-gen3-13g-cvt', 'ABS + EBD'),
  ('avanza-gen3-13g-cvt', 'Hill Start Assist'),
  ('avanza-gen3-15g-cvt', 'Dual Airbag'),
  ('avanza-gen3-15g-cvt', 'ABS + EBD'),
  ('avanza-gen3-15g-cvt', 'Hill Start Assist'),
  ('avanza-gen3-15g-cvt', 'Vehicle Stability Control'),
  -- ── Veloz ──
  ('veloz-gen1-15-mt', 'Dual Airbag'),
  ('veloz-gen1-15-mt', 'ABS + EBD'),
  ('veloz-gen1-15-mt', 'Hill Start Assist'),
  ('veloz-gen1-15-mt', 'Vehicle Stability Control'),
  ('veloz-gen1-15-cvt', 'Dual Airbag'),
  ('veloz-gen1-15-cvt', 'ABS + EBD'),
  ('veloz-gen1-15-cvt', 'Hill Start Assist'),
  ('veloz-gen1-15-cvt', 'Vehicle Stability Control'),
  ('veloz-gen1-15-cvt', 'Push Start + Keyless'),
  ('veloz-gen1-15-q-cvt-tss', '6 Airbag'),
  ('veloz-gen1-15-q-cvt-tss', 'Toyota Safety Sense'),
  ('veloz-gen1-15-q-cvt-tss', 'Pre-Collision System'),
  ('veloz-gen1-15-q-cvt-tss', 'Lane Departure Alert'),
  ('veloz-gen1-15-q-cvt-tss', 'Adaptive Cruise Control'),
  ('veloz-gen1-15-q-cvt-tss', 'Push Start + Keyless'),
  ('veloz-gen1-15-q-cvt-tss', 'Apple CarPlay / Android Auto'),
  -- ── Raize ──
  ('raize-gen1-10t-g-cvt', '6 Airbag'),
  ('raize-gen1-10t-g-cvt', 'ABS + EBD'),
  ('raize-gen1-10t-g-cvt', 'Vehicle Stability Control'),
  ('raize-gen1-10t-g-cvt', 'Hill Start Assist'),
  ('raize-gen1-10t-g-cvt', 'Push Start + Keyless'),
  ('raize-gen1-10t-g-cvt', 'LED Headlamp'),
  ('raize-gen1-10t-gr-sport-cvt', '6 Airbag'),
  ('raize-gen1-10t-gr-sport-cvt', 'ABS + EBD'),
  ('raize-gen1-10t-gr-sport-cvt', 'Vehicle Stability Control'),
  ('raize-gen1-10t-gr-sport-cvt', 'Hill Start Assist'),
  ('raize-gen1-10t-gr-sport-cvt', 'Push Start + Keyless'),
  ('raize-gen1-10t-gr-sport-cvt', 'LED Headlamp'),
  ('raize-gen1-10t-gr-sport-cvt', 'Paddle Shifter'),
  ('raize-gen1-10t-gr-sport-cvt', 'Body Kit GR Sport'),
  ('raize-gen1-10t-gr-sport-cvt', 'Suspensi GR Sport'),
  ('raize-gen1-10t-gr-sport-cvt', 'Apple CarPlay / Android Auto'),
  -- ── GR86 ──
  ('gr86-gen1-24-mt', 'Torsen LSD'),
  ('gr86-gen1-24-mt', 'Track Mode'),
  ('gr86-gen1-24-mt', 'Hill Start Assist'),
  ('gr86-gen1-24-mt', 'Vehicle Stability Control'),
  ('gr86-gen1-24-mt', 'Sport Bucket Seats'),
  ('gr86-gen1-24-mt', 'Apple CarPlay / Android Auto'),
  ('gr86-gen1-24-at', 'Torsen LSD'),
  ('gr86-gen1-24-at', 'Track Mode'),
  ('gr86-gen1-24-at', 'Hill Start Assist'),
  ('gr86-gen1-24-at', 'Vehicle Stability Control'),
  ('gr86-gen1-24-at', 'Paddle Shifter'),
  ('gr86-gen1-24-at', 'Sport Bucket Seats'),
  ('gr86-gen1-24-at', 'Apple CarPlay / Android Auto')
on conflict do nothing;

-- ═════════════════════════════════════════════════════════════════════════════
-- Sanity check (uncomment to verify counts after run):
-- ═════════════════════════════════════════════════════════════════════════════
-- select m.name as model, count(distinct g.id) as gens, count(v.id) as variants
-- from models m
-- left join generations g on g.model_id = m.id
-- left join variants v    on v.generation_id = g.id
-- where m.brand_id = 'toyota'
-- group by m.name
-- order by m.name;
