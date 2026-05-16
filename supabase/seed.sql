-- ─────────────────────────────────────────────────────────────────────────────
-- CarCat seed — Toyota Fortuner + Honda Civic (Indonesia market)
--
-- Coverage:
--   Toyota Fortuner
--     Gen 1   pre-facelift   (AN50/AN60)  2005-2008
--     Gen 1   facelift 1     (AN50/AN60)  2008-2011
--     Gen 1   facelift 2     (AN50/AN60)  2011-2015
--     Gen 2                  (AN150/AN160) 2015-2020
--     Gen 2   facelift       (AN150/AN160) 2020-present
--
--   Honda Civic
--     Gen 7   (ES)   2001-2005   (sold in ID as "Civic VTi-S")
--     Gen 8   (FD)   2006-2011
--     Gen 9   (FB)   2012-2015
--     Gen 10  (FC sedan / FK hatch)  2016-2021
--     Gen 11  (FE/FL)  2022-present
--
-- Prices are approximate launch-period IDR (millions).
-- Run AFTER schema.sql.
-- ─────────────────────────────────────────────────────────────────────────────

-- Clean slate (harmless if already empty)
truncate variant_features, variant_colors, variants, generations, models, brands restart identity cascade;

-- ═════════════════════════════════════════════════════════════════════════════
-- BRANDS
-- ═════════════════════════════════════════════════════════════════════════════
insert into brands (id, name, country) values
  ('toyota', 'Toyota', 'Jepang'),
  ('honda',  'Honda',  'Jepang');

-- ═════════════════════════════════════════════════════════════════════════════
-- MODELS
-- ═════════════════════════════════════════════════════════════════════════════
insert into models (id, brand_id, name, body_type, description, hero_image_url) values
  ('toyota-fortuner', 'toyota', 'Fortuner', 'SUV',
   'SUV ladder-frame berbasis Hilux. Tangguh untuk medan berat namun nyaman sebagai kendaraan keluarga premium. Salah satu SUV terlaris di Indonesia sejak 2005.',
   'https://picsum.photos/seed/fortuner-hero/1200/600'),

  ('honda-civic', 'honda', 'Civic', 'Sedan',
   'Sedan kompak ikonik Honda. Sejak generasi awal 1972, Civic dikenal akan handling sporty, efisiensi, dan kualitas build. Di Indonesia, hadir dalam bentuk sedan dan hatchback.',
   'https://picsum.photos/seed/civic-hero/1200/600');

-- ═════════════════════════════════════════════════════════════════════════════
-- TOYOTA FORTUNER — GENERATIONS
-- ═════════════════════════════════════════════════════════════════════════════
insert into generations (id, model_id, name, chassis_code, year_start, year_end, description, hero_image_url) values
  ('toyota-fortuner-gen1-pre', 'toyota-fortuner', 'Gen 1 (Pre-Facelift)', 'AN50/AN60', 2005, 2008,
   'Generasi pertama Fortuner di Indonesia, diluncurkan 2005. Desain kotak-kotak khas SUV ladder-frame, berbagi platform dengan Hilux Vigo. Tersedia mesin 2.7L bensin dan 2.5L/3.0L diesel.',
   'https://picsum.photos/seed/fortuner-gen1-pre/1200/600'),

  ('toyota-fortuner-gen1-fl1', 'toyota-fortuner', 'Gen 1 Facelift 1', 'AN50/AN60', 2008, 2011,
   'Facelift pertama dengan grille baru, headlamp lebih tajam, dan interior dual-tone. Varian TRD Sportivo diperkenalkan dengan body kit dan velg dual-tone.',
   'https://picsum.photos/seed/fortuner-gen1-fl1/1200/600'),

  ('toyota-fortuner-gen1-fl2', 'toyota-fortuner', 'Gen 1 Facelift 2', 'AN50/AN60', 2011, 2015,
   'Facelift kedua dengan grille chrome horizontal, headlamp projector, dan teknologi VNT pada diesel 2.5L. TRD Sportivo VNT menjadi varian populer.',
   'https://picsum.photos/seed/fortuner-gen1-fl2/1200/600'),

  ('toyota-fortuner-gen2-pre', 'toyota-fortuner', 'Gen 2 (Pre-Facelift)', 'AN150/AN160', 2015, 2020,
   'Generasi kedua diluncurkan akhir 2015 di Indonesia. Desain lebih agresif dengan LED DRL, mesin 2.4L diesel 2GD-FTV baru (148 hp / 400 Nm) dan 2.7L bensin 2TR-FE. Varian VRZ menjadi flagship.',
   'https://picsum.photos/seed/fortuner-gen2-pre/1200/600'),

  ('toyota-fortuner-gen2-fl', 'toyota-fortuner', 'Gen 2 Facelift', 'AN150/AN160', 2020, null,
   'Facelift 2020 dengan grille baru full-width, headlamp LED bi-beam, dan mesin baru 2.8L 1GD-FTV (201 hp / 500 Nm) untuk varian atas. GR Sport diperkenalkan 2021 dengan suspensi monotube dan body kit khusus.',
   'https://picsum.photos/seed/fortuner-gen2-fl/1200/600');

-- ═════════════════════════════════════════════════════════════════════════════
-- TOYOTA FORTUNER — VARIANTS
-- ═════════════════════════════════════════════════════════════════════════════

