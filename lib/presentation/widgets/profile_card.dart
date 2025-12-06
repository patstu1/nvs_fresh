import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';
import 'role_badge.dart';
import 'match_percentage.dart';

class ProfileCard extends StatelessWidget {
  final UserProfile user;
  final VoidCallback onTap;

  const ProfileCard({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: NVSColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: NVSColors.neonMint.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: NVSColors.neonMint.withValues(alpha: 0.2),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            // Profile image with match percentage overlay
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                    child: user.avatarUrl.isNotEmpty
                        ? Image.network(
                            user.avatarUrl,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: NVSColors.cardBackground,
                                  child: const Icon(
                                    Icons.person,
                                    size: 40,
                                    color: NVSColors.secondaryText,
                                  ),
                                ),
                          )
                        : Container(
                            color: NVSColors.cardBackground,
                            child: const Icon(
                              Icons.person,
                              size: 40,
                              color: NVSColors.secondaryText,
                            ),
                          ),
                  ),
                  // Match percentage overlay
                  Positioned(
                    top: 8,
                    right: 8,
                    child: MatchPercentage(
                      percentage:
                          85, // Default compatibility since UserProfile doesn't have this
                    ),
                  ),
                  // Favorite button
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        size: 16,
                        color: NVSColors.ultraLightMint,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // User info section
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    // Name and age
                    Text(
                      '${user.displayName}, ${user.age}',
                      style: const TextStyle(
                        fontFamily: 'MagdaCleanMono',
                        color: NVSColors.ultraLightMint,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Role badge
                    RoleBadge(
                      emoji:
                          '🔥', // Default emoji since UserProfile doesn't have roleEmoji
                      role:
                          'Versatile', // Default role since UserProfile doesn't have sexualRole
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
