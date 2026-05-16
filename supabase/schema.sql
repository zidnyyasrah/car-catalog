-- ─────────────────────────────────────────────────────────────────────────────
-- CarCat schema — generation-aware
--
-- Hierarchy: brand → model → generation → variant
--   brand        : Toyota
--   model        : Fortuner
--   generation   : Gen 1 (2005-2008), Gen 1 Facelift 1 (2008-2011), ...
--   variant      : '2.7 V VVT-i A/T 4x2' with engine/price/specs
--
-- Run this BEFORE seed.sql. It drops all existing data.
-- ─────────────────────────────────────────────────────────────────────────────

-- Drop old tables (CASCADE removes dependent rows / FKs)
drop table if exists car_features cascade;
drop table if exists car_colors   cascade;
drop table if exists cars         cascade;

drop table if exists variant_features cascade;
drop table if exists variant_colors   cascade;
drop table if exists variants         cascade;
drop table if exists generations      cascade;
drop table if exists models           cascade;
drop table if exists brands           cascade;

-- ── brands ───────────────────────────────────────────────────────────────────
create table brands (
  id      text primary key,            -- 'toyota'
  name    text not null unique,        -- 'Toyota'
  country text
);

-- ── models ───────────────────────────────────────────────────────────────────
-- The long-lived nameplate (Fortuner, Civic). Spans decades.
create table models (
  id             text primary key,                                   -- 'toyota-fortuner'
  brand_id       text not null references brands(id) on delete cascade,
  name           text not null,                                      -- 'Fortuner'
  body_type      text,                                               -- broad body type when stable across gens
  description    text,
  hero_image_url text,
  unique (brand_id, name)
);

create index models_brand_idx on models (brand_id);

-- ── generations ──────────────────────────────────────────────────────────────
-- A distinct design era / facelift. year_end NULL = still in production.
create table generations (
  id             text primary key,                                   -- 'toyota-fortuner-gen1'
  model_id       text not null references models(id) on delete cascade,
  name           text not null,                                      -- 'Gen 1', 'Gen 1 Facelift 1', 'Gen 2'
  chassis_code   text,                                               -- 'AN50/AN60', 'FD', 'FL5'
  year_start     int  not null,
  year_end       int,                                                -- NULL if still produced
  description    text,
  hero_image_url text,
  check (year_end is null or year_end >= year_start)
);

create index generations_model_idx on generations (model_id);
create index generations_years_idx on generations (year_start, year_end);

-- ── variants ─────────────────────────────────────────────────────────────────
-- A trim level within a generation. Holds all specs and price.
-- year_start/year_end is the variant's own availability window (subset of generation).
create table variants (
  id                        text primary key,                       -- 'toyota-fortuner-gen1-27g-at-2007'
  generation_id             text not null references generations(id) on delete cascade,
  trim_name                 text not null,                          -- '2.7 G Lux A/T'
  year_start                int  not null,
  year_end                  int,

  engine_type               text,                                   -- '2TR-FE 2.7L DOHC VVT-i'
  engine_displacement_cc    int,
  power_hp                  int,
  torque_nm                 int,
  transmission              text,                                   -- 'M/T' | 'A/T' | 'CVT' | '6MT'
  drive_system              text,                                   -- '4x2 RWD' | '4x4' | 'FWD'
  is_electric               boolean not null default false,
  fuel_consumption_km_per_l numeric,
  seating_capacity          int,
  ground_clearance_mm       int,
  dimensions                text,                                   -- 'L x W x H' in mm
  safety_rating             int,
  price_min_million_idr     numeric,
  price_max_million_idr     numeric,
  image_url                 text,
  description               text,
  check (year_end is null or year_end >= year_start)
);

create index variants_generation_idx on variants (generation_id);
create index variants_years_idx      on variants (year_start, year_end);

-- ── variant_colors / variant_features (M:N) ──────────────────────────────────
create table variant_colors (
  variant_id text not null references variants(id) on delete cascade,
  color      text not null,
  primary key (variant_id, color)
);

create table variant_features (
  variant_id text not null references variants(id) on delete cascade,
  feature    text not null,
  primary key (variant_id, feature)
);

-- ─────────────────────────────────────────────────────────────────────────────
-- Convenience view: flat denormalized rows (drop-in replacement for old `cars`).
-- Useful for filter screens until the Dart side migrates fully.
-- ─────────────────────────────────────────────────────────────────────────────
create or replace view cars_flat as
select
  v.id                                             as id,
  b.name                                           as brand,
  m.name                                           as type,             -- 'Fortuner'
  g.name                                           as generation,       -- 'Gen 1 Facelift 2'
  v.trim_name                                      as variant,
  v.year_start                                     as year_start,
  v.year_end                                       as year_end,
  g.year_start                                     as generation_year_start,
  g.year_end                                       as generation_year_end,
  m.body_type                                      as body_type,
  v.engine_type,
  v.engine_displacement_cc,
  v.power_hp,
  v.torque_nm,
  v.transmission,
  v.drive_system,
  v.is_electric,
  v.fuel_consumption_km_per_l                      as fuel_consumption,
  v.seating_capacity,
  v.ground_clearance_mm,
  v.dimensions,
  v.safety_rating,
  v.price_min_million_idr                          as price_min,
  v.price_max_million_idr                          as price_max,
  v.image_url,
  coalesce(v.description, g.description, m.description) as description
from variants v
join generations g on g.id = v.generation_id
join models      m on m.id = g.model_id
join brands      b on b.id = m.brand_id;
