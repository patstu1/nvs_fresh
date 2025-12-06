import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

class RoleBadge extends StatelessWidget {
  final String emoji;
  final String role;

  const RoleBadge({
    super.key,
    required this.emoji,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: NVSColors.neonMint.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: NVSColors.neonMint.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(width: 4),
          Text(
            role,
            style: const TextStyle(
              fontFamily: 'MagdaCleanMono',
              color: NVSColors.ultraLightMint,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
