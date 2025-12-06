import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

class NvsChip extends StatelessWidget {
  const NvsChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
    this.icon,
  });
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? NVSColors.primaryNeonMint.withValues(alpha: 0.2)
              : NVSColors.cardBackground.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? NVSColors.primaryNeonMint : NVSColors.dividerColor,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? <BoxShadow>[
                  BoxShadow(
                    color: NVSColors.primaryNeonMint.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (icon != null) ...<Widget>[
              Icon(
                icon,
                size: 16,
                color: isSelected ? NVSColors.primaryNeonMint : NVSColors.secondaryText,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isSelected ? NVSColors.primaryNeonMint : NVSColors.ultraLightMint,
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
