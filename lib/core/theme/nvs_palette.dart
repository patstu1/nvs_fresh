import 'package:flutter/material.dart';

/// Font family constants for NVS typography.
class NvsFonts {
  static const String primary = 'BellGothic';
  static const String secondary = 'MagdaCleanMono';
}

/// Canonical NVS palette. All accent tones must be derived from these colors.
class NvsColors {
  // ---------------------------------------------------------------------------
  // Core brand colors
  // ---------------------------------------------------------------------------
  static const Color primary = Color(0xFFE3F2DE); // Soft bone primary
  static const Color secondary = Color(0xFF95FFF2); // Mint highlight
  static const Color tertiary = Color(0xFF4D5D53); // Green-grey support

  // ---------------------------------------------------------------------------
  // Backgrounds & surfaces
  // ---------------------------------------------------------------------------
  static const Color backgroundDark = Color(0xFF0A0A0A);
  static const Color background = backgroundDark;
  static const Color surfaceDark = Color(0xFF121212);
  static const Color surfaceMedium = Color(0xFF161616);
  static const Color surface = surfaceMedium;
  static const Color panel = Color(0xFF141414);
  static const Color cardBackground = Color(0xFF111111);
  static const Color border = Color(0x332A3A31);
  static const Color borderStrong = Color(0x664D5D53);
  static const Color transparent = Color(0x00000000);
  static const Color gridObsidian = Color(0xFF050505);
  static const Color gridDepth = Color(0xFF060606);
  static const Color deepCore = Color(0xFF080808);
  static const Color industrialCarbon = Color(0xFF0D0D0D);
  static const Color gunmetal = Color(0xFF2A2A2A);
  static const Color graphitic = Color(0xFF2F2F2F);
  static const Color meatMarketTeal = Color(0xFF2E8B8B);
  static const Color steelBright = Color(0xFF5A5A5A);
  static const Color chromeGray = Color(0xFF808080);
  static const Color profileMint = Color(0xFFB2FFD6);
  static const Color profileNeonLime = Color(0xFFCCFF33);
  static const Color nowPulseMint = Color(0xFF04FFF7);
  static const Color nowSignalLime = Color(0xFF00FF9F);
  static const Color nowUserHalo = Color(0x6604FFF7);
  static const Color nowLocationPulse = Color(0xFF4BEFE0);
  static const Color nowGradientDark = Color(0xFF001122);
  static const Color nowGradientMint = Color(0xFFA7FFE0);
  static const Color nowDeepPulse = Color(0xFF001A1A);
  static const Color nowMidnightFog = Color(0xFF0F0F1E);
  static const Color nowOrbitalNavy = Color(0xFF1A1A2E);
  static const Color nowCarbon = Color(0xFF1B1B1B);
  static const Color nowSpectralViolet = Color(0xFF8A2BE2);
  static const Color nowSignalCrimson = Color(0xFFFF073A);
  static const Color nowPulseMagenta = Color(0xFFFF1493);
  static const Color nowNeonRose = Color(0xFFFF6699);
  static const Color nowSolarOrange = Color(0xFFFF6B35);
  static const Color nowAmberPulse = Color(0xFFFFA500);
  static const Color nowSignalGold = Color(0xFFFFD700);
  static const Color frostMint = Color(0xFFB5FFEB);
  static const Color holoCyan = Color(0xFF65F6FF);
  static const Color frostBlue = Color(0xFF88D8FF);
  static const Color iceBlue = Color(0xFF8DEAFF);
  static const Color bioMint = Color(0xFF9FFFCB);
  static const Color arcticWhite = Color(0xFFE9FFF9);
  static const Color emberRed = Color(0xFFC21807);
  static const Color alertRed = Color(0xFFFF4444);

  // ---------------------------------------------------------------------------
  // Text & feedback
  // ---------------------------------------------------------------------------
  static const Color textPrimary = primary;
  static const Color textSecondary = Color(0xCC95FFF2);
  static const Color textTertiary = Color(0x8095FFF2);
  static const Color textDisabled = Color(0x6695FFF2);
  static const Color textMuted = Color(0xFF8A8A8A);
  static const Color bodyText = primary;
  static const Color dividerColor = Color(0x1995FFF2);

