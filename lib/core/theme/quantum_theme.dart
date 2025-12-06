// lib/core/theme/quantum_theme.dart
// Unified Quantum Theme System for NVS 2027+ Architecture
// Replaces all fragmented theme implementations with a single, bio-responsive theme

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'quantum_design_tokens.dart';

/// Quantum Theme System
/// Bio-responsive, performance-optimized theme for neural engagement
/// Consolidates: nvs_theme.dart, app_theme.dart, and all color references
class QuantumTheme {
  /// Primary theme for the entire NVS application
  /// This replaces all existing theme implementations
  static ThemeData get quantumDark {
    return ThemeData(
      // ============================================================================
      // CORE THEME CONFIGURATION
      // ============================================================================
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: QuantumDesignTokens.fontPrimary,

      // ============================================================================
      // COLOR SCHEME - Quantum Cyberpunk Palette
      // ============================================================================
      colorScheme: const ColorScheme.dark(
        // Primary colors
        primary: QuantumDesignTokens.neonMint,
        primaryContainer: QuantumDesignTokens.cardBackground,
        onPrimaryContainer: QuantumDesignTokens.ultraLightMint,

        // Secondary colors
        secondary: QuantumDesignTokens.turquoiseNeon,
        secondaryContainer: QuantumDesignTokens.deepCardBackground,
        onSecondaryContainer: QuantumDesignTokens.turquoiseNeon,

        // Tertiary colors
        tertiary: QuantumDesignTokens.avocadoGreen,
        onTertiary: QuantumDesignTokens.pureBlack,
        tertiaryContainer: QuantumDesignTokens.elevatedSurface,
        onTertiaryContainer: QuantumDesignTokens.avocadoGreen,

        // Error colors
        error: QuantumDesignTokens.scannerRed,
        onError: QuantumDesignTokens.textOnDark,
        errorContainer: QuantumDesignTokens.scannerRed.withValues(alpha: 0.2),
        onErrorContainer: QuantumDesignTokens.scannerRed,

        // Surface colors
        surface: QuantumDesignTokens.pureBlack,
        onSurface: QuantumDesignTokens.textPrimary,
        onSurfaceVariant: QuantumDesignTokens.textSecondary,

        // Outline colors
        outline: QuantumDesignTokens.neonMint.withValues(alpha: 0.3),
        outlineVariant: QuantumDesignTokens.turquoiseNeon.withValues(alpha: 0.2),

        // Container colors
        surfaceContainerHighest: QuantumDesignTokens.elevatedSurface,
        surfaceContainerHigh: QuantumDesignTokens.cardBackground,
        surfaceContainer: QuantumDesignTokens.deepCardBackground,
        surfaceContainerLow: QuantumDesignTokens.voidBlack,
        surfaceContainerLowest: QuantumDesignTokens.pureBlack,

        // Inverse colors for accessibility
        inversePrimary: QuantumDesignTokens.pureBlack,
        inverseSurface: QuantumDesignTokens.textPrimary,
        onInverseSurface: QuantumDesignTokens.pureBlack,

        // Shadows
        shadow: QuantumDesignTokens.pureBlack,
        scrim: QuantumDesignTokens.pureBlack.withValues(alpha: 0.8),
      ),

      // ============================================================================
      // SCAFFOLD THEME
      // ============================================================================
      scaffoldBackgroundColor: QuantumDesignTokens.pureBlack,

      // ============================================================================
      // APP BAR THEME - Quantum Command Interface
      // ============================================================================
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: QuantumDesignTokens.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: QuantumDesignTokens.pureBlack,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        titleTextStyle: QuantumDesignTokens.createQuantumTextStyle(
          fontSize: QuantumDesignTokens.fontXL,
          fontWeight: QuantumDesignTokens.weightBold,
          glowIntensity: 0.4,
        ),
        iconTheme: const IconThemeData(
          color: QuantumDesignTokens.neonMint,
          size: QuantumDesignTokens.iconLG,
        ),
        actionsIconTheme: const IconThemeData(
          color: QuantumDesignTokens.turquoiseNeon,
          size: QuantumDesignTokens.iconMD,
        ),
      ),

      // ============================================================================
      // BOTTOM NAVIGATION BAR THEME - Neural Interface
      // ============================================================================
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: QuantumDesignTokens.neonMint,
        unselectedItemColor: QuantumDesignTokens.textTertiary,
        selectedLabelStyle: TextStyle(
          fontFamily: QuantumDesignTokens.fontPrimary,
          fontSize: QuantumDesignTokens.fontXS,
          fontWeight: QuantumDesignTokens.weightBold,
          letterSpacing: QuantumDesignTokens.letterSpacingWide,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: QuantumDesignTokens.fontPrimary,
          fontSize: QuantumDesignTokens.fontNano,
          fontWeight: QuantumDesignTokens.weightRegular,
        ),
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),

