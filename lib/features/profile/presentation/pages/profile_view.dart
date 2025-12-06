import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

class ProfileViewWidget extends StatelessWidget {
  const ProfileViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: NVSColors.pureBlack.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: NVSColors.primaryLightMint.withValues(alpha: 0.5),
              width: 2,
            ),
            boxShadow: const <BoxShadow>[...NVSColors.mintGlow],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircleAvatar(
                radius: 40,
                backgroundColor: NVSColors.primaryLightMint.withValues(alpha: 0.08),
                child: const Text(
                  'U',
                  style: TextStyle(
                    color: NVSColors.primaryGreenAccent,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Profile',
                style: TextStyle(
                  color: NVSColors.primaryLightMint,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  shadows: NVSColors.mintTextShadow,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'your personal space',
                style: TextStyle(
                  color: NVSColors.primaryGreenAccent.withValues(alpha: 0.8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