  // ---------------------------------------------------------------------------
  // Legacy aliases (map old names to new palette)
  // ---------------------------------------------------------------------------
  static const Color accent = tertiary;
  static const Color secondaryDark = tertiary;
  static const Color pureBlack = backgroundDark;
  static const Color voidBlack = backgroundDark;
  static const Color charcoalBlack = surfaceDark;
  static const Color matteBlack = backgroundDark;
  static const Color white = Color(0xFFFFFFFF);
  static const Color pureWhite = white;
  static const Color softGray = Color(0xFF2B2B2B);
  static const Color mediumGray = Color(0xFF262626);
  static const Color lightGray = Color(0xFF3C3C3C);
  static const Color darkGray = Color(0xFF1A1A1A);
  static const Color textPrimaryLegacy = primary;
  static const Color textSecondaryLegacy = textSecondary;
  static const Color textTertiaryLegacy = textTertiary;
  static const Color textDisabledLegacy = textDisabled;
  static const Color bodyTextLegacy = bodyText;

  static const Color success = secondary;
  static const Color warning = tertiary;
  static const Color error = tertiary;
  static const Color info = secondary;
  static const Color neutral = tertiary;

  static const Color neonMint = secondary;
  static const Color cyberMint = secondary;
  static const Color plasmaGreen = secondary;
  static const Color turquoiseNeon = secondary;
  static const Color hologramBlue = secondary;
  static const Color neonBlue = secondary;
  static const Color neonPurple = secondary;
  static const Color neonPink = secondary;
  static const Color electricBlue = secondary;
  static const Color electricPink = secondary;
  static const Color lightMintGreen = primary;
  static const Color ultraLightMint = primary;
  static const Color ultraLightNeonMint = primary;
  static const Color primaryGlow = primary;
  static const Color primaryGlowLegacy = primary;
  static const Color primaryOlive = tertiary;
  static const Color oliveGreen = tertiary;
  static const Color oliveGreenNeon = tertiary;
  static const Color primaryLime = tertiary;
  static const Color neonOrange = tertiary;
  static const Color neonRed = tertiary;
  static const Color neonYellow = primary;
  static const Color secondaryMint = secondary;
  static const Color primaryText = textPrimary;
  static const Color glitchAqua = secondary;
  static const Color glitchOlive = tertiary;
  static const Color glitchRed = secondary;
  static const Color glitchPink = secondary; // Added missing

  static const Color meatMarketAccent = secondary;
  static const Color meatMarketPrimary = backgroundDark;
  static const Color meatMarketSteel = tertiary;
  static const Color meatMarketMint = secondary;

  // Additional aliases for backwards compatibility
  static const Color neonGreen = secondary;
  static const Color primaryGreenAccent = secondary;
  static const Color nvsBlack = backgroundDark;
  static const Color darkBackground = backgroundDark;
  static const Color secondaryAmber = tertiary;
  static const Color scannerGlow = secondary;
  static const Color aquaOutline = secondary;
  static const Color primaryNeonMint = secondary;
  static const Color hangingChainSteel = steelBright;
  static const Color coldRoomFrost = frostMint;
  static const Color coldRoomCyan = holoCyan;
  static const Color coldRoomBlue = frostBlue;
  static const Color coldRoomIce = iceBlue;
  static const Color hydroMint = bioMint;
  static const Color surgicalWhite = arcticWhite;
  static const Color hazardAmber = emberRed;
  static const Color hazardRed = alertRed;
  static const Color profileAccentMint = profileMint;
  static const Color profileSignalLime = profileNeonLime;

  // ---------------------------------------------------------------------------
  // Shadows & glow effects derived from core palette
  // ---------------------------------------------------------------------------
  static final List<BoxShadow> liquidGlassLight = <BoxShadow>[
    BoxShadow(
      color: secondary.withValues(alpha: 0.12),
      blurRadius: 18,
      spreadRadius: 3,
      offset: const Offset(0, 10),
    ),
    BoxShadow(
      color: primary.withValues(alpha: 0.06),
      blurRadius: 28,
      spreadRadius: 12,
    ),
  ];

  static final List<BoxShadow> primaryGlowSoft = <BoxShadow>[
    BoxShadow(
      color: secondary.withValues(alpha: 0.28),
      blurRadius: 14,
      spreadRadius: 4,
      offset: const Offset(0, 6),
    ),
    BoxShadow(
      color: secondary.withValues(alpha: 0.12),
      blurRadius: 32,
      spreadRadius: 14,
    ),
  ];

