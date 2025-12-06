import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/compatibility_providers.dart';

class NvsConnectCompatibilityScreen extends StatefulWidget {
  const NvsConnectCompatibilityScreen({
    required this.currentUserId,
    required this.potentialMatchId,
    super.key,
  });
  final String currentUserId;
  final String potentialMatchId;

  @override
  State<NvsConnectCompatibilityScreen> createState() => _NvsConnectCompatibilityScreenState();
}

class _NvsConnectCompatibilityScreenState extends State<NvsConnectCompatibilityScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _glowController;
  late AnimationController _scoreController;
  late AnimationController _nvsController;

  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _scoreAnimation;
  late Animation<double> _nvsBreathingAnimation;

  bool _showVerdict = false;
  bool _isAnalyzing = true;
  final int _compatibilityScore = 0;
  final String _nvsVerdict = '';

  // Data now comes from Firestore via Riverpod providers

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    _scoreController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _nvsController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _scoreAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scoreController, curve: Curves.elasticOut),
    );

    _nvsBreathingAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _nvsController, curve: Curves.easeInOut),
    );

    _startAnalysis();
  }

  Future<void> _startAnalysis() async {
    setState(() {
      _isAnalyzing = true;
    });
    // In the Firestore-driven version, analysis visuals remain but score comes from stream
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) setState(() => _isAnalyzing = false);
    _scoreController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) setState(() => _showVerdict = true);
  }

  String _generateNvsVerdict() {
    if (_compatibilityScore >= 90) {
      return "This isn't just attraction. You two vibrate on a frequency I haven't seen in weeks.";
    } else if (_compatibilityScore >= 80) {
      return "This could be electric — just don't ghost each other after 48 hours.";
    } else if (_compatibilityScore >= 70) {
      return "We both know you fall too fast. Let's try someone different this time.";
    } else {
      return "Interesting choice. I see what you're drawn to, and I understand why.";
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _glowController.dispose();
    _scoreController.dispose();
    _nvsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // NVS Header with animated logo
              _buildNvsHeader(),

              // Split Profile Comparison
              _buildSplitProfileView(),

              // Zodiac Compatibility Section
              _buildZodiacCompatibility(),

              // Personality Metrics Breakdown
              _buildPersonalityMetrics(),

              // Mutual Network Analysis
              _buildMutualNetworkAnalysis(),

              // Aesthetic Similarity
              _buildAestheticSimilarity(),

              // Final Compatibility Score
              _buildCompatibilityScore(),

              // NVS Verdict
              if (_showVerdict) _buildNvsVerdict(),

              // Continue Button
              if (_showVerdict) _buildContinueButton(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNvsHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: <Widget>[
          // NVS Logo/Avatar with breathing animation
          AnimatedBuilder(
            animation: _nvsBreathingAnimation,
            builder: (BuildContext context, Widget? child) {
              return Transform.scale(
                scale: _nvsBreathingAnimation.value,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: <Color>[Color(0xFFB0FFF7), Color(0xFF00F0FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: const Color(0xFFB0FFF7).withValues(alpha: 0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.psychology,
                    color: Colors.black,
                    size: 40,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // NVS Title
          const Text(
            'NVS',
            style: TextStyle(
              color: Color(0xFFB0FFF7),
              fontSize: 32,
              fontWeight: FontWeight.w300,
              letterSpacing: 4,
              shadows: <Shadow>[
                Shadow(
                  color: Color(0xFFB0FFF7),
                  blurRadius: 10,
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          if (_isAnalyzing)
            const Text(
              'ANALYZING COMPATIBILITY...',
              style: TextStyle(
                color: Color(0xFF666666),
                fontSize: 12,
                letterSpacing: 2,
              ),
            )
                .animate(onPlay: (AnimationController controller) => controller.repeat())
                .fadeIn(duration: 1000.ms)
                .fadeOut(duration: 1000.ms),
        ],
      ),
    );
  }

  Widget _buildSplitProfileView() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 200,
      child: Row(
        children: <Widget>[
          // Current User
          Expanded(
            child: _buildProfileCard(
              currentUser['name'] as String,
              currentUser['age'] as int,
              currentUser['avatar'] as String,
              true,
            ),
          ),

          // VS Indicator
          SizedBox(
            width: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (BuildContext context, Widget? child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: const Text(
                        'VS',
                        style: TextStyle(
                          color: Color(0xFFFF53A1),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Potential Match
          Expanded(
            child: _buildProfileCard(
              potentialMatch['name'] as String,
              potentialMatch['age'] as int,
              potentialMatch['avatar'] as String,
              false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(
    String name,
    int age,
    String avatar,
    bool isCurrentUser,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            const Color(0xFF1A1A1A).withValues(alpha: 0.8),
            const Color(0xFF0A0A0A).withValues(alpha: 0.9),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFB0FFF7).withValues(alpha: 0.3),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFFB0FFF7).withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          // Avatar with neon ring
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFB0FFF7),
                width: 2,
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: const Color(0xFFB0FFF7).withValues(alpha: 0.3),
                  blurRadius: 15,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                avatar,
                width: 76,
                height: 76,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                  return const ColoredBox(
                    color: Color(0xFF333333),
                    child: Icon(
                      Icons.person,
                      color: Color(0xFFB0FFF7),
                      size: 40,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Name and Age
          Text(
            '$name, $age',
            style: const TextStyle(
              color: Color(0xFFE6FFF4),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZodiacCompatibility() {
    final Map<String, String> userZodiac = currentUser['zodiac'] as Map<String, String>;
    final Map<String, String> matchZodiac = potentialMatch['zodiac'] as Map<String, String>;

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            const Color(0xFF1A1A1A).withValues(alpha: 0.8),
            const Color(0xFF0A0A0A).withValues(alpha: 0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFB0FFF7).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Row(
            children: <Widget>[
              Icon(
                Icons.stars,
                color: Color(0xFFFF53A1),
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                'ZODIAC COMPATIBILITY',
                style: TextStyle(
                  color: Color(0xFFB0FFF7),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    _buildZodiacSign('SUN', userZodiac['sun']!),
                    const SizedBox(height: 12),
                    _buildZodiacSign('MOON', userZodiac['moon']!),
                    const SizedBox(height: 12),
                    _buildZodiacSign('RISING', userZodiac['rising']!),
                  ],
                ),
              ),
              SizedBox(
                width: 60,
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (BuildContext context, Widget? child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: const Icon(
                        Icons.favorite,
                        color: Color(0xFFFF53A1),
                        size: 30,
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    _buildZodiacSign('SUN', matchZodiac['sun']!),
                    const SizedBox(height: 12),
                    _buildZodiacSign('MOON', matchZodiac['moon']!),
                    const SizedBox(height: 12),
                    _buildZodiacSign('RISING', matchZodiac['rising']!),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildZodiacSign(String type, String sign) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFB0FFF7).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFB0FFF7).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: <Widget>[
          Text(
            type,
            style: const TextStyle(
              color: Color(0xFF666666),
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            sign,
            style: const TextStyle(
              color: Color(0xFFB0FFF7),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalityMetrics() {
    final Map<String, dynamic> userTraits = currentUser['traits'] as Map<String, dynamic>;
    final Map<String, dynamic> matchTraits = potentialMatch['traits'] as Map<String, dynamic>;

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            const Color(0xFF1A1A1A).withValues(alpha: 0.8),
            const Color(0xFF0A0A0A).withValues(alpha: 0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFB0FFF7).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Row(
            children: <Widget>[
              Icon(
                Icons.psychology,
                color: Color(0xFFFF53A1),
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                'PERSONALITY METRICS',
                style: TextStyle(
                  color: Color(0xFFB0FFF7),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...userTraits.entries
              .where((MapEntry<String, dynamic> entry) => entry.value is double)
              .map((MapEntry<String, dynamic> entry) {
            final double userValue = entry.value as double;
            final double matchValue = matchTraits[entry.key] as double? ?? 0.0;
            final double compatibility = 1.0 - (userValue - matchValue).abs();

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildMetricBar(
                _formatMetricName(entry.key),
                compatibility,
              ),
            );
          }),
        ],
      ),
    );
  }

  String _formatMetricName(String key) {
    return key.split('_').map((String word) => word[0].toUpperCase() + word.substring(1)).join(' ');
  }

  Widget _buildMetricBar(String label, double value) {
    final Color color = value >= 0.8
        ? const Color(0xFFB0FFF7)
        : value >= 0.6
            ? const Color(0xFFFF53A1)
            : const Color(0xFF666666);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFFE6FFF4),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              '${(value * 100).round()}%',
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: const Color(0xFF333333),
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: value,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[color.withValues(alpha: 0.6), color],
                ),
                borderRadius: BorderRadius.circular(3),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMutualNetworkAnalysis() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            const Color(0xFF1A1A1A).withValues(alpha: 0.8),
            const Color(0xFF0A0A0A).withValues(alpha: 0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFB0FFF7).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Row(
            children: <Widget>[
              Icon(
                Icons.group,
                color: Color(0xFFFF53A1),
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                'MUTUAL NETWORK',
                style: TextStyle(
                  color: Color(0xFFB0FFF7),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildNetworkStat(
                'MUTUAL CONNECTIONS',
                '${currentUser['mutualConnections']}',
                Icons.people,
              ),
              _buildNetworkStat(
                'SHARED VENUES',
                '3',
                Icons.location_on,
              ),
              _buildNetworkStat(
                'COMMON INTERESTS',
                '7',
                Icons.favorite,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkStat(String label, String value, IconData icon) {
    return Column(
      children: <Widget>[
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFB0FFF7).withValues(alpha: 0.1),
            border: Border.all(
              color: const Color(0xFFB0FFF7).withValues(alpha: 0.3),
            ),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFB0FFF7),
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFFB0FFF7),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF666666),
            fontSize: 10,
            letterSpacing: 1,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAestheticSimilarity() {
    final List<String> userTags = currentUser['aestheticTags'] as List<String>;
    final List<String> matchTags = potentialMatch['aestheticTags'] as List<String>;

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            const Color(0xFF1A1A1A).withValues(alpha: 0.8),
            const Color(0xFF0A0A0A).withValues(alpha: 0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFB0FFF7).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Row(
            children: <Widget>[
              Icon(
                Icons.palette,
                color: Color(0xFFFF53A1),
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                'AESTHETIC HARMONY',
                style: TextStyle(
                  color: Color(0xFFB0FFF7),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'YOUR STYLE',
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          userTags.map((String tag) => _buildAestheticTag(tag, true)).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'THEIR STYLE',
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          matchTags.map((String tag) => _buildAestheticTag(tag, false)).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAestheticTag(String tag, bool isUser) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isUser
            ? const Color(0xFFB0FFF7).withValues(alpha: 0.1)
            : const Color(0xFFFF53A1).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUser
              ? const Color(0xFFB0FFF7).withValues(alpha: 0.3)
              : const Color(0xFFFF53A1).withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        tag,
        style: TextStyle(
          color: isUser ? const Color(0xFFB0FFF7) : const Color(0xFFFF53A1),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildCompatibilityScore() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(30),
      child: Column(
        children: <Widget>[
          const Text(
            'COMPATIBILITY ANALYSIS',
            style: TextStyle(
              color: Color(0xFFB0FFF7),
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),

          const SizedBox(height: 30),

          // Animated circular score meter
          AnimatedBuilder(
            animation: _scoreAnimation,
            builder: (BuildContext context, Widget? child) {
              return Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  // Outer glow ring
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: const Color(0xFFB0FFF7).withValues(alpha: 0.3),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                  ),

                  // Progress circle
                  SizedBox(
                    width: 160,
                    height: 160,
                    child: CircularProgressIndicator(
                      value: _scoreAnimation.value * (_compatibilityScore / 100),
                      strokeWidth: 8,
                      backgroundColor: const Color(0xFF333333),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _compatibilityScore >= 80
                            ? const Color(0xFFB0FFF7)
                            : _compatibilityScore >= 60
                                ? const Color(0xFFFF53A1)
                                : const Color(0xFF666666),
                      ),
                    ),
                  ),

                  // Score text
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        '${(_scoreAnimation.value * _compatibilityScore).round()}%',
                        style: const TextStyle(
                          color: Color(0xFFE6FFF4),
                          fontSize: 36,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 2,
                        ),
                      ),
                      const Text(
                        'MATCH',
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 14,
                          letterSpacing: 3,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNvsVerdict() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            const Color(0xFF1A1A1A).withValues(alpha: 0.9),
            const Color(0xFF0A0A0A).withValues(alpha: 0.95),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFB0FFF7).withValues(alpha: 0.5),
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFFB0FFF7).withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: <Color>[Color(0xFFB0FFF7), Color(0xFF00F0FF)],
                  ),
                ),
                child: const Icon(
                  Icons.psychology,
                  color: Colors.black,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'NVS VERDICT',
                style: TextStyle(
                  color: Color(0xFFB0FFF7),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            _nvsVerdict,
            style: const TextStyle(
              color: Color(0xFFE6FFF4),
              fontSize: 18,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildContinueButton() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (BuildContext context, Widget? child) {
          return Transform.scale(
            scale: 1.0 + (_pulseAnimation.value - 1.0) * 0.05,
            child: GestureDetector(
              onTap: () {
                // TODO: Navigate to Match Playground
                Navigator.pushNamed(context, '/connect/playground');
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: <Color>[Color(0xFFB0FFF7), Color(0xFF00F0FF)],
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: const Color(0xFFB0FFF7).withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.play_arrow,
                      color: Colors.black,
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'CONTINUE TO MATCH PLAYGROUND',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
