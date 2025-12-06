import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class NvsConnectScreen extends StatefulWidget {
  const NvsConnectScreen({super.key});

  @override
  State<NvsConnectScreen> createState() => _NvsConnectScreenState();
}

class _NvsConnectScreenState extends State<NvsConnectScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _glowController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _videoController = VideoPlayerController.asset(
      'assets/videos/vecteezy_glowing-line-with-waving-animation-on-black-background_67815418.mp4',
    )
      ..setLooping(true)
      ..setVolume(0)
      ..initialize().then((_) {
        setState(() {});
        _videoController.play();
      });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _glowController.dispose();
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: Stack(
        children: <Widget>[
          if (_videoController.value.isInitialized)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController.value.size.width,
                  height: _videoController.value.size.height,
                  child: VideoPlayer(_videoController),
                ),
              ),
            ),
          // DEBUG BANNER
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: const Color(0xFFB0FFF7),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: const Center(
                child: Text(
                  'DEBUG: Connect screen loaded',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  // NVS AI Header
                  _buildNvsHeader(),
                  // Split Screen Compatibility Analysis
                  _buildSplitScreenAnalysis(),
                  // Zodiac Compatibility
                  _buildZodiacCompatibility(),
                  // Shared Interests with Charts
                  _buildSharedInterests(),
                  // Compatibility Metrics
                  _buildCompatibilityMetrics(),
                  // Mutual Network Analysis
                  _buildNetworkAnalysis(),
                  // Aesthetic Similarity
                  _buildAestheticSimilarity(),
                  // Final Match Score
                  _buildMatchScore(),
                  // NVS Verdict
                  _buildNvsVerdict(),
                  // Continue Button
                  _buildContinueButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNvsHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: <Widget>[
          // NVS Avatar/Logo
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (BuildContext context, Widget? child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: <Color>[Color(0xFFB0FFF7), Color(0xFF00F0FF)],
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: const Color(0xFFB0FFF7).withValues(alpha: 0.5),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'NVS',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'NVS AI COMPATIBILITY',
                  style: TextStyle(
                    color: Color(0xFFB0FFF7),
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Let's begin... I'm NVS. My job is to know who you'll actually click with.",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSplitScreenAnalysis() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          // Central Split Face Visual
          _buildCentralSplitFace(),

          const SizedBox(height: 30),

          // User Comparison Row
          Row(
            children: <Widget>[
              // User A (Current User)
              Expanded(
                child: _buildUserProfile(
                  name: 'You',
                  avatar: 'assets/images/avatar_placeholder.png',
                  isCurrentUser: true,
                  score: '12.022',
                ),
              ),
              const SizedBox(width: 20),
              // VS Indicator
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFB0FFF7),
                    width: 2,
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: const Color(0xFFB0FFF7).withValues(alpha: 0.3),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'VS',
                    style: TextStyle(
                      color: Color(0xFFB0FFF7),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // User B (Potential Match)
              Expanded(
                child: _buildUserProfile(
                  name: 'Alex',
                  avatar: 'assets/images/avatar_placeholder.png',
                  isCurrentUser: false,
                  score: '27.2322',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCentralSplitFace() {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // Outer Glowing Ring
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: <Color>[
                  Color(0xFFFF53A1), // Pink
                  Color(0xFFB0FFF7), // Mint
                ],
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: const Color(0xFFB0FFF7).withValues(alpha: 0.5),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),

          // Inner Ring
          Container(
            width: 180,
            height: 180,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
          ),

          // Split Face Design
          SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              children: <Widget>[
                // Left half (Pink)
                Positioned(
                  left: 0,
                  child: Container(
                    width: 60,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(60),
                        bottomLeft: Radius.circular(60),
                      ),
                      gradient: LinearGradient(
                        colors: <Color>[
                          const Color(0xFFFF53A1).withValues(alpha: 0.8),
                          const Color(0xFFFF53A1).withValues(alpha: 0.3),
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),

                // Right half (Green/Mint)
                Positioned(
                  right: 0,
                  child: Container(
                    width: 60,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(60),
                        bottomRight: Radius.circular(60),
                      ),
                      gradient: LinearGradient(
                        colors: <Color>[
                          const Color(0xFFB0FFF7).withValues(alpha: 0.3),
                          const Color(0xFFB0FFF7).withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Surrounding Icons
          Positioned(
            top: 10,
            left: 10,
            child: _buildSurroundingIcon(Icons.thumb_up, const Color(0xFFFF53A1)),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: _buildSurroundingIcon(
              Icons.favorite_border,
              const Color(0xFFB0FFF7),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: _buildSurroundingIcon(
              Icons.camera_alt,
              const Color(0xFF00F0FF),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: _buildSurroundingIcon(Icons.favorite, const Color(0xFFFF53A1)),
          ),
        ],
      ),
    );
  }

  Widget _buildSurroundingIcon(IconData icon, Color color) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.2),
        border: Border.all(
          color: color,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: 8,
          ),
        ],
      ),
      child: Icon(
        icon,
        color: color,
        size: 16,
      ),
    );
  }

  Widget _buildUserProfile({
    required String name,
    required String avatar,
    required bool isCurrentUser,
    required String score,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFB0FFF7).withValues(alpha: 0.5),
        ),
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Colors.black,
            const Color(0xFFB0FFF7).withValues(alpha: 0.1),
          ],
        ),
      ),
      child: Column(
        children: <Widget>[
          // Avatar with glowing ring
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: const Color(0xFFB0FFF7).withValues(alpha: 0.5),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 35,
              backgroundImage: AssetImage(avatar),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            name,
            style: const TextStyle(
              color: Color(0xFFB0FFF7),
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            score,
            style: TextStyle(
              color: const Color(0xFFB0FFF7).withValues(alpha: 0.8),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZodiacCompatibility() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFB0FFF7).withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'ZODIAC COMPATIBILITY',
            style: TextStyle(
              color: Color(0xFFB0FFF7),
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: <Widget>[
              Expanded(
                child: _buildZodiacInfo('Sun', 'Leo', '♌'),
              ),
              Expanded(
                child: _buildZodiacInfo('Moon', 'Scorpio', '♏'),
              ),
              Expanded(
                child: _buildZodiacInfo('Rising', 'Gemini', '♊'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFFB0FFF7).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFFB0FFF7).withValues(alpha: 0.3),
              ),
            ),
            child: const Text(
              'Leo + Scorpio: explosive potential... or a restraining order.',
              style: TextStyle(
                color: Color(0xFFB0FFF7),
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZodiacInfo(String type, String sign, String symbol) {
    return Column(
      children: <Widget>[
        Text(
          symbol,
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(height: 5),
        Text(
          type,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 12,
            fontWeight: FontWeight.w300,
          ),
        ),
        Text(
          sign,
          style: const TextStyle(
            color: Color(0xFFB0FFF7),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSharedInterests() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Row(
        children: <Widget>[
          // Left side - Shared Interests List
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFB0FFF7).withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'SHARED INTERESTS',
                    style: TextStyle(
                      color: Color(0xFFB0FFF7),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildInterestItem('You Diline Love'),
                  _buildInterestItem('Coffee Shops'),
                  _buildInterestItem('Digital Art'),
                  _buildInterestItem('Spiritual Growth'),
                  _buildInterestItem('Adventure Travel'),
                ],
              ),
            ),
          ),

          const SizedBox(width: 20),

          // Right side - Pie Chart
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFB0FFF7).withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: <Widget>[
                  const Text(
                    'MATCH %',
                    style: TextStyle(
                      color: Color(0xFFB0FFF7),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildPieChart(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterestItem(String interest) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFB0FFF7).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFB0FFF7).withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        interest,
        style: const TextStyle(
          color: Color(0xFFB0FFF7),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // Pie chart segments
          CustomPaint(
            size: const Size(80, 80),
            painter: PieChartPainter(),
          ),
          // Center percentage
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
              border: Border.all(
                color: const Color(0xFFB0FFF7),
                width: 2,
              ),
            ),
            child: const Center(
              child: Text(
                '92.0%',
                style: TextStyle(
                  color: Color(0xFFB0FFF7),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompatibilityMetrics() {
    final List<Map<String, Object>> metrics = <Map<String, Object>>[
      <String, Object>{'name': 'Emotional', 'score': 85, 'color': const Color(0xFFB0FFF7)},
      <String, Object>{'name': 'Sexual', 'score': 92, 'color': const Color(0xFFFF53A1)},
      <String, Object>{'name': 'Long-term', 'score': 78, 'color': const Color(0xFF00F0FF)},
      <String, Object>{'name': 'Communication', 'score': 88, 'color': const Color(0xFFB0FFF7)},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'COMPATIBILITY METRICS',
            style: TextStyle(
              color: Color(0xFFB0FFF7),
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 15),
          ...metrics.map(
            (Map<String, Object> metric) => _buildMetricBar(
              metric['name'] as String,
              metric['score'] as int,
              metric['color'] as Color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricBar(String name, int score, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                name,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                '$score%',
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: score / 100,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[color, color.withValues(alpha: 0.7)],
                  ),
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: color.withValues(alpha: 0.5),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkAnalysis() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFB0FFF7).withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'MUTUAL NETWORK',
            style: TextStyle(
              color: Color(0xFFB0FFF7),
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: <Widget>[
              Expanded(
                child: _buildNetworkItem('Mutual Friends', '12'),
              ),
              Expanded(
                child: _buildNetworkItem('Same Clubs', '3'),
              ),
              Expanded(
                child: _buildNetworkItem('Brands', '8'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkItem(String label, String count) {
    return Column(
      children: <Widget>[
        Text(
          count,
          style: const TextStyle(
            color: Color(0xFFB0FFF7),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 12,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  Widget _buildAestheticSimilarity() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFB0FFF7).withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'AESTHETIC HARMONY',
            style: TextStyle(
              color: Color(0xFFB0FFF7),
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: <Widget>[
              Expanded(
                child: _buildAestheticItem('Style Match', '89%'),
              ),
              Expanded(
                child: _buildAestheticItem('Color Palette', '76%'),
              ),
              Expanded(
                child: _buildAestheticItem('Vibe Sync', '94%'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAestheticItem(String label, String percentage) {
    return Column(
      children: <Widget>[
        Text(
          percentage,
          style: const TextStyle(
            color: Color(0xFFB0FFF7),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 12,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  Widget _buildMatchScore() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (BuildContext context, Widget? child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: <Color>[Color(0xFFB0FFF7), Color(0xFF00F0FF)],
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: const Color(0xFFB0FFF7).withValues(alpha: 0.5),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      '87%',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 15),
          const Text(
            'MATCH SCORE',
            style: TextStyle(
              color: Color(0xFFB0FFF7),
              fontSize: 18,
              fontWeight: FontWeight.w500,
              letterSpacing: 3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNvsVerdict() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFB0FFF7).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFB0FFF7).withValues(alpha: 0.3),
        ),
      ),
      child: const Column(
        children: <Widget>[
          Text(
            'NVS VERDICT',
            style: TextStyle(
              color: Color(0xFFB0FFF7),
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: 15),
          Text(
            "85% Emotional Fit – but prepare for chaos during Mercury retrograde. This could be electric — just don't ghost each other after 48 hours.",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          // Three heart icons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildHeartIcon(const Color(0xFFFF53A1)),
              const SizedBox(width: 10),
              _buildHeartIcon(const Color(0xFFB0FFF7)),
              const SizedBox(width: 10),
              _buildHeartIcon(const Color(0xFFFF53A1)),
            ],
          ),

          const SizedBox(height: 20),

          // MESSAGE NOW button
          AnimatedBuilder(
            animation: _glowAnimation,
            builder: (BuildContext context, Widget? child) {
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      const Color(0xFFB0FFF7),
                      const Color(0xFFB0FFF7).withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: const Color(0xFFB0FFF7).withValues(alpha: _glowAnimation.value),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: HapticFeedback.lightImpact,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'MESSAGE NOW',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeartIcon(Color color) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.3),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: 8,
          ),
        ],
      ),
      child: const Icon(
        Icons.favorite,
        color: Colors.white,
        size: 12,
      ),
    );
  }
}

class PieChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width / 2;

    // Define segments (pink, green, blue)
    final List<Map<String, Object>> segments = <Map<String, Object>>[
      <String, Object>{'color': const Color(0xFFFF53A1), 'sweepAngle': 0.4}, // 40%
      <String, Object>{'color': const Color(0xFFB0FFF7), 'sweepAngle': 0.35}, // 35%
      <String, Object>{'color': const Color(0xFF00F0FF), 'sweepAngle': 0.25}, // 25%
    ];

    double startAngle = 0;

    for (final Map<String, Object> segment in segments) {
      final Paint paint = Paint()
        ..color = segment['color'] as Color
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        (segment['sweepAngle'] as double) * 2 * 3.14159,
        true,
        paint,
      );

      startAngle += (segment['sweepAngle'] as double) * 2 * 3.14159;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
