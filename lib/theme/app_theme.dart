// packages/core/lib/theme/app_theme.dart
// Quantum App Theme for NVS Architecture

import 'package:flutter/material.dart';
import 'nvs_colors.dart';

class AppTheme {
  // Backwards-compatible color getters used throughout the app codebase
  static const Color backgroundColor = NVSColors.pureBlack;
  static const Color primaryColor = NVSColors.ultraLightMint;
  static const Color primaryTextColor = NVSColors.ultraLightMint;
  static const Color secondaryTextColor = NVSColors.secondaryText;
  static const Color surfaceColor = NVSColors.cardBackground;
  static const Color neonBorderColor = NVSColors.ultraLightMint;
  static const Color tertiaryTextColor = Colors.white54;
  static const Color accentColor = NVSColors.primaryGreenAccent;
  static const Color borderColor = NVSColors.primaryGreenAccent;
  static const Color cardColor = NVSColors.cardBackground;
  static const Color secondaryColor = NVSColors.primaryLimeGreen;
  static const LinearGradient primaryGradient = LinearGradient(
    colors: <Color>[
      NVSColors.primaryLightMint,
      NVSColors.primaryGreenAccent,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: NVSColors.pureBlack,
      primaryColor: NVSColors.ultraLightMint,
      colorScheme: const ColorScheme.dark(
        primary: NVSColors.ultraLightMint,
        secondary: NVSColors.avocadoGreen,
        surface: NVSColors.cardBackground,
        onSurface: NVSColors.white,
        onPrimary: NVSColors.pureBlack,
      ),
      fontFamily: 'MagdaCleanMono',
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: NVSColors.ultraLightMint,
          fontWeight: FontWeight.bold,
          fontSize: 32,
        ),
        bodyLarge: TextStyle(color: NVSColors.white, fontSize: 16),
        bodyMedium: TextStyle(color: NVSColors.secondaryText, fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: NVSColors.ultraLightMint,
          foregroundColor: NVSColors.pureBlack,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
