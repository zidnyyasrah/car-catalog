import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color background = Color(0xFF0A0A0F);
  static const Color surface = Color(0xFF14141F);
  static const Color surfaceElevated = Color(0xFF1C1C2A);
  static const Color border = Color(0xFF24243A);
  static const Color hairline = Color(0xFF1F1F2C);
  static const Color accent = Color(0xFFFF3D5A);
  static const Color accentSoft = Color(0xFFFF7A8C);
  static const Color textPrimary = Color(0xFFF5F5F7);
  static const Color textSecondary = Color(0xFF9090A8);
  static const Color textMuted = Color(0xFF5E5E78);
  static const Color electric = Color(0xFF00E5B0);
  static const Color gold = Color(0xFFFFC857);

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
        onPrimary: Colors.white,
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