-- ── Gen 1 Pre-Facelift (2005-2008) ─────────────────────────────────────────
insert into variants (id, generation_id, trim_name, year_start, year_end,
  engine_type, engine_displacement_cc, power_hp, torque_nm,
  transmission, drive_system, fuel_consumption_km_per_l, seating_capacity,
  ground_clearance_mm, dimensions, safety_rating,
  price_min_million_idr, price_max_million_idr, image_url, description) values

  ('fortuner-gen1pre-27g-mt', 'toyota-fortuner-gen1-pre', '2.7 G Lux M/T', 2005, 2008,
   '2TR-FE 2.7L DOHC VVT-i', 2694, 158, 241,
   'M/T', '4x2 RWD', 9.5, 7, 220, '4695 x 1840 x 1850', 3,
   240, 260, 'https://picsum.photos/seed/fort-gen1pre-27g-mt/600/380',
   'Varian bensin manual generasi pertama. Mesin 2TR-FE 2.7L bertenaga 158 hp.'),

  ('fortuner-gen1pre-27g-at', 'toyota-fortuner-gen1-pre', '2.7 G Lux A/T', 2005, 2008,
   '2TR-FE 2.7L DOHC VVT-i', 2694, 158, 241,
   'A/T 4-speed', '4x2 RWD', 9.0, 7, 220, '4695 x 1840 x 1850', 3,
   260, 280, 'https://picsum.photos/seed/fort-gen1pre-27g-at/600/380',
   'Versi otomatis 4-speed dari 2.7 G Lux. Populer untuk pemakaian kota.'),

  ('fortuner-gen1pre-25g-diesel-mt', 'toyota-fortuner-gen1-pre', '2.5 G Diesel M/T', 2005, 2008,
   '2KD-FTV 2.5L Common Rail Turbo Diesel', 2494, 102, 260,
   'M/T', '4x2 RWD', 11.0, 7, 220, '4695 x 1840 x 1850', 3,
   270, 290, 'https://picsum.photos/seed/fort-gen1pre-25d-mt/600/380',
   'Varian diesel 2.5L common-rail. Ekonomis dan torsi besar untuk medan berat.');

-- ── Gen 1 Facelift 1 (2008-2011) ───────────────────────────────────────────
insert into variants (id, generation_id, trim_name, year_start, year_end,
  engine_type, engine_displacement_cc, power_hp, torque_nm,
  transmission, drive_system, fuel_consumption_km_per_l, seating_capacity,
  ground_clearance_mm, dimensions, safety_rating,
  price_min_million_idr, price_max_million_idr, image_url, description) values

  ('fortuner-gen1fl1-27g-at', 'toyota-fortuner-gen1-fl1', '2.7 G Lux A/T', 2008, 2011,
   '2TR-FE 2.7L DOHC VVT-i', 2694, 158, 241,
   'A/T 4-speed', '4x2 RWD', 9.2, 7, 220, '4695 x 1840 x 1850', 3,
   295, 315, 'https://picsum.photos/seed/fort-gen1fl1-27g-at/600/380',
   'Versi facelift dengan grille baru dan interior dual-tone.'),

  ('fortuner-gen1fl1-25g-diesel-at', 'toyota-fortuner-gen1-fl1', '2.5 G Diesel A/T', 2008, 2011,
   '2KD-FTV 2.5L Common Rail Turbo Diesel', 2494, 102, 260,
   'A/T 4-speed', '4x2 RWD', 11.5, 7, 220, '4695 x 1840 x 1850', 3,
   310, 330, 'https://picsum.photos/seed/fort-gen1fl1-25d-at/600/380',
   'Diesel 2.5L versi otomatis. Best-seller di periode ini.'),

  ('fortuner-gen1fl1-25-trd-sportivo', 'toyota-fortuner-gen1-fl1', '2.5 G TRD Sportivo Diesel A/T', 2009, 2011,
   '2KD-FTV 2.5L Common Rail Turbo Diesel', 2494, 102, 260,
   'A/T 4-speed', '4x2 RWD', 11.0, 7, 220, '4695 x 1840 x 1850', 3,
   340, 360, 'https://picsum.photos/seed/fort-gen1fl1-trd/600/380',
   'Edisi TRD Sportivo dengan body kit, velg dual-tone, dan emblem TRD.');

-- ── Gen 1 Facelift 2 (2011-2015) ───────────────────────────────────────────
insert into variants (id, generation_id, trim_name, year_start, year_end,
  engine_type, engine_displacement_cc, power_hp, torque_nm,
  transmission, drive_system, fuel_consumption_km_per_l, seating_capacity,
  ground_clearance_mm, dimensions, safety_rating,
  price_min_million_idr, price_max_million_idr, image_url, description) values

  ('fortuner-gen1fl2-27v-at', 'toyota-fortuner-gen1-fl2', '2.7 V A/T', 2011, 2015,
   '2TR-FE 2.7L DOHC VVT-i', 2694, 158, 241,
   'A/T 4-speed', '4x2 RWD', 9.5, 7, 220, '4705 x 1840 x 1850', 3,
   345, 365, 'https://picsum.photos/seed/fort-gen1fl2-27v/600/380',
   'Trim V bensin. Grille chrome baru, headlamp projector.'),

  ('fortuner-gen1fl2-25g-vnt-mt', 'toyota-fortuner-gen1-fl2', '2.5 G VNT M/T', 2012, 2015,
   '2KD-FTV 2.5L D-4D VNT Turbo Diesel', 2494, 144, 343,
   'M/T', '4x2 RWD', 12.0, 7, 220, '4705 x 1840 x 1850', 3,
   360, 380, 'https://picsum.photos/seed/fort-gen1fl2-25vnt-mt/600/380',
   'Mesin diesel dengan teknologi Variable Nozzle Turbo (VNT). Torsi 343 Nm.'),

  ('fortuner-gen1fl2-25g-vnt-at', 'toyota-fortuner-gen1-fl2', '2.5 G VNT A/T', 2012, 2015,
   '2KD-FTV 2.5L D-4D VNT Turbo Diesel', 2494, 144, 343,
   'A/T 4-speed', '4x2 RWD', 11.5, 7, 220, '4705 x 1840 x 1850', 3,
   385, 405, 'https://picsum.photos/seed/fort-gen1fl2-25vnt-at/600/380',
   'Versi otomatis dari 2.5 G VNT. Varian terlaris di periode 2012-2015.'),

  ('fortuner-gen1fl2-25-trd-vnt', 'toyota-fortuner-gen1-fl2', '2.5 TRD Sportivo VNT A/T', 2013, 2015,
   '2KD-FTV 2.5L D-4D VNT Turbo Diesel', 2494, 144, 343,
   'A/T 4-speed', '4x2 RWD', 11.0, 7, 220, '4705 x 1840 x 1850', 3,
   410, 435, 'https://picsum.photos/seed/fort-gen1fl2-trd/600/380',
   'TRD Sportivo dengan VNT diesel. Body kit, sunroof opsional, jok kulit.');

