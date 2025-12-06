// Legacy Colors Compatibility Layer
// This file provides backward compatibility for old NVSColors references
// while transitioning to the new QuantumDesignTokens system.

import 'package:flutter/material.dart';
import 'quantum_design_tokens.dart';

/// Deprecated: Use QuantumDesignTokens instead
/// This class provides backward compatibility for legacy code
@deprecated
class NVSColors {
  // Primary colors mapped to quantum design tokens
  static Color get black => QuantumDesignTokens.pureBlack;
  static Color get white => QuantumDesignTokens.white;
  static Color get charcoalBlack => QuantumDesignTokens.charcoalBlack;

  // Neon colors
  static Color get neonBlue => QuantumDesignTokens.cyanCore;
  static Color get neonGreen => QuantumDesignTokens.mint;
  static Color get neonPink => QuantumDesignTokens.fuschia;
  static Color get neonPulse => QuantumDesignTokens.neonPulse;

  // Grays
  static Color get darkGray => QuantumDesignTokens.charcoalBlack;
  static Color get mediumGray => QuantumDesignTokens.softGray;
  static Color get lightGray => QuantumDesignTokens.softGray;
  static Color get softGray => QuantumDesignTokens.softGray;

  // Special colors
  static Color get primary => QuantumDesignTokens.cyanCore;
  static Color get secondary => QuantumDesignTokens.mint;
  static Color get accent => QuantumDesignTokens.fuschia;
  static Color get background => QuantumDesignTokens.pureBlack;
  static Color get surface => QuantumDesignTokens.charcoalBlack;

  // Status colors
  static Color get success => QuantumDesignTokens.mint;
  static Color get warning => const Color(0xFFFFAA00);
  static Color get error => const Color(0xFFFF4444);
  static Color get info => QuantumDesignTokens.cyanCore;

  // Additional compatibility colors
  static Color get transparent => Colors.transparent;
  static Color get semiTransparent => Colors.black54;

  // Legacy gradient colors
  static LinearGradient get primaryGradient => LinearGradient(
        colors: <Color>[QuantumDesignTokens.cyanCore, QuantumDesignTokens.mint],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get backgroundGradient => const LinearGradient(
        colors: <Color>[QuantumDesignTokens.pureBlack, QuantumDesignTokens.charcoalBlack],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
}

/// Deprecated: Use QuantumDesignTokens instead
@deprecated
class AppTheme {
  static Color get primary => QuantumDesignTokens.cyanCore;
  static Color get secondary => QuantumDesignTokens.mint;
  static Color get background => QuantumDesignTokens.pureBlack;
  static Color get surface => QuantumDesignTokens.charcoalBlack;
  static Color get onPrimary => QuantumDesignTokens.white;
  static Color get onSecondary => QuantumDesignTokens.pureBlack;
  static Color get onBackground => QuantumDesignTokens.white;
  static Color get onSurface => QuantumDesignTokens.white;

  // Text colors
  static Color get textPrimary => QuantumDesignTokens.white;
  static Color get textSecondary => QuantumDesignTokens.softGray;
  static Color get textAccent => QuantumDesignTokens.cyanCore;

  // Border colors
  static Color get borderPrimary => QuantumDesignTokens.cyanCore;
  static Color get borderSecondary => QuantumDesignTokens.softGray;
}
