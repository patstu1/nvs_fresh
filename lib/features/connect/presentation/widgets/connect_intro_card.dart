import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';
import 'zodiac_ring.dart';

class ConnectIntroCard extends StatelessWidget {
  const ConnectIntroCard({super.key});
  // Data is injected from real AI report; fallback to local asset if missing
  final String avatarUrl = 'assets/images/avatar_placeholder.png';
  final String name = 'RYKER';
  final String sunSign = 'SCORPIO';
  final String compatibilityPercent = '78%';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // This is the container for the avatar and the animated ring
        SizedBox(
          width: 250,
          height: 250,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              const ZodiacRing(),

              // The Avatar
              CircleAvatar(
                radius: 100,
                backgroundImage: avatarUrl.startsWith('http')
                    ? NetworkImage(avatarUrl)
                    : const AssetImage('assets/images/avatar_placeholder.png') as ImageProvider,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // User Info
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          sunSign,
          style: const TextStyle(
            color: NVSColors.secondaryText,
            fontSize: 16,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 32),
        // Compatibility Score
        Text(
          'COMPATIBILITY',
          style: TextStyle(
            color: NVSColors.primaryNeonMint.withValues(alpha: 0.7),
            fontSize: 14,
            letterSpacing: 4,
          ),
        ),
        Text(
          compatibilityPercent,
          style: const TextStyle(
            color: NVSColors.primaryNeonMint,
            fontSize: 72,
            fontWeight: FontWeight.w100, // Thin and elegant
          ),
        ),
      ],
    );
  }
}