-- ── Gen 2 (2015-2020) ──────────────────────────────────────────────────────
insert into variants (id, generation_id, trim_name, year_start, year_end,
  engine_type, engine_displacement_cc, power_hp, torque_nm,
  transmission, drive_system, fuel_consumption_km_per_l, seating_capacity,
  ground_clearance_mm, dimensions, safety_rating,
  price_min_million_idr, price_max_million_idr, image_url, description) values

  ('fortuner-gen2pre-24g-mt', 'toyota-fortuner-gen2-pre', '2.4 G Diesel M/T', 2016, 2020,
   '2GD-FTV 2.4L D-4D Common Rail Turbo Diesel', 2393, 148, 400,
   'M/T 6-speed', '4x2 RWD', 13.0, 7, 225, '4795 x 1855 x 1835', 4,
   460, 480, 'https://picsum.photos/seed/fort-gen2pre-24g-mt/600/380',
   'Trim entry generasi kedua. Mesin 2GD-FTV baru 2.4L dengan torsi 400 Nm.'),

  ('fortuner-gen2pre-24g-at', 'toyota-fortuner-gen2-pre', '2.4 G Diesel A/T', 2016, 2020,
   '2GD-FTV 2.4L D-4D Common Rail Turbo Diesel', 2393, 148, 400,
   'A/T 6-speed', '4x2 RWD', 12.5, 7, 225, '4795 x 1855 x 1835', 4,
   485, 505, 'https://picsum.photos/seed/fort-gen2pre-24g-at/600/380',
   'G diesel otomatis 6-speed. Lebih halus dan ekonomis dibanding gen sebelumnya.'),

  ('fortuner-gen2pre-24vrz-at', 'toyota-fortuner-gen2-pre', '2.4 VRZ Diesel A/T', 2016, 2020,
   '2GD-FTV 2.4L D-4D Common Rail Turbo Diesel', 2393, 148, 400,
   'A/T 6-speed', '4x2 RWD', 12.5, 7, 225, '4795 x 1855 x 1835', 4,
   525, 555, 'https://picsum.photos/seed/fort-gen2pre-24vrz/600/380',
   'Flagship pre-facelift. LED headlamp, head-up display, push start, jok kulit perforasi.'),

  ('fortuner-gen2pre-27srz-at', 'toyota-fortuner-gen2-pre', '2.7 SRZ Petrol A/T', 2016, 2020,
   '2TR-FE 2.7L Dual VVT-i', 2694, 163, 245,
   'A/T 6-speed', '4x2 RWD', 9.5, 7, 225, '4795 x 1855 x 1835', 4,
   500, 525, 'https://picsum.photos/seed/fort-gen2pre-27srz/600/380',
   'Varian bensin dengan trim setara VRZ. Lebih responsif tapi konsumsi BBM lebih tinggi.');

-- ── Gen 2 Facelift (2020-present) ──────────────────────────────────────────
insert into variants (id, generation_id, trim_name, year_start, year_end,
  engine_type, engine_displacement_cc, power_hp, torque_nm,
  transmission, drive_system, fuel_consumption_km_per_l, seating_capacity,
  ground_clearance_mm, dimensions, safety_rating,
  price_min_million_idr, price_max_million_idr, image_url, description) values

  ('fortuner-gen2fl-24g-mt', 'toyota-fortuner-gen2-fl', '2.4 G Diesel M/T', 2020, null,
   '2GD-FTV 2.4L D-4D Common Rail Turbo Diesel', 2393, 148, 400,
   'M/T 6-speed', '4x2 RWD', 13.5, 7, 225, '4795 x 1855 x 1835', 5,
   542, 560, 'https://picsum.photos/seed/fort-gen2fl-24g-mt/600/380',
   'Trim entry facelift 2020. Grille baru full-width, headlamp LED bi-beam.'),

  ('fortuner-gen2fl-24g-at', 'toyota-fortuner-gen2-fl', '2.4 G Diesel A/T', 2020, null,
   '2GD-FTV 2.4L D-4D Common Rail Turbo Diesel', 2393, 148, 400,
   'A/T 6-speed', '4x2 RWD', 13.0, 7, 225, '4795 x 1855 x 1835', 5,
   569, 590, 'https://picsum.photos/seed/fort-gen2fl-24g-at/600/380',
   'G diesel otomatis facelift. Volume seller.'),

  ('fortuner-gen2fl-24v-at', 'toyota-fortuner-gen2-fl', '2.4 V Diesel A/T', 2020, null,
   '2GD-FTV 2.4L D-4D Common Rail Turbo Diesel', 2393, 148, 400,
   'A/T 6-speed', '4x2 RWD', 13.0, 7, 225, '4795 x 1855 x 1835', 5,
   608, 635, 'https://picsum.photos/seed/fort-gen2fl-24v/600/380',
   'Trim menengah dengan LED, kamera 360 (opsional), Toyota Safety Sense partial.'),

  ('fortuner-gen2fl-28vrz-at', 'toyota-fortuner-gen2-fl', '2.8 VRZ Diesel A/T', 2020, null,
   '1GD-FTV 2.8L D-4D Common Rail Turbo Diesel', 2755, 201, 500,
   'A/T 6-speed', '4x2 RWD', 12.0, 7, 225, '4795 x 1855 x 1835', 5,
   667, 700, 'https://picsum.photos/seed/fort-gen2fl-28vrz/600/380',
   'Flagship facelift dengan mesin baru 2.8L 1GD-FTV: 201 hp dan 500 Nm. Lebih bertenaga dari sebelumnya.'),

  ('fortuner-gen2fl-28grs-4x4', 'toyota-fortuner-gen2-fl', '2.8 GR Sport 4x4 A/T', 2021, null,
   '1GD-FTV 2.8L D-4D Common Rail Turbo Diesel', 2755, 201, 500,
   'A/T 6-speed', '4x4', 11.5, 7, 225, '4795 x 1855 x 1835', 5,
   730, 770, 'https://picsum.photos/seed/fort-gen2fl-grs/600/380',
   'Top-of-the-line. Suspensi monotube khusus GR, body kit GR Sport, jok kulit-suede, sistem 4x4 dengan locking diff.');

