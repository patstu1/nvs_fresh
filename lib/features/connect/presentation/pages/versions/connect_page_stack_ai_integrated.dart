// lib/features/connect/presentation/pages/connect_page_stack.dart

import 'package:flutter/material.dart';
import '../../../data/connect_mock_profiles.dart';
import '../../../data/connect_ai_service.dart';

class ConnectPageStack extends StatelessWidget {
  const ConnectPageStack({super.key});

  @override
  Widget build(BuildContext context) {
    final int matchScore = CompatibilityAIService.calculateMatchScore(userYou, userThem);
    final int obsessionRisk = CompatibilityAIService.estimateObsessionRisk(userYou);
    final bool polarity = CompatibilityAIService.isPolarityAligned(userYou.role, userThem.role);
    final String verdict = CompatibilityAIService.generateVerdict(
      compatibility: matchScore,
      obsessionRisk: obsessionRisk,
      polarityAligned: polarity,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView(
        children: <Widget>[
          _infoPage('Page 1: Birth Time Analysis', <String>[
            'You → Sun: ${userYou.sun}, Moon: ${userYou.moon}, Rising: ${userYou.rising}',
            'Them → Sun: ${userThem.sun}, Moon: ${userThem.moon}, Rising: ${userThem.rising}',
          ]),
          _infoPage('Page 3: Role Polarity', <String>[
            'You: ${userYou.role}',
            'Them: ${userThem.role}',
            if (polarity) 'Polarity: ALIGNED' else 'Polarity: MISALIGNED',
          ]),
          _infoPage('Page 5: Match Score', <String>[
            'Compatibility: $matchScore%',
            'Obsession Risk: $obsessionRisk',
            "Polarity Match: ${polarity ? 'Yes' : 'No'}",
          ]),
          _infoPage('Page 9: AI Verdict', <String>[verdict]),
        ],
      ),
    );
  }

  Widget _infoPage(String title, List<String> lines) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFB2FFD6),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Center(
              child: Text(
                lines.join('\n\n'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.7,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
