// packages/core/lib/theme/nvs_theme.dart
import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';
import 'nvs_colors.dart';

class NvsTheme {
  static ThemeData get theme {
    return ThemeData(
      scaffoldBackgroundColor: NVSColors.pureBlack,
      // Global default uses Magda for body; section titles override to Bell
      fontFamily: 'MagdaCleanMono',
      textTheme: _strictTextTheme(),
      colorScheme: const ColorScheme.dark(
        primary: NVSColors.primaryLightMint,
        secondary: NVSColors.primaryNeonMint,
        surface: NVSColors.pureBlack,
      ),
      // Enhanced button theme for better definition
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: NVSColors.primaryLightMint,
          foregroundColor: NVSColors.pureBlack,
          textStyle: const TextStyle(
            fontFamily: 'BellGothic',
            fontWeight: FontWeight.bold,
            letterSpacing: 1.4,
          ),
          elevation: 4,
          shadowColor: NVSColors.primaryLightMint.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: NVSColors.primaryGreenAccent, width: 1),
          ),
        ),
      ),

      // Enhanced app bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: NVSColors.pureBlack,
        elevation: 0,
        titleTextStyle: const TextStyle(
          fontFamily: 'BellGothic',
          fontWeight: FontWeight.w700,
          letterSpacing: 1.3,
          fontSize: 20,
          color: NVSColors.primaryLightMint,
        ),
        iconTheme: IconThemeData(
          color: NVSColors.primaryLightMint,
          shadows: [Shadow(color: NVSColors.primaryGreenAccent.withValues(alpha: 0.5), blurRadius: 2)],
        ),
      ),
      // Enforce lowercase for body by convention in widgets; provide helpers
    );
  }

  static TextTheme _strictTextTheme() {
    TextStyle caps(TextStyle base, {double ls = 1.2, FontWeight w = FontWeight.w700}) =>
        base.copyWith(fontFamily: 'BellGothic', letterSpacing: ls, fontWeight: w);
    const TextStyle bodyBase = TextStyle(fontFamily: 'MagdaCleanMono', letterSpacing: 0.2);
    return TextTheme(
      displayLarge: caps(const TextStyle()),
      displayMedium: caps(const TextStyle()),
      displaySmall: caps(const TextStyle()),
      headlineLarge: caps(const TextStyle()),
      headlineMedium: caps(const TextStyle()),
      headlineSmall: caps(const TextStyle()),
      titleLarge: caps(const TextStyle()),
      titleMedium: caps(const TextStyle()),
      titleSmall: caps(const TextStyle()),
      bodyLarge: bodyBase,
      bodyMedium: bodyBase,
      bodySmall: bodyBase.copyWith(letterSpacing: 0.1),
      labelLarge: caps(const TextStyle(), ls: 1.1, w: FontWeight.bold),
      labelMedium: caps(const TextStyle(), ls: 1.0),
      labelSmall: caps(const TextStyle(), ls: 0.8),
    );
  }
}