      // ============================================================================
      // CARD THEME - Quantum Containers
      // ============================================================================
      cardTheme: CardThemeData(
        color: QuantumDesignTokens.cardBackground,
        elevation: 0,
        shadowColor: QuantumDesignTokens.neonMint.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(QuantumDesignTokens.radiusLG),
          side: BorderSide(
            color: QuantumDesignTokens.neonMint.withValues(alpha: 0.3),
          ),
        ),
        margin: const EdgeInsets.all(QuantumDesignTokens.spaceMD),
      ),

      // ============================================================================
      // BUTTON THEMES - Interactive Elements
      // ============================================================================

      // Elevated Button - Primary Actions
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: QuantumDesignTokens.neonMint,
          foregroundColor: QuantumDesignTokens.pureBlack,
          elevation: 0,
          shadowColor: QuantumDesignTokens.neonMint.withValues(alpha: 0.5),
          padding: const EdgeInsets.symmetric(
            horizontal: QuantumDesignTokens.spaceXL,
            vertical: QuantumDesignTokens.spaceMD,
          ),
          minimumSize: const Size(
            QuantumDesignTokens.hitTargetRECOMMENDED,
            QuantumDesignTokens.buttonHeightMD,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(QuantumDesignTokens.radiusMD),
          ),
          textStyle: const TextStyle(
            fontFamily: QuantumDesignTokens.fontPrimary,
            fontSize: QuantumDesignTokens.fontSM,
            fontWeight: QuantumDesignTokens.weightBold,
            letterSpacing: QuantumDesignTokens.letterSpacingWide,
          ),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return QuantumDesignTokens.turquoiseNeon.withValues(alpha: 0.3);
            }
            if (states.contains(WidgetState.hovered)) {
              return QuantumDesignTokens.avocadoGreen.withValues(alpha: 0.2);
            }
            return null;
          }),
          backgroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return QuantumDesignTokens.interactiveDisabled;
            }
            if (states.contains(WidgetState.pressed)) {
              return QuantumDesignTokens.avocadoGreen;
            }
            if (states.contains(WidgetState.hovered)) {
              return QuantumDesignTokens.turquoiseNeon;
            }
            return QuantumDesignTokens.neonMint;
          }),
        ),
      ),

      // Outlined Button - Secondary Actions
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: QuantumDesignTokens.neonMint,
          backgroundColor: Colors.transparent,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: QuantumDesignTokens.spaceXL,
            vertical: QuantumDesignTokens.spaceMD,
          ),
          minimumSize: const Size(
            QuantumDesignTokens.hitTargetRECOMMENDED,
            QuantumDesignTokens.buttonHeightMD,
          ),
          side: const BorderSide(
            color: QuantumDesignTokens.neonMint,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(QuantumDesignTokens.radiusMD),
          ),
          textStyle: const TextStyle(
            fontFamily: QuantumDesignTokens.fontPrimary,
            fontSize: QuantumDesignTokens.fontSM,
            fontWeight: QuantumDesignTokens.weightBold,
            letterSpacing: QuantumDesignTokens.letterSpacingWide,
          ),
        ).copyWith(
          foregroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return QuantumDesignTokens.interactiveDisabled;
            }
            if (states.contains(WidgetState.pressed)) {
              return QuantumDesignTokens.avocadoGreen;
            }
            if (states.contains(WidgetState.hovered)) {
              return QuantumDesignTokens.turquoiseNeon;
            }
            return QuantumDesignTokens.neonMint;
          }),
          side: WidgetStateProperty.resolveWith<BorderSide>((Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return const BorderSide(
                color: QuantumDesignTokens.interactiveDisabled,
                width: 1.5,
              );
            }
            if (states.contains(WidgetState.pressed)) {
              return const BorderSide(
                color: QuantumDesignTokens.avocadoGreen,
                width: 2,
              );
            }
            if (states.contains(WidgetState.hovered)) {
              return const BorderSide(
                color: QuantumDesignTokens.turquoiseNeon,
                width: 1.5,
              );
            }
            return const BorderSide(
              color: QuantumDesignTokens.neonMint,
              width: 1.5,
            );
          }),
        ),
      ),

      // Text Button - Tertiary Actions
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: QuantumDesignTokens.textSecondary,
          backgroundColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(
            horizontal: QuantumDesignTokens.spaceLG,
            vertical: QuantumDesignTokens.spaceSM,
          ),
          minimumSize: const Size(
            QuantumDesignTokens.hitTargetRECOMMENDED,
            QuantumDesignTokens.buttonHeightSM,
          ),
          textStyle: const TextStyle(
            fontFamily: QuantumDesignTokens.fontPrimary,
            fontSize: QuantumDesignTokens.fontSM,
            fontWeight: QuantumDesignTokens.weightMedium,
            letterSpacing: QuantumDesignTokens.letterSpacingNormal,
          ),
        ).copyWith(
          foregroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return QuantumDesignTokens.textDisabled;
            }
            if (states.contains(WidgetState.pressed)) {
              return QuantumDesignTokens.avocadoGreen;
            }
            if (states.contains(WidgetState.hovered)) {
              return QuantumDesignTokens.neonMint;
            }
            return QuantumDesignTokens.textSecondary;
          }),
        ),
      ),

      // Floating Action Button - Quantum Portal
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: QuantumDesignTokens.neonMint,
        foregroundColor: QuantumDesignTokens.pureBlack,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        disabledElevation: 0,
        shape: CircleBorder(),
      ),

      // ============================================================================
      // INPUT DECORATION THEME - Neural Interfaces
      // ============================================================================
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: QuantumDesignTokens.cardBackground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: QuantumDesignTokens.spaceLG,
          vertical: QuantumDesignTokens.spaceMD,
        ),

        // Border styles
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(QuantumDesignTokens.radiusMD),
          borderSide: BorderSide(
            color: QuantumDesignTokens.neonMint.withValues(alpha: 0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(QuantumDesignTokens.radiusMD),
          borderSide: BorderSide(
            color: QuantumDesignTokens.neonMint.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(QuantumDesignTokens.radiusMD),
          borderSide: const BorderSide(
            color: QuantumDesignTokens.neonMint,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(QuantumDesignTokens.radiusMD),
          borderSide: const BorderSide(
            color: QuantumDesignTokens.scannerRed,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(QuantumDesignTokens.radiusMD),
          borderSide: const BorderSide(
            color: QuantumDesignTokens.scannerRed,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(QuantumDesignTokens.radiusMD),
          borderSide: const BorderSide(
            color: QuantumDesignTokens.interactiveDisabled,
          ),
        ),

        // Text styles
        labelStyle: const TextStyle(
          fontFamily: QuantumDesignTokens.fontSecondary,
          fontSize: QuantumDesignTokens.fontSM,
          color: QuantumDesignTokens.textSecondary,
          fontWeight: QuantumDesignTokens.weightRegular,
        ),
        hintStyle: const TextStyle(
          fontFamily: QuantumDesignTokens.fontSecondary,
          fontSize: QuantumDesignTokens.fontSM,
          color: QuantumDesignTokens.textTertiary,
          fontWeight: QuantumDesignTokens.weightRegular,
        ),
        helperStyle: const TextStyle(
          fontFamily: QuantumDesignTokens.fontSecondary,
          fontSize: QuantumDesignTokens.fontXS,
          color: QuantumDesignTokens.textTertiary,
        ),
        errorStyle: const TextStyle(
          fontFamily: QuantumDesignTokens.fontSecondary,
          fontSize: QuantumDesignTokens.fontXS,
          color: QuantumDesignTokens.scannerRed,
          fontWeight: QuantumDesignTokens.weightMedium,
        ),
      ),

      // ============================================================================
      // TEXT THEME - Neural Typography Hierarchy
      // ============================================================================
      textTheme: TextTheme(
        // Display styles - Maximum impact
        displayLarge: QuantumDesignTokens.createQuantumTextStyle(
          fontSize: QuantumDesignTokens.fontQuantum,
          fontWeight: QuantumDesignTokens.weightBlack,
          glowIntensity: 0.7,
        ),
        displayMedium: QuantumDesignTokens.createQuantumTextStyle(
          fontSize: QuantumDesignTokens.fontCosmic,
          fontWeight: QuantumDesignTokens.weightBlack,
          glowIntensity: 0.6,
        ),
        displaySmall: QuantumDesignTokens.createQuantumTextStyle(
          fontSize: QuantumDesignTokens.fontGiga,
          fontWeight: QuantumDesignTokens.weightBold,
        ),

        // Headline styles - Section headers
        headlineLarge: QuantumDesignTokens.createQuantumTextStyle(
          fontSize: QuantumDesignTokens.fontXXL,
          fontWeight: QuantumDesignTokens.weightBold,
          glowIntensity: 0.4,
        ),
        headlineMedium: QuantumDesignTokens.createQuantumTextStyle(
          fontSize: QuantumDesignTokens.fontXL,
          fontWeight: QuantumDesignTokens.weightBold,
          glowIntensity: 0.3,
        ),
        headlineSmall: QuantumDesignTokens.createQuantumTextStyle(
          fontSize: QuantumDesignTokens.fontLG,
          fontWeight: QuantumDesignTokens.weightBold,
          glowIntensity: 0.2,
        ),

        // Title styles - Component headers
        titleLarge: const TextStyle(
          fontFamily: QuantumDesignTokens.fontPrimary,
          fontSize: QuantumDesignTokens.fontLG,
          fontWeight: QuantumDesignTokens.weightBold,
          color: QuantumDesignTokens.textPrimary,
          letterSpacing: QuantumDesignTokens.letterSpacingWide,
          height: QuantumDesignTokens.lineHeightNormal,
        ),
        titleMedium: const TextStyle(
          fontFamily: QuantumDesignTokens.fontPrimary,
          fontSize: QuantumDesignTokens.fontMD,
          fontWeight: QuantumDesignTokens.weightBold,
          color: QuantumDesignTokens.textPrimary,
          letterSpacing: QuantumDesignTokens.letterSpacingNormal,
          height: QuantumDesignTokens.lineHeightNormal,
        ),
        titleSmall: const TextStyle(
          fontFamily: QuantumDesignTokens.fontPrimary,
          fontSize: QuantumDesignTokens.fontSM,
          fontWeight: QuantumDesignTokens.weightSemiBold,
          color: QuantumDesignTokens.textSecondary,
          letterSpacing: QuantumDesignTokens.letterSpacingNormal,
          height: QuantumDesignTokens.lineHeightNormal,
        ),

        // Body styles - Content text
        bodyLarge: const TextStyle(
          fontFamily: QuantumDesignTokens.fontPrimary,
          fontSize: QuantumDesignTokens.fontMD,
          fontWeight: QuantumDesignTokens.weightRegular,
          color: QuantumDesignTokens.textPrimary,
          letterSpacing: QuantumDesignTokens.letterSpacingNormal,
          height: QuantumDesignTokens.lineHeightRelaxed,
        ),
        bodyMedium: const TextStyle(
          fontFamily: QuantumDesignTokens.fontPrimary,
          fontSize: QuantumDesignTokens.fontSM,
          fontWeight: QuantumDesignTokens.weightRegular,
          color: QuantumDesignTokens.textSecondary,
          letterSpacing: QuantumDesignTokens.letterSpacingNormal,
          height: QuantumDesignTokens.lineHeightRelaxed,
        ),
        bodySmall: const TextStyle(
          fontFamily: QuantumDesignTokens.fontPrimary,
          fontSize: QuantumDesignTokens.fontXS,
          fontWeight: QuantumDesignTokens.weightRegular,
          color: QuantumDesignTokens.textTertiary,
          letterSpacing: QuantumDesignTokens.letterSpacingNormal,
          height: QuantumDesignTokens.lineHeightNormal,
        ),

        // Label styles - Technical elements
        labelLarge: const TextStyle(
          fontFamily: QuantumDesignTokens.fontSecondary,
          fontSize: QuantumDesignTokens.fontSM,
          fontWeight: QuantumDesignTokens.weightMedium,
          color: QuantumDesignTokens.neonMint,
          letterSpacing: QuantumDesignTokens.letterSpacingWide,
          height: QuantumDesignTokens.lineHeightTight,
        ),
        labelMedium: const TextStyle(
          fontFamily: QuantumDesignTokens.fontSecondary,
          fontSize: QuantumDesignTokens.fontXS,
          fontWeight: QuantumDesignTokens.weightMedium,
          color: QuantumDesignTokens.turquoiseNeon,
          letterSpacing: QuantumDesignTokens.letterSpacingWide,
          height: QuantumDesignTokens.lineHeightTight,
        ),
        labelSmall: const TextStyle(
          fontFamily: QuantumDesignTokens.fontSecondary,
          fontSize: QuantumDesignTokens.fontMicro,
          fontWeight: QuantumDesignTokens.weightMedium,
          color: QuantumDesignTokens.textTertiary,
          letterSpacing: QuantumDesignTokens.letterSpacingNormal,
          height: QuantumDesignTokens.lineHeightTight,
        ),
      ),

      // ============================================================================
      // ICON THEME - Cyberpunk Iconography
      // ============================================================================
      iconTheme: const IconThemeData(
        color: QuantumDesignTokens.neonMint,
        size: QuantumDesignTokens.iconMD,
        opacity: 1.0,
      ),
      primaryIconTheme: const IconThemeData(
        color: QuantumDesignTokens.pureBlack,
        size: QuantumDesignTokens.iconMD,
        opacity: 1.0,
      ),

      // ============================================================================
      // DIVIDER THEME - Quantum Separators
      // ============================================================================
      dividerTheme: DividerThemeData(
        color: QuantumDesignTokens.neonMint.withValues(alpha: 0.2),
        thickness: 1,
        space: QuantumDesignTokens.spaceMD,
      ),

      // ============================================================================
      // SWITCH THEME - Bio-Responsive Toggles
      // ============================================================================
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return QuantumDesignTokens.interactiveDisabled;
          }
          if (states.contains(WidgetState.selected)) {
            return QuantumDesignTokens.neonMint;
          }
          return QuantumDesignTokens.textTertiary;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return QuantumDesignTokens.cardBackground;
          }
          if (states.contains(WidgetState.selected)) {
            return QuantumDesignTokens.neonMint.withValues(alpha: 0.3);
          }
          return QuantumDesignTokens.cardBackground;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.transparent;
          }
          return QuantumDesignTokens.neonMint.withValues(alpha: 0.5);
        }),
      ),

      // ============================================================================
      // LIST TILE THEME - Information Hierarchies
      // ============================================================================
      listTileTheme: const ListTileThemeData(
        tileColor: Colors.transparent,
        selectedTileColor: QuantumDesignTokens.cardBackground,
        iconColor: QuantumDesignTokens.neonMint,
        textColor: QuantumDesignTokens.textPrimary,
        selectedColor: QuantumDesignTokens.neonMint,
        contentPadding: EdgeInsets.symmetric(
          horizontal: QuantumDesignTokens.spaceLG,
          vertical: QuantumDesignTokens.spaceSM,
        ),
        titleTextStyle: TextStyle(
          fontFamily: QuantumDesignTokens.fontPrimary,
          fontSize: QuantumDesignTokens.fontMD,
          fontWeight: QuantumDesignTokens.weightBold,
          color: QuantumDesignTokens.textPrimary,
          letterSpacing: QuantumDesignTokens.letterSpacingNormal,
        ),
        subtitleTextStyle: TextStyle(
          fontFamily: QuantumDesignTokens.fontPrimary,
          fontSize: QuantumDesignTokens.fontSM,
          fontWeight: QuantumDesignTokens.weightRegular,
          color: QuantumDesignTokens.textSecondary,
        ),
        leadingAndTrailingTextStyle: TextStyle(
          fontFamily: QuantumDesignTokens.fontSecondary,
          fontSize: QuantumDesignTokens.fontXS,
          fontWeight: QuantumDesignTokens.weightMedium,
          color: QuantumDesignTokens.turquoiseNeon,
        ),
      ),

      // ============================================================================
      // BOTTOM SHEET THEME - Modal Quantum Interfaces
      // ============================================================================
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: QuantumDesignTokens.pureBlack,
        modalBackgroundColor: QuantumDesignTokens.cardBackground,
        elevation: 0,
        modalElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(QuantumDesignTokens.radiusXL),
          ),
        ),
        constraints: BoxConstraints(),
      ),

      // ============================================================================
      // DIALOG THEME - Quantum Modals
      // ============================================================================
      dialogTheme: DialogThemeData(
        backgroundColor: QuantumDesignTokens.cardBackground,
        elevation: 0,
        shadowColor: QuantumDesignTokens.neonMint.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(QuantumDesignTokens.radiusXL),
          side: BorderSide(
            color: QuantumDesignTokens.neonMint.withValues(alpha: 0.5),
          ),
        ),
        titleTextStyle: QuantumDesignTokens.createQuantumTextStyle(
          fontSize: QuantumDesignTokens.fontXL,
          fontWeight: QuantumDesignTokens.weightBold,
          glowIntensity: 0.3,
        ),
        contentTextStyle: const TextStyle(
          fontFamily: QuantumDesignTokens.fontPrimary,
          fontSize: QuantumDesignTokens.fontSM,
          fontWeight: QuantumDesignTokens.weightRegular,
          color: QuantumDesignTokens.textSecondary,
        ),
      ),

      // ============================================================================
      // SNACK BAR THEME - Quantum Notifications
      // ============================================================================
      snackBarTheme: SnackBarThemeData(
        backgroundColor: QuantumDesignTokens.elevatedSurface,
        contentTextStyle: const TextStyle(
          fontFamily: QuantumDesignTokens.fontPrimary,
          fontSize: QuantumDesignTokens.fontSM,
          fontWeight: QuantumDesignTokens.weightMedium,
          color: QuantumDesignTokens.textPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(QuantumDesignTokens.radiusMD),
          side: BorderSide(
            color: QuantumDesignTokens.neonMint.withValues(alpha: 0.3),
          ),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      ),

      // ============================================================================
      // TOOLTIP THEME - Contextual Information
      // ============================================================================
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: QuantumDesignTokens.elevatedSurface,
          borderRadius: BorderRadius.circular(QuantumDesignTokens.radiusSM),
          border: Border.all(
            color: QuantumDesignTokens.neonMint.withValues(alpha: 0.3),
          ),
          boxShadow: QuantumDesignTokens.mintGlowSoft,
        ),
        textStyle: const TextStyle(
          fontFamily: QuantumDesignTokens.fontSecondary,
          fontSize: QuantumDesignTokens.fontXS,
          fontWeight: QuantumDesignTokens.weightMedium,
          color: QuantumDesignTokens.textPrimary,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: QuantumDesignTokens.spaceMD,
          vertical: QuantumDesignTokens.spaceSM,
        ),
      ),

      // ============================================================================
      // CHECKBOX THEME - Selection Interfaces
      // ============================================================================
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return QuantumDesignTokens.interactiveDisabled;
          }
          if (states.contains(WidgetState.selected)) {
            return QuantumDesignTokens.neonMint;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(QuantumDesignTokens.pureBlack),
        side: WidgetStateBorderSide.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return const BorderSide(
              color: QuantumDesignTokens.interactiveDisabled,
              width: 1.5,
            );
          }
          return const BorderSide(
            color: QuantumDesignTokens.neonMint,
            width: 1.5,
          );
        }),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(QuantumDesignTokens.radiusXS),
        ),
      ),

      // ============================================================================
      // RADIO THEME - Selection Interfaces
      // ============================================================================
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return QuantumDesignTokens.interactiveDisabled;
          }
          if (states.contains(WidgetState.selected)) {
            return QuantumDesignTokens.neonMint;
          }
          return QuantumDesignTokens.textTertiary;
        }),
      ),

      // ============================================================================
      // PROGRESS INDICATOR THEME - Loading States
      // ============================================================================
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: QuantumDesignTokens.neonMint,
        linearTrackColor: QuantumDesignTokens.cardBackground,
        circularTrackColor: QuantumDesignTokens.cardBackground,
        refreshBackgroundColor: QuantumDesignTokens.pureBlack,
      ),

      // ============================================================================
      // SLIDER THEME - Continuous Input
      // ============================================================================
      sliderTheme: SliderThemeData(
        activeTrackColor: QuantumDesignTokens.neonMint,
        inactiveTrackColor: QuantumDesignTokens.cardBackground,
        thumbColor: QuantumDesignTokens.neonMint,
        overlayColor: QuantumDesignTokens.neonMint.withValues(alpha: 0.2),
        valueIndicatorColor: QuantumDesignTokens.elevatedSurface,
        valueIndicatorTextStyle: const TextStyle(
          fontFamily: QuantumDesignTokens.fontSecondary,
          fontSize: QuantumDesignTokens.fontXS,
          fontWeight: QuantumDesignTokens.weightMedium,
          color: QuantumDesignTokens.textPrimary,
        ),
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 8,
          disabledThumbRadius: 6,
        ),
        trackHeight: 4,
      ),

      // ============================================================================
      // TAB BAR THEME - Navigation Interfaces
      // ============================================================================
      tabBarTheme: const TabBarThemeData(
        labelColor: QuantumDesignTokens.neonMint,
        unselectedLabelColor: QuantumDesignTokens.textTertiary,
        labelStyle: TextStyle(
          fontFamily: QuantumDesignTokens.fontPrimary,
          fontSize: QuantumDesignTokens.fontSM,
          fontWeight: QuantumDesignTokens.weightBold,
          letterSpacing: QuantumDesignTokens.letterSpacingWide,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: QuantumDesignTokens.fontPrimary,
          fontSize: QuantumDesignTokens.fontSM,
          fontWeight: QuantumDesignTokens.weightRegular,
        ),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: QuantumDesignTokens.neonMint,
            width: 2,
          ),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: QuantumDesignTokens.cardBackground,
        overlayColor: WidgetStatePropertyAll(
          Color(0x1A00FFA3), // neonMint with 0.1 alpha
        ),
      ),
    );
  }

  /// Bio-responsive theme variant that adapts to user biometric state
  static ThemeData getBioResponsiveTheme({
    required double arousalLevel,
    required double heartRate,
    bool enableQuantumEffects = true,
  }) {
    final ThemeData baseTheme = quantumDark;
    final Color bioColor = QuantumDesignTokens.getBioResponsiveColor(arousalLevel);
    // final bioGradient = QuantumDesignTokens.createBioSyncGradient(heartRate);

    return baseTheme.copyWith(
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: bioColor,
        secondary: bioColor.withValues(alpha: 0.7),
      ),
      floatingActionButtonTheme: baseTheme.floatingActionButtonTheme.copyWith(
        backgroundColor: bioColor,
      ),
      progressIndicatorTheme: baseTheme.progressIndicatorTheme.copyWith(
        color: bioColor,
      ),
    );
  }

  /// Get theme optimized for specific performance tier
  static ThemeData getPerformanceOptimizedTheme({
    required int targetFPS,
    bool enableGlowEffects = true,
    bool enableAnimations = true,
  }) {
    final ThemeData baseTheme = quantumDark;

    if (targetFPS < 60) {
      // Reduced performance mode
      return baseTheme.copyWith(
        // Disable shadows and glow effects
        cardTheme: baseTheme.cardTheme.copyWith(
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        // Simplified text styles without glow
        textTheme: baseTheme.textTheme.copyWith(
          displayLarge: baseTheme.textTheme.displayLarge?.copyWith(),
          displayMedium: baseTheme.textTheme.displayMedium?.copyWith(),
          displaySmall: baseTheme.textTheme.displaySmall?.copyWith(),
        ),
      );
    }

    return baseTheme;
  }
}

