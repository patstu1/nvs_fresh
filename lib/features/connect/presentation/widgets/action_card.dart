import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

// The one place we use a color outside our primary palette.
const Color HOT_PINK_NEON = Color(0xFFF900F9);

class ActionCard extends StatelessWidget {
  const ActionCard({required this.onSave, required this.onPass, super.key});
  final VoidCallback onSave;
  final VoidCallback onPass;

  @override
  Widget build(BuildContext context) {
    return Column(
      // We stretch the children to fill the entire screen space
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // The "Save" Zone
        Expanded(
          child: InkWell(
            onTap: onSave,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.favorite, // The heart glyph
                  color: HOT_PINK_NEON,
                  size: 80,
                  shadows: <Shadow>[
                    BoxShadow(
                      color: HOT_PINK_NEON.withValues(alpha: 0.8),
                      blurRadius: 24,
                      spreadRadius: 12,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'SAVE',
                  style: TextStyle(
                    color: HOT_PINK_NEON,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),
              ],
            ),
          ),
        ),
        // A sharp dividing line
        Container(
          height: 1.5,
          color: NVSColors.dividerColor,
        ),
        // The "Pass" Zone
        Expanded(
          child: InkWell(
            onTap: onPass,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.close, // The X glyph
                  color: NVSColors.secondaryText,
                  size: 80,
                ),
                SizedBox(height: 16),
                Text(
                  'PASS',
                  style: TextStyle(
                    color: NVSColors.secondaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
