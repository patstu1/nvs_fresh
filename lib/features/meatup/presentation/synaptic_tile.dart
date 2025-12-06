// lib/features/meatup/presentation/synaptic_tile.dart

import 'package:flutter/material.dart';
import 'package:nvs/features/profile/presentation/obfuscated_image_view.dart';
import '../application/meatup_provider.dart';

class SynapticTile extends StatelessWidget {
  // Score from 0.0 to 1.0

  const SynapticTile({
    required this.profile,
    required this.compatibilityScore,
    super.key,
  });
  final MeatupUser profile;
  final double compatibilityScore;

  @override
  Widget build(BuildContext context) {
    // Calculate glow color and intensity based on the compatibility score
    final Color baseGlowColor = Theme.of(context).colorScheme.primary;
    final double glowOpacity =
        (compatibilityScore - 0.5).clamp(0.0, 0.5) * 2; // Normalize score to opacity
    final double glowSpread = compatibilityScore * 10; // More score = wider glow

    return GestureDetector(
      onTap: () {
        // Navigate to the HolographicDataStreamView for this profile
        // context.push('/profile/${profile.walletAddress}');
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          // This creates the bio-responsive glow effect.
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: baseGlowColor.withOpacity(glowOpacity),
              blurRadius: glowSpread,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: ObfuscatedImageView(
            // Fetch the appropriate photo URI from the profile's IPFS data
            imageUrl: profile.gridPhotoURL ?? '',
            isRevealedInitially: false,
          ),
        ),
      ),
    );
  }
}
