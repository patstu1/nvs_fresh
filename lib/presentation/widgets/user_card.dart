import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

class UserCard extends StatelessWidget {
  final String matchPercentage;
  final String userName;
  final String age;
  final bool isOnline;
  final bool hasImage;

  const UserCard({
    required this.matchPercentage,
    required this.userName,
    required this.age,
    required this.isOnline,
    required this.hasImage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: NVSColors.neonMint.withValues(alpha: 0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          // Match percentage
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                matchPercentage,
                style: const TextStyle(
                  color: NVSColors.neonMint,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Favorite button
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: NVSColors.neonMint.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.favorite_border,
                color: NVSColors.neonMint,
                size: 24,
              ),
            ),
          ),

          // User info at bottom
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Row(
              children: [
                Text(
                  '$userName, $age',
                  style: const TextStyle(
                    color: NVSColors.neonMint,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 4),
                if (isOnline)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: NVSColors.neonMint,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
