// lib/core/theme/quantum_design_tokens.dart
// Unified Design Token System for NVS 2027+ Architecture
// Single source of truth for all visual properties, measurements, and styling

import 'package:flutter/material.dart';

/// Quantum Design Token System
/// Replaces all fragmented theme files with a unified, scientifically-precise
/// design system optimized for bio-responsive interfaces and neural engagement
class QuantumDesignTokens {
  // ============================================================================
  // COLOR SYSTEM - Quantum-Enhanced Cyberpunk Palette
  // ============================================================================

  /// Core Brand Colors - Primary Identity
  static const Color pureBlack = Color(0xFF232901);
  static const Color voidBlack = Color(0xFF0A0A0A); // Deeper black for depths
  static const Color ultraLightMint = Color(0xFFE2FFF4); // Primary brand glow
  static const Color neonMint = Color(0xFF00FFA3); // Interactive elements
  static const Color turquoiseNeon = Color(0xFF04FFF7); // Secondary accents
  static const Color avocadoGreen = Color(0xFF00FF9F); // Role tags, active states

  /// Extended Cyberpunk Palette
  static const Color scannerRed = Color(0xFFFF073A); // Alerts, errors, scanner beams
  static const Color plasmaGreen = Color(0xFF39FF14); // Data streams, success states
  static const Color hologramBlue = Color(0xFF00BFFF); // Tech elements, links
  static const Color electricPurple = Color(0xFF8A2BE2); // Mystery, premium features
  static const Color neonPink = Color(0xFFFF1493); // Emotional accents, alerts
  static const Color cyberOrange = Color(0xFFFF6B35); // Energy, notifications
  static const Color quantumGold = Color(0xFFFFD700); // Premium, cosmic tier

  /// Bio-Responsive Colors (Dynamic based on user state)
  static const Color bioCalm = Color(0xFF00FFB3); // Low arousal, relaxed state
  static const Color bioNeutral = Color(0xFF04FFF7); // Baseline state
  static const Color bioExcited = Color(0xFFFF4DFF); // High arousal, excited state
  static const Color bioStressed = Color(0xFFFF073A); // Stress, tension indicators
  static const Color bioSynchronized = Color(0xFFFFD700); // Perfect bio-sync state

  /// Additional Colors
  static const Color charcoalBlack = Color(0xFF1A1A1A);
  static const Color neonPulse = Color(0xFF00FFF0);
  static const Color white = Color(0xFFFFFFFF);
  static const Color softGray = Color(0xFF8A8A8A);

  /// Surface and Background Colors
  static const Color cardBackground = Color(0xFF1B1B1B);
  static const Color glassBackground = Color(0x40000000); // 25% opacity black
  static const Color deepCardBackground = Color(0xFF0F0F0F);
  static const Color elevatedSurface = Color(0xFF2A2A2A);
  static const Color glassMorphSurface = Color(0x60000000); // 37% opacity for glassmorphism

  /// Text Hierarchy
  static const Color textPrimary = ultraLightMint;
  static const Color textSecondary = Color(0x99E2FFF4); // 60% opacity mint
  static const Color textTertiary = Color(0x66E2FFF4); // 40% opacity mint
  static const Color textDisabled = Color(0x44E2FFF4); // 26% opacity mint
  static const Color textOnDark = Color(0xFFFFFFFF);
  static const Color textOnLight = Color(0xFF232901);

  /// Status and Semantic Colors
  static const Color success = plasmaGreen;
  static const Color warning = cyberOrange;
  static const Color error = scannerRed;
  static const Color info = hologramBlue;
  static const Color neutral = Color(0xFF888888);

  /// Interactive States
  static const Color interactiveDefault = neonMint;
  static const Color interactiveHover = turquoiseNeon;
  static const Color interactivePressed = avocadoGreen;
  static const Color interactiveDisabled = Color(0x40E2FFF4);
  static const Color interactiveFocus = quantumGold;

  // ============================================================================
  // TYPOGRAPHY SYSTEM - Bell Gothic Primary, MagdaCleanMono Secondary
  // ============================================================================

  /// Font Families - Bell Gothic primary, MagdaCleanMono secondary
  static const String fontPrimary = 'BellGothic';
  static const String fontSecondary = 'MagdaCleanMono';

  /// Font Weights
  static const FontWeight weightLight = FontWeight.w300;
  static const FontWeight weightRegular = FontWeight.w400;
  static const FontWeight weightMedium = FontWeight.w500;
  static const FontWeight weightSemiBold = FontWeight.w600;
  static const FontWeight weightBold = FontWeight.w700;
  static const FontWeight weightExtraBold = FontWeight.w800;
  static const FontWeight weightBlack = FontWeight.w900;

