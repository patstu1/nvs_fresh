// lib/features/connect/presentation/pages/connect_page_stack.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ConnectPageStack extends StatelessWidget {
  const ConnectPageStack({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView(
        children: const <Widget>[
          BirthTimePage(),
          PsychMapPage(),
          RolePolarityPage(),
          EmotionalForecastPage(),
          MatchDetailsPage(),
          RiskProjectionPage(),
          CompatibilityMatrixPage(),
          ShadowAnalysisPage(),
          AIVerdictPage(),
        ],
      ),
    );
  }
}

Widget animatedPage({required String title, required Widget child}) {
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
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 700),
            child: child,
          ),
        ),
      ],
    ),
  );
}

// Page 1 – Birth Time Analysis
class BirthTimePage extends StatefulWidget {
  const BirthTimePage({super.key});

  @override
  State<BirthTimePage> createState() => _BirthTimePageState();
}

class _BirthTimePageState extends State<BirthTimePage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeIn;
  @override
  void initState() {
    super.initState();
    _fadeController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _fadeIn = CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);
    _fadeController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return animatedPage(
      title: 'Page 1: Birth Time Analysis',
      child: FadeTransition(
        opacity: _fadeIn,
        child: const Center(
          child: Text(
            'Sun: Scorpio\nMoon: Leo\nRising: Capricorn',
            style: TextStyle(color: Colors.white, fontSize: 18, height: 1.8),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

// Page 2 – Psych Map
class PsychMapPage extends StatelessWidget {
  const PsychMapPage({super.key});
  @override
  Widget build(BuildContext context) {
    return animatedPage(
      title: 'Page 2: Psychological Map',
      child: const Column(
        children: <Widget>[
          TraitBar(label: 'Obsession', value: 8, color: Color(0xFFFF6699)),
          TraitBar(label: 'Control', value: 6, color: Color(0xFFB2FFD6)),
          TraitBar(label: 'Chaos', value: 7, color: Color(0xFFCCFF33)),
          TraitBar(label: 'Trust', value: 3, color: Colors.tealAccent),
        ],
      ),
    );
  }
}

// Page 3 – Role Polarity
class RolePolarityPage extends StatefulWidget {
  const RolePolarityPage({super.key});
  @override
  State<RolePolarityPage> createState() => _RolePolarityPageState();
}

class _RolePolarityPageState extends State<RolePolarityPage> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _scaleAnim;
  @override
  void initState() {
    super.initState();
    _pulseController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))
          ..repeat(reverse: true);
    _scaleAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return animatedPage(
      title: 'Page 3: Role Polarity',
      child: ScaleTransition(
        scale: _scaleAnim,
        child: const Center(
          child: Text(
            'You: Power Bottom\nThem: Breeder\n\nPolarity: ALIGNED',
            style: TextStyle(color: Color(0xFFB2FFD6), fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

// Page 4 – Emotional Forecast
class EmotionalForecastPage extends StatelessWidget {
  const EmotionalForecastPage({super.key});
  @override
  Widget build(BuildContext context) {
    return animatedPage(
      title: 'Page 4: Emotional Forecast',
      child: const Center(
        child: Text(
          'Spiral Risk: HIGH\nTrust Stability: 36%\nCollapse Trigger: Jealousy',
          style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.8),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// Page 5 – Match Details
class MatchDetailsPage extends StatelessWidget {
  const MatchDetailsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return animatedPage(
      title: 'Page 5: Match Details',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 120,
            width: 120,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                PieChart(
                  PieChartData(
                    centerSpaceRadius: 36,
                    sectionsSpace: 2,
                    startDegreeOffset: -90,
                    sections: <dynamic>[
                      PieChartSectionData(
                        color: const Color(0xFFB2FFD6),
                        value: 73,
                        showTitle: false,
                        radius: 22,
                      ),
                      PieChartSectionData(
                        color: Colors.white10,
                        value: 27,
                        showTitle: false,
                        radius: 22,
                      ),
                    ],
                  ),
                ),
                const Text(
                  '73%',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Emotional Sync: MEDIUM\nRole Clash: LOW',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.6),
          ),
        ],
      ),
    );
  }
}

// Page 6 – Risk & Projection
class RiskProjectionPage extends StatelessWidget {
  const RiskProjectionPage({super.key});
  String generateRiskForecast({
    required int obsession,
    required int trust,
    required int stability,
  }) {
    if (obsession > 7 && trust < 4) {
      return 'Phase 1: High attraction\nPhase 2: Triggered collapse\nPhase 3: Obsession loop\nRisk: 87%';
    }
    if (stability > 6) return 'Phase 1: Harmonious connection\nPhase 2: Kink divergence\nRisk: 34%';
    return 'Volatile but survivable. Keep roles defined.\nRisk: 59%';
  }

  @override
  Widget build(BuildContext context) {
    final String forecast = generateRiskForecast(obsession: 8, trust: 3, stability: 4);
    return animatedPage(
      title: 'Page 6: Risk & Projection',
      child: Center(
        child: Text(
          forecast,
          style: const TextStyle(color: Colors.pinkAccent, fontSize: 15, height: 1.7),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// Page 7 – Compatibility Matrix
class CompatibilityMatrixPage extends StatelessWidget {
  const CompatibilityMatrixPage({super.key});
  @override
  Widget build(BuildContext context) {
    return animatedPage(
      title: 'Page 7: Compatibility Matrix',
      child: const Column(
        children: <Widget>[
          MatrixRow(label: 'Emotional Sync', you: 8, them: 4),
          MatrixRow(label: 'Kink Alignment', you: 10, them: 9),
          MatrixRow(label: 'Control Balance', you: 7, them: 7),
          MatrixRow(label: 'Truth Tolerance', you: 6, them: 2),
          MatrixRow(label: 'Jealousy Potential', you: 5, them: 9),
        ],
      ),
    );
  }
}

// Page 8 – Shadow Analysis
class ShadowAnalysisPage extends StatefulWidget {
  const ShadowAnalysisPage({super.key});
  @override
  State<ShadowAnalysisPage> createState() => _ShadowAnalysisPageState();
}

class _ShadowAnalysisPageState extends State<ShadowAnalysisPage> {
  bool revealed = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 900), () => setState(() => revealed = true));
  }

  @override
  Widget build(BuildContext context) {
    return animatedPage(
      title: 'Page 8: Shadow Analysis',
      child: Center(
        child: AnimatedOpacity(
          opacity: revealed ? 1 : 0,
          duration: const Duration(milliseconds: 600),
          child: const Text(
            'Your Core Shadow: CONTROL\n\nTheir Core Shadow: ABANDONMENT\n\nProjected Conflict:\nThey seek safety. You weaponize withdrawal.',
            style: TextStyle(color: Colors.pinkAccent, fontSize: 16, height: 1.8),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

// Page 9 – AI Verdict
class AIVerdictPage extends StatefulWidget {
  const AIVerdictPage({super.key});
  @override
  State<AIVerdictPage> createState() => _AIVerdictPageState();
}

class _AIVerdictPageState extends State<AIVerdictPage> {
  String verdict = '...';
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1100), () {
      setState(() {
        verdict = generateAIVerdict(score: 73, polarity: true, risk: 8);
      });
    });
  }

  String generateAIVerdict({required int score, required bool polarity, required int risk}) {
    if (score > 85 && polarity) {
      return 'Verdict: HIGH ALIGNMENT\nPsychological + sexual cohesion strong.';
    }
    if (risk >= 8) return 'Verdict: OBSSESSION RISK HIGH\nEngagement may spiral.';
    if (score < 60) return 'Verdict: LOW COMPATIBILITY\nCore needs conflict.';
    return 'Verdict: MIXED FIELD\nPotential if emotional pacing is slow.';
  }

  @override
  Widget build(BuildContext context) {
    return animatedPage(
      title: 'Page 9: AI Verdict',
      child: Center(
        child: Text(
          verdict,
          style: const TextStyle(color: Color(0xFFFF6699), fontSize: 16, height: 1.8),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// Shared components
class MatrixRow extends StatelessWidget {
  const MatrixRow({required this.label, required this.you, required this.them, super.key});
  final String label;
  final int you;
  final int them;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 12),
        Text(label, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 6),
        Row(
          children: <Widget>[
            Expanded(
              child: LinearProgressIndicator(
                value: you / 10,
                color: const Color(0xFFB2FFD6),
                backgroundColor: Colors.white10,
                minHeight: 8,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: LinearProgressIndicator(
                value: them / 10,
                color: const Color(0xFFCCFF33),
                backgroundColor: Colors.white10,
                minHeight: 8,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TraitBar extends StatelessWidget {
  const TraitBar({required this.label, required this.value, required this.color, super.key});
  final String label;
  final int value;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label.toUpperCase(), style: const TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: value / 10,
            color: color,
            backgroundColor: Colors.white10,
            minHeight: 8,
          ),
        ],
      ),
    );
  }
}
