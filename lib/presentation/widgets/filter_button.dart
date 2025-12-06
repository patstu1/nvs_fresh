import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';
import 'package:nvs/theme/nvs_palette.dart';
// import 'package:nvs/nvs_icons.dart'; // Assuming custom icons are defined here

class FilterButton extends StatelessWidget {
  const FilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Implement filter sheet navigation
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: NVSPalette.background.withValues(alpha: 0.7),
          shape: BoxShape.circle,
          border: Border.all(color: NVSPalette.textTertiary),
          boxShadow: NVSPalette.primaryGlow,
        ),
        child: const Icon(
          Icons.tune, // Use built-in filter icon
          color: NVSPalette.primary,
          size: 28,
        ),
      ),
    );
  }
}
