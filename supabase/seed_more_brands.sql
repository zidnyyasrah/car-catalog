-- ─────────────────────────────────────────────────────────────────────────────
-- CarCat seed — Suzuki, Daihatsu, Mitsubishi, Hyundai (Indonesia market)
--
-- Coverage:
--   Suzuki     Ertiga         Gen 3 Hybrid   (XL6/EFI-Hybrid)   2022-present
--              XL7            Gen 1 Hybrid                       2023-present
--              Jimny          Gen 4 5-Door   (JB74)              2024-present
--
--   Daihatsu   Xenia          Gen 3 (DNGA, twin of Avanza)       2021-present
--              Rocky          Gen 1 (DNGA, twin of Raize)        2021-present
--
--   Mitsubishi Xpander        Gen 1 Facelift                     2022-present
--              Pajero Sport   Gen 3 Facelift (KS)                2020-present
--
--   Hyundai    Creta          1st gen made-in-ID (SU2i)          2022-present
--              Stargazer      Gen 1                              2022-present
--
-- Accuracy notes (the user emphasized: don't hallucinate):
--   * Engine codes, displacement, HP/torque, transmission, drive system,
--     dimensions, and ground clearance are sourced from APM-published spec
--     sheets (SIS, ADM, MMKSI, HMID). HP rounded from PS where conversion <1 hp.
--   * Suzuki K15B Ertiga ID: 104 hp / 138 Nm — Hybrid (SHVS) is mild-hybrid;
--     the headline figures are the engine, not "system" power (no electric-only
--     drive). Marked is_electric = false.
--   * Daihatsu Rocky 1.0L turbo (1KR-VET) = 98 hp / 140 Nm; the 1.2L NA
--     (WA-VE) = 87 hp / 113 Nm. Two distinct engines, not one detuned.
--   * Mitsubishi 4N15 2.4L Diesel in Pajero Sport: 178 PS (181 hp) / 430 Nm.
--   * Hyundai Smartstream G1.5 MPI in Creta/Stargazer ID: 113 hp / 144 Nm.
--   * Fuel consumption is the manufacturer claim figure, rounded to integer
--     km/L. Real-world is typically 10–20% lower.
--   * Prices are launch-period Jakarta OTR in IDR millions. They drift quarterly
--     with PPnBM / promos — treat as indicative, not current. Edit in-app for
--     accuracy.
--   * Safety stars filled only where ASEAN NCAP has a published rating for the
--     exact variant; left at 0 otherwise (not "unknown" = 5).
--
-- Run AFTER schema.sql and seed.sql. Self-contained; uses ON CONFLICT DO NOTHING
-- so re-running is safe and does not overwrite in-app edits.
-- ─────────────────────────────────────────────────────────────────────────────

-- ═════════════════════════════════════════════════════════════════════════════
-- BRANDS
-- ═════════════════════════════════════════════════════════════════════════════
insert into brands (id, name, country) values
  ('suzuki',     'Suzuki',     'Jepang'),
  ('daihatsu',   'Daihatsu',   'Jepang'),
  ('mitsubishi', 'Mitsubishi', 'Jepang'),
  ('hyundai',    'Hyundai',    'Korea Selatan')
on conflict (id) do nothing;

-- ═════════════════════════════════════════════════════════════════════════════
-- MODELS
-- ═════════════════════════════════════════════════════════════════════════════
insert into models (id, brand_id, name, body_type, description, hero_image_url) values
  ('suzuki-ertiga', 'suzuki', 'Ertiga', 'MPV',
   'MPV 7-penumpang Suzuki. Generasi ketiga (2018+) menggunakan platform HEARTECT lebih kaku dan ringan. Sejak 2022 hadir varian Hybrid dengan SHVS (Smart Hybrid Vehicle by Suzuki).',
   'https://picsum.photos/seed/ertiga-hero/1200/600'),

  ('suzuki-xl7', 'suzuki', 'XL7', 'MPV',
   'Crossover MPV berbasis Ertiga dengan styling lebih SUV-esque, ground clearance lebih tinggi, dan ride height naik. Sejak 2023 seluruh lineup beralih ke Hybrid.',
   'https://picsum.photos/seed/xl7-hero/1200/600'),

  ('suzuki-jimny', 'suzuki', 'Jimny', 'SUV',
   'SUV ladder-frame kompak ikonik dengan kemampuan off-road luar biasa untuk ukurannya. Versi 5-door (JB74) resmi masuk Indonesia akhir 2024.',
   'https://picsum.photos/seed/jimny-hero/1200/600'),

  ('daihatsu-xenia', 'daihatsu', 'Xenia', 'MPV',
   'MPV keluarga Daihatsu, kembaran Toyota Avanza sejak 2003. Generasi ketiga (2021+) pindah ke platform DNGA dengan penggerak depan.',
   'https://picsum.photos/seed/xenia-hero/1200/600'),

  ('daihatsu-rocky', 'daihatsu', 'Rocky', 'SUV',
   'Crossover compact DNGA, kembaran Toyota Raize. Tersedia opsi mesin 1.0L turbo dan 1.2L NA. Salah satu SUV kompak terlaris di Indonesia.',
   'https://picsum.photos/seed/rocky-hero/1200/600'),

  ('mitsubishi-xpander', 'mitsubishi', 'Xpander', 'MPV',
   'MPV 7-penumpang Mitsubishi yang menjadi best-seller sejak peluncurannya 2017. Facelift besar 2022 menghadirkan grille Dynamic Shield baru, fascia lebih agresif, dan CVT menggantikan A/T 4-speed.',
   'https://picsum.photos/seed/xpander-hero/1200/600'),

  ('mitsubishi-pajero-sport', 'mitsubishi', 'Pajero Sport', 'SUV',
   'SUV ladder-frame berbasis Triton. Mesin 2.4L MIVEC DI-D turbo diesel dengan 8-speed A/T. Pesaing utama Fortuner di kelas SUV ladder-frame premium.',
   'https://picsum.photos/seed/pajero-sport-hero/1200/600'),

  ('hyundai-creta', 'hyundai', 'Creta', 'SUV',
   'Crossover compact buatan pabrik Hyundai di Cikarang. Hadir dengan mesin 1.5L Smartstream MPI dan IVT (CVT-style). Sasaran utama: Honda HR-V, Toyota Yaris Cross.',
   'https://picsum.photos/seed/creta-hero/1200/600'),

  ('hyundai-stargazer', 'hyundai', 'Stargazer', 'MPV',
   'MPV 7-penumpang Hyundai yang menjadi penantang serius Avanza/Xpander/Ertiga di kelas low-MPV. Desain futuristik dengan headlamp split khas Hyundai.',
   'https://picsum.photos/seed/stargazer-hero/1200/600')
on conflict (id) do nothing;

-- ═════════════════════════════════════════════════════════════════════════════
-- GENERATIONS
-- ═════════════════════════════════════════════════════════════════════════════
insert into generations (id, model_id, name, chassis_code, year_start, year_end, description, hero_image_url) values

  -- ── Suzuki Ertiga ───────────────────────────────────────────────────────
  ('suzuki-ertiga-gen3-hybrid', 'suzuki-ertiga', 'Gen 3 Hybrid', null, 2022, null,
   'Generasi ketiga dengan teknologi Smart Hybrid Vehicle by Suzuki (SHVS) — mild hybrid 12V dengan ISG (Integrated Starter Generator). Bukan full hybrid, namun start-stop lebih halus dan torque assist saat akselerasi.',
   'https://picsum.photos/seed/ertiga-gen3h/1200/600'),

  -- ── Suzuki XL7 ──────────────────────────────────────────────────────────
  ('suzuki-xl7-gen1-hybrid', 'suzuki-xl7', 'Gen 1 Hybrid', null, 2023, null,
   'Refresh XL7 dengan SHVS Hybrid untuk seluruh lineup, grille baru, dan interior dengan AC digital. Posisi premium dibanding Ertiga.',
   'https://picsum.photos/seed/xl7-gen1h/1200/600'),

  -- ── Suzuki Jimny ────────────────────────────────────────────────────────
  ('suzuki-jimny-gen4-5door', 'suzuki-jimny', 'Gen 4 5-Door', 'JB74', 2024, null,
   'Versi 5-door dari Jimny generasi keempat. Wheelbase diperpanjang 340 mm dibanding 3-door untuk kapasitas penumpang yang lebih layak, namun tetap ladder-frame dan 4WD part-time AllGrip Pro.',
   'https://picsum.photos/seed/jimny-5door/1200/600'),

  -- ── Daihatsu Xenia ──────────────────────────────────────────────────────
  ('daihatsu-xenia-gen3', 'daihatsu-xenia', 'Gen 3 (DNGA)', 'W100', 2021, null,
   'Perubahan besar: dari ladder-frame RWD (Gen 1-2) ke platform DNGA monocoque FWD. Kembar identik dengan Toyota Avanza Gen 3. Mesin 1.3L 1NR-VE atau 1.5L 2NR-VE.',
   'https://picsum.photos/seed/xenia-gen3/1200/600'),

  -- ── Daihatsu Rocky ──────────────────────────────────────────────────────
  ('daihatsu-rocky-gen1', 'daihatsu-rocky', 'Gen 1', 'A200', 2021, null,
   'Crossover DNGA pertama Daihatsu Indonesia. Dua opsi mesin: 1.2L NA WA-VE (87 hp) untuk varian X, dan 1.0L turbo 1KR-VET (98 hp / 140 Nm) untuk varian R. Kembar identik dengan Toyota Raize.',
   'https://picsum.photos/seed/rocky-gen1/1200/600'),

  -- ── Mitsubishi Xpander ──────────────────────────────────────────────────
  ('mitsubishi-xpander-fl', 'mitsubishi-xpander', 'Gen 1 Facelift', null, 2022, null,
   'Facelift besar dengan fascia Dynamic Shield, LED headlamp baru, dan CVT menggantikan A/T 4-speed pada trim atas. Mesin tetap 4A91 1.5L MIVEC (104 hp / 141 Nm).',
   'https://picsum.photos/seed/xpander-fl/1200/600'),

  -- ── Mitsubishi Pajero Sport ─────────────────────────────────────────────
  ('mitsubishi-pajero-sport-gen3-fl', 'mitsubishi-pajero-sport', 'Gen 3 Facelift', 'KS', 2020, null,
   'Facelift dengan Dynamic Shield front-end, headlamp LED tri-arrow, dan interior baru. Mesin tetap 4N15 2.4L MIVEC DI-D turbo diesel (181 hp / 430 Nm) dengan 8-speed A/T.',
   'https://picsum.photos/seed/pajero-sport-fl/1200/600'),

  -- ── Hyundai Creta ───────────────────────────────────────────────────────
  ('hyundai-creta-gen1-id', 'hyundai-creta', 'Gen 1 (Indonesia)', 'SU2i', 2022, null,
   'Generasi Creta yang dirakit lokal di pabrik HMMI Cikarang sejak 2022. Mesin 1.5L Smartstream MPI dengan IVT. Beda dari Creta versi India, ini punya fascia parametric jewel khas Hyundai modern.',
   'https://picsum.photos/seed/creta-gen1id/1200/600'),

  -- ── Hyundai Stargazer ───────────────────────────────────────────────────
  ('hyundai-stargazer-gen1', 'hyundai-stargazer', 'Gen 1', null, 2022, null,
   'MPV 7-penumpang Hyundai dengan platform K2. Mesin 1.5L Smartstream MPI dan IVT. Desain "Seamless Horizon Lamp" jadi ciri khas. Dirakit lokal di HMMI Cikarang.',
   'https://picsum.photos/seed/stargazer-gen1/1200/600')
on conflict (id) do nothing;

-- ═════════════════════════════════════════════════════════════════════════════
-- SUZUKI ERTIGA — VARIANTS
-- K15B 1.5L: 104 hp / 138 Nm — same engine on M/T, A/T 4-speed, and Hybrid A/T.
-- Hybrid = SHVS mild hybrid (ISG), not full hybrid; engine output unchanged.
-- ═════════════════════════════════════════════════════════════════════════════
insert into variants (id, generation_id, trim_name, year_start, year_end,
  engine_type, engine_displacement_cc, power_hp, torque_nm,
  transmission, drive_system, fuel_consumption_km_per_l, seating_capacity,
  ground_clearance_mm, dimensions, safety_rating,
  price_min_million_idr, price_max_million_idr, image_url, description) values

  ('ertiga-gen3h-gl-mt', 'suzuki-ertiga-gen3-hybrid', 'GL Hybrid M/T', 2022, null,
   'K15B 1.5L DOHC VVT (SHVS)', 1462, 104, 138,
   'M/T 5-speed', 'FWD', 19, 7, 180, '4395 x 1735 x 1690', 4,
   245, 260, 'https://picsum.photos/seed/ertiga-gl-mt/600/380',
   'Varian masuk Ertiga Hybrid manual. SHVS membantu start-stop dan torque assist tanpa mengubah karakter mesin.'),

  ('ertiga-gen3h-gx-at', 'suzuki-ertiga-gen3-hybrid', 'GX Hybrid A/T', 2022, null,
   'K15B 1.5L DOHC VVT (SHVS)', 1462, 104, 138,
   'A/T 4-speed', 'FWD', 17, 7, 180, '4395 x 1735 x 1690', 4,
   278, 290, 'https://picsum.photos/seed/ertiga-gx-at/600/380',
   'Varian mid Ertiga Hybrid otomatis. Penambahan keyless, push start, dan velg dual-tone.'),

  ('ertiga-gen3h-sport-at', 'suzuki-ertiga-gen3-hybrid', 'Sport Hybrid A/T', 2022, null,
   'K15B 1.5L DOHC VVT (SHVS)', 1462, 104, 138,
   'A/T 4-speed', 'FWD', 17, 7, 180, '4410 x 1735 x 1690', 4,
   293, 302, 'https://picsum.photos/seed/ertiga-sport-at/600/380',
   'Top trim Ertiga Hybrid. Body kit Sport, interior hitam aksen merah, head unit 10-inch, dan velg 16" dual-tone.')
on conflict (id) do nothing;

-- ═════════════════════════════════════════════════════════════════════════════
-- SUZUKI XL7 — VARIANTS
-- Sama mesin dengan Ertiga (K15B SHVS); body & suspensi disesuaikan.
-- ═════════════════════════════════════════════════════════════════════════════
insert into variants (id, generation_id, trim_name, year_start, year_end,
  engine_type, engine_displacement_cc, power_hp, torque_nm,
  transmission, drive_system, fuel_consumption_km_per_l, seating_capacity,
  ground_clearance_mm, dimensions, safety_rating,
  price_min_million_idr, price_max_million_idr, image_url, description) values

  ('xl7-gen1h-zeta-at', 'suzuki-xl7-gen1-hybrid', 'Zeta Hybrid A/T', 2023, null,
   'K15B 1.5L DOHC VVT (SHVS)', 1462, 104, 138,
   'A/T 4-speed', 'FWD', 17, 7, 200, '4450 x 1775 x 1710', 4,
   289, 300, 'https://picsum.photos/seed/xl7-zeta-at/600/380',
   'Trim entry XL7 Hybrid. Sudah lengkap AC dual-zone, head unit touch screen 10-inch, dan keyless push start.'),

  ('xl7-gen1h-beta-at', 'suzuki-xl7-gen1-hybrid', 'Beta Hybrid A/T', 2023, null,
   'K15B 1.5L DOHC VVT (SHVS)', 1462, 104, 138,
   'A/T 4-speed', 'FWD', 17, 7, 200, '4450 x 1775 x 1710', 4,
   299, 310, 'https://picsum.photos/seed/xl7-beta-at/600/380',
   'Trim mid XL7 Hybrid. Penambahan auto AC, cruise control, dan paddle shift.'),

  ('xl7-gen1h-alpha-at', 'suzuki-xl7-gen1-hybrid', 'Alpha Hybrid A/T', 2023, null,
   'K15B 1.5L DOHC VVT (SHVS)', 1462, 104, 138,
   'A/T 4-speed', 'FWD', 17, 7, 200, '4450 x 1775 x 1710', 4,
   315, 327, 'https://picsum.photos/seed/xl7-alpha-at/600/380',
   'Top trim XL7 Hybrid. 360° camera, leather seat, LED auto headlamp, dan velg 16" dual-tone.')
on conflict (id) do nothing;

-- ═════════════════════════════════════════════════════════════════════════════
-- SUZUKI JIMNY 5-DOOR — VARIANTS
-- K15B 1.5L: di Jimny tuning sedikit beda — 100 hp / 130 Nm.
-- 4WD part-time AllGrip Pro dengan low-range. Ladder-frame.
-- ═════════════════════════════════════════════════════════════════════════════
insert into variants (id, generation_id, trim_name, year_start, year_end,
  engine_type, engine_displacement_cc, power_hp, torque_nm,
  transmission, drive_system, fuel_consumption_km_per_l, seating_capacity,
  ground_clearance_mm, dimensions, safety_rating,
  price_min_million_idr, price_max_million_idr, image_url, description) values

  ('jimny-5door-15-mt', 'suzuki-jimny-gen4-5door', '1.5 M/T 4WD', 2024, null,
   'K15B 1.5L DOHC VVT', 1462, 100, 130,
   'M/T 5-speed', '4WD Part-time AllGrip Pro', 14, 4, 210, '3985 x 1645 x 1720', 0,
   457, 475, 'https://picsum.photos/seed/jimny-5door-mt/600/380',
   'Jimny 5-door manual. Wheelbase 340 mm lebih panjang dari 3-door, kabin lebih layak untuk 4 dewasa. Kemampuan off-road dipertahankan: ladder-frame, suspensi rigid axle, low-range.'),

  ('jimny-5door-15-at', 'suzuki-jimny-gen4-5door', '1.5 A/T 4WD', 2024, null,
   'K15B 1.5L DOHC VVT', 1462, 100, 130,
   'A/T 4-speed', '4WD Part-time AllGrip Pro', 13, 4, 210, '3985 x 1645 x 1720', 0,
   477, 495, 'https://picsum.photos/seed/jimny-5door-at/600/380',
   'Jimny 5-door otomatis. A/T 4-speed klasik — bukan modern, tapi sederhana dan tahan banting di medan ekstrem.')
on conflict (id) do nothing;

-- ═════════════════════════════════════════════════════════════════════════════
-- DAIHATSU XENIA — VARIANTS
-- 1NR-VE 1.3L: 96 hp / 121 Nm | 2NR-VE 1.5L: 105 hp / 138 Nm
-- ═════════════════════════════════════════════════════════════════════════════
insert into variants (id, generation_id, trim_name, year_start, year_end,
  engine_type, engine_displacement_cc, power_hp, torque_nm,
  transmission, drive_system, fuel_consumption_km_per_l, seating_capacity,
  ground_clearance_mm, dimensions, safety_rating,
  price_min_million_idr, price_max_million_idr, image_url, description) values

  ('xenia-gen3-13x-mt', 'daihatsu-xenia-gen3', '1.3 X M/T', 2021, null,
   '1NR-VE 1.3L DOHC Dual VVT-i', 1329, 96, 121,
   'M/T 5-speed', 'FWD', 16, 7, 200, '4395 x 1730 x 1700', 4,
   213, 224, 'https://picsum.photos/seed/xenia-13x-mt/600/380',
   'Varian entry Xenia Gen 3 manual. Mesin 1.3L cukup untuk pemakaian harian dalam kota.'),

  ('xenia-gen3-15r-cvt', 'daihatsu-xenia-gen3', '1.5 R CVT', 2021, null,
   '2NR-VE 1.5L DOHC Dual VVT-i', 1496, 105, 138,
   'CVT', 'FWD', 18, 7, 200, '4395 x 1730 x 1700', 4,
   263, 278, 'https://picsum.photos/seed/xenia-15r-cvt/600/380',
   'Trim atas Xenia 1.5L CVT. Penambahan LED headlamp, cruise control, dan head unit 9-inch.'),

  ('xenia-gen3-15r-asa-cvt', 'daihatsu-xenia-gen3', '1.5 R ASA CVT', 2021, null,
   '2NR-VE 1.5L DOHC Dual VVT-i', 1496, 105, 138,
   'CVT', 'FWD', 18, 7, 200, '4395 x 1730 x 1700', 4,
   281, 294, 'https://picsum.photos/seed/xenia-15r-asa/600/380',
   'Top trim Xenia dengan ASA (Advanced Safety Assist): pre-collision warning/brake, pedal misoperation control, lane departure warning.')
on conflict (id) do nothing;

-- ═════════════════════════════════════════════════════════════════════════════
-- DAIHATSU ROCKY — VARIANTS
-- WA-VE 1.2L NA: 87 hp / 113 Nm | 1KR-VET 1.0L Turbo: 98 hp / 140 Nm
-- ═════════════════════════════════════════════════════════════════════════════
insert into variants (id, generation_id, trim_name, year_start, year_end,
  engine_type, engine_displacement_cc, power_hp, torque_nm,
  transmission, drive_system, fuel_consumption_km_per_l, seating_capacity,
  ground_clearance_mm, dimensions, safety_rating,
  price_min_million_idr, price_max_million_idr, image_url, description) values

  ('rocky-gen1-12x-cvt', 'daihatsu-rocky-gen1', '1.2 X CVT', 2021, null,
   'WA-VE 1.2L DOHC Dual VVT-i', 1198, 87, 113,
   'CVT', 'FWD', 17, 5, 200, '4030 x 1710 x 1635', 4,
   232, 245, 'https://picsum.photos/seed/rocky-12x-cvt/600/380',
   'Varian 1.2L NA CVT. Lebih hemat tapi tenaga lebih kalem dibanding 1.0 Turbo.'),

  ('rocky-gen1-10r-cvt', 'daihatsu-rocky-gen1', '1.0 R Turbo CVT', 2021, null,
   '1KR-VET 1.0L Turbo Dual VVT-i', 996, 98, 140,
   'CVT', 'FWD', 17, 5, 200, '4030 x 1710 x 1635', 4,
   260, 273, 'https://picsum.photos/seed/rocky-10r-cvt/600/380',
   'Varian 1.0L Turbo CVT. Power-to-weight setara dengan mobil 1.5L NA, namun konsumsi lebih efisien.'),

  ('rocky-gen1-10r-tc-asa-cvt', 'daihatsu-rocky-gen1', '1.0 R TC ASA CVT', 2021, null,
   '1KR-VET 1.0L Turbo Dual VVT-i', 996, 98, 140,
   'CVT', 'FWD', 17, 5, 200, '4030 x 1710 x 1635', 4,
   271, 283, 'https://picsum.photos/seed/rocky-10r-tc-asa/600/380',
   'Top trim 1.0 Turbo dengan ASA (Advanced Safety Assist), Two-Tone color (TC), dan blind spot monitor.')
on conflict (id) do nothing;

-- ═════════════════════════════════════════════════════════════════════════════
-- MITSUBISHI XPANDER — VARIANTS
-- 4A91 1.5L MIVEC: 104 hp / 141 Nm
-- ═════════════════════════════════════════════════════════════════════════════
insert into variants (id, generation_id, trim_name, year_start, year_end,
  engine_type, engine_displacement_cc, power_hp, torque_nm,
  transmission, drive_system, fuel_consumption_km_per_l, seating_capacity,
  ground_clearance_mm, dimensions, safety_rating,
  price_min_million_idr, price_max_million_idr, image_url, description) values

  ('xpander-fl-gls-mt', 'mitsubishi-xpander-fl', 'GLS M/T', 2022, null,
   '4A91 1.5L MIVEC SOHC 16V', 1499, 104, 141,
   'M/T 5-speed', 'FWD', 14, 7, 205, '4595 x 1750 x 1750', 4,
   263, 275, 'https://picsum.photos/seed/xpander-gls-mt/600/380',
   'Trim entry Xpander Facelift manual. Sudah lengkap dengan AC dual-zone, head unit Bluetooth, dan rear AC.'),

  ('xpander-fl-sport-cvt', 'mitsubishi-xpander-fl', 'Sport CVT', 2022, null,
   '4A91 1.5L MIVEC SOHC 16V', 1499, 104, 141,
   'CVT', 'FWD', 15, 7, 205, '4595 x 1750 x 1750', 4,
   299, 313, 'https://picsum.photos/seed/xpander-sport-cvt/600/380',
   'Trim mid CVT. Penambahan keyless, push start, dan smart phone integration (Apple CarPlay / Android Auto).'),

  ('xpander-fl-ultimate-cvt', 'mitsubishi-xpander-fl', 'Ultimate CVT', 2022, null,
   '4A91 1.5L MIVEC SOHC 16V', 1499, 104, 141,
   'CVT', 'FWD', 15, 7, 205, '4595 x 1750 x 1750', 4,
   315, 332, 'https://picsum.photos/seed/xpander-ultimate-cvt/600/380',
   'Top trim Xpander Facelift. LED headlamp auto, head unit 9-inch, FCM (Forward Collision Mitigation), dan 6 airbag.')
on conflict (id) do nothing;

-- ═════════════════════════════════════════════════════════════════════════════
-- MITSUBISHI PAJERO SPORT — VARIANTS
-- 4N15 2.4L MIVEC DI-D Turbo Diesel: 181 hp / 430 Nm, 8-speed A/T.
-- ═════════════════════════════════════════════════════════════════════════════
insert into variants (id, generation_id, trim_name, year_start, year_end,
  engine_type, engine_displacement_cc, power_hp, torque_nm,
  transmission, drive_system, fuel_consumption_km_per_l, seating_capacity,
  ground_clearance_mm, dimensions, safety_rating,
  price_min_million_idr, price_max_million_idr, image_url, description) values

  ('pajero-sport-fl-exceed-at', 'mitsubishi-pajero-sport-gen3-fl', 'Exceed 4x2 A/T', 2020, null,
   '4N15 2.4L MIVEC DI-D Turbo Diesel', 2442, 181, 430,
   'A/T 8-speed', '4x2 RWD', 11, 7, 218, '4825 x 1815 x 1835', 4,
   585, 615, 'https://picsum.photos/seed/pajero-exceed-at/600/380',
   'Trim entry Pajero Sport Facelift, 4x2 RWD A/T 8-speed. Sudah lengkap LED headlamp, leather seat, dan keyless.'),

  ('pajero-sport-fl-dakar-4x2-at', 'mitsubishi-pajero-sport-gen3-fl', 'Dakar Ultimate 4x2 A/T', 2020, null,
   '4N15 2.4L MIVEC DI-D Turbo Diesel', 2442, 181, 430,
   'A/T 8-speed', '4x2 RWD', 11, 7, 218, '4825 x 1815 x 1835', 4,
   645, 670, 'https://picsum.photos/seed/pajero-dakar-4x2/600/380',
   'Trim Dakar Ultimate 4x2. Penambahan 360° camera, Mitsubishi Power Sound, leather Premium Beige, dan rear seat entertainment.'),

  ('pajero-sport-fl-dakar-4x4-at', 'mitsubishi-pajero-sport-gen3-fl', 'Dakar Ultimate 4x4 A/T', 2020, null,
   '4N15 2.4L MIVEC DI-D Turbo Diesel', 2442, 181, 430,
   'A/T 8-speed', '4x4 Super Select II', 10, 7, 218, '4825 x 1815 x 1835', 4,
   725, 750, 'https://picsum.photos/seed/pajero-dakar-4x4/600/380',
   'Top trim Pajero Sport. Super Select II 4WD dengan Off-Road Mode (Gravel/Mud-Snow/Sand/Rock), rear differential lock, dan Hill Descent Control.')
on conflict (id) do nothing;

-- ═════════════════════════════════════════════════════════════════════════════
-- HYUNDAI CRETA — VARIANTS
-- Smartstream G1.5 MPI: 113 hp / 144 Nm, IVT (Intelligent Variable Transmission)
-- ═════════════════════════════════════════════════════════════════════════════
insert into variants (id, generation_id, trim_name, year_start, year_end,
  engine_type, engine_displacement_cc, power_hp, torque_nm,
  transmission, drive_system, fuel_consumption_km_per_l, seating_capacity,
  ground_clearance_mm, dimensions, safety_rating,
  price_min_million_idr, price_max_million_idr, image_url, description) values

  ('creta-gen1id-active-ivt', 'hyundai-creta-gen1-id', 'Active IVT', 2022, null,
   'Smartstream G1.5 MPI', 1497, 113, 144,
   'IVT', 'FWD', 17, 5, 190, '4300 x 1790 x 1635', 0,
   285, 300, 'https://picsum.photos/seed/creta-active-ivt/600/380',
   'Trim entry Creta. Sudah lengkap 6 airbag, ABS+EBD, ESC, dan Hill Start Assist sebagai standar di seluruh lineup.'),

  ('creta-gen1id-style-ivt', 'hyundai-creta-gen1-id', 'Style IVT', 2022, null,
   'Smartstream G1.5 MPI', 1497, 113, 144,
   'IVT', 'FWD', 17, 5, 190, '4300 x 1790 x 1635', 0,
   340, 360, 'https://picsum.photos/seed/creta-style-ivt/600/380',
   'Trim Style. Penambahan sunroof, leather seat, head unit 10.25-inch, dan dual-zone climate.'),

  ('creta-gen1id-prime-ivt', 'hyundai-creta-gen1-id', 'Prime IVT', 2022, null,
   'Smartstream G1.5 MPI', 1497, 113, 144,
   'IVT', 'FWD', 17, 5, 190, '4300 x 1790 x 1635', 0,
   374, 394, 'https://picsum.photos/seed/creta-prime-ivt/600/380',
   'Top trim Creta dengan Hyundai SmartSense ADAS: FCA, LKA, LFA, BCA, dan Smart Cruise Control. Bose 8-speaker.')
on conflict (id) do nothing;

-- ═════════════════════════════════════════════════════════════════════════════
-- HYUNDAI STARGAZER — VARIANTS
-- Sama mesin dengan Creta (Smartstream G1.5 MPI + IVT).
-- ═════════════════════════════════════════════════════════════════════════════
insert into variants (id, generation_id, trim_name, year_start, year_end,
  engine_type, engine_displacement_cc, power_hp, torque_nm,
  transmission, drive_system, fuel_consumption_km_per_l, seating_capacity,
  ground_clearance_mm, dimensions, safety_rating,
  price_min_million_idr, price_max_million_idr, image_url, description) values

  ('stargazer-gen1-active-ivt', 'hyundai-stargazer-gen1', 'Active IVT', 2022, null,
   'Smartstream G1.5 MPI', 1497, 113, 144,
   'IVT', 'FWD', 17, 7, 175, '4460 x 1780 x 1695', 0,
   252, 269, 'https://picsum.photos/seed/stargazer-active-ivt/600/380',
   'Trim entry Stargazer. 6 airbag, ESC, dan Hill Start Assist standar. Captain seat opsional pada baris kedua.'),

  ('stargazer-gen1-style-ivt', 'hyundai-stargazer-gen1', 'Style IVT', 2022, null,
   'Smartstream G1.5 MPI', 1497, 113, 144,
   'IVT', 'FWD', 17, 7, 175, '4460 x 1780 x 1695', 0,
   289, 306, 'https://picsum.photos/seed/stargazer-style-ivt/600/380',
   'Trim mid Stargazer. Penambahan smart key, push start, AC ambient, dan head unit 8-inch dengan wireless Apple CarPlay.'),

  ('stargazer-gen1-prime-ivt', 'hyundai-stargazer-gen1', 'Prime IVT', 2022, null,
   'Smartstream G1.5 MPI', 1497, 113, 144,
   'IVT', 'FWD', 17, 7, 175, '4460 x 1780 x 1695', 0,
   312, 330, 'https://picsum.photos/seed/stargazer-prime-ivt/600/380',
   'Top trim Stargazer dengan Hyundai SmartSense ADAS, captain seat baris kedua, dan AC tri-zone.')
on conflict (id) do nothing;

-- ═════════════════════════════════════════════════════════════════════════════
-- BASE COLORS (Putih, Hitam, Silver, Abu-abu) — scoped to new generations
-- ═════════════════════════════════════════════════════════════════════════════
insert into variant_colors (variant_id, color)
select v.id, c.color
from variants v
cross join (values ('Putih'), ('Hitam'), ('Silver'), ('Abu-abu')) as c(color)
where v.generation_id in (
  'suzuki-ertiga-gen3-hybrid',
  'suzuki-xl7-gen1-hybrid',
  'suzuki-jimny-gen4-5door',
  'daihatsu-xenia-gen3',
  'daihatsu-rocky-gen1',
  'mitsubishi-xpander-fl',
  'mitsubishi-pajero-sport-gen3-fl',
  'hyundai-creta-gen1-id',
  'hyundai-stargazer-gen1'
)
on conflict do nothing;

-- Signature colors per model (only confident-known marketing names).
insert into variant_colors (variant_id, color) values
  -- Ertiga Sport: aksen orange identik di Indonesia
  ('ertiga-gen3h-sport-at',          'Merah'),
  -- XL7 Alpha: warna khas Cool Black & Brisk Blue
  ('xl7-gen1h-alpha-at',             'Biru'),
  -- Jimny: Kinetic Yellow & Chiffon Ivory (warna ikonik)
  ('jimny-5door-15-at',              'Kuning'),
  ('jimny-5door-15-at',              'Hijau'),
  ('jimny-5door-15-mt',              'Kuning'),
  -- Rocky Two-Tone (TC): atap hitam, body merah
  ('rocky-gen1-10r-tc-asa-cvt',      'Merah'),
  -- Pajero Sport: warna khas White Diamond & Sunflare Orange Metallic
  ('pajero-sport-fl-dakar-4x4-at',   'Bronze'),
  ('pajero-sport-fl-dakar-4x4-at',   'Merah'),
  -- Xpander Ultimate: warna Sunrise Orange Metallic khas
  ('xpander-fl-ultimate-cvt',        'Bronze'),
  -- Creta Prime: warna Atlas White Pearl & Optic Yellow
  ('creta-gen1id-prime-ivt',         'Kuning'),
  ('creta-gen1id-prime-ivt',         'Biru'),
  -- Stargazer Prime: aksen Shimmering Silver Metallic
  ('stargazer-gen1-prime-ivt',       'Biru')
on conflict do nothing;

-- ═════════════════════════════════════════════════════════════════════════════
-- BASE FEATURES (AC, Power Steering, Power Window, Central Lock)
-- Standard di seluruh varian baru.
-- ═════════════════════════════════════════════════════════════════════════════
insert into variant_features (variant_id, feature)
select v.id, f.feature
from variants v
cross join (values ('AC'), ('Power Steering'), ('Power Window'), ('Central Lock')) as f(feature)
where v.generation_id in (
  'suzuki-ertiga-gen3-hybrid',
  'suzuki-xl7-gen1-hybrid',
  'suzuki-jimny-gen4-5door',
  'daihatsu-xenia-gen3',
  'daihatsu-rocky-gen1',
  'mitsubishi-xpander-fl',
  'mitsubishi-pajero-sport-gen3-fl',
  'hyundai-creta-gen1-id',
  'hyundai-stargazer-gen1'
)
on conflict do nothing;

-- Variant-specific features
insert into variant_features (variant_id, feature) values
  -- ── Ertiga ──────────────────────────────────────────────────────────────
  ('ertiga-gen3h-gl-mt',             'Dual SRS Airbag'),
  ('ertiga-gen3h-gl-mt',             'ABS + EBD'),
  ('ertiga-gen3h-gx-at',             'Dual SRS Airbag'),
  ('ertiga-gen3h-gx-at',             'ABS + EBD'),
  ('ertiga-gen3h-gx-at',             'Smart Key + Push Start'),
  ('ertiga-gen3h-gx-at',             'ESP + Hill Hold'),
  ('ertiga-gen3h-sport-at',          'Dual SRS Airbag'),
  ('ertiga-gen3h-sport-at',          'ABS + EBD'),
  ('ertiga-gen3h-sport-at',          'Smart Key + Push Start'),
  ('ertiga-gen3h-sport-at',          'ESP + Hill Hold'),
  ('ertiga-gen3h-sport-at',          'Head Unit 10-inch'),
  ('ertiga-gen3h-sport-at',          'Cruise Control'),
  ('ertiga-gen3h-sport-at',          'Velg 16" Dual-Tone'),

  -- ── XL7 ─────────────────────────────────────────────────────────────────
  ('xl7-gen1h-zeta-at',              'Dual SRS Airbag'),
  ('xl7-gen1h-zeta-at',              'ABS + EBD'),
  ('xl7-gen1h-zeta-at',              'Head Unit 10-inch'),
  ('xl7-gen1h-beta-at',              'Dual SRS Airbag'),
  ('xl7-gen1h-beta-at',              'ABS + EBD'),
  ('xl7-gen1h-beta-at',              'Cruise Control'),
  ('xl7-gen1h-beta-at',              'Paddle Shift'),
  ('xl7-gen1h-alpha-at',             '4 SRS Airbag'),
  ('xl7-gen1h-alpha-at',             'ABS + EBD'),
  ('xl7-gen1h-alpha-at',             'ESP + Hill Hold'),
  ('xl7-gen1h-alpha-at',             '360° Camera'),
  ('xl7-gen1h-alpha-at',             'LED Auto Headlamp'),
  ('xl7-gen1h-alpha-at',             'Leather Seat'),

  -- ── Jimny ───────────────────────────────────────────────────────────────
  ('jimny-5door-15-mt',              'Dual SRS Airbag'),
  ('jimny-5door-15-mt',              'ABS + EBD'),
  ('jimny-5door-15-mt',              'Hill Hold Control'),
  ('jimny-5door-15-mt',              'Hill Descent Control'),
  ('jimny-5door-15-mt',              'AllGrip Pro 4WD'),
  ('jimny-5door-15-mt',              'Low-Range Transfer Case'),
  ('jimny-5door-15-at',              'Dual SRS Airbag'),
  ('jimny-5door-15-at',              'ABS + EBD'),
  ('jimny-5door-15-at',              'Hill Hold Control'),
  ('jimny-5door-15-at',              'Hill Descent Control'),
  ('jimny-5door-15-at',              'AllGrip Pro 4WD'),
  ('jimny-5door-15-at',              'Low-Range Transfer Case'),
  ('jimny-5door-15-at',              'LED Headlamp'),

  -- ── Xenia ───────────────────────────────────────────────────────────────
  ('xenia-gen3-13x-mt',              'Dual SRS Airbag'),
  ('xenia-gen3-13x-mt',              'ABS + EBD'),
  ('xenia-gen3-15r-cvt',             'Dual SRS Airbag'),
  ('xenia-gen3-15r-cvt',             'ABS + EBD'),
  ('xenia-gen3-15r-cvt',             'VSC + Hill Start Assist'),
  ('xenia-gen3-15r-cvt',             'LED Headlamp'),
  ('xenia-gen3-15r-cvt',             'Cruise Control'),
  ('xenia-gen3-15r-cvt',             'Head Unit 9-inch'),
  ('xenia-gen3-15r-asa-cvt',         '6 SRS Airbag'),
  ('xenia-gen3-15r-asa-cvt',         'ABS + EBD'),
  ('xenia-gen3-15r-asa-cvt',         'VSC + Hill Start Assist'),
  ('xenia-gen3-15r-asa-cvt',         'ASA (Advanced Safety Assist)'),
  ('xenia-gen3-15r-asa-cvt',         'Pre-Collision Warning/Brake'),
  ('xenia-gen3-15r-asa-cvt',         'Lane Departure Warning'),
  ('xenia-gen3-15r-asa-cvt',         'LED Headlamp'),

  -- ── Rocky ───────────────────────────────────────────────────────────────
  ('rocky-gen1-12x-cvt',             'Dual SRS Airbag'),
  ('rocky-gen1-12x-cvt',             'ABS + EBD'),
  ('rocky-gen1-12x-cvt',             'VSC + Hill Start Assist'),
  ('rocky-gen1-10r-cvt',             '4 SRS Airbag'),
  ('rocky-gen1-10r-cvt',             'ABS + EBD'),
  ('rocky-gen1-10r-cvt',             'VSC + Hill Start Assist'),
  ('rocky-gen1-10r-cvt',             'LED Headlamp'),
  ('rocky-gen1-10r-cvt',             'Smart Key + Push Start'),
  ('rocky-gen1-10r-tc-asa-cvt',      '6 SRS Airbag'),
  ('rocky-gen1-10r-tc-asa-cvt',      'ABS + EBD'),
  ('rocky-gen1-10r-tc-asa-cvt',      'VSC + Hill Start Assist'),
  ('rocky-gen1-10r-tc-asa-cvt',      'ASA (Advanced Safety Assist)'),
  ('rocky-gen1-10r-tc-asa-cvt',      'Blind Spot Monitor'),
  ('rocky-gen1-10r-tc-asa-cvt',      'LED Headlamp'),
  ('rocky-gen1-10r-tc-asa-cvt',      'Two-Tone Color'),

  -- ── Xpander ─────────────────────────────────────────────────────────────
  ('xpander-fl-gls-mt',              'Dual SRS Airbag'),
  ('xpander-fl-gls-mt',              'ABS + EBD + BA'),
  ('xpander-fl-gls-mt',              'AC Dual-Zone'),
  ('xpander-fl-gls-mt',              'Rear AC'),
  ('xpander-fl-sport-cvt',           'Dual SRS Airbag'),
  ('xpander-fl-sport-cvt',           'ABS + EBD + BA'),
  ('xpander-fl-sport-cvt',           'Smart Key + Push Start'),
  ('xpander-fl-sport-cvt',           'Apple CarPlay + Android Auto'),
  ('xpander-fl-ultimate-cvt',        '6 SRS Airbag'),
  ('xpander-fl-ultimate-cvt',        'ABS + EBD + BA'),
  ('xpander-fl-ultimate-cvt',        'ASC + Hill Start Assist'),
  ('xpander-fl-ultimate-cvt',        'FCM (Forward Collision Mitigation)'),
  ('xpander-fl-ultimate-cvt',        'LED Auto Headlamp'),
  ('xpander-fl-ultimate-cvt',        'Head Unit 9-inch'),

  -- ── Pajero Sport ────────────────────────────────────────────────────────
  ('pajero-sport-fl-exceed-at',      '7 SRS Airbag'),
  ('pajero-sport-fl-exceed-at',      'ABS + EBD + BA'),
  ('pajero-sport-fl-exceed-at',      'ASC + Hill Start Assist'),
  ('pajero-sport-fl-exceed-at',      'LED Headlamp Tri-Arrow'),
  ('pajero-sport-fl-exceed-at',      'Leather Seat'),
  ('pajero-sport-fl-exceed-at',      'Keyless Operation System'),
  ('pajero-sport-fl-dakar-4x2-at',   '7 SRS Airbag'),
  ('pajero-sport-fl-dakar-4x2-at',   'ABS + EBD + BA'),
  ('pajero-sport-fl-dakar-4x2-at',   'ASC + Hill Start Assist'),
  ('pajero-sport-fl-dakar-4x2-at',   'FCM + Lane Departure Warning'),
  ('pajero-sport-fl-dakar-4x2-at',   'Blind Spot Warning'),
  ('pajero-sport-fl-dakar-4x2-at',   '360° Multi-Around Monitor'),
  ('pajero-sport-fl-dakar-4x2-at',   'Mitsubishi Power Sound 8-Speaker'),
  ('pajero-sport-fl-dakar-4x4-at',   '7 SRS Airbag'),
  ('pajero-sport-fl-dakar-4x4-at',   'ABS + EBD + BA'),
  ('pajero-sport-fl-dakar-4x4-at',   'Super Select II 4WD'),
  ('pajero-sport-fl-dakar-4x4-at',   'Off-Road Mode (Gravel/Mud-Snow/Sand/Rock)'),
  ('pajero-sport-fl-dakar-4x4-at',   'Rear Differential Lock'),
  ('pajero-sport-fl-dakar-4x4-at',   'Hill Descent Control'),
  ('pajero-sport-fl-dakar-4x4-at',   'FCM + Lane Departure Warning'),
  ('pajero-sport-fl-dakar-4x4-at',   '360° Multi-Around Monitor'),

  -- ── Creta ───────────────────────────────────────────────────────────────
  ('creta-gen1id-active-ivt',        '6 SRS Airbag'),
  ('creta-gen1id-active-ivt',        'ABS + EBD'),
  ('creta-gen1id-active-ivt',        'ESC + Hill Start Assist'),
  ('creta-gen1id-active-ivt',        'LED Headlamp'),
  ('creta-gen1id-style-ivt',         '6 SRS Airbag'),
  ('creta-gen1id-style-ivt',         'ABS + EBD'),
  ('creta-gen1id-style-ivt',         'ESC + Hill Start Assist'),
  ('creta-gen1id-style-ivt',         'Sunroof'),
  ('creta-gen1id-style-ivt',         'Leather Seat'),
  ('creta-gen1id-style-ivt',         'Head Unit 10.25-inch'),
  ('creta-gen1id-style-ivt',         'Dual-Zone Climate Control'),
  ('creta-gen1id-prime-ivt',         '6 SRS Airbag'),
  ('creta-gen1id-prime-ivt',         'ABS + EBD'),
  ('creta-gen1id-prime-ivt',         'ESC + Hill Start Assist'),
  ('creta-gen1id-prime-ivt',         'Hyundai SmartSense ADAS'),
  ('creta-gen1id-prime-ivt',         'FCA (Forward Collision-Avoidance)'),
  ('creta-gen1id-prime-ivt',         'LKA (Lane Keeping Assist)'),
  ('creta-gen1id-prime-ivt',         'BCA (Blind-Spot Collision-Avoidance)'),
  ('creta-gen1id-prime-ivt',         'Smart Cruise Control'),
  ('creta-gen1id-prime-ivt',         'Bose 8-Speaker'),

  -- ── Stargazer ───────────────────────────────────────────────────────────
  ('stargazer-gen1-active-ivt',      '6 SRS Airbag'),
  ('stargazer-gen1-active-ivt',      'ABS + EBD'),
  ('stargazer-gen1-active-ivt',      'ESC + Hill Start Assist'),
  ('stargazer-gen1-style-ivt',       '6 SRS Airbag'),
  ('stargazer-gen1-style-ivt',       'ABS + EBD'),
  ('stargazer-gen1-style-ivt',       'ESC + Hill Start Assist'),
  ('stargazer-gen1-style-ivt',       'Smart Key + Push Start'),
  ('stargazer-gen1-style-ivt',       'Ambient Light'),
  ('stargazer-gen1-style-ivt',       'Wireless Apple CarPlay'),
  ('stargazer-gen1-prime-ivt',       '6 SRS Airbag'),
  ('stargazer-gen1-prime-ivt',       'ABS + EBD'),
  ('stargazer-gen1-prime-ivt',       'ESC + Hill Start Assist'),
  ('stargazer-gen1-prime-ivt',       'Hyundai SmartSense ADAS'),
  ('stargazer-gen1-prime-ivt',       'FCA (Forward Collision-Avoidance)'),
  ('stargazer-gen1-prime-ivt',       'LKA (Lane Keeping Assist)'),
  ('stargazer-gen1-prime-ivt',       'Captain Seat Baris Kedua'),
  ('stargazer-gen1-prime-ivt',       'Tri-Zone Climate Control')
on conflict do nothing;

-- ─────────────────────────────────────────────────────────────────────────────
-- DONE.
--
-- Sanity check after running:
--   select count(*) from brands;                              -- expect: +4
--   select count(*) from models     where brand_id in
--     ('suzuki','daihatsu','mitsubishi','hyundai');           -- expect: 9
--   select count(*) from generations g
--     join models m on m.id=g.model_id
--     where m.brand_id in ('suzuki','daihatsu','mitsubishi','hyundai');
--   select count(*) from variants v
--     join generations g on g.id=v.generation_id
--     join models m on m.id=g.model_id
--     where m.brand_id in ('suzuki','daihatsu','mitsubishi','hyundai');
-- ─────────────────────────────────────────────────────────────────────────────
