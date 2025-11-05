import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Branded gradient palette surfaced through [ThemeExtension].
class AppGradients extends ThemeExtension<AppGradients> {
  const AppGradients({
    required this.hero,
    required this.surface,
    required this.button,
  });

  final Gradient hero;
  final Gradient surface;
  final Gradient button;

  @override
  ThemeExtension<AppGradients> copyWith({
    Gradient? hero,
    Gradient? surface,
    Gradient? button,
  }) {
    return AppGradients(
      hero: hero ?? this.hero,
      surface: surface ?? this.surface,
      button: button ?? this.button,
    );
  }

  @override
  ThemeExtension<AppGradients> lerp(covariant ThemeExtension<AppGradients>? other, double t) {
    if (other is! AppGradients) return this;
    return AppGradients(
      hero: LinearGradient.lerp(hero as LinearGradient?, other.hero as LinearGradient?, t) ?? hero,
      surface:
          LinearGradient.lerp(surface as LinearGradient?, other.surface as LinearGradient?, t) ??
              surface,
      button:
          LinearGradient.lerp(button as LinearGradient?, other.button as LinearGradient?, t) ??
              button,
    );
  }
}

const _primaryColor = Color(0xFF4154F9);
const _secondaryColor = Color(0xFFEC4899);
const _tertiaryColor = Color(0xFF06B6D4);
const _surfaceColor = Color(0xFFF8FAFF);
const _surfaceVariant = Color(0xFFE4E9FF);
const _neutral900 = Color(0xFF1E1B4B);
const _neutral600 = Color(0xFF475569);

final _baseTextTheme = GoogleFonts.interTextTheme().copyWith(
  displayLarge: GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
  ),
  displayMedium: GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
    letterSpacing: -0.4,
  ),
  headlineLarge: GoogleFonts.poppins(fontWeight: FontWeight.w600),
  titleLarge: GoogleFonts.inter(fontWeight: FontWeight.w600),
  bodyLarge: GoogleFonts.inter(fontWeight: FontWeight.w400),
  bodyMedium: GoogleFonts.inter(fontWeight: FontWeight.w400),
  labelLarge: GoogleFonts.inter(fontWeight: FontWeight.w600, letterSpacing: 0.4),
);

/// Centralised theme configuration using Material 3 design language.
final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: _primaryColor,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFDBE2FF),
    onPrimaryContainer: _neutral900,
    secondary: _secondaryColor,
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFFFD1E8),
    onSecondaryContainer: _neutral900,
    tertiary: _tertiaryColor,
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFCCFBF1),
    onTertiaryContainer: _neutral900,
    error: Color(0xFFD92D20),
    onError: Colors.white,
    errorContainer: Color(0xFFFEE4E2),
    onErrorContainer: Color(0xFF7A271A),
    background: _surfaceColor,
    onBackground: _neutral900,
    surface: _surfaceColor,
    onSurface: _neutral900,
    surfaceVariant: _surfaceVariant,
    onSurfaceVariant: _neutral600,
    outline: Color(0xFFCBD5F5),
    shadow: Color(0x33212B64),
    inverseSurface: _neutral900,
    onInverseSurface: Colors.white,
    inversePrimary: Color(0xFF9DB1FF),
    scrim: Color(0x661D1F33),
  ),
  scaffoldBackgroundColor: _surfaceColor,
  textTheme: _baseTextTheme,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  typography: Typography.material2021(platform: TargetPlatform.android),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    centerTitle: false,
    backgroundColor: Colors.transparent,
    foregroundColor: _neutral900,
    titleTextStyle: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 20,
      letterSpacing: -0.2,
      color: _neutral900,
    ),
  ),
  cardTheme: CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    clipBehavior: Clip.antiAlias,
    margin: EdgeInsets.zero,
    color: Colors.white.withOpacity(0.88),
    shadowColor: const Color(0x331A237E),
    surfaceTintColor: Colors.transparent,
  ),
  chipTheme: ChipThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
    backgroundColor: const Color(0xFFE0E7FF),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
    fillColor: Colors.white,
    filled: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: _primaryColor,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
  ),
  dialogTheme: DialogThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
    backgroundColor: Colors.white.withOpacity(0.96),
    elevation: 16,
  ),
  dividerTheme: const DividerThemeData(space: 32, thickness: 1),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
    },
  ),
  extensions: const [
    AppGradients(
      hero: LinearGradient(
        colors: [Color(0xFF4154F9), Color(0xFF8B5CF6), Color(0xFFFF6584)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      surface: LinearGradient(
        colors: [Color(0x99FFFFFF), Color(0x66F1F5FF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      button: LinearGradient(
        colors: [Color(0xFF4154F9), Color(0xFF06B6D4)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
    ),
  ],
);
