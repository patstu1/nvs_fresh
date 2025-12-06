import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';
import '../../data/connect_ai_service.dart' as connect_ai;
import 'package:nvs/data/now_mock_users.dart' as now_data;
import '../../../../shared/widgets/nvs_logo_video.dart';
import '../../../../shared/widgets/section_label.dart';
// import '../../services/nvs_ai_voice_service.dart'; // Unused import

class ConnectPageStack extends StatelessWidget {
  const ConnectPageStack({required this.userTarget, super.key});
  final connect_ai.UserProfile userTarget;

  @override
  Widget build(BuildContext context) {
    // Derive a baseline "you" profile from designated NOW users deterministically
    final connect_ai.UserProfile userYou = _deriveUserProfile(
      now_data.nowMockUsers.first.username,
      role: now_data.nowMockUsers.first.role,
    );
    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      body: Stack(
        children: <Widget>[
          const Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Center(child: NvsLogo(letterSpacing: 10)),
          ),
          PageView(
            children: <Widget>[
              BirthTimePage(userTarget: userTarget),
              PsychologicalMapPage(userTarget: userTarget),
              RolePolarityPage(userYou: userYou, userTarget: userTarget),
              EmotionalForecastPage(userTarget: userTarget),
              MatchDetailsPage(userYou: userYou, userTarget: userTarget),
              RiskProjectionPage(userYou: userYou, userTarget: userTarget),
            ],
          ),
          // Section Label
          const SectionLabel(
            sectionName: 'CONNECT',
            glowColor: NVSColors.primaryNeonMint,
            alignment: Alignment.topLeft,
            padding: EdgeInsets.all(16),
          ),
        ],
      ),
    );
  }
}

Widget pageScaffold({required String title, required Widget child}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // NVS Logo Video at top
        const Center(
          child: NvsLogoVideo(
            height: 50,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(
            color: NVSColors.neonMint,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        Expanded(child: child),
      ],
    ),
  );
}

class AiPoweredPage extends StatelessWidget {
  const AiPoweredPage({
    required this.title,
    required this.userTarget,
    required this.content,
    super.key,
    this.textColor = const Color(0xFFB2FFD6), // Mint
  });
  final String title;
  final Color textColor;
  final connect_ai.UserProfile userTarget;
  final String content;

  @override
  Widget build(BuildContext context) {
    return pageScaffold(
      title: title,
      child: Center(
        child: Text(
          content,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            height: 1.8,
            fontFamily: 'BellGothic',
          ),
        ),
      ),
    );
  }
}

class BirthTimePage extends StatelessWidget {
  const BirthTimePage({required this.userTarget, super.key});
  final connect_ai.UserProfile userTarget;

  @override
  Widget build(BuildContext context) {
    return AiPoweredPage(
      title: 'Page 1: Birth Time Analysis',
      userTarget: userTarget,
      content:
          'Sun: ${userTarget.sun}\nMoon: ${userTarget.moon}\nRising: ${userTarget.rising}\n\nAstrological alignment suggests compatibility patterns.',
    );
  }
}

class PsychologicalMapPage extends StatelessWidget {
  const PsychologicalMapPage({required this.userTarget, super.key});
  final connect_ai.UserProfile userTarget;

  @override
  Widget build(BuildContext context) {
    final int obsession = userTarget.traits['obsession'] ?? 0;
    final int control = userTarget.traits['control'] ?? 0;
    return AiPoweredPage(
      title: 'Page 2: Psychological Map',
      userTarget: userTarget,
      content:
          "Obsession Level: $obsession/10\nControl Need: $control/10\n\nPsychological patterns indicate ${obsession > 7 ? 'high' : 'moderate'} intensity connection.",
      textColor: const Color(0xFFCCFF33), // Lime
    );
  }
}

class RolePolarityPage extends StatelessWidget {
  const RolePolarityPage({required this.userYou, required this.userTarget, super.key});
  final connect_ai.UserProfile userYou;
  final connect_ai.UserProfile userTarget;

