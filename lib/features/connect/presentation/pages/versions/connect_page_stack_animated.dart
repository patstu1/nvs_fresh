// lib/features/connect/presentation/pages/connect_page_stack_animated.dart

import 'package:flutter/material.dart';

class ConnectPageStack extends StatelessWidget {
  const ConnectPageStack({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView(
        children: const <Widget>[
          BirthTimePage(),
          RolePolarityPage(),
          AIVerdictPage(),
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
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFFB2FFD6),
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
    return pageScaffold(
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
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _scaleAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return pageScaffold(
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

class AIVerdictPage extends StatefulWidget {
  const AIVerdictPage({super.key});

  @override
  State<AIVerdictPage> createState() => _AIVerdictPageState();
}

class _AIVerdictPageState extends State<AIVerdictPage> with TickerProviderStateMixin {
  String aiVerdict = '...';

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        aiVerdict = generateAIVerdict(compatibility: 73, obsessionRisk: 8, polarityMatch: true);
      });
    });
  }

  String generateAIVerdict({
    required int compatibility,
    required int obsessionRisk,
    required bool polarityMatch,
  }) {
    if (compatibility < 60) {
      return 'Low cohesion. Psychological misalignment detected.';
    }
    if (obsessionRisk > 7 && polarityMatch) {
      return 'Chemistry is volatile. Obsession loop likely.';
    }
    if (polarityMatch && compatibility > 80) {
      return 'Strong match. Power dynamic balanced.';
    }
    return 'Mixed field. Monitor emotional patterns before engaging.';
  }

  @override
  Widget build(BuildContext context) {
    return pageScaffold(
      title: 'Page 9: AI Verdict',
      child: Center(
        child: Text(
          aiVerdict,
          style: const TextStyle(color: Color(0xFFFF6699), fontSize: 16, height: 1.8),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
