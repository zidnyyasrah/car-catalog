-- ─────────────────────────────────────────────────────────────────────────────
-- CarCat seed — Kia + Wuling + extras for Suzuki/Daihatsu/Mitsubishi/Hyundai
--
-- Coverage:
--   Kia        Sonet         Gen 1 Facelift                     2023-present
--              Carens        Gen 1                              2022-present
--
--   Wuling     Almaz         Hybrid (series-parallel)           2023-present
--              Air EV        Gen 1 (E100)                       2022-present
--
--   Suzuki     Grand Vitara  Gen 1 SHVS (imported India)        2023-present
--   Daihatsu   Sigra         Gen 1 Facelift                     2019-present
--              Terios        Gen 3 (twin of Toyota Rush)        2018-present
--   Mitsubishi Triton        Gen 5 (KK/KL, bi-turbo diesel)     2024-present
--   Hyundai    IONIQ 5       Gen 1 (E-GMP, made-in-ID)          2022-present
--
-- Accuracy notes (continuing the discipline from seed_more_brands.sql):
--   * Suzuki K15C in Grand Vitara: 102 hp / 137 Nm (Dualjet + SHVS mild hybrid,
--     NOT full hybrid). Engine output unchanged by SHVS — is_electric = false.
--   * Wuling Almaz Hybrid: series-parallel hybrid. 2.0L Atkinson (124 hp) +
--     electric motor (174 hp / 320 Nm). The motor drives the wheels in most
--     conditions, so I report the motor figures as power_hp/torque_nm and mark
--     is_electric = false (it's still a hybrid, ICE remains primary energy).
--   * Wuling Air EV: 30 kW / 110 Nm motor on both Standard and Long Range. The
--     difference is battery capacity (17.3 vs 26.7 kWh) and range (200 vs 300
--     km claim). Engine output the same.
--   * Hyundai IONIQ 5 RWD Standard: 168 hp / 350 Nm. AWD Long Range: 320 hp /
--     605 Nm system (front 95 hp + rear 225 hp). is_electric = true.
--   * Mitsubishi 4N16 2.4L Bi-Turbo Diesel in Triton Gen 5: 201 hp / 470 Nm.
--     The 4N15 (Pajero Sport / older Triton) is single-turbo 181 hp / 430 Nm —
--     these are distinct engines, don't conflate.
--   * Kia Smartstream G1.5 MPI (Sonet/Carens): 113 hp / 144 Nm — same family
--     as the Hyundai engine in Creta/Stargazer (Hyundai-Kia share powertrain).
--   * Daihatsu Sigra 1.0L 1KR-DE: 66 hp / 89 Nm (3-cyl) | 1.2L 3NR-VE: 87 hp /
--     113 Nm (4-cyl). Two distinct engines.
--   * Daihatsu Terios is the twin of Toyota Rush; specs identical to Rush Gen 2
--     already seeded.
--   * Fuel consumption: manufacturer claim figures (not real-world).
--   * Prices: launch-period Jakarta OTR (IDR millions); edit in-app for drift.
--   * Safety stars: ASEAN NCAP rating where published; 0 if uncertain.
--
-- Run AFTER schema.sql and seed.sql. Self-contained; ON CONFLICT DO NOTHING.
-- ─────────────────────────────────────────────────────────────────────────────

-- ═════════════════════════════════════════════════════════════════════════════
-- BRANDS (new)
-- ═════════════════════════════════════════════════════════════════════════════
insert into brands (id, name, country) values
  ('kia',    'Kia',    'Korea Selatan'),
  ('wuling', 'Wuling', 'Tiongkok')
on conflict (id) do nothing;

-- ═════════════════════════════════════════════════════════════════════════════
-- MODELS
-- ═════════════════════════════════════════════════════════════════════════════
insert into models (id, brand_id, name, body_type, description, hero_image_url) values
  -- ── Kia ─────────────────────────────────────────────────────────────────
  ('kia-sonet', 'kia', 'Sonet', 'SUV',
   'Crossover compact Kia, kompetitor langsung Toyota Raize / Daihatsu Rocky. Mesin 1.5L MPI + IVT, dirakit di pabrik Anantapur (India). Facelift 2023 mendapat fascia tiger nose baru dan ADAS pada trim atas.',
   'https://picsum.photos/seed/sonet-hero/1200/600'),

  ('kia-carens', 'kia', 'Carens', 'MPV',
   'MPV 7-penumpang Kia (di sebagian pasar disebut "Carens Clavis"). Mesin 1.5L Smartstream MPI dengan IVT. Lebih premium dibanding Stargazer/Avanza, target keluarga muda.',
   'https://picsum.photos/seed/carens-hero/1200/600'),

  -- ── Wuling ──────────────────────────────────────────────────────────────
  ('wuling-almaz', 'wuling', 'Almaz', 'SUV',
   'SUV mid-size Wuling, sejak 2023 hadir dalam konfigurasi Hybrid (series-parallel). Mesin 2.0L Atkinson + electric motor 174 hp menggantikan 1.5L turbo pada varian Hybrid.',
   'https://picsum.photos/seed/almaz-hero/1200/600'),

  ('wuling-air-ev', 'wuling', 'Air EV', 'Hatchback',
   'Mobil listrik kompak 2-pintu Wuling. Dirakit lokal di pabrik Cikarang, jadi mobil resmi delegasi G20 Bali 2022. Praktis untuk kota dengan baterai LFP yang aman dan tahan lama.',
   'https://picsum.photos/seed/air-ev-hero/1200/600'),

  -- ── Extras ──────────────────────────────────────────────────────────────
  ('suzuki-grand-vitara', 'suzuki', 'Grand Vitara', 'SUV',
   'SUV Suzuki yang menggunakan kembali nameplate "Grand Vitara". Generasi ini dibangun di India dengan platform GLOBAL-C, mesin 1.5L Dualjet + SHVS. Diimpor utuh ke Indonesia sejak 2023.',
   'https://picsum.photos/seed/grand-vitara-hero/1200/600'),

  ('daihatsu-sigra', 'daihatsu', 'Sigra', 'MPV',
   'LCGC (Low Cost Green Car) 7-penumpang Daihatsu, kembar Toyota Calya. Pilihan paling terjangkau di kelas MPV 7-seater. Tersedia mesin 1.0L 3-silinder dan 1.2L 4-silinder.',
   'https://picsum.photos/seed/sigra-hero/1200/600'),

  ('daihatsu-terios', 'daihatsu', 'Terios', 'SUV',
   'SUV 7-penumpang Daihatsu, kembar identik Toyota Rush. Berbasis ladder-frame F800, RWD, dengan ground clearance 220 mm. Pilihan terjangkau di segmen SUV ladder-frame.',
   'https://picsum.photos/seed/terios-hero/1200/600'),

  ('mitsubishi-triton', 'mitsubishi', 'Triton', 'Pickup',
   'Pickup ladder-frame Mitsubishi. Generasi kelima (2024+) di Indonesia hadir dengan mesin baru 4N16 2.4L Bi-Turbo Diesel (201 hp / 470 Nm), 6-speed A/T, dan Super Select II 4WD pada varian top.',
   'https://picsum.photos/seed/triton-hero/1200/600'),

  ('hyundai-ioniq-5', 'hyundai', 'IONIQ 5', 'SUV',
   'BEV crossover Hyundai dengan platform E-GMP 800V. Dirakit lokal di HMMI Cikarang sejak 2022 (mobil listrik buatan Indonesia pertama dengan skala produksi serius). Pengisian DC fast 18 menit dari 10→80%.',
   'https://picsum.photos/seed/ioniq5-hero/1200/600')
on conflict (id) do nothing;

-- ═════════════════════════════════════════════════════════════════════════════
-- GENERATIONS
-- ═════════════════════════════════════════════════════════════════════════════
insert into generations (id, model_id, name, chassis_code, year_start, year_end, description, hero_image_url) values

  -- ── Kia Sonet ───────────────────────────────────────────────────────────
  ('kia-sonet-gen1-fl', 'kia-sonet', 'Gen 1 Facelift', null, 2023, null,
   'Facelift Sonet dengan grille tiger nose baru, Star Map LED DRL, dan velg desain baru. Trim atas mendapat Hyundai-Kia SmartSense ADAS. Mesin tetap Smartstream G1.5 MPI + IVT.',
   'https://picsum.photos/seed/sonet-gen1fl/1200/600'),

  -- ── Kia Carens ──────────────────────────────────────────────────────────
  ('kia-carens-gen1', 'kia-carens', 'Gen 1', null, 2022, null,
   'Generasi pertama Carens dengan platform K2, debut sebagai 7-seater MPV global. Mesin Smartstream G1.5 MPI dengan IVT. Trim Indonesia: Premiere dan Premiere Black Pearl (edisi cosmetic).',
   'https://picsum.photos/seed/carens-gen1/1200/600'),

  -- ── Wuling Almaz Hybrid ─────────────────────────────────────────────────
  ('wuling-almaz-hybrid', 'wuling-almaz', 'Hybrid (Gen 1 Refresh)', null, 2023, null,
   'Almaz dengan sistem hybrid series-parallel: 2.0L Atkinson NA + electric motor 174 hp. Dedicated Hybrid Transmission (DHT) menggantikan CVT. Baterai LFP 1.8 kWh berfungsi sebagai buffer.',
   'https://picsum.photos/seed/almaz-hybrid/1200/600'),

  -- ── Wuling Air EV ───────────────────────────────────────────────────────
  ('wuling-air-ev-gen1', 'wuling-air-ev', 'Gen 1', 'E100', 2022, null,
   'BEV pertama Wuling di Indonesia. Motor 30 kW (40 hp) RWD, single-speed direct drive. Dua opsi baterai LFP: Standard Range (17.3 kWh, ~200 km) dan Long Range (26.7 kWh, ~300 km claim).',
   'https://picsum.photos/seed/air-ev-gen1/1200/600'),

  -- ── Suzuki Grand Vitara ─────────────────────────────────────────────────
  ('suzuki-grand-vitara-gen1-shvs', 'suzuki-grand-vitara', 'Gen 1 SHVS', null, 2023, null,
   'Grand Vitara modern (bukan revival 4WD lawas). Mesin K15C 1.5L Dualjet + SHVS mild hybrid 12V. AGS atau 6-speed A/T. Indonesia dapat versi FWD A/T saja.',
   'https://picsum.photos/seed/grand-vitara-gen1/1200/600'),

  -- ── Daihatsu Sigra ──────────────────────────────────────────────────────
  ('daihatsu-sigra-fl', 'daihatsu-sigra', 'Gen 1 Facelift', null, 2019, null,
   'Facelift Sigra dengan grille baru, head unit touch screen, dan refinement interior. Tetap LCGC dengan harga terjangkau. Tersedia mesin 1.0L 3-cyl atau 1.2L 4-cyl.',
   'https://picsum.photos/seed/sigra-fl/1200/600'),

  -- ── Daihatsu Terios ─────────────────────────────────────────────────────
  ('daihatsu-terios-gen3', 'daihatsu-terios', 'Gen 3', 'F800', 2018, null,
   'Generasi ketiga Terios, kembar identik dengan Toyota Rush. Lebih ramping dan modern dari Gen 2. Mesin 1.5L 2NR-VE (104 hp / 136 Nm). 7-penumpang RWD ladder-frame dengan ground clearance 220 mm.',
   'https://picsum.photos/seed/terios-gen3/1200/600'),

  -- ── Mitsubishi Triton ───────────────────────────────────────────────────
  ('mitsubishi-triton-gen5', 'mitsubishi-triton', 'Gen 5', 'KK/KL', 2024, null,
   'Generasi kelima Triton, all-new platform dengan body lebih besar (5320 x 1865 mm) dan mesin baru 4N16 2.4L Bi-Turbo MIVEC DI-D (201 hp / 470 Nm). 6-speed A/T dan Super Select II 4WD pada trim atas.',
   'https://picsum.photos/seed/triton-gen5/1200/600'),

  -- ── Hyundai IONIQ 5 ─────────────────────────────────────────────────────
  ('hyundai-ioniq-5-gen1', 'hyundai-ioniq-5', 'Gen 1', 'NE', 2022, null,
   'Platform E-GMP 800V — pengisian ultra-cepat dan vehicle-to-load (V2L) untuk powering perangkat eksternal. Desain ikonik dengan pixel headlamp dan flush door handle. Made-in-Indonesia.',
   'https://picsum.photos/seed/ioniq5-gen1/1200/600')
on conflict (id) do nothing;

-- ═════════════════════════════════════════════════════════════════════════════
-- KIA SONET — VARIANTS
-- Smartstream G1.5 MPI: 113 hp / 144 Nm
-- ═════════════════════════════════════════════════════════════════════════════
insert into variants (id, generation_id, trim_name, year_start, year_end,
  engine_type, engine_displacement_cc, power_hp, torque_nm,
  transmission, drive_system, fuel_consumption_km_per_l, seating_capacity,
  ground_clearance_mm, dimensions, safety_rating,
  price_min_million_idr, price_max_million_idr, image_url, description) values

  ('sonet-fl-smart-mt', 'kia-sonet-gen1-fl', 'Smart M/T', 2023, null,
   'Smartstream G1.5 MPI', 1497, 113, 144,
   'M/T 6-speed', 'FWD', 16, 5, 205, '3995 x 1790 x 1610', 0,
   223, 235, 'https://picsum.photos/seed/sonet-smart-mt/600/380',
   'Trim entry Sonet manual. 6-speed M/T responsif untuk kota. 2 airbag dan ABS+EBD sebagai standar.'),

  ('sonet-fl-premiere-ivt', 'kia-sonet-gen1-fl', 'Premiere IVT', 2023, null,
   'Smartstream G1.5 MPI', 1497, 113, 144,
   'IVT', 'FWD', 17, 5, 205, '3995 x 1790 x 1610', 0,
   276, 290, 'https://picsum.photos/seed/sonet-premiere-ivt/600/380',
   'Trim mid Sonet IVT. Penambahan keyless, push start, head unit 10.25-inch dengan wireless CarPlay/Android Auto, dan velg 16" diamond cut.'),

  ('sonet-fl-dynamic-ivt', 'kia-sonet-gen1-fl', 'Dynamic IVT', 2023, null,
   'Smartstream G1.5 MPI', 1497, 113, 144,
   'IVT', 'FWD', 17, 5, 205, '3995 x 1790 x 1610', 0,
   311, 325, 'https://picsum.photos/seed/sonet-dynamic-ivt/600/380',
   'Top trim Sonet. SmartSense ADAS (FCA, LKA, BCA, LFA), sunroof, leather seat ventilated, Bose 7-speaker.')
on conflict (id) do nothing;

-- ═════════════════════════════════════════════════════════════════════════════
-- KIA CARENS — VARIANTS
-- Sama engine dengan Sonet (Smartstream G1.5 MPI + IVT).
-- ═════════════════════════════════════════════════════════════════════════════
insert into variants (id, generation_id, trim_name, year_start, year_end,
  engine_type, engine_displacement_cc, power_hp, torque_nm,
  transmission, drive_system, fuel_consumption_km_per_l, seating_capacity,
  ground_clearance_mm, dimensions, safety_rating,
  price_min_million_idr, price_max_million_idr, image_url, description) values

  ('carens-gen1-premiere-ivt', 'kia-carens-gen1', 'Premiere IVT', 2022, null,
   'Smartstream G1.5 MPI', 1497, 113, 144,
   'IVT', 'FWD', 16, 7, 195, '4540 x 1800 x 1700', 0,
   359, 378, 'https://picsum.photos/seed/carens-premiere-ivt/600/380',
   'Trim Premiere Carens. Sunroof, ventilated front seat, head unit 10.25-inch, Bose 8-speaker, dan one-touch tumble pada baris kedua untuk akses baris ketiga.'),

  ('carens-gen1-premiere-bp-ivt', 'kia-carens-gen1', 'Premiere Black Pearl IVT', 2023, null,
   'Smartstream G1.5 MPI', 1497, 113, 144,
   'IVT', 'FWD', 16, 7, 195, '4540 x 1800 x 1700', 0,
   369, 385, 'https://picsum.photos/seed/carens-premiere-bp-ivt/600/380',
   'Premiere Black Pearl: edisi cosmetic dengan eksterior dark chrome, velg hitam, dan interior all-black. Spec mekanikal identik dengan Premiere.')
on conflict (id) do nothing;

-- ═════════════════════════════════════════════════════════════════════════════
-- WULING ALMAZ HYBRID — VARIANTS
-- Series-parallel hybrid: ICE 2.0L Atkinson + motor 174 hp / 320 Nm. DHT.
-- ═════════════════════════════════════════════════════════════════════════════
insert into variants (id, generation_id, trim_name, year_start, year_end,
  engine_type, engine_displacement_cc, power_hp, torque_nm,
  transmission, drive_system, fuel_consumption_km_per_l, seating_capacity,
  ground_clearance_mm, dimensions, safety_rating,
  price_min_million_idr, price_max_million_idr, image_url, description) values

  ('almaz-hybrid-ex', 'wuling-almaz-hybrid', 'EX Hybrid', 2023, null,
   '2.0L Atkinson + Electric Motor (Series-Parallel Hybrid)', 1999, 174, 320,
   'DHT (Dedicated Hybrid Transmission)', 'FWD', 21, 7, 188, '4695 x 1850 x 1760', 0,
   470, 495, 'https://picsum.photos/seed/almaz-hybrid-ex/600/380',
   'Almaz Hybrid varian tunggal di Indonesia. Sistem series-parallel hybrid (mirip Toyota THS): motor jadi penggerak utama, ICE bisa charge baterai atau langsung drive wheels via clutch. Klaim konsumsi 21 km/L.')
on conflict (id) do nothing;

-- ═════════════════════════════════════════════════════════════════════════════
-- WULING AIR EV — VARIANTS
-- Motor 30 kW (40 hp) / 110 Nm. Standard 17.3 kWh / 200 km; Long Range 26.7 kWh / 300 km.
-- is_electric = true; fuel_consumption_km_per_l = 0 (not applicable).
-- ═════════════════════════════════════════════════════════════════════════════
insert into variants (id, generation_id, trim_name, year_start, year_end,
  engine_type, engine_displacement_cc, power_hp, torque_nm,
  transmission, drive_system, is_electric, fuel_consumption_km_per_l, seating_capacity,
  ground_clearance_mm, dimensions, safety_rating,
  price_min_million_idr, price_max_million_idr, image_url, description) values

  ('air-ev-standard', 'wuling-air-ev-gen1', 'Standard Range', 2022, null,
   'Permanent Magnet Synchronous Motor (30 kW)', 0, 40, 110,
   'Single-Speed Direct Drive', 'RWD', true, 0, 4,
   140, '2974 x 1505 x 1631', 0,
   209, 220, 'https://picsum.photos/seed/air-ev-standard/600/380',
   'Trim Standard Air EV. Baterai LFP 17.3 kWh, jarak tempuh 200 km (claim WLTP). Pengisian AC 6.6 kW (4 jam 0→100%), atau pakai colokan rumah biasa.'),

  ('air-ev-long-range', 'wuling-air-ev-gen1', 'Long Range', 2022, null,
   'Permanent Magnet Synchronous Motor (30 kW)', 0, 40, 110,
   'Single-Speed Direct Drive', 'RWD', true, 0, 4,
   140, '2974 x 1505 x 1631', 0,
   265, 280, 'https://picsum.photos/seed/air-ev-lr/600/380',
   'Trim Long Range Air EV. Baterai LFP 26.7 kWh, jarak tempuh 300 km (claim). Penambahan keyless entry, voice command, dan sunroof glass roof.')
on conflict (id) do nothing;

-- ═════════════════════════════════════════════════════════════════════════════
-- SUZUKI GRAND VITARA — VARIANTS
-- K15C 1.5L Dualjet + SHVS: 102 hp / 137 Nm. 6-speed A/T. FWD only di Indonesia.
-- ═════════════════════════════════════════════════════════════════════════════
insert into variants (id, generation_id, trim_name, year_start, year_end,
  engine_type, engine_displacement_cc, power_hp, torque_nm,
  transmission, drive_system, fuel_consumption_km_per_l, seating_capacity,
  ground_clearance_mm, dimensions, safety_rating,
  price_min_million_idr, price_max_million_idr, image_url, description) values

  ('grand-vitara-gx-at', 'suzuki-grand-vitara-gen1-shvs', 'GX Hybrid A/T', 2023, null,
   'K15C 1.5L Dualjet + SHVS', 1462, 102, 137,
   'A/T 6-speed', 'FWD', 18, 5, 210, '4345 x 1795 x 1645', 5,
   362, 380, 'https://picsum.photos/seed/grand-vitara-gx/600/380',
   'Top trim Grand Vitara untuk Indonesia. 6 airbag, sunroof panoramic, head-up display, dan 360° camera. Global NCAP 5-star (struktur identik dengan India-spec).')
on conflict (id) do nothing;

-- ═════════════════════════════════════════════════════════════════════════════
-- DAIHATSU SIGRA — VARIANTS
-- 1.0L 1KR-DE: 66 hp / 89 Nm (3-cyl) | 1.2L 3NR-VE: 87 hp / 113 Nm (4-cyl)
-- ═════════════════════════════════════════════════════════════════════════════
insert into variants (id, generation_id, trim_name, year_start, year_end,
  engine_type, engine_displacement_cc, power_hp, torque_nm,
  transmission, drive_system, fuel_consumption_km_per_l, seating_capacity,
  ground_clearance_mm, dimensions, safety_rating,
  price_min_million_idr, price_max_million_idr, image_url, description) values

  ('sigra-fl-10d-mt', 'daihatsu-sigra-fl', '1.0 D M/T', 2019, null,
   '1KR-DE 1.0L 3-cyl DOHC', 998, 66, 89,
   'M/T 5-speed', 'FWD', 19, 7, 180, '4070 x 1655 x 1600', 0,
   135, 145, 'https://picsum.photos/seed/sigra-10d-mt/600/380',
   'Trim entry Sigra. LCGC paling terjangkau di kelas 7-seater. Cukup untuk pemakaian dalam kota dengan beban ringan.'),

  ('sigra-fl-12x-mt', 'daihatsu-sigra-fl', '1.2 X M/T', 2019, null,
   '3NR-VE 1.2L 4-cyl DOHC Dual VVT-i', 1197, 87, 113,
   'M/T 5-speed', 'FWD', 18, 7, 180, '4070 x 1655 x 1600', 0,
   155, 165, 'https://picsum.photos/seed/sigra-12x-mt/600/380',
   'Trim 1.2 X manual. Mesin 4-silinder lebih halus dan bertenaga dibanding 1.0L untuk pemakaian keluarga.'),

  ('sigra-fl-12r-deluxe-at', 'daihatsu-sigra-fl', '1.2 R Deluxe A/T', 2019, null,
   '3NR-VE 1.2L 4-cyl DOHC Dual VVT-i', 1197, 87, 113,
   'A/T 4-speed', 'FWD', 17, 7, 180, '4070 x 1655 x 1600', 0,
   180, 189, 'https://picsum.photos/seed/sigra-12r-deluxe-at/600/380',
   'Top trim Sigra. Dual SRS airbag, ABS+EBD, head unit touch screen, dan velg dual-tone. Tetap LCGC namun cukup lengkap.')
on conflict (id) do nothing;

-- ═════════════════════════════════════════════════════════════════════════════
-- DAIHATSU TERIOS — VARIANTS
-- 2NR-VE 1.5L: 104 hp / 136 Nm (sama dengan Toyota Rush twin).
-- ═════════════════════════════════════════════════════════════════════════════
insert into variants (id, generation_id, trim_name, year_start, year_end,
  engine_type, engine_displacement_cc, power_hp, torque_nm,
  transmission, drive_system, fuel_consumption_km_per_l, seating_capacity,
  ground_clearance_mm, dimensions, safety_rating,
  price_min_million_idr, price_max_million_idr, image_url, description) values

  ('terios-gen3-x-mt', 'daihatsu-terios-gen3', '1.5 X M/T', 2018, null,
   '2NR-VE 1.5L DOHC Dual VVT-i', 1496, 104, 136,
   'M/T 5-speed', '4x2 RWD', 13, 7, 220, '4435 x 1695 x 1735', 4,
   235, 247, 'https://picsum.photos/seed/terios-x-mt/600/380',
   'Trim entry Terios manual. 7-penumpang RWD ladder-frame dengan ground clearance 220 mm. Tahan untuk jalan rusak.'),

  ('terios-gen3-r-at', 'daihatsu-terios-gen3', '1.5 R A/T', 2018, null,
   '2NR-VE 1.5L DOHC Dual VVT-i', 1496, 104, 136,
   'A/T 4-speed', '4x2 RWD', 13, 7, 220, '4435 x 1695 x 1735', 4,
   265, 280, 'https://picsum.photos/seed/terios-r-at/600/380',
   'Trim mid Terios otomatis. Penambahan velg alloy, keyless, head unit touch screen, dan dual airbag.'),

  ('terios-gen3-r-deluxe-at', 'daihatsu-terios-gen3', '1.5 R Deluxe A/T', 2018, null,
   '2NR-VE 1.5L DOHC Dual VVT-i', 1496, 104, 136,
   'A/T 4-speed', '4x2 RWD', 13, 7, 220, '4435 x 1695 x 1735', 4,
   285, 300, 'https://picsum.photos/seed/terios-r-deluxe-at/600/380',
   'Top trim Terios. Penambahan side & curtain airbag (4 total), VSC, hill start assist, dan velg 17".')
on conflict (id) do nothing;

-- ═════════════════════════════════════════════════════════════════════════════
-- MITSUBISHI TRITON GEN 5 — VARIANTS
-- 4N16 2.4L Bi-Turbo MIVEC DI-D: 201 hp / 470 Nm. 6-speed A/T.
-- ═════════════════════════════════════════════════════════════════════════════
insert into variants (id, generation_id, trim_name, year_start, year_end,
  engine_type, engine_displacement_cc, power_hp, torque_nm,
  transmission, drive_system, fuel_consumption_km_per_l, seating_capacity,
  ground_clearance_mm, dimensions, safety_rating,
  price_min_million_idr, price_max_million_idr, image_url, description) values

  ('triton-gen5-hpe-4x4-at', 'mitsubishi-triton-gen5', 'HPE 4x4 A/T', 2024, null,
   '4N16 2.4L Bi-Turbo MIVEC DI-D', 2442, 201, 470,
   'A/T 6-speed', '4x4 Super Select II', 12, 5, 228, '5320 x 1865 x 1815', 0,
   525, 555, 'https://picsum.photos/seed/triton-hpe-4x4/600/380',
   'Trim HPE Double Cabin 4x4. Super Select II memungkinkan 4WD di permukaan kering (jarang di kelasnya). 7 airbag, ASC, dan keyless operation.'),

  ('triton-gen5-hpe-ultimate-4x4-at', 'mitsubishi-triton-gen5', 'HPE Ultimate 4x4 A/T', 2024, null,
   '4N16 2.4L Bi-Turbo MIVEC DI-D', 2442, 201, 470,
   'A/T 6-speed', '4x4 Super Select II', 12, 5, 228, '5320 x 1865 x 1815', 0,
   580, 615, 'https://picsum.photos/seed/triton-hpe-ultimate-4x4/600/380',
   'Top trim Triton Gen 5. Penambahan ADAS (FCM, LDW, BSW, RCTA), 360° camera, Off-Road Mode (Gravel/Mud/Sand/Rock), dan rear differential lock.')
on conflict (id) do nothing;

-- ═════════════════════════════════════════════════════════════════════════════
-- HYUNDAI IONIQ 5 — VARIANTS
-- E-GMP 800V platform. Standard 58 kWh RWD: 168 hp / 350 Nm.
-- Long Range 77.4 kWh AWD: 320 hp / 605 Nm system.
-- ═════════════════════════════════════════════════════════════════════════════
insert into variants (id, generation_id, trim_name, year_start, year_end,
  engine_type, engine_displacement_cc, power_hp, torque_nm,
  transmission, drive_system, is_electric, fuel_consumption_km_per_l, seating_capacity,
  ground_clearance_mm, dimensions, safety_rating,
  price_min_million_idr, price_max_million_idr, image_url, description) values

  ('ioniq5-gen1-prime-sr', 'hyundai-ioniq-5-gen1', 'Prime Standard Range', 2022, null,
   'Permanent Magnet Synchronous Motor (125 kW)', 0, 168, 350,
   'Single-Speed Reduction Gear', 'RWD', true, 0, 5,
   158, '4635 x 1890 x 1605', 5,
   780, 815, 'https://picsum.photos/seed/ioniq5-prime-sr/600/380',
   'Trim entry IONIQ 5. Baterai 58 kWh, jarak tempuh 384 km (WLTP claim). 0-100 km/h 8.5 detik. V2L 3.6 kW untuk powering peralatan eksternal. Global NCAP 5-star.'),

  ('ioniq5-gen1-signature-lr-awd', 'hyundai-ioniq-5-gen1', 'Signature Long Range AWD', 2022, null,
   'Dual PMSM (Front 70 kW + Rear 165 kW = 235 kW system)', 0, 320, 605,
   'Single-Speed Reduction Gear', 'AWD', true, 0, 5,
   158, '4635 x 1890 x 1605', 5,
   985, 1030, 'https://picsum.photos/seed/ioniq5-sig-lr-awd/600/380',
   'Top trim IONIQ 5 AWD. Baterai 77.4 kWh, jarak tempuh 481 km (WLTP). 0-100 km/h 5.2 detik. SmartSense ADAS, Bose 8-speaker, dan relax seat (electric reclining + footrest).')
on conflict (id) do nothing;

-- ═════════════════════════════════════════════════════════════════════════════
-- BASE COLORS (Putih, Hitam, Silver, Abu-abu)
-- ═════════════════════════════════════════════════════════════════════════════
insert into variant_colors (variant_id, color)
select v.id, c.color
from variants v
cross join (values ('Putih'), ('Hitam'), ('Silver'), ('Abu-abu')) as c(color)
where v.generation_id in (
  'kia-sonet-gen1-fl',
  'kia-carens-gen1',
  'wuling-almaz-hybrid',
  'wuling-air-ev-gen1',
  'suzuki-grand-vitara-gen1-shvs',
  'daihatsu-sigra-fl',
  'daihatsu-terios-gen3',
  'mitsubishi-triton-gen5',
  'hyundai-ioniq-5-gen1'
)
on conflict do nothing;

-- Signature colors per model (confident-known marketing accents only).
insert into variant_colors (variant_id, color) values
  -- Sonet Dynamic: Intense Red & Pewter Olive
  ('sonet-fl-dynamic-ivt',              'Merah'),
  ('sonet-fl-dynamic-ivt',              'Hijau'),
  -- Carens Premiere: Imperial Blue khas Kia
  ('carens-gen1-premiere-ivt',          'Biru'),
  -- Almaz Hybrid: Wine Red khas Wuling
  ('almaz-hybrid-ex',                   'Merah'),
  -- Air EV: warna-warna khas pastel (Lemon, Avocado, Peach, Pristine White)
  ('air-ev-long-range',                 'Kuning'),
  ('air-ev-long-range',                 'Hijau'),
  ('air-ev-standard',                   'Kuning'),
  -- Grand Vitara: Splendid Silver & Brave Khaki
  ('grand-vitara-gx-at',                'Hijau'),
  -- Terios R Deluxe: Merah Solid khas Daihatsu
  ('terios-gen3-r-deluxe-at',           'Merah'),
  -- Triton Gen 5: Yamabuki Orange Metallic khas Triton
  ('triton-gen5-hpe-ultimate-4x4-at',   'Bronze'),
  ('triton-gen5-hpe-ultimate-4x4-at',   'Merah'),
  -- IONIQ 5: Atlas White, Lucid Blue, Gravity Gold
  ('ioniq5-gen1-prime-sr',              'Biru'),
  ('ioniq5-gen1-signature-lr-awd',      'Biru'),
  ('ioniq5-gen1-signature-lr-awd',      'Bronze')
on conflict do nothing;

-- ═════════════════════════════════════════════════════════════════════════════
-- BASE FEATURES (AC, Power Steering, Power Window, Central Lock)
-- ═════════════════════════════════════════════════════════════════════════════
insert into variant_features (variant_id, feature)
select v.id, f.feature
from variants v
cross join (values ('AC'), ('Power Steering'), ('Power Window'), ('Central Lock')) as f(feature)
where v.generation_id in (
  'kia-sonet-gen1-fl',
  'kia-carens-gen1',
  'wuling-almaz-hybrid',
  'wuling-air-ev-gen1',
  'suzuki-grand-vitara-gen1-shvs',
  'daihatsu-sigra-fl',
  'daihatsu-terios-gen3',
  'mitsubishi-triton-gen5',
  'hyundai-ioniq-5-gen1'
)
on conflict do nothing;

-- Variant-specific features
insert into variant_features (variant_id, feature) values
  -- ── Sonet ───────────────────────────────────────────────────────────────
  ('sonet-fl-smart-mt',                   '2 SRS Airbag'),
  ('sonet-fl-smart-mt',                   'ABS + EBD'),
  ('sonet-fl-premiere-ivt',               '2 SRS Airbag'),
  ('sonet-fl-premiere-ivt',               'ABS + EBD'),
  ('sonet-fl-premiere-ivt',               'ESC + Hill Start Assist'),
  ('sonet-fl-premiere-ivt',               'Smart Key + Push Start'),
  ('sonet-fl-premiere-ivt',               'Head Unit 10.25-inch'),
  ('sonet-fl-premiere-ivt',               'Wireless Apple CarPlay + Android Auto'),
  ('sonet-fl-dynamic-ivt',                '6 SRS Airbag'),
  ('sonet-fl-dynamic-ivt',                'ABS + EBD'),
  ('sonet-fl-dynamic-ivt',                'ESC + Hill Start Assist'),
  ('sonet-fl-dynamic-ivt',                'Hyundai-Kia SmartSense ADAS'),
  ('sonet-fl-dynamic-ivt',                'FCA (Forward Collision-Avoidance)'),
  ('sonet-fl-dynamic-ivt',                'LKA (Lane Keeping Assist)'),
  ('sonet-fl-dynamic-ivt',                'BCA (Blind-Spot Collision-Avoidance)'),
  ('sonet-fl-dynamic-ivt',                'Sunroof'),
  ('sonet-fl-dynamic-ivt',                'Ventilated Leather Seat'),
  ('sonet-fl-dynamic-ivt',                'Bose 7-Speaker'),

  -- ── Carens ──────────────────────────────────────────────────────────────
  ('carens-gen1-premiere-ivt',            '6 SRS Airbag'),
  ('carens-gen1-premiere-ivt',            'ABS + EBD'),
  ('carens-gen1-premiere-ivt',            'ESC + Hill Start Assist'),
  ('carens-gen1-premiere-ivt',            'Sunroof'),
  ('carens-gen1-premiere-ivt',            'Ventilated Front Seat'),
  ('carens-gen1-premiere-ivt',            'Head Unit 10.25-inch'),
  ('carens-gen1-premiere-ivt',            'Bose 8-Speaker'),
  ('carens-gen1-premiere-ivt',            'One-Touch Tumble Row 2'),
  ('carens-gen1-premiere-bp-ivt',         '6 SRS Airbag'),
  ('carens-gen1-premiere-bp-ivt',         'ABS + EBD'),
  ('carens-gen1-premiere-bp-ivt',         'ESC + Hill Start Assist'),
  ('carens-gen1-premiere-bp-ivt',         'Sunroof'),
  ('carens-gen1-premiere-bp-ivt',         'Ventilated Front Seat'),
  ('carens-gen1-premiere-bp-ivt',         'Dark Chrome Exterior'),
  ('carens-gen1-premiere-bp-ivt',         'All-Black Interior'),
  ('carens-gen1-premiere-bp-ivt',         'Bose 8-Speaker'),

  -- ── Almaz Hybrid ────────────────────────────────────────────────────────
  ('almaz-hybrid-ex',                     '6 SRS Airbag'),
  ('almaz-hybrid-ex',                     'ABS + EBD'),
  ('almaz-hybrid-ex',                     'ESC + Hill Hold'),
  ('almaz-hybrid-ex',                     'WIND (Wuling Indonesia Command) Voice'),
  ('almaz-hybrid-ex',                     'ADAS Level 2 (ACC + LKA + AEB)'),
  ('almaz-hybrid-ex',                     'Head Unit 12.8-inch'),
  ('almaz-hybrid-ex',                     '360° Panoramic Camera'),
  ('almaz-hybrid-ex',                     'Power Tailgate'),
  ('almaz-hybrid-ex',                     'Panoramic Sunroof'),

  -- ── Air EV ──────────────────────────────────────────────────────────────
  ('air-ev-standard',                     '2 SRS Airbag'),
  ('air-ev-standard',                     'ABS + EBD'),
  ('air-ev-standard',                     'TPMS'),
  ('air-ev-standard',                     'Internet of Vehicle (IoV)'),
  ('air-ev-standard',                     'Voice Command'),
  ('air-ev-long-range',                   '2 SRS Airbag'),
  ('air-ev-long-range',                   'ABS + EBD'),
  ('air-ev-long-range',                   'TPMS'),
  ('air-ev-long-range',                   'Keyless Entry'),
  ('air-ev-long-range',                   'Internet of Vehicle (IoV)'),
  ('air-ev-long-range',                   'Voice Command'),
  ('air-ev-long-range',                   'Glass Roof'),

  -- ── Grand Vitara ────────────────────────────────────────────────────────
  ('grand-vitara-gx-at',                  '6 SRS Airbag'),
  ('grand-vitara-gx-at',                  'ABS + EBD + BA'),
  ('grand-vitara-gx-at',                  'ESP + Hill Hold'),
  ('grand-vitara-gx-at',                  'Panoramic Sunroof'),
  ('grand-vitara-gx-at',                  'Head-Up Display'),
  ('grand-vitara-gx-at',                  '360° Camera'),
  ('grand-vitara-gx-at',                  'Wireless Apple CarPlay + Android Auto'),
  ('grand-vitara-gx-at',                  'Ventilated Front Seat'),

  -- ── Sigra ───────────────────────────────────────────────────────────────
  ('sigra-fl-10d-mt',                     'Driver SRS Airbag'),
  ('sigra-fl-12x-mt',                     'Dual SRS Airbag'),
  ('sigra-fl-12x-mt',                     'ABS + EBD'),
  ('sigra-fl-12r-deluxe-at',              'Dual SRS Airbag'),
  ('sigra-fl-12r-deluxe-at',              'ABS + EBD'),
  ('sigra-fl-12r-deluxe-at',              'Head Unit Touch Screen'),
  ('sigra-fl-12r-deluxe-at',              'Velg Alloy Dual-Tone'),

  -- ── Terios ──────────────────────────────────────────────────────────────
  ('terios-gen3-x-mt',                    'Dual SRS Airbag'),
  ('terios-gen3-x-mt',                    'ABS + EBD'),
  ('terios-gen3-r-at',                    'Dual SRS Airbag'),
  ('terios-gen3-r-at',                    'ABS + EBD'),
  ('terios-gen3-r-at',                    'Keyless Entry'),
  ('terios-gen3-r-at',                    'Head Unit Touch Screen'),
  ('terios-gen3-r-deluxe-at',             '4 SRS Airbag'),
  ('terios-gen3-r-deluxe-at',             'ABS + EBD'),
  ('terios-gen3-r-deluxe-at',             'VSC + Hill Start Assist'),
  ('terios-gen3-r-deluxe-at',             'Velg 17"'),

  -- ── Triton ──────────────────────────────────────────────────────────────
  ('triton-gen5-hpe-4x4-at',              '7 SRS Airbag'),
  ('triton-gen5-hpe-4x4-at',              'ABS + EBD + BA'),
  ('triton-gen5-hpe-4x4-at',              'ASC + Hill Start Assist'),
  ('triton-gen5-hpe-4x4-at',              'Super Select II 4WD'),
  ('triton-gen5-hpe-4x4-at',              'Keyless Operation System'),
  ('triton-gen5-hpe-4x4-at',              'LED Headlamp'),
  ('triton-gen5-hpe-ultimate-4x4-at',     '7 SRS Airbag'),
  ('triton-gen5-hpe-ultimate-4x4-at',     'ABS + EBD + BA'),
  ('triton-gen5-hpe-ultimate-4x4-at',     'ASC + Hill Start Assist'),
  ('triton-gen5-hpe-ultimate-4x4-at',     'Super Select II 4WD'),
  ('triton-gen5-hpe-ultimate-4x4-at',     'Off-Road Mode (Gravel/Mud/Sand/Rock)'),
  ('triton-gen5-hpe-ultimate-4x4-at',     'Rear Differential Lock'),
  ('triton-gen5-hpe-ultimate-4x4-at',     'FCM (Forward Collision Mitigation)'),
  ('triton-gen5-hpe-ultimate-4x4-at',     'Lane Departure Warning'),
  ('triton-gen5-hpe-ultimate-4x4-at',     'Blind Spot Warning + RCTA'),
  ('triton-gen5-hpe-ultimate-4x4-at',     '360° Camera'),

  -- ── IONIQ 5 ─────────────────────────────────────────────────────────────
  ('ioniq5-gen1-prime-sr',                '7 SRS Airbag'),
  ('ioniq5-gen1-prime-sr',                'ABS + EBD'),
  ('ioniq5-gen1-prime-sr',                'ESC + Hill Start Assist'),
  ('ioniq5-gen1-prime-sr',                'V2L (Vehicle-to-Load 3.6 kW)'),
  ('ioniq5-gen1-prime-sr',                'Hyundai SmartSense ADAS'),
  ('ioniq5-gen1-prime-sr',                'DC Fast Charging (350 kW)'),
  ('ioniq5-gen1-prime-sr',                'Pixel LED Headlamp'),
  ('ioniq5-gen1-signature-lr-awd',        '7 SRS Airbag'),
  ('ioniq5-gen1-signature-lr-awd',        'ABS + EBD'),
  ('ioniq5-gen1-signature-lr-awd',        'ESC + Hill Start Assist'),
  ('ioniq5-gen1-signature-lr-awd',        'V2L (Vehicle-to-Load 3.6 kW)'),
  ('ioniq5-gen1-signature-lr-awd',        'Hyundai SmartSense ADAS'),
  ('ioniq5-gen1-signature-lr-awd',        'Highway Driving Assist 2'),
  ('ioniq5-gen1-signature-lr-awd',        'Smart Cruise Control'),
  ('ioniq5-gen1-signature-lr-awd',        'Relax Front Seat (electric + footrest)'),
  ('ioniq5-gen1-signature-lr-awd',        'Bose 8-Speaker'),
  ('ioniq5-gen1-signature-lr-awd',        'Vision Roof (panoramic glass)'),
  ('ioniq5-gen1-signature-lr-awd',        'DC Fast Charging (350 kW)')
on conflict do nothing;

-- ─────────────────────────────────────────────────────────────────────────────
-- DONE.
--
-- Sanity check after running:
--   select count(*) from brands;          -- expect: previous + 2 (kia, wuling)
--   select name from brands order by name;
--   select count(*) from models
--     where brand_id in ('kia','wuling','suzuki','daihatsu','mitsubishi','hyundai')
--     and id not in (select id from models where created_at < now());  -- approximate
--   -- Or simpler: just verify the 19 new variants are present:
--   select count(*) from variants v
--     join generations g on g.id = v.generation_id
--     where g.id in (
--       'kia-sonet-gen1-fl','kia-carens-gen1',
--       'wuling-almaz-hybrid','wuling-air-ev-gen1',
--       'suzuki-grand-vitara-gen1-shvs',
--       'daihatsu-sigra-fl','daihatsu-terios-gen3',
--       'mitsubishi-triton-gen5','hyundai-ioniq-5-gen1'
--     );                                                          -- expect: 19
-- ─────────────────────────────────────────────────────────────────────────────