-- ═════════════════════════════════════════════════════════════════════════════
-- HONDA CIVIC — GENERATIONS
-- ═════════════════════════════════════════════════════════════════════════════
insert into generations (id, model_id, name, chassis_code, year_start, year_end, description, hero_image_url) values
  ('honda-civic-gen7', 'honda-civic', 'Gen 7 (ES)', 'ES', 2001, 2005,
   'Generasi ketujuh dengan desain bulat khas era awal 2000-an. Di Indonesia hadir dengan mesin 1.7L D17A. Lantai datar khas Honda generasi ini.',
   'https://picsum.photos/seed/civic-gen7/1200/600'),

  ('honda-civic-gen8', 'honda-civic', 'Gen 8 (FD)', 'FD', 2006, 2011,
   'Generasi kedelapan dengan desain "monoform" futuristik dan dasbor dua tingkat (digital atas, analog bawah). Mesin 1.8L R18A dan 2.0L K20A. Salah satu Civic paling populer di Indonesia.',
   'https://picsum.photos/seed/civic-gen8/1200/600'),

  ('honda-civic-gen9', 'honda-civic', 'Gen 9 (FB)', 'FB', 2012, 2015,
   'Generasi kesembilan dengan refinement dari FD. Desain lebih kalem, kualitas interior turun menurut review, namun handling tetap sporty.',
   'https://picsum.photos/seed/civic-gen9/1200/600'),

  ('honda-civic-gen10', 'honda-civic', 'Gen 10 (FC/FK)', 'FC/FK', 2016, 2021,
   'Generasi kesepuluh, desain dramatis dengan grille "flying-wing". Memperkenalkan mesin 1.5L VTEC Turbo. Hadir sebagai sedan (FC) dan hatchback (FK). Type R FK8 menjadi legenda.',
   'https://picsum.photos/seed/civic-gen10/1200/600'),

  ('honda-civic-gen11', 'honda-civic', 'Gen 11 (FE/FL)', 'FE/FL', 2022, null,
   'Generasi kesebelas dengan desain lebih bersih dan dewasa. Di Indonesia hadir sebagai hatchback RS 1.5 Turbo (FL1) dan Type R FL5. Interior minimalis dengan honeycomb grille pada AC.',
   'https://picsum.photos/seed/civic-gen11/1200/600');

-- ═════════════════════════════════════════════════════════════════════════════
-- HONDA CIVIC — VARIANTS
-- ═════════════════════════════════════════════════════════════════════════════

-- ── Gen 7 ES (2001-2005) ───────────────────────────────────────────────────
insert into variants (id, generation_id, trim_name, year_start, year_end,
  engine_type, engine_displacement_cc, power_hp, torque_nm,
  transmission, drive_system, fuel_consumption_km_per_l, seating_capacity,
  ground_clearance_mm, dimensions, safety_rating,
  price_min_million_idr, price_max_million_idr, image_url, description) values

  ('civic-gen7-17vtis-mt', 'honda-civic-gen7', '1.7 VTi-S M/T', 2001, 2005,
   'D17A 1.7L SOHC VTEC', 1668, 127, 152,
   'M/T 5-speed', 'FWD', 12.0, 5, 150, '4455 x 1730 x 1430', 3,
   175, 195, 'https://picsum.photos/seed/civic-gen7-mt/600/380',
   'Civic ES manual. Mesin 1.7L D17A VTEC, handling khas Honda generasi awal 2000-an.'),

  ('civic-gen7-17vtis-at', 'honda-civic-gen7', '1.7 VTi-S A/T', 2001, 2005,
   'D17A 1.7L SOHC VTEC', 1668, 127, 152,
   'A/T 4-speed', 'FWD', 11.0, 5, 150, '4455 x 1730 x 1430', 3,
   190, 210, 'https://picsum.photos/seed/civic-gen7-at/600/380',
   'Versi matic 4-speed. Volume seller untuk kalangan profesional muda saat itu.');