  @override
  Widget build(BuildContext context) {
    final bool isAligned =
        connect_ai.CompatibilityAIService.isPolarityAligned(userYou.role, userTarget.role);
    return AiPoweredPage(
      title: 'Page 3: Role Polarity',
      userTarget: userTarget,
      content:
          "You: ${userYou.role}\nThem: ${userTarget.role}\n\nPolarity: ${isAligned ? 'ALIGNED' : 'MISMATCHED'}\n\n${isAligned ? 'Sexual dynamics harmonize' : 'Role conflict likely'}",
    );
  }
}

class EmotionalForecastPage extends StatelessWidget {
  const EmotionalForecastPage({required this.userTarget, super.key});
  final connect_ai.UserProfile userTarget;

  @override
  Widget build(BuildContext context) {
    final int emotionalSync = userTarget.traits['emotional_sync'] ?? 0;
    final int trust = userTarget.traits['trust'] ?? 0;
    return AiPoweredPage(
      title: 'Page 4: Emotional Forecast',
      userTarget: userTarget,
      content:
          "Emotional Sync: $emotionalSync/10\nTrust Baseline: $trust/10\n\n${emotionalSync > 6 ? 'High emotional resonance expected' : 'Emotional disconnect possible'}",
      textColor: const Color(0xFFFF6699), // Pink
    );
  }
}

class MatchDetailsPage extends StatelessWidget {
  const MatchDetailsPage({required this.userYou, required this.userTarget, super.key});
  final connect_ai.UserProfile userYou;
  final connect_ai.UserProfile userTarget;

  @override
  Widget build(BuildContext context) {
    final int matchScore = connect_ai.CompatibilityAIService.calculateMatchScore(
      userYou,
      userTarget,
    );
    final int kinkAlignment = userTarget.traits['kink_alignment'] ?? 0;
    return AiPoweredPage(
      title: 'Page 5: Match Details',
      userTarget: userTarget,
      content:
          "Overall Match: $matchScore%\nKink Alignment: $kinkAlignment/10\n\n${matchScore > 75 ? 'High compatibility detected' : 'Mixed compatibility signals'}",
    );
  }
}

class RiskProjectionPage extends StatelessWidget {
  const RiskProjectionPage({required this.userYou, required this.userTarget, super.key});
  final connect_ai.UserProfile userYou;
  final connect_ai.UserProfile userTarget;

  @override
  Widget build(BuildContext context) {
    final int obsessionRisk = connect_ai.CompatibilityAIService.estimateObsessionRisk(userTarget);
    final int matchScore = connect_ai.CompatibilityAIService.calculateMatchScore(
      userYou,
      userTarget,
    );
    final bool isAligned = connect_ai.CompatibilityAIService.isPolarityAligned(
      userYou.role,
      userTarget.role,
    );
    final String verdict = connect_ai.CompatibilityAIService.generateVerdict(
      compatibility: matchScore,
      obsessionRisk: obsessionRisk,
      polarityAligned: isAligned,
    );

    return AiPoweredPage(
      title: 'Page 6: Risk & Projection',
      userTarget: userTarget,
      content: 'Obsession Risk: $obsessionRisk/10\n\n$verdict',
      textColor: const Color(0xFFFF6699), // Pink
    );
  }
}

// Deterministic derivation of astro traits from a name to avoid hardcoded placeholders
connect_ai.UserProfile _deriveUserProfile(String name, {required String role}) {
  final List<String> signs = <String>[
    'Aries',
    'Taurus',
    'Gemini',
    'Cancer',
    'Leo',
    'Virgo',
    'Libra',
    'Scorpio',
    'Sagittarius',
    'Capricorn',
    'Aquarius',
    'Pisces',
  ];
  final int h = name.hashCode.abs();
  final String sun = signs[h % signs.length];
  final String moon = signs[(h ~/ 7) % signs.length];
  final String rising = signs[(h ~/ 13) % signs.length];
  return connect_ai.UserProfile(
    name: name,
    role: role,
    sun: sun,
    moon: moon,
    rising: rising,
    traits: <String, int>{
      'obsession': 5 + (h % 5),
      'control': 4 + (h % 6),
      'emotional_sync': 5 + (h % 5),
      'trust': 5 + ((h ~/ 3) % 5),
      'kink_alignment': 5 + ((h ~/ 5) % 5),
    },
  );
}
