// packages/core/lib/theme/nvs_text_styles.dart
import 'package:flutter/material.dart';
import 'nvs_colors.dart';

class NvsTextStyles {
  // Font family constants - match pubspec.yaml declarations
  static const String primaryFont = 'BellGothic';
  static const String secondaryFont = 'MagdaCleanMono';

  // Base text styles
  static const TextStyle display = TextStyle(
    fontFamily: primaryFont,
    color: NVSColors.ultraLightMint,
    fontWeight: FontWeight.bold,
    fontSize: 48,
  );

  static const TextStyle heading = TextStyle(
    fontFamily: primaryFont,
    color: NVSColors.ultraLightMint,
    fontWeight: FontWeight.w600,
    fontSize: 24,
  );

  static const TextStyle body = TextStyle(
    fontFamily: secondaryFont,
    color: NVSColors.ultraLightMint,
    fontSize: 16,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: secondaryFont,
    color: NVSColors.softGray,
    fontSize: 12,
  );

  static const TextStyle button = TextStyle(
    fontFamily: primaryFont,
    color: NVSColors.ultraLightMint,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  static const TextStyle cardTitle = TextStyle(
    fontFamily: primaryFont,
    color: NVSColors.ultraLightMint,
    fontWeight: FontWeight.w600,
    fontSize: 14,
  );

  static const TextStyle label = TextStyle(
    fontFamily: primaryFont,
    color: NVSColors.ultraLightMint,
    fontWeight: FontWeight.w500,
    fontSize: 12,
  );
}
