import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

class HolographicToggleButton extends StatelessWidget {
  const HolographicToggleButton({
    required this.text,
    required this.isActive,
    required this.onTap,
    super.key,
  });
  final String text;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? NVSColors.neonMint.withValues(alpha: 0.2) : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: isActive ? NVSColors.neonMint : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: isActive
                  ? NVSTextStyles.cardTitle.copyWith(color: NVSColors.ultraLightMint)
                  : NVSTextStyles.cardTitle.copyWith(color: NVSColors.secondaryText),
            ),
          ),
        ),
      ),
    );
  }
}
