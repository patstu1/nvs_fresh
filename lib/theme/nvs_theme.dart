import 'package:flutter/material.dart';
import 'nvs_palette.dart';

class NVSTheme {
  static ThemeData build() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: NVSPalette.surfaceDark,
      primaryColor: NVSPalette.mint,
      cardTheme: const CardTheme(
        color: NVSPalette.chromeGray,
        margin: EdgeInsets.all(8),
        elevation: 0,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: NVSPalette.surfaceDark,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: NVSPalette.pureBlack,
        indicatorColor: NVSPalette.mint.withOpacity(0.2),
        labelTextStyle: MaterialStateProperty.all(
          const TextStyle(color: Colors.white),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: NVSPalette.chromeGray,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: NVSPalette.mediumGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: NVSPalette.mint, width: 1.5),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
        titleLarge: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: NVSPalette.mint,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(NVSPalette.mint),
          foregroundColor:
              MaterialStateProperty.all(NVSPalette.pureBlack),
        ),
      ),
    );
  }
}
