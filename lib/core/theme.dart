import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ثيم تطبيق «موجود» — هوية بصرية عربية بخط Cairo.
class AppTheme {
  // اللون الأساسي مستوحى من الأخضر الجامعي.
  static const Color primary = Color(0xFF00695C);
  static const Color secondary = Color(0xFF26A69A);
  static const Color lost = Color(0xFFD32F2F); // مفقود
  static const Color found = Color(0xFF2E7D32); // موجود

  static ThemeData light() {
    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: secondary,
      ),
      useMaterial3: true,
    );

    return base.copyWith(
      textTheme: GoogleFonts.cairoTextTheme(base.textTheme),
      scaffoldBackgroundColor: const Color(0xFFF7F8FA),
      appBarTheme: AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: GoogleFonts.cairo(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