-- ── Gen 8 FD (2006-2011) ───────────────────────────────────────────────────
insert into variants (id, generation_id, trim_name, year_start, year_end,
  engine_type, engine_displacement_cc, power_hp, torque_nm,
  transmission, drive_system, fuel_consumption_km_per_l, seating_capacity,
  ground_clearance_mm, dimensions, safety_rating,
  price_min_million_idr, price_max_million_idr, image_url, description) values

  ('civic-gen8-18ivtec-mt', 'honda-civic-gen8', '1.8 i-VTEC M/T', 2006, 2011,
   'R18A1 1.8L SOHC i-VTEC', 1799, 140, 174,
   'M/T 5-speed', 'FWD', 13.0, 5, 150, '4540 x 1755 x 1450', 4,
   280, 310, 'https://picsum.photos/seed/civic-gen8-18mt/600/380',
   'FD1 manual. Dashboard digital atas khas Civic generasi ini.'),

  ('civic-gen8-18ivtec-at', 'honda-civic-gen8', '1.8 i-VTEC A/T', 2006, 2011,
   'R18A1 1.8L SOHC i-VTEC', 1799, 140, 174,
   'A/T 5-speed', 'FWD', 12.0, 5, 150, '4540 x 1755 x 1450', 4,
   305, 335, 'https://picsum.photos/seed/civic-gen8-18at/600/380',
   'FD1 matic 5-speed. Best-seller pada periodenya.'),

  ('civic-gen8-20ivtec-at', 'honda-civic-gen8', '2.0 i-VTEC A/T', 2006, 2011,
   'K20Z2 2.0L DOHC i-VTEC', 1998, 155, 188,
   'A/T 5-speed', 'FWD', 11.0, 5, 150, '4540 x 1755 x 1450', 4,
   355, 380, 'https://picsum.photos/seed/civic-gen8-20at/600/380',
   'FD2. Mesin K20 lebih bertenaga, paddle shift, jok kulit. Varian premium FD.');

-- ── Gen 9 FB (2012-2015) ───────────────────────────────────────────────────
insert into variants (id, generation_id, trim_name, year_start, year_end,
  engine_type, engine_displacement_cc, power_hp, torque_nm,
  transmission, drive_system, fuel_consumption_km_per_l, seating_capacity,
  ground_clearance_mm, dimensions, safety_rating,
  price_min_million_idr, price_max_million_idr, image_url, description) values

  ('civic-gen9-18ivtec-at', 'honda-civic-gen9', '1.8 i-VTEC A/T', 2012, 2015,
   'R18Z1 1.8L SOHC i-VTEC', 1799, 140, 174,
   'A/T 5-speed', 'FWD', 13.5, 5, 150, '4550 x 1755 x 1435', 4,
   400, 430, 'https://picsum.photos/seed/civic-gen9-18at/600/380',
   'FB sedan 1.8 matic. Eco Assist green/blue indicator memandu efisiensi.'),

  ('civic-gen9-20ivtec-at', 'honda-civic-gen9', '2.0 i-VTEC A/T', 2012, 2015,
   'R20A 2.0L SOHC i-VTEC', 1997, 155, 190,
   'A/T 5-speed', 'FWD', 12.0, 5, 150, '4550 x 1755 x 1435', 4,
   440, 470, 'https://picsum.photos/seed/civic-gen9-20at/600/380',
   'Varian premium 2.0. Smart Entry, paddle shifter, jok kulit.');

-- ── Gen 10 FC/FK (2016-2021) ───────────────────────────────────────────────
insert into variants (id, generation_id, trim_name, year_start, year_end,
  engine_type, engine_displacement_cc, power_hp, torque_nm,
  transmission, drive_system, fuel_consumption_km_per_l, seating_capacity,
  ground_clearance_mm, dimensions, safety_rating,
  price_min_million_idr, price_max_million_idr, image_url, description) values

  ('civic-gen10-15turbo-sedan-cvt', 'honda-civic-gen10', '1.5 Turbo Sedan CVT', 2016, 2021,
   'L15B7 1.5L DOHC VTEC Turbo', 1498, 173, 220,
   'CVT', 'FWD', 14.5, 5, 138, '4630 x 1799 x 1416', 5,
   485, 520, 'https://picsum.photos/seed/civic-gen10-sedan/600/380',
   'Civic Turbo Sedan FC. Memperkenalkan mesin 1.5 VTEC Turbo (173 hp) ke nameplate Civic.'),

  ('civic-gen10-15turbo-hatch-rs', 'honda-civic-gen10', '1.5 Hatchback RS Turbo CVT', 2017, 2021,
   'L15B7 1.5L DOHC VTEC Turbo', 1498, 173, 220,
   'CVT', 'FWD', 14.0, 5, 130, '4517 x 1799 x 1416', 5,
   515, 555, 'https://picsum.photos/seed/civic-gen10-hatch/600/380',
   'Civic Hatchback RS Turbo FK. Body kit RS, knalpot center-exit, paddle shifter.'),

  ('civic-gen10-20-typer-fk8', 'honda-civic-gen10', 'Type R FK8 2.0 Turbo 6MT', 2017, 2021,
   'K20C1 2.0L DOHC i-VTEC Turbo', 1996, 310, 400,
   'M/T 6-speed', 'FWD with Helical LSD', 11.0, 4, 125, '4557 x 1877 x 1434', 5,
   995, 1100, 'https://picsum.photos/seed/civic-gen10-typer/600/380',
   'Type R FK8. Hot hatch FWD legendaris, rekor Nürburgring saat peluncuran. Suspensi adaptif, brake Brembo.');

