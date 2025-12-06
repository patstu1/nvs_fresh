import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

class MatchListItem extends StatelessWidget {
  const MatchListItem({super.key});
  // Placeholder data
  final String avatarUrl = 'https://source.unsplash.com/random/200x200?portrait,man,cinematic';
  final String name = 'KAINE';
  final String compatibility = '92%';
  final String icebreaker = 'The AI says you two are a cosmic inevitability.';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: NVSColors.dividerColor),
        ),
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(avatarUrl),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  icebreaker,
                  style: const TextStyle(
                    color: NVSColors.secondaryText,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            compatibility,
            style: const TextStyle(
              color: NVSColors.primaryNeonMint,
              fontSize: 24,
              fontWeight: FontWeight.w100,
            ),
          ),
        ],
      ),
    );
  }
}
