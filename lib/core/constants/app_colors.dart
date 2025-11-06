import 'package:flutter/material.dart';

/// Color palette aligned with the Kohinchha design system.
class AppColors {
  AppColors._();

  // Primary
  static const Color indigoDeep = Color(0xFF1E1B4B);
  static const Color indigo900 = Color(0xFF312E81);
  static const Color indigo800 = Color(0xFF3730A3);
  static const Color indigo700 = Color(0xFF4338CA);
  static const Color indigo600 = Color(0xFF4F46E5);
  static const Color royalBlue = Color(0xFF2563EB);
  static const Color blue500 = Color(0xFF3B82F6);
  static const Color electricViolet = Color(0xFF7C3AED);
  static const Color violet600 = Color(0xFF7C3AED);
  static const Color violet500 = Color(0xFF8B5CF6);

  // Secondary
  static const Color softAqua = Color(0xFF67E8F9);
  static const Color aqua400 = Color(0xFF22D3EE);
  static const Color lightLilac = Color(0xFFE9D5FF);
  static const Color lilac200 = Color(0xFFDDD6FE);
  static const Color pearlWhite = Color(0xFFFAFAFA);
  static const Color pearl50 = Color(0xFFF8FAFC);

  // Semantic
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF06B6D4);

  // Neutral
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);

  // Gradients
  static const Gradient gradientPrimary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [indigo700, royalBlue, electricViolet],
  );

  static const Gradient gradientSecondary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [softAqua, violet500],
  );

  static const Gradient gradientSoft = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0x0D7C3AED),
      Color(0x0D2563EB),
    ],
  );

  static const Gradient gradientHeader = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [indigoDeep, indigo900, indigo700],
  );
}
