import 'package:flutter/material.dart';

// =============================================================================
// NVS GLOBAL COLOR PALETTE
// =============================================================================
// ONLY 2 COLORS:
// - Background: #000000 (matte black)
// - Primary: #E4FFF0 (mint)
// NO FILLS - only outline glows
// =============================================================================

// Global constants
const Color kNvsMint = Color(0xFFE4FFF0);
const Color kNvsBg = Color(0xFF000000);

// Font Family Constants
class NVSFonts {
  static const String primary = 'BellGothic';
  static const String secondary = 'MagdaCleanMono';
}

class NVSColors {
  // ===========================================
  // THE ONLY 2 COLORS IN THE APP
  // ===========================================
  static const Color mint = Color(0xFFE4FFF0);      // Primary mint - #E4FFF0
  static const Color black = Color(0xFF000000);      // Matte black background
  
  // ===========================================
  // ALIASES (all map to mint or black)
  // ===========================================
  
  // Primary colors - all mint
  static const Color primaryNeonMint = mint;
  static const Color primaryLightMint = mint;
  static const Color primaryGreenAccent = mint;
  static const Color primaryLimeGreen = mint;
  static const Color ultraLightMint = mint;
  static const Color neonMint = mint;
  static const Color turquoiseNeon = mint;
  static const Color avocadoGreen = mint;
  static const Color neonPulse = mint;
  static const Color softGray = mint;
  static const Color secondaryText = mint;
  static const Color dividerColor = mint;
  static const Color electricPink = mint;
  static const Color neonPurple = mint;
  static const Color white = mint;
  
  // Background colors - all black
  static const Color matteBlack = black;
  static const Color pureBlack = black;
  static const Color voidBlack = black;
  static const Color charcoalBlack = black;
  static const Color darkGray = black;
  static const Color cardBackground = black;
  
  // Legacy aliases
  static const Color kNvsMint = mint;
  static const Color kNvsCyan = mint;
  static const Color kNvsBg = black;
  static const Color kNvsCard = black;
  
  // Status Colors - all mint (no colored status)
  static const Color success = mint;
  static const Color warning = mint;
  static const Color error = mint;
  static const Color info = mint;

  // ===========================================
  // GLOW EFFECTS (outline glow only, no fills)
  // ===========================================
  static List<BoxShadow> glowEffect([double opacity = 0.3, double blur = 15]) {
    return [
      BoxShadow(
        color: mint.withOpacity(opacity),
        blurRadius: blur,
        spreadRadius: 2,
      ),
    ];
  }
  
  static const List<BoxShadow> mintGlow = <BoxShadow>[
    BoxShadow(color: Color(0x4DE4FFF0), blurRadius: 15, spreadRadius: 2),
  ];

  static const List<Shadow> mintTextShadow = <Shadow>[
    Shadow(color: Color(0x4DE4FFF0), blurRadius: 8),
  ];
  
  // Border decoration helper - outline only, no fill
  static BoxDecoration outlineBox({
    double opacity = 0.3,
    double borderRadius = 12,
    double glowOpacity = 0.1,
    double glowBlur = 10,
  }) {
    return BoxDecoration(
      color: Colors.transparent, // NO FILL
      border: Border.all(color: mint.withOpacity(opacity)),
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: mint.withOpacity(glowOpacity),
          blurRadius: glowBlur,
          spreadRadius: 1,
        ),
      ],
    );
  }
}
