import 'package:flutter/material.dart';
import 'package:nvs/theme/nvs_palette.dart';

const String _primaryFontFamily = 'BellGothic';
const String _secondaryFontFamily = 'MagdaCleanMono';

/// Canonical text styles used across the experience. All styles are derived
/// from the NV Studio font families and [NVSPalette] so color and typography
/// remain consistent even without the legacy AppTheme helpers.
class NvsTextStyles {
  const NvsTextStyles._();

  static TextStyle get display => const TextStyle(
    fontFamily: _primaryFontFamily,
    fontWeight: FontWeight.w900,
    fontSize: 32,
    letterSpacing: 1.2,
    color: NVSPalette.textPrimary,
  );

  static TextStyle get heading => const TextStyle(
    fontFamily: _primaryFontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 24,
    letterSpacing: 1.1,
    color: NVSPalette.textPrimary,
  );

  static TextStyle get body => const TextStyle(
    fontFamily: _secondaryFontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.4,
    letterSpacing: 0.4,
    color: NVSPalette.textSecondary,
  );

  static TextStyle get label => const TextStyle(
    fontFamily: _secondaryFontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 12,
    letterSpacing: 1.0,
    color: NVSPalette.secondary,
  );

  static TextStyle get caption => const TextStyle(
    fontFamily: _secondaryFontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 11,
    letterSpacing: 0.8,
    color: NVSPalette.secondary,
  );

  static TextStyle get button => const TextStyle(
    fontFamily: _primaryFontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 14,
    letterSpacing: 1.2,
    color: NVSPalette.textPrimary,
  );
}

/// Legacy uppercase alias for gradual migration.
class NVSTextStyles {
  const NVSTextStyles._();

  static TextStyle get display => NvsTextStyles.display;
  static TextStyle get heading => NvsTextStyles.heading;
  static TextStyle get body => NvsTextStyles.body;
  static TextStyle get label => NvsTextStyles.label;
  static TextStyle get caption => NvsTextStyles.caption;
  static TextStyle get button => NvsTextStyles.button;
}