-- ── Gen 11 FE/FL (2022-present) ────────────────────────────────────────────
insert into variants (id, generation_id, trim_name, year_start, year_end,
  engine_type, engine_displacement_cc, power_hp, torque_nm,
  transmission, drive_system, fuel_consumption_km_per_l, seating_capacity,
  ground_clearance_mm, dimensions, safety_rating,
  price_min_million_idr, price_max_million_idr, image_url, description) values

  ('civic-gen11-15rs-hatch-cvt', 'honda-civic-gen11', '1.5 RS Hatchback Turbo CVT', 2022, null,
   'L15CA 1.5L DOHC VTEC Turbo', 1498, 177, 240,
   'CVT', 'FWD', 14.5, 5, 133, '4548 x 1802 x 1408', 5,
   615, 645, 'https://picsum.photos/seed/civic-gen11-rs/600/380',
   'Civic FL1 RS Hatchback. Desain lebih kalem dan dewasa, Honda Sensing standar.'),

  ('civic-gen11-20-typer-fl5', 'honda-civic-gen11', 'Type R FL5 2.0 Turbo 6MT', 2023, null,
   'K20C1 2.0L DOHC i-VTEC Turbo', 1996, 319, 420,
   'M/T 6-speed', 'FWD with Helical LSD', 11.0, 4, 130, '4595 x 1890 x 1407', 5,
   1300, 1450, 'https://picsum.photos/seed/civic-gen11-typer/600/380',
   'Type R FL5. Penerus FK8. Rekor Nürburgring FWD baru. Desain lebih clean tanpa scoop berlebihan.');

-- ═════════════════════════════════════════════════════════════════════════════
-- VARIANT COLORS
-- ═════════════════════════════════════════════════════════════════════════════
insert into variant_colors (variant_id, color)
select v.id, c.color
from variants v
cross join (values
  ('Putih'), ('Hitam'), ('Silver'), ('Abu-abu')
) as c(color);

-- Brand/era-specific extra colors
insert into variant_colors (variant_id, color) values
  -- Fortuner — beige & dark blue on many trims
  ('fortuner-gen1pre-27g-mt',        'Champagne'),
  ('fortuner-gen1pre-27g-at',        'Champagne'),
  ('fortuner-gen1pre-25g-diesel-mt', 'Champagne'),
  ('fortuner-gen1fl1-27g-at',        'Cokelat'),
  ('fortuner-gen1fl1-25g-diesel-at', 'Cokelat'),
  ('fortuner-gen1fl1-25-trd-sportivo', 'Merah'),
  ('fortuner-gen1fl2-27v-at',        'Cokelat Metalik'),
  ('fortuner-gen1fl2-25g-vnt-mt',    'Cokelat Metalik'),
  ('fortuner-gen1fl2-25g-vnt-at',    'Cokelat Metalik'),
  ('fortuner-gen1fl2-25-trd-vnt',    'Merah'),
  ('fortuner-gen2pre-24g-mt',        'Bronze'),
  ('fortuner-gen2pre-24g-at',        'Bronze'),
  ('fortuner-gen2pre-24vrz-at',      'Bronze'),
  ('fortuner-gen2pre-27srz-at',      'Merah'),
  ('fortuner-gen2fl-24g-mt',         'Bronze'),
  ('fortuner-gen2fl-24g-at',         'Bronze'),
  ('fortuner-gen2fl-24v-at',         'Bronze'),
  ('fortuner-gen2fl-28vrz-at',       'Phantom Brown'),
  ('fortuner-gen2fl-28grs-4x4',      'Merah'),
  ('fortuner-gen2fl-28grs-4x4',      'Attitude Black'),
  -- Civic — bold colors on sporty trims
  ('civic-gen8-18ivtec-mt',          'Merah'),
  ('civic-gen8-18ivtec-at',          'Merah'),
  ('civic-gen8-20ivtec-at',          'Merah'),
  ('civic-gen9-18ivtec-at',          'Biru'),
  ('civic-gen9-20ivtec-at',          'Biru'),
  ('civic-gen10-15turbo-sedan-cvt',  'Merah'),
  ('civic-gen10-15turbo-hatch-rs',   'Merah'),
  ('civic-gen10-15turbo-hatch-rs',   'Kuning Phoenix'),
  ('civic-gen10-20-typer-fk8',       'Championship White'),
  ('civic-gen10-20-typer-fk8',       'Rallye Red'),
  ('civic-gen10-20-typer-fk8',       'Sonic Gray'),
  ('civic-gen11-15rs-hatch-cvt',     'Merah'),
  ('civic-gen11-15rs-hatch-cvt',     'Sonic Gray'),
  ('civic-gen11-20-typer-fl5',       'Championship White'),
  ('civic-gen11-20-typer-fl5',       'Rallye Red'),
  ('civic-gen11-20-typer-fl5',       'Sonic Gray');

-- ═════════════════════════════════════════════════════════════════════════════
-- VARIANT FEATURES
-- ═════════════════════════════════════════════════════════════════════════════

-- Universal-ish basics
insert into variant_features (variant_id, feature)
select v.id, f.feature
from variants v
cross join (values
  ('AC'), ('Power Steering'), ('Power Window'), ('Central Lock')
) as f(feature);

