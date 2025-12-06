import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

class ConnectIntroPage extends StatelessWidget {
  const ConnectIntroPage({required this.compatibilityPercent, super.key});
  final String compatibilityPercent;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: NVSColors.pureBlack,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        children: <Widget>[
          const Text(
            '✨ AI MATCH REPORT ✨',
            style: TextStyle(
              color: NVSColors.primaryNeonMint,
              fontSize: 22,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Compatibility',
            style: TextStyle(
              color: NVSColors.secondaryText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            compatibilityPercent,
            style: const TextStyle(
              color: NVSColors.neonLime,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          const Expanded(
            child: Center(
              child: Text(
                'Let’s see what the stars—and our sassiest AI—have to say about this one.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: NVSColors.secondaryText,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Icon(Icons.swipe, size: 36, color: NVSColors.primaryNeonMint),
          const SizedBox(height: 12),
          const Text(
            'Swipe right to begin',
            style: TextStyle(
              color: NVSColors.secondaryText,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