  static final List<BoxShadow> primaryGlowMedium = <BoxShadow>[
    BoxShadow(
      color: secondary.withValues(alpha: 0.35),
      blurRadius: 18,
      spreadRadius: 6,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: secondary.withValues(alpha: 0.18),
      blurRadius: 42,
      spreadRadius: 16,
    ),
  ];

  static final List<BoxShadow> primaryGlowStrong = <BoxShadow>[
    BoxShadow(
      color: secondary.withValues(alpha: 0.45),
      blurRadius: 28,
      spreadRadius: 10,
      offset: const Offset(0, 10),
    ),
    BoxShadow(
      color: secondary.withValues(alpha: 0.22),
      blurRadius: 58,
      spreadRadius: 22,
    ),
  ];

  static final List<BoxShadow> oliveGlow = <BoxShadow>[
    BoxShadow(
      color: tertiary.withValues(alpha: 0.32),
      blurRadius: 16,
      spreadRadius: 6,
    ),
  ];

  static final List<BoxShadow> aquaGlow = <BoxShadow>[
    BoxShadow(
      color: secondary.withValues(alpha: 0.28),
      blurRadius: 16,
      spreadRadius: 4,
    ),
    BoxShadow(
      color: secondary.withValues(alpha: 0.12),
      blurRadius: 34,
      spreadRadius: 12,
    ),
  ];

  static final List<BoxShadow> aquaGlowIntense = <BoxShadow>[
    BoxShadow(
      color: secondary.withValues(alpha: 0.42),
      blurRadius: 22,
      spreadRadius: 8,
    ),
    BoxShadow(
      color: secondary.withValues(alpha: 0.18),
      blurRadius: 48,
      spreadRadius: 16,
    ),
  ];

  static final List<BoxShadow> meatMarketShadow = <BoxShadow>[
    BoxShadow(
      color: secondary.withValues(alpha: 0.32),
      blurRadius: 18,
      spreadRadius: 4,
    ),
  ];

  static final List<BoxShadow> meatMarketSteelShadow = <BoxShadow>[
    BoxShadow(
      color: tertiary.withValues(alpha: 0.28),
      blurRadius: 16,
      spreadRadius: 2,
    ),
  ];

  static final List<Shadow> aquaTextGlow = <Shadow>[
    Shadow(color: secondary.withValues(alpha: 0.6), blurRadius: 8),
    Shadow(color: secondary.withValues(alpha: 0.24), blurRadius: 16),
  ];

  static final List<Shadow> oliveTextGlow = <Shadow>[
    Shadow(color: tertiary.withValues(alpha: 0.5), blurRadius: 6),
    Shadow(color: tertiary.withValues(alpha: 0.2), blurRadius: 12),
  ];

  static List<Shadow> get primaryTextShadow => <Shadow>[
    Shadow(color: secondary.withValues(alpha: 0.3), blurRadius: 6),
    Shadow(color: secondary.withValues(alpha: 0.18), blurRadius: 14),
  ];

  static const double breatheMin = 0.9;
  static const double breatheMax = 1.2;

