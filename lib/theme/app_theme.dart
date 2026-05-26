import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Deep teal foundation — the dark surfaces in the reference design.
  static const Color background = Color(0xFF0E2225);
  static const Color surface = Color(0xFF173034);
  static const Color surfaceElevated = Color(0xFF1F3D42);
  static const Color border = Color(0xFF254A50);
  static const Color hairline = Color(0xFF1B3539);

  // Warm cream — the "light card on dark" surface from the reference.
  static const Color cream = Color(0xFFF4EFE5);
  static const Color creamMuted = Color(0xFFE6DFCF);
  static const Color onCream = Color(0xFF0E2225);

  // Bright lime accent — primary action / highlight.
  static const Color accent = Color(0xFFCDE74A);
  static const Color accentSoft = Color(0xFFDDEE82);
  // Text/icon color to sit on top of the lime accent.
  static const Color onAccent = Color(0xFF0E2225);

  // Warm off-white & muted teal-greys for editorial typography.
  static const Color textPrimary = Color(0xFFF1ECDF);
  static const Color textSecondary = Color(0xFF9DB2AF);
  static const Color textMuted = Color(0xFF60777B);

  // Soft lavender + champagne as secondary accents (electric kept as the
  // existing constant name so the EV chip etc. keep compiling).
  static const Color electric = Color(0xFFC8B8E0);
  static const Color gold = Color(0xFFE6D2A7);

  // Pillowy corner radii — the soft-card language of the reference.
  static const double radiusCard = 24;
  static const double radiusPill = 28;
  static const double radiusLg = 18;

  static const double sx = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 40;
  static const double xxxl = 64;

  static const Duration motionFast = Duration(milliseconds: 180);
  static const Duration motion = Duration(milliseconds: 240);
  static const Duration motionSlow = Duration(milliseconds: 380);

  static TextStyle eyebrow({Color color = textMuted}) => GoogleFonts.inter(
        color: color,
        fontSize: 10.5,
        fontWeight: FontWeight.w700,
        letterSpacing: 2.4,
        height: 1,
      );

  static TextStyle display({Color color = textPrimary, double size = 40}) =>
      GoogleFonts.inter(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.w900,
        letterSpacing: -1.4,
        height: 1.02,
      );

  static TextStyle numeral({Color color = textPrimary, double size = 44}) =>
      GoogleFonts.inter(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.w900,
        letterSpacing: -2,
        height: 1,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      colorScheme: const ColorScheme.dark(
        primary: accent,
        secondary: electric,
        surface: surface,
        onPrimary: onAccent,
        onSurface: textPrimary,
      ),
      scaffoldBackgroundColor: background,
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.inter(
          color: textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: GoogleFonts.inter(color: textMuted, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: accent, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: accent,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}
