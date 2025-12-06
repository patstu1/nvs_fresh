// packages/core/lib/theme/nvs_colors.dart
// Core NVS Colors - Quantum Cyberpunk Palette

import 'package:flutter/material.dart';

// Strict NVS palette constants (updated)
const Color nvsMint = Color(0xFF95FFF2); // Secondary: #95fff2
const Color nvsCyan = Color(0xFF95FFF2); // Secondary: #95fff2
const Color nvsPrimary = Color(0xFFE3F2DE); // Primary: #E3F2DE
const Color nvsOlive = Color(0xFF4D5D53); // Secondary: #4D5D53
const Color nvsBlack = Color(0xFF000000);

class NVSColors {
  // Allowed Brand Colors (updated)
  static const Color primaryLightMint = Color(0xFFE3F2DE); // Primary: #E3F2DE
  static const Color primaryGreenAccent = Color(0xFF95FFF2); // Secondary: #95fff2
  static const Color primaryNeonMint = Color(0xFF95FFF2); // Secondary: #95fff2
  static const Color primaryLimeGreen = Color(0xFF4D5D53); // Secondary: #4D5D53

  // Backward-compat aliases mapped to allowed palette
  static const Color ultraLightMint = primaryLightMint; // Use brand primary #e4fff0
  static const Color neonMint = primaryLightMint; // Ensure primary mint everywhere
  static const Color turquoiseNeon = primaryGreenAccent;
  static const Color avocadoGreen = primaryLimeGreen;
  static const Color neonLime = primaryLimeGreen;
  static const Color aquaOutline = primaryLightMint; // Outlines use brand primary
  static const Color primaryGlow = primaryLightMint; // Glows use brand primary
  static const Color neonGreen = primaryGreenAccent;
  static const Color neonBlue = primaryGreenAccent;
  static const Color neonYellow = primaryLightMint;
  static const Color neonPink = electricPink;
  static const Color glitchPink = electricPink;
  static const Color hologramBlue = primaryGreenAccent;
  static const Color plasmaGreen = primaryLimeGreen;
  static const Color neonOrange = primaryLightMint;
  static const Color matteBlack = pureBlack;
  static const Color ultraLightNeonMint = primaryLightMint;
  static const Color oliveGreenNeon = primaryLimeGreen;
  static const Color scannerGlow = primaryLightMint;
  static const Color background = pureBlack;
  static const Color errorColor = Color(0xFFFF4444);

  // Background Colors
  static const Color pureBlack = Color(0xFF000000);
  static const Color voidBlack = Color(0xFF000000);
  static const Color charcoalBlack = Color(0xFF000000);
  static const Color cardBackground = Colors.transparent; // No charcoal boxes

  // Accent Colors
  static const Color neonPulse = primaryNeonMint;
  static const Color white = Color(0xFFFFFFFF); // Neon White
  static const Color softGray = primaryLightMint; // mapped to allowed
  static const Color darkGray = pureBlack; // mapped to allowed
  // Common dark container background used by legacy widgets
  static const Color darkBackground = pureBlack;

  // Extended Colors for Legacy Compatibility
  // Allowed neon accents
  static const Color electricPink = Color(0xFFFF41D6); // light neon pink
  static const Color neonPurple = Color(0xFF9B5DE5); // light neon purple
  static const Color secondaryText = primaryGreenAccent; // mapped to allowed
  static const Color dividerColor = primaryGreenAccent; // mapped to allowed

  // Status Colors
  static const Color success = Color(0xFF00FF88);
  static const Color warning = electricPink; // avoid yellow
  static const Color error = Color(0xFFFF4444);
  static const Color info = Color(0xFF00AAFF);

  // Glow Effects
  static const List<BoxShadow> mintGlow = [
    BoxShadow(color: ultraLightMint, blurRadius: 8, spreadRadius: 2),
  ];

  // Text Shadows
  static const List<Shadow> mintTextShadow = [Shadow(color: ultraLightMint, blurRadius: 4)];
}

/// Legacy alias for older code paths that still reference `NvsColors`.
/// Maps every legacy field onto the approved palette.
class NvsColors {
  static const Color mint = NVSColors.primaryGreenAccent;
  static final Color mintSoft = NVSColors.primaryGreenAccent.withValues(alpha: 0.6);
  static const Color bg = NVSColors.pureBlack;
  static final Color panel = NVSColors.pureBlack.withValues(alpha: 0.85);
  static final Color panelHi = NVSColors.pureBlack.withValues(alpha: 0.92);
  static final Color textDim = NVSColors.primaryLightMint.withValues(alpha: 0.65);
  static const Color cyan = NVSColors.primaryGreenAccent;
  static const Color magenta = NVSColors.primaryLightMint;
}
