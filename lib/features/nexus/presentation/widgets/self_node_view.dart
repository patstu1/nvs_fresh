import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

class SelfNodeView extends StatelessWidget {
  const SelfNodeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: NVSColors.pureBlack,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: NVSColors.primaryNeonMint.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: NVSColors.primaryNeonMint.withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Profile Avatar
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: NVSColors.primaryNeonMint,
                  width: 2,
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: NVSColors.primaryNeonMint.withValues(alpha: 0.5),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const CircleAvatar(
                radius: 48,
                backgroundColor: NVSColors.dividerColor,
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: NVSColors.primaryNeonMint,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Node Title
            const Text(
              'SELF',
              style: TextStyle(
                color: NVSColors.primaryNeonMint,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 6,
              ),
            ),
            const SizedBox(height: 8),

            // Subtitle
            Text(
              'IDENTITY MATRIX',
              style: TextStyle(
                color: NVSColors.secondaryText.withValues(alpha: 0.7),
                fontSize: 12,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 30),

            // Profile Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildProfileStat('AURA', 'FIRE'),
                Container(
                  width: 1,
                  height: 30,
                  color: NVSColors.dividerColor,
                ),
                _buildProfileStat('SIGNAL', '94%'),
                Container(
                  width: 1,
                  height: 30,
                  color: NVSColors.dividerColor,
                ),
                _buildProfileStat('VIBE', 'ACTIVE'),
              ],
            ),
            const SizedBox(height: 30),

            // Edit Button
            Container(
              width: double.infinity,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: NVSColors.primaryNeonMint.withValues(alpha: 0.5),
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: () {
                    // TODO: Navigate to detailed profile editing
                  },
                  child: const Center(
                    child: Text(
                      'EDIT PROFILE',
                      style: TextStyle(
                        color: NVSColors.primaryNeonMint,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileStat(String label, String value) {
    return Column(
      children: <Widget>[
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: NVSColors.secondaryText.withValues(alpha: 0.6),
            fontSize: 10,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