  /// Font Sizes - Quantum Scale
  static const double fontNano = 10.0; // Ultra-small labels, timestamps
  static const double fontMicro = 12.0; // Small secondary text
  static const double fontXS = 14.0; // Body text, forms
  static const double fontSM = 16.0; // Standard body text
  static const double fontMD = 18.0; // Large body text
  static const double fontLG = 20.0; // Section headers
  static const double fontXL = 24.0; // Page headers
  static const double fontXXL = 28.0; // Major headers
  static const double fontGiga = 32.0; // Hero text
  static const double fontQuantum = 48.0; // Massive display text

  /// Icon Sizes - Consistent with font scale
  static const double iconXS = 16.0;
  static const double iconSM = 20.0;
  static const double iconMD = 24.0;
  static const double iconLG = 28.0;
  static const double iconXL = 32.0;
  static const double iconXXL = 40.0;

  // ============================================================================
  // SPACING SYSTEM - Harmonic Proportions
  // ============================================================================

  /// Base unit: 4px - All measurements are multiples of this for perfect alignment
  static const double _baseUnit = 4.0;

  /// Nano spacing (1-2 units) - Fine details
  static const double spaceNano = _baseUnit * 1; // 4px
  static const double spaceMicro = _baseUnit * 2; // 8px

  /// Atomic spacing (3-4 units) - Component internals
  static const double spaceXXS = _baseUnit * 3; // 12px
  static const double spaceXS = _baseUnit * 4; // 16px

  /// Molecular spacing (5-8 units) - Standard component spacing
  static const double spaceSM = _baseUnit * 5; // 20px
  static const double spaceMD = _baseUnit * 6; // 24px
  static const double spaceLG = _baseUnit * 8; // 32px

  /// Macro spacing (10-16 units) - Section separation
  static const double spaceXL = _baseUnit * 10; // 40px
  static const double spaceXXL = _baseUnit * 12; // 48px
  static const double spaceGiga = _baseUnit * 16; // 64px

  /// Cosmic spacing (20+ units) - Page-level separation
  static const double spaceCosmic = _baseUnit * 20; // 80px
  static const double spaceQuantum = _baseUnit * 24; // 96px

  /// Additional Font Sizes - Extended Scale
  static const double fontCosmic = 40.0; // Headline large

  /// Line Heights - Optimized for readability
  static const double lineHeightTight = 1.2;
  static const double lineHeightNormal = 1.4;
  static const double lineHeightRelaxed = 1.6;
  static const double lineHeightLoose = 1.8;

  /// Letter Spacing - Cyberpunk aesthetic
  static const double letterSpacingTight = -0.5;
  static const double letterSpacingNormal = 0.0;
  static const double letterSpacingWide = 0.5;
  static const double letterSpacingExtraWide = 1.0;
  static const double letterSpacingQuantum = 2.0; // For dramatic headers

  // ============================================================================
  // BORDER RADIUS SYSTEM - Organic Cyberpunk Forms
  // ============================================================================

  static const double radiusNone = 0.0;
  static const double radiusXS = 4.0;
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusXXL = 24.0;
  static const double radiusGiga = 32.0;
  static const double radiusFull = 9999.0; // Perfect circles

  // ============================================================================
  // SHADOW SYSTEM - Quantum Glow Effects
  // ============================================================================

