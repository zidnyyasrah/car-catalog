import 'package:flutter/material.dart';

class BrandInfo {
  final String name;
  final String country;
  final int foundedYear;
  final Color primary;
  final Color secondary;
  final String tagline;
  final String logoUrl;

  const BrandInfo({
    required this.name,
    required this.country,
    required this.foundedYear,
    required this.primary,
    required this.secondary,
    required this.tagline,
    required this.logoUrl,
  });
}

const Map<String, BrandInfo> brandInfo = {
  'Toyota': BrandInfo(
    name: 'Toyota',
    country: 'Jepang',
    foundedYear: 1937,
    primary: Color(0xFFEB0A1E),
    secondary: Color(0xFF8B0010),
    tagline: 'Let\'s Go Places',
    logoUrl: 'https://logo.clearbit.com/toyota.com',
  ),
  'Honda': BrandInfo(
    name: 'Honda',
    country: 'Jepang',
    foundedYear: 1948,
    primary: Color(0xFFE40521),
    secondary: Color(0xFF8B0012),
    tagline: 'The Power of Dreams',
    logoUrl: 'https://logo.clearbit.com/honda.com',
  ),
  'Daihatsu': BrandInfo(
    name: 'Daihatsu',
    country: 'Jepang',
    foundedYear: 1907,
    primary: Color(0xFF005EB8),
    secondary: Color(0xFF003B71),
    tagline: 'Sahabatku Daihatsu',
    logoUrl: 'https://logo.clearbit.com/daihatsu.com',
  ),
  'Mitsubishi': BrandInfo(
    name: 'Mitsubishi',
    country: 'Jepang',
    foundedYear: 1917,
    primary: Color(0xFFE60012),
    secondary: Color(0xFF8B000B),
    tagline: 'Drive Your Ambition',
    logoUrl: 'https://logo.clearbit.com/mitsubishi-motors.com',
  ),
  'Suzuki': BrandInfo(
    name: 'Suzuki',
    country: 'Jepang',
    foundedYear: 1909,
    primary: Color(0xFFE60012),
    secondary: Color(0xFF003595),
    tagline: 'Way of Life!',
    logoUrl: 'https://logo.clearbit.com/globalsuzuki.com',
  ),
  'Hyundai': BrandInfo(
    name: 'Hyundai',
    country: 'Korea Selatan',
    foundedYear: 1967,
    primary: Color(0xFF002C5F),
    secondary: Color(0xFF00AAD2),
    tagline: 'New Thinking. New Possibilities.',
    logoUrl: 'https://logo.clearbit.com/hyundai.com',
  ),
  'Kia': BrandInfo(
    name: 'Kia',
    country: 'Korea Selatan',
    foundedYear: 1944,
    primary: Color(0xFFBB162B),
    secondary: Color(0xFF05141F),
    tagline: 'Movement that inspires',
    logoUrl: 'https://logo.clearbit.com/kia.com',
  ),
  'Wuling': BrandInfo(
    name: 'Wuling',
    country: 'Tiongkok',
    foundedYear: 2002,
    primary: Color(0xFFC8102E),
    secondary: Color(0xFF5C0A1A),
    tagline: 'Drive for a Better Life',
    logoUrl: 'https://logo.clearbit.com/wuling.id',
  ),
};

BrandInfo brandInfoFor(String name) =>
    brandInfo[name] ??
    const BrandInfo(
      name: 'Unknown',
      country: '-',
      foundedYear: 0,
      primary: Color(0xFF666666),
      secondary: Color(0xFF333333),
      tagline: '',
      logoUrl: '',
    );