-- Era / trim specific
insert into variant_features (variant_id, feature) values
  -- ── Fortuner Gen 1 (basic safety, no airbags initially on lower trims) ──
  ('fortuner-gen1pre-27g-mt',        'Dual Airbag'),
  ('fortuner-gen1pre-27g-at',        'Dual Airbag'),
  ('fortuner-gen1pre-27g-at',        'ABS + EBD'),
  ('fortuner-gen1pre-25g-diesel-mt', 'Dual Airbag'),
  ('fortuner-gen1fl1-27g-at',        'Dual Airbag'),
  ('fortuner-gen1fl1-27g-at',        'ABS + EBD'),
  ('fortuner-gen1fl1-27g-at',        'Audio CD/DVD'),
  ('fortuner-gen1fl1-25g-diesel-at', 'Dual Airbag'),
  ('fortuner-gen1fl1-25g-diesel-at', 'ABS + EBD'),
  ('fortuner-gen1fl1-25-trd-sportivo','TRD Body Kit'),
  ('fortuner-gen1fl1-25-trd-sportivo','Velg Dual-tone'),
  ('fortuner-gen1fl1-25-trd-sportivo','Jok Kulit'),
  ('fortuner-gen1fl2-27v-at',        'Dual Airbag'),
  ('fortuner-gen1fl2-27v-at',        'ABS + EBD'),
  ('fortuner-gen1fl2-27v-at',        'Head Unit Touchscreen'),
  ('fortuner-gen1fl2-25g-vnt-mt',    'Dual Airbag'),
  ('fortuner-gen1fl2-25g-vnt-mt',    'VNT Diesel'),
  ('fortuner-gen1fl2-25g-vnt-at',    'Dual Airbag'),
  ('fortuner-gen1fl2-25g-vnt-at',    'VNT Diesel'),
  ('fortuner-gen1fl2-25g-vnt-at',    'Head Unit Touchscreen'),
  ('fortuner-gen1fl2-25-trd-vnt',    'TRD Body Kit'),
  ('fortuner-gen1fl2-25-trd-vnt',    'VNT Diesel'),
  ('fortuner-gen1fl2-25-trd-vnt',    'Jok Kulit'),
  ('fortuner-gen1fl2-25-trd-vnt',    'Sunroof'),
  -- ── Fortuner Gen 2 Pre-Facelift ──
  ('fortuner-gen2pre-24g-mt',        'Dual Airbag'),
  ('fortuner-gen2pre-24g-mt',        'ABS + EBD + BA'),
  ('fortuner-gen2pre-24g-mt',        'Hill Start Assist'),
  ('fortuner-gen2pre-24g-at',        'Dual Airbag'),
  ('fortuner-gen2pre-24g-at',        'ABS + EBD + BA'),
  ('fortuner-gen2pre-24g-at',        'Hill Start Assist'),
  ('fortuner-gen2pre-24g-at',        'Vehicle Stability Control'),
  ('fortuner-gen2pre-24vrz-at',      '7 Airbag'),
  ('fortuner-gen2pre-24vrz-at',      'LED Headlamp'),
  ('fortuner-gen2pre-24vrz-at',      'Push Start + Keyless'),
  ('fortuner-gen2pre-24vrz-at',      'Head-Up Display'),
  ('fortuner-gen2pre-24vrz-at',      'Jok Kulit Perforasi'),
  ('fortuner-gen2pre-24vrz-at',      'Power Tailgate'),
  ('fortuner-gen2pre-27srz-at',      '7 Airbag'),
  ('fortuner-gen2pre-27srz-at',      'LED Headlamp'),
  ('fortuner-gen2pre-27srz-at',      'Push Start + Keyless'),
  -- ── Fortuner Gen 2 Facelift ──
  ('fortuner-gen2fl-24g-mt',         '3 Airbag'),
  ('fortuner-gen2fl-24g-mt',         'ABS + EBD + BA'),
  ('fortuner-gen2fl-24g-mt',         'Hill Start Assist'),
  ('fortuner-gen2fl-24g-mt',         'LED Headlamp Bi-Beam'),
  ('fortuner-gen2fl-24g-at',         '3 Airbag'),
  ('fortuner-gen2fl-24g-at',         'Vehicle Stability Control'),
  ('fortuner-gen2fl-24g-at',         'LED Headlamp Bi-Beam'),
  ('fortuner-gen2fl-24v-at',         '7 Airbag'),
  ('fortuner-gen2fl-24v-at',         'Push Start + Keyless'),
  ('fortuner-gen2fl-24v-at',         '360° Camera'),
  ('fortuner-gen2fl-24v-at',         'Power Tailgate'),
  ('fortuner-gen2fl-28vrz-at',       '7 Airbag'),
  ('fortuner-gen2fl-28vrz-at',       'Toyota Safety Sense'),
  ('fortuner-gen2fl-28vrz-at',       'Push Start + Keyless'),
  ('fortuner-gen2fl-28vrz-at',       '360° Camera'),
  ('fortuner-gen2fl-28vrz-at',       'Head-Up Display'),
  ('fortuner-gen2fl-28vrz-at',       'Jok Kulit Perforasi Ventilated'),
  ('fortuner-gen2fl-28vrz-at',       'Apple CarPlay / Android Auto'),
  ('fortuner-gen2fl-28grs-4x4',      '7 Airbag'),
  ('fortuner-gen2fl-28grs-4x4',      'Toyota Safety Sense'),
  ('fortuner-gen2fl-28grs-4x4',      '4x4 with Locking Diff'),
  ('fortuner-gen2fl-28grs-4x4',      'Monotube Damper GR'),
  ('fortuner-gen2fl-28grs-4x4',      'Jok Kulit-Suede GR'),
  ('fortuner-gen2fl-28grs-4x4',      'Body Kit GR Sport'),
  ('fortuner-gen2fl-28grs-4x4',      '360° Camera'),
  ('fortuner-gen2fl-28grs-4x4',      'Apple CarPlay / Android Auto'),
  -- ── Civic Gen 7 ──
  ('civic-gen7-17vtis-mt',           'Dual Airbag'),
  ('civic-gen7-17vtis-at',           'Dual Airbag'),
  ('civic-gen7-17vtis-at',           'ABS'),
  -- ── Civic Gen 8 (FD) ──
  ('civic-gen8-18ivtec-mt',          'Dual Airbag'),
  ('civic-gen8-18ivtec-mt',          'ABS + EBD'),
  ('civic-gen8-18ivtec-at',          'Dual Airbag'),
  ('civic-gen8-18ivtec-at',          'ABS + EBD'),
  ('civic-gen8-18ivtec-at',          'Smart Entry'),
  ('civic-gen8-20ivtec-at',          'Dual Airbag'),
  ('civic-gen8-20ivtec-at',          'ABS + EBD'),
  ('civic-gen8-20ivtec-at',          'Smart Entry'),
  ('civic-gen8-20ivtec-at',          'Paddle Shifter'),
  ('civic-gen8-20ivtec-at',          'Jok Kulit'),
  ('civic-gen8-20ivtec-at',          'Cruise Control'),
  -- ── Civic Gen 9 (FB) ──
  ('civic-gen9-18ivtec-at',          'Dual Airbag'),
  ('civic-gen9-18ivtec-at',          'ABS + EBD'),
  ('civic-gen9-18ivtec-at',          'Eco Assist'),
  ('civic-gen9-18ivtec-at',          'Smart Entry'),
  ('civic-gen9-20ivtec-at',          'Dual Airbag'),
  ('civic-gen9-20ivtec-at',          'ABS + EBD'),
  ('civic-gen9-20ivtec-at',          'Paddle Shifter'),
  ('civic-gen9-20ivtec-at',          'Jok Kulit'),
  ('civic-gen9-20ivtec-at',          'Cruise Control'),
  -- ── Civic Gen 10 (FC/FK) ──
  ('civic-gen10-15turbo-sedan-cvt',  '6 Airbag'),
  ('civic-gen10-15turbo-sedan-cvt',  'Honda LaneWatch'),
  ('civic-gen10-15turbo-sedan-cvt',  'Push Start + Keyless'),
  ('civic-gen10-15turbo-sedan-cvt',  'LED Headlamp'),
  ('civic-gen10-15turbo-sedan-cvt',  'Cruise Control'),
  ('civic-gen10-15turbo-sedan-cvt',  'Jok Kulit'),
  ('civic-gen10-15turbo-hatch-rs',   '6 Airbag'),
  ('civic-gen10-15turbo-hatch-rs',   'Honda LaneWatch'),
  ('civic-gen10-15turbo-hatch-rs',   'Push Start + Keyless'),
  ('civic-gen10-15turbo-hatch-rs',   'LED Headlamp'),
  ('civic-gen10-15turbo-hatch-rs',   'Paddle Shifter'),
  ('civic-gen10-15turbo-hatch-rs',   'Body Kit RS'),
  ('civic-gen10-15turbo-hatch-rs',   'Center-Exit Exhaust'),
  ('civic-gen10-20-typer-fk8',       'Brembo Brakes'),
  ('civic-gen10-20-typer-fk8',       'Helical LSD'),
  ('civic-gen10-20-typer-fk8',       'Adaptive Dampers'),
  ('civic-gen10-20-typer-fk8',       'Rev Match Control'),
  ('civic-gen10-20-typer-fk8',       'Recaro Bucket Seats'),
  ('civic-gen10-20-typer-fk8',       'Triple Exhaust'),
  ('civic-gen10-20-typer-fk8',       'LED Headlamp'),
  ('civic-gen10-20-typer-fk8',       '+R Mode'),
  -- ── Civic Gen 11 (FE/FL) ──
  ('civic-gen11-15rs-hatch-cvt',     'Honda Sensing'),
  ('civic-gen11-15rs-hatch-cvt',     '6 Airbag'),
  ('civic-gen11-15rs-hatch-cvt',     'Adaptive Cruise Control'),
  ('civic-gen11-15rs-hatch-cvt',     'Lane Keep Assist'),
  ('civic-gen11-15rs-hatch-cvt',     'Push Start + Keyless'),
  ('civic-gen11-15rs-hatch-cvt',     'LED Headlamp'),
  ('civic-gen11-15rs-hatch-cvt',     'Wireless Charger'),
  ('civic-gen11-15rs-hatch-cvt',     'Apple CarPlay / Android Auto'),
  ('civic-gen11-20-typer-fl5',       'Brembo Brakes'),
  ('civic-gen11-20-typer-fl5',       'Helical LSD'),
  ('civic-gen11-20-typer-fl5',       'Adaptive Dampers'),
  ('civic-gen11-20-typer-fl5',       'Rev Match Control'),
  ('civic-gen11-20-typer-fl5',       'Recaro-style Bucket Seats'),
  ('civic-gen11-20-typer-fl5',       'Triple Exhaust'),
  ('civic-gen11-20-typer-fl5',       'LogR Datalogger'),
  ('civic-gen11-20-typer-fl5',       '+R Mode'),
  ('civic-gen11-20-typer-fl5',       'Honda Sensing');

-- ═════════════════════════════════════════════════════════════════════════════
-- Quick sanity check
-- ═════════════════════════════════════════════════════════════════════════════
-- select b.name, m.name, g.name, g.year_start, g.year_end, count(v.id) as variants
-- from brands b
-- join models m       on m.brand_id  = b.id
-- join generations g  on g.model_id  = m.id
-- left join variants v on v.generation_id = g.id
-- group by b.name, m.name, g.name, g.year_start, g.year_end
-- order by b.name, m.name, g.year_start;