  /// Mint Glow Shadows
  static List<BoxShadow> get mintGlowSoft => <BoxShadow>[
        BoxShadow(
          color: neonMint.withValues(alpha: 0.3),
          blurRadius: 8,
          spreadRadius: 2,
          offset: const Offset(0, 2),
        ),
        BoxShadow(
          color: neonMint.withValues(alpha: 0.1),
          blurRadius: 16,
          spreadRadius: 4,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get mintGlowMedium => <BoxShadow>[
        BoxShadow(
          color: neonMint.withValues(alpha: 0.5),
          blurRadius: 12,
          spreadRadius: 3,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: neonMint.withValues(alpha: 0.2),
          blurRadius: 24,
          spreadRadius: 6,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get mintGlowIntense => <BoxShadow>[
        BoxShadow(
          color: neonMint.withValues(alpha: 0.7),
          blurRadius: 16,
          spreadRadius: 4,
          offset: const Offset(0, 6),
        ),
        BoxShadow(
          color: neonMint.withValues(alpha: 0.3),
          blurRadius: 32,
          spreadRadius: 8,
          offset: const Offset(0, 12),
        ),
        BoxShadow(
          color: neonMint.withValues(alpha: 0.1),
          blurRadius: 64,
          spreadRadius: 16,
          offset: const Offset(0, 24),
        ),
      ];

  /// Turquoise Glow Shadows
  static List<BoxShadow> get turquoiseGlow => <BoxShadow>[
        BoxShadow(
          color: turquoiseNeon.withValues(alpha: 0.5),
          blurRadius: 12,
          spreadRadius: 3,
        ),
        BoxShadow(
          color: turquoiseNeon.withValues(alpha: 0.2),
          blurRadius: 24,
          spreadRadius: 6,
        ),
      ];

  /// Red Scanner Glow
  static List<BoxShadow> get scannerGlow => <BoxShadow>[
        BoxShadow(
          color: scannerRed.withValues(alpha: 0.6),
          blurRadius: 10,
          spreadRadius: 2,
        ),
        BoxShadow(
          color: scannerRed.withValues(alpha: 0.3),
          blurRadius: 20,
          spreadRadius: 4,
        ),
      ];

  /// Depth Shadows (Non-glowing)
  static List<BoxShadow> get depthSmall => <BoxShadow>[
        BoxShadow(
          color: pureBlack.withValues(alpha: 0.3),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get depthMedium => <BoxShadow>[
        BoxShadow(
          color: pureBlack.withValues(alpha: 0.4),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get depthLarge => <BoxShadow>[
        BoxShadow(
          color: pureBlack.withValues(alpha: 0.5),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ];

  // ============================================================================
  // TEXT SHADOW SYSTEM - Cyberpunk Glow Effects
  // ============================================================================

  static List<Shadow> get textGlowSoft => <Shadow>[
        Shadow(
          color: ultraLightMint.withValues(alpha: 0.5),
          blurRadius: 4,
        ),
        Shadow(
          color: ultraLightMint.withValues(alpha: 0.2),
          blurRadius: 8,
        ),
      ];

  static List<Shadow> get textGlowMedium => <Shadow>[
        Shadow(
          color: ultraLightMint.withValues(alpha: 0.7),
          blurRadius: 6,
        ),
        Shadow(
          color: ultraLightMint.withValues(alpha: 0.3),
          blurRadius: 12,
        ),
      ];

  static List<Shadow> get textGlowIntense => <Shadow>[
        Shadow(
          color: ultraLightMint.withValues(alpha: 0.9),
          blurRadius: 8,
        ),
        Shadow(
          color: ultraLightMint.withValues(alpha: 0.5),
          blurRadius: 16,
        ),
        Shadow(
          color: ultraLightMint.withValues(alpha: 0.2),
          blurRadius: 32,
        ),
      ];

  // ============================================================================
  // ANIMATION SYSTEM - Neural-Fluid Motion
  // ============================================================================

  /// Animation Durations
  static const Duration durationInstant = Duration();
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);
  static const Duration durationRelaxed = Duration(milliseconds: 800);
  static const Duration durationLuxury = Duration(milliseconds: 1200);

  /// Animation Curves - Cyberpunk Feel
  static const Curve curveQuantumEase = Curves.easeInOutCubic;
  static const Curve curveNeuralFlow = Curves.easeOutExpo;
  static const Curve curveBioSync = Curves.elasticOut;
  static const Curve curveGlitchEffect = Curves.bounceInOut;
  static const Curve curveScannerBeam = Curves.linear;

  // ============================================================================
  // COMPONENT SIZING SYSTEM
  // ============================================================================

  /// Button Heights
  static const double buttonHeightSM = 32.0;
  static const double buttonHeightMD = 40.0;
  static const double buttonHeightLG = 48.0;
  static const double buttonHeightXL = 56.0;

  static const double iconGiga = 48.0;

  /// Avatar Sizes
  static const double avatarXS = 24.0;
  static const double avatarSM = 32.0;
  static const double avatarMD = 40.0;
  static const double avatarLG = 48.0;
  static const double avatarXL = 64.0;
  static const double avatarXXL = 80.0;
  static const double avatarGiga = 120.0;

  /// Hit Target Sizes (Accessibility)
  static const double hitTargetMIN = 44.0; // iOS minimum
  static const double hitTargetRECOMMENDED = 48.0; // Material recommendation

  // ============================================================================
  // GRADIENT SYSTEM - Quantum Color Flows
  // ============================================================================

  static const LinearGradient primaryGradient = LinearGradient(
    colors: <Color>[neonMint, turquoiseNeon],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: <Color>[turquoiseNeon, avocadoGreen],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: <Color>[pureBlack, voidBlack],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: <Color>[
      Color(0x40000000),
      Color(0x20000000),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const RadialGradient quantumGlow = RadialGradient(
    colors: <Color>[
      Color(0x60E2FFF4),
      Color(0x30E2FFF4),
      Color(0x00E2FFF4),
    ],
    stops: <double>[0.0, 0.5, 1.0],
  );

  // ============================================================================
  // RESPONSIVE BREAKPOINTS - Multi-Device Optimization
  // ============================================================================

  static const double breakpointMobile = 480.0;
  static const double breakpointTablet = 768.0;
  static const double breakpointDesktop = 1024.0;
  static const double breakpointWide = 1440.0;

  // ============================================================================
  // Z-INDEX SYSTEM - Layering Hierarchy
  // ============================================================================

  static const int zIndexBackground = -1;
  static const int zIndexDefault = 0;
  static const int zIndexRaised = 1;
  static const int zIndexFloating = 10;
  static const int zIndexOverlay = 100;
  static const int zIndexModal = 1000;
  static const int zIndexPopover = 1100;
  static const int zIndexTooltip = 1200;
  static const int zIndexNotification = 1300;
  static const int zIndexQuantumPortal = 9999;

  // ============================================================================
  // ACCESSIBILITY SYSTEM - Inclusive Design
  // ============================================================================

  /// Contrast Ratios (WCAG Compliant)
  static const double contrastAANormal = 4.5;
  static const double contrastAALarge = 3.0;
  static const double contrastAAANormal = 7.0;
  static const double contrastAAALarge = 4.5;

  /// Focus Indicators
  static const double focusIndicatorWidth = 2.0;
  static const Color focusIndicatorColor = quantumGold;

  // ============================================================================
  // PERFORMANCE OPTIMIZATION TOKENS
  // ============================================================================

  /// Frame Rate Targets
  static const int targetFPS60 = 60;
  static const int targetFPS120 = 120; // Flagship device target
  static const int targetFPS144 = 144; // Premium device target

  /// Animation Performance Budgets
  static const int maxSimultaneousAnimations = 3;
  static const int maxBlurRadius = 32; // Performance-safe blur limit
  static const int maxShadowLayers = 3;

  // ============================================================================
  // HELPER METHODS - Dynamic Token Generation
  // ============================================================================

  /// Generate bio-responsive color based on user state
  static Color getBioResponsiveColor(double arousalLevel) {
    if (arousalLevel < 0.3) return bioCalm;
    if (arousalLevel < 0.7) return bioNeutral;
    if (arousalLevel < 0.9) return bioExcited;
    return bioStressed;
  }

  /// Generate glow intensity based on interaction state
  static List<BoxShadow> getInteractiveGlow(bool isHovered, bool isPressed) {
    if (isPressed) return mintGlowIntense;
    if (isHovered) return mintGlowMedium;
    return mintGlowSoft;
  }

  /// Generate responsive spacing based on screen size
  static double getResponsiveSpacing(double screenWidth, double baseSpacing) {
    if (screenWidth < breakpointMobile) return baseSpacing * 0.8;
    if (screenWidth < breakpointTablet) return baseSpacing;
    if (screenWidth < breakpointDesktop) return baseSpacing * 1.2;
    return baseSpacing * 1.4;
  }

  /// Generate quantum-themed BorderRadius
  static BorderRadius getQuantumRadius(double intensity) {
    final double radius = radiusMD + (intensity * radiusLG);
    return BorderRadius.circular(radius);
  }

  /// Create custom gradient with bio-sync colors
  static LinearGradient createBioSyncGradient(double heartRate) {
    final double normalizedRate = (heartRate - 60) / 100; // Normalize around 60-160 BPM
    final Color primaryColor = Color.lerp(bioCalm, bioExcited, normalizedRate.clamp(0.0, 1.0))!;
    return LinearGradient(
      colors: <Color>[primaryColor, primaryColor.withValues(alpha: 0.3)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// Create text style with quantum glow effect
  static TextStyle createQuantumTextStyle({
    required double fontSize,
    required FontWeight fontWeight,
    Color? color,
    bool enableGlow = true,
    double glowIntensity = 0.5,
  }) {
    return TextStyle(
      fontFamily: QuantumDesignTokens.fontPrimary,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? textPrimary,
      letterSpacing: letterSpacingWide,
      shadows: enableGlow
          ? <Shadow>[
              Shadow(
                color: (color ?? neonMint).withValues(alpha: glowIntensity),
                blurRadius: 4 + (glowIntensity * 8),
              ),
              Shadow(
                color: (color ?? neonMint).withValues(alpha: glowIntensity * 0.5),
                blurRadius: 8 + (glowIntensity * 16),
              ),
            ]
          : null,
    );
  }
}