/// Legacy color compatibility
/// Provides backward compatibility for existing components
class NVSColors {
  // Redirect all legacy color references to QuantumDesignTokens
  static const Color pureBlack = QuantumDesignTokens.pureBlack;
  static const Color ultraLightMint = QuantumDesignTokens.ultraLightMint;
  static const Color neonMint = QuantumDesignTokens.neonMint;
  static const Color turquoiseNeon = QuantumDesignTokens.turquoiseNeon;
  static const Color avocadoGreen = QuantumDesignTokens.avocadoGreen;
  static const Color cardBackground = QuantumDesignTokens.cardBackground;
  static const Color textPrimary = QuantumDesignTokens.textPrimary;
  static const Color textSecondary = QuantumDesignTokens.textSecondary;
  static const Color primaryGlow = QuantumDesignTokens.ultraLightMint;
  static const Color primaryNeonMint = QuantumDesignTokens.neonMint;
  static const Color ultraLightNeonMint = QuantumDesignTokens.ultraLightMint;
  static const Color matteBlack = QuantumDesignTokens.pureBlack;
  static const Color oliveGreenNeon = QuantumDesignTokens.avocadoGreen;
  static const Color neonGreen = QuantumDesignTokens.avocadoGreen;
  static const Color errorColor = QuantumDesignTokens.scannerRed;
  static const Color neonOrange = QuantumDesignTokens.cyberOrange;
  static const Color darkBackground = QuantumDesignTokens.pureBlack;
  static const Color aquaOutline = QuantumDesignTokens.turquoiseNeon;
  static const Color neonLime = QuantumDesignTokens.avocadoGreen;
  static const Color neonPurple = QuantumDesignTokens.electricPurple;
  static const Color electricBlue = QuantumDesignTokens.hologramBlue;
  static const Color secondaryText = QuantumDesignTokens.textSecondary;
  static const Color disabledText = QuantumDesignTokens.textDisabled;
  static const Color dividerColor = QuantumDesignTokens.textTertiary;

  // Legacy shadow getters
  static List<BoxShadow> get mintGlow => QuantumDesignTokens.mintGlowMedium;
  static List<BoxShadow> get avocadoGlow => QuantumDesignTokens.turquoiseGlow;
  static List<Shadow> get mintTextShadow => QuantumDesignTokens.textGlowMedium;
}
