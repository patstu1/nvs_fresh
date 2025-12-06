import 'package:flutter/material.dart';

// Baseline brand tokens
const Color kNvsMint = Color(0xFF7FF4F9);
const Color kNvsCyan = Color(0xFF36B4FF);
const Color kNvsBg = Color(0xFF0B0B1F);
const Color kNvsCard = Color(0xFFF1F1F1);

// Font Family Constants
class NVSFonts {
  static const String primary = 'BellGothic';
  static const String secondary = 'MagdaCleanMono';
}

class NVSColors {
  // Baseline brand tokens (added)
  static const Color kNvsMint = Color(0xFF7FF4F9);
  static const Color kNvsCyan = Color(0xFF36B4FF);
  static const Color kNvsBg = Color(0xFF0B0B1F);
  static const Color kNvsCard = Color(0xFFF1F1F1);

  // Custom Primary Brand Colors (Your Specification)
  static const Color primaryNeonMint = Color(0xFF08F3F0); // #08F3F0
  static const Color primaryLightMint = Color(0xFFE4FFF0); // #E4FFF0
  static const Color primaryGreenAccent = Color(0xFF97FFC5); // #97FFC5
  static const Color primaryLimeGreen = Color(0xFFA2E868); // #A2E868

  // Back-compat aliases mapped to strict palette
  static const Color ultraLightMint = primaryLightMint; // Use brand primary
  static const Color neonMint = primaryLightMint; // Ensure primary mint
  static const Color turquoiseNeon = primaryGreenAccent;
  static const Color avocadoGreen = primaryLimeGreen;

  // Background Colors - Matte Black Primary
  static const Color matteBlack = kNvsBg; // Primary matte black background
  static const Color pureBlack = Color(0xFF000000);
  static const Color voidBlack = Color(0xFF000000);
  static const Color charcoalBlack = Color(0xFF000000);
  static const Color cardBackground = kNvsCard;

  // Accent Colors
  static const Color neonPulse = primaryNeonMint;
  static const Color white = Color(0xFFFFFFFF);
  static const Color softGray = primaryLightMint;
  static const Color darkGray = pureBlack;

  // Extended Colors for Legacy Compatibility
  static const Color electricPink = primaryNeonMint;
  static const Color neonPurple = primaryNeonMint;
  static const Color secondaryText = primaryGreenAccent;
  static const Color dividerColor = primaryGreenAccent;

  // Status Colors
  static const Color success = Color(0xFF00FF88);
  static const Color warning = Color(0xFFFFAA00);
  static const Color error = Color(0xFFFF4444);
  static const Color info = Color(0xFF00AAFF);

  // Glow Effects
  static const List<BoxShadow> mintGlow = <BoxShadow>[
    BoxShadow(color: ultraLightMint, blurRadius: 8, spreadRadius: 2),
  ];

  // Text Shadows
  static const List<Shadow> mintTextShadow = <Shadow>[Shadow(color: ultraLightMint, blurRadius: 4)];
}