  static LinearGradient get meatMarketSteelGradient => LinearGradient(
    colors: <Color>[tertiary.withValues(alpha: 0.88), surfaceDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Color panelBackground = panel;
  static const Color mint = primary;
  static const Color mintSoft = primary;
  static const Color bg = background;
  static const Color borderColor = border;
}

/// Legacy uppercase accessors maintained for backwards compatibility.
class NVSPalette {
  static const Color primary = NvsColors.primary;
  static const Color secondary = NvsColors.secondary;
  static const Color tertiary = NvsColors.tertiary;
  static const Color accent = NvsColors.accent;
  static const Color secondaryDark = NvsColors.secondaryDark;
  static const Color background = NvsColors.background;
  static const Color backgroundDark = NvsColors.backgroundDark;
  static const Color surfaceDark = NvsColors.surfaceDark;
  static const Color surfaceMedium = NvsColors.surfaceMedium;
  static const Color surface = NvsColors.surface;
  static const Color panel = NvsColors.panel;
  static const Color cardBackground = NvsColors.cardBackground;
  static const Color border = NvsColors.border;
  static const Color borderStrong = NvsColors.borderStrong;
  static const Color transparent = NvsColors.transparent;
  static const Color textPrimary = NvsColors.textPrimary;
  static const Color textSecondary = NvsColors.textSecondary;
  static const Color textTertiary = NvsColors.textTertiary;
  static const Color textDisabled = NvsColors.textDisabled;
  static const Color textMuted = NvsColors.textMuted;
  static const Color bodyText = NvsColors.bodyText;
  static const Color dividerColor = NvsColors.dividerColor;
  static const Color success = NvsColors.success;
  static const Color warning = NvsColors.warning;
  static const Color error = NvsColors.error;
  static const Color info = NvsColors.info;
  static const Color neutral = NvsColors.neutral;
  static const Color white = NvsColors.white;
  static const Color pureWhite = NvsColors.pureWhite;
  static const Color softGray = NvsColors.softGray;
  static const Color mediumGray = NvsColors.mediumGray;
  static const Color lightGray = NvsColors.lightGray;
  static const Color darkGray = NvsColors.darkGray;
  static const Color pureBlack = NvsColors.pureBlack;
  static const Color voidBlack = NvsColors.voidBlack;
  static const Color charcoalBlack = NvsColors.charcoalBlack;
  static const Color matteBlack = NvsColors.matteBlack;
  static const Color gridObsidian = NvsColors.gridObsidian;
  static const Color gridDepth = NvsColors.gridDepth;
  static const Color deepCore = NvsColors.deepCore;
  static const Color industrialCarbon = NvsColors.industrialCarbon;
  static const Color gunmetal = NvsColors.gunmetal;
  static const Color graphitic = NvsColors.graphitic;
  static const Color profileMint = NvsColors.profileMint;
  static const Color profileNeonLime = NvsColors.profileNeonLime;
  static const Color nowPulseMint = NvsColors.nowPulseMint;
  static const Color nowSignalLime = NvsColors.nowSignalLime;
  static const Color nowUserHalo = NvsColors.nowUserHalo;
  static const Color nowLocationPulse = NvsColors.nowLocationPulse;
  static const Color nowGradientDark = NvsColors.nowGradientDark;
  static const Color nowGradientMint = NvsColors.nowGradientMint;
  static const Color nowDeepPulse = NvsColors.nowDeepPulse;
  static const Color nowMidnightFog = NvsColors.nowMidnightFog;
  static const Color nowOrbitalNavy = NvsColors.nowOrbitalNavy;
  static const Color nowCarbon = NvsColors.nowCarbon;
  static const Color nowSpectralViolet = NvsColors.nowSpectralViolet;
  static const Color nowSignalCrimson = NvsColors.nowSignalCrimson;
  static const Color nowPulseMagenta = NvsColors.nowPulseMagenta;
  static const Color nowNeonRose = NvsColors.nowNeonRose;
  static const Color nowSolarOrange = NvsColors.nowSolarOrange;
  static const Color nowAmberPulse = NvsColors.nowAmberPulse;
  static const Color nowSignalGold = NvsColors.nowSignalGold;
  static const Color neonMint = NvsColors.neonMint;
  static const Color cyberMint = NvsColors.cyberMint;
  static const Color plasmaGreen = NvsColors.plasmaGreen;
  static const Color turquoiseNeon = NvsColors.turquoiseNeon;
  static const Color hologramBlue = NvsColors.hologramBlue;
  static const Color neonBlue = NvsColors.neonBlue;
  static const Color neonPurple = NvsColors.neonPurple;
  static const Color neonPink = NvsColors.neonPink;
  static const Color electricBlue = NvsColors.electricBlue;
  static const Color electricPink = NvsColors.electricPink;
  static const Color lightMintGreen = NvsColors.lightMintGreen;
  static const Color ultraLightMint = NvsColors.ultraLightMint;
  static const Color ultraLightNeonMint = NvsColors.ultraLightNeonMint;
  static const Color primaryGlow = NvsColors.primaryGlow;
  static const Color primaryGlowLegacy = NvsColors.primaryGlowLegacy;
  static const Color primaryOlive = NvsColors.primaryOlive;
  static const Color oliveGreen = NvsColors.oliveGreen;
  static const Color oliveGreenNeon = NvsColors.oliveGreenNeon;
  static const Color primaryLime = NvsColors.primaryLime;
  static const Color neonOrange = NvsColors.neonOrange;
  static const Color neonRed = NvsColors.neonRed;
  static const Color neonYellow = NvsColors.neonYellow;
  static const Color secondaryMint = NvsColors.secondaryMint;
  static const Color primaryText = NvsColors.primaryText;
  static const Color glitchAqua = NvsColors.glitchAqua;
  static const Color glitchOlive = NvsColors.glitchOlive;
  static const Color glitchRed = NvsColors.glitchRed;
  static const Color glitchPink = NvsColors.glitchPink;
  static const Color meatMarketAccent = NvsColors.meatMarketAccent;
  static const Color meatMarketPrimary = NvsColors.meatMarketPrimary;
  static const Color meatMarketSteel = NvsColors.meatMarketSteel;
  static const Color meatMarketMint = NvsColors.meatMarketMint;

  // Additional compatibility aliases
  static const Color neonGreen = NvsColors.neonGreen;
  static const Color primaryGreenAccent = NvsColors.primaryGreenAccent;
  static const Color nvsBlack = NvsColors.nvsBlack;
  static const Color darkBackground = NvsColors.darkBackground;
  static const Color secondaryAmber = NvsColors.secondaryAmber;
  static const Color scannerGlow = NvsColors.scannerGlow;
  static const Color aquaOutline = NvsColors.aquaOutline;
  static const Color primaryNeonMint = NvsColors.primaryNeonMint;
  static const Color meatMarketTeal = NvsColors.meatMarketTeal;
  static const Color steelBright = NvsColors.steelBright;
  static const Color chromeGray = NvsColors.chromeGray;
  static const Color frostMint = NvsColors.frostMint;
  static const Color holoCyan = NvsColors.holoCyan;
  static const Color frostBlue = NvsColors.frostBlue;
  static const Color iceBlue = NvsColors.iceBlue;
  static const Color bioMint = NvsColors.bioMint;
  static const Color arcticWhite = NvsColors.arcticWhite;
  static const Color emberRed = NvsColors.emberRed;
  static const Color alertRed = NvsColors.alertRed;
  static const Color hangingChainSteel = NvsColors.hangingChainSteel;
  static const Color coldRoomFrost = NvsColors.coldRoomFrost;
  static const Color coldRoomCyan = NvsColors.coldRoomCyan;
  static const Color coldRoomBlue = NvsColors.coldRoomBlue;
  static const Color coldRoomIce = NvsColors.coldRoomIce;
  static const Color hydroMint = NvsColors.hydroMint;
  static const Color surgicalWhite = NvsColors.surgicalWhite;
  static const Color hazardAmber = NvsColors.hazardAmber;
  static const Color hazardRed = NvsColors.hazardRed;
  static const Color profileAccentMint = NvsColors.profileAccentMint;
  static const Color profileSignalLime = NvsColors.profileSignalLime;

  static const double breatheMin = NvsColors.breatheMin;
  static const double breatheMax = NvsColors.breatheMax;
  static const Color panelBackground = NvsColors.panelBackground;
  static const Color mint = NvsColors.mint;
  static const Color mintSoft = NvsColors.mintSoft;
  static const Color bg = NvsColors.bg;
  static const Color borderColor = NvsColors.borderColor;

  static List<BoxShadow> get liquidGlassLight => NvsColors.liquidGlassLight;
  static List<BoxShadow> get primaryGlowSoft => NvsColors.primaryGlowSoft;
  static List<BoxShadow> get primaryGlowMedium => NvsColors.primaryGlowMedium;
  static List<BoxShadow> get primaryGlowStrong => NvsColors.primaryGlowStrong;
  static List<BoxShadow> get oliveGlow => NvsColors.oliveGlow;
  static List<BoxShadow> get aquaGlow => NvsColors.aquaGlow;
  static List<BoxShadow> get aquaGlowIntense => NvsColors.aquaGlowIntense;
  static List<BoxShadow> get meatMarketShadow => NvsColors.meatMarketShadow;
  static List<BoxShadow> get meatMarketSteelShadow =>
      NvsColors.meatMarketSteelShadow;
  static List<Shadow> get aquaTextGlow => NvsColors.aquaTextGlow;
  static List<Shadow> get oliveTextGlow => NvsColors.oliveTextGlow;
  static List<Shadow> get primaryTextShadow => NvsColors.primaryTextShadow;
  static LinearGradient get meatMarketSteelGradient =>
      NvsColors.meatMarketSteelGradient;
}

class NVSFonts {
  static const String primary = NvsFonts.primary;
  static const String secondary = NvsFonts.secondary;
}
