import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final base = ThemeData.light();
    final textTheme = TextTheme(
      displayLarge: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        fontSize: 40,
        color: AppColors.gray900,
      ),
      displayMedium: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        fontSize: 32,
        color: AppColors.gray900,
      ),
      displaySmall: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        fontSize: 28,
        color: AppColors.gray900,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        fontSize: 24,
        color: AppColors.gray900,
      ),
      headlineSmall: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        fontSize: 20,
        color: AppColors.gray900,
      ),
      titleLarge: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        fontSize: 18,
        color: AppColors.gray900,
      ),
      titleMedium: GoogleFonts.inter(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: AppColors.gray800,
      ),
      titleSmall: GoogleFonts.inter(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: AppColors.gray700,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.gray700,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.gray600,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.gray500,
      ),
      labelLarge: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: Colors.white,
      ),
      labelMedium: GoogleFonts.inter(
        fontWeight: FontWeight.w600,
        fontSize: 12,
        color: Colors.white,
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.pearlWhite,
      textTheme: textTheme,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.indigo700,
        primary: AppColors.indigo700,
        secondary: AppColors.violet500,
        background: AppColors.pearlWhite,
        surface: Colors.white,
        error: AppColors.error,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.indigoDeep),
        titleTextStyle: textTheme.titleLarge,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.gray200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.indigo600, width: 2),
        ),
        labelStyle: textTheme.bodyMedium,
        hintStyle: textTheme.bodySmall,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.indigo700,
          foregroundColor: Colors.white,
          textStyle: textTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.indigo600, width: 1.4),
          textStyle: textTheme.labelLarge?.copyWith(color: AppColors.indigo700),
          foregroundColor: AppColors.indigo700,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        labelStyle: textTheme.bodySmall?.copyWith(color: AppColors.gray700),
        backgroundColor: AppColors.gray100,
      ),
    );
  }
}
