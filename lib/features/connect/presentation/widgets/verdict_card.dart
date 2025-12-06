import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

class VerdictCard extends StatelessWidget {
  // Optional for more context

  const VerdictCard({
    required this.title,
    required this.verdict,
    super.key,
    this.subtitle,
  });
  final String title;
  final String verdict;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // The title of the reading
          Text(
            title,
            style: TextStyle(
              color: NVSColors.primaryNeonMint.withValues(alpha: 0.8),
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 5,
            ),
          ),
          const SizedBox(height: 8),
          // A subtle divider
          Container(
            width: 80,
            height: 1.5,
            color: NVSColors.dividerColor,
          ),
          const SizedBox(height: 32),
          // The AI's verdict. The star of the show.
          Text(
            verdict,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w100, // Elegant and readable
              height: 1.5, // Line spacing for readability
            ),
          ),
          if (subtitle != null) ...<Widget>[
            const SizedBox(height: 24),
            Text(
              subtitle!,
              style: const TextStyle(
                color: NVSColors.secondaryText,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
