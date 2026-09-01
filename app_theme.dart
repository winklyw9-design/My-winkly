import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Central colors + text styles for Winkly.
/// Warm, friendly palette — orange accent (matches the wireframe's
/// orange "NEW" tags), soft neutrals for cards and backgrounds.
class AppColors {
  static const bg = Color(0xFFF7F5F2);
  static const card = Color(0xFFFFFFFF);
  static const border = Color(0xFFE7E2DA);
  static const accent = Color(0xFFE8763C); // orange accent
  static const accentSoft = Color(0xFFFCE9DD);
  static const text = Color(0xFF2A2622);
  static const muted = Color(0xFF8A8378);
  static const lock = Color(0xFFB08C4F);
}

class AppTheme {
  static ThemeData get light {
    final base = ThemeData.light();
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.accent,
        surface: AppColors.card,
      ),
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
        bodyColor: AppColors.text,
        displayColor: AppColors.text,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bg,
        elevation: 0,
        foregroundColor: AppColors.text,
        centerTitle: false,
      ),
      dividerColor: AppColors.border,
    );
  }

  static TextStyle heading({double size = 20}) => GoogleFonts.inter(
        fontWeight: FontWeight.w700,
        fontSize: size,
        color: AppColors.text,
      );

  static TextStyle muted({double size = 12}) => GoogleFonts.inter(
        fontSize: size,
        color: AppColors.muted,
      );
}
