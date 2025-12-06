import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../../core/theme/nvs_colors.dart';
import '../../../../models/match_user_model.dart';
import '../synaptic_match_card.dart';
import 'package:nvs/features/messenger/presentation/universal_messaging_sheet.dart';

class ConnectViewWidget extends ConsumerStatefulWidget {
  const ConnectViewWidget({super.key});

  @override
  ConsumerState<ConnectViewWidget> createState() => _ConnectViewWidgetState();
}

class _ConnectViewWidgetState extends ConsumerState<ConnectViewWidget>
    with TickerProviderStateMixin {
  late final AudioPlayer _audioPlayer = AudioPlayer();
  late PageController _pageController;
  late AnimationController _cardController;
  late AnimationController _glowController;
  late Animation<double> _cardAnimation;
  late Animation<double> _glowAnimation;

  int _currentIndex = 0;
  List<MatchUser> _matches = <MatchUser>[];

  final List<String> _analysisSteps = <String>[
    'Analyzing Birth Chart Compatibility...',
    'Mapping Psychological Profiles...',
    'Calculating Role Polarity...',
    'Forecasting Emotional Dynamics...',
    'Generating Match Details...',
    'Projecting Risk Factors...',
    'Finalizing AI Verdict...',
    'Complete Compatibility Report',
    'Ready to Connect',
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializePageController();
    _generateMatches();
    _maybeShowOnboarding();
  }

  Future<void> _maybeShowOnboarding() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool done = prefs.getBool('hasCompletedConnectOnboarding') ?? false;
    if (!done && mounted) {
      // Delay to allow first frame
      await Future<void>.delayed(const Duration(milliseconds: 200));
      if (!mounted) return;
      context.push('/connect/onboarding');
    }
  }

  void _initializeAnimations() {
    _cardController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);

    _glowController = AnimationController(duration: const Duration(seconds: 2), vsync: this)
      ..repeat(reverse: true);

    _cardAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _cardController, curve: Curves.elasticOut));

    _glowAnimation = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _glowController, curve: Curves.easeInOut));

    _cardController.forward();
  }

  void _initializePageController() {
    _pageController = PageController(viewportFraction: 0.9);
  }

  void _openOnboarding() {
    if (!mounted) return;
    context.push('/connect/onboarding');
  }

  void _openMatchDetail(MatchUser match) {
    if (!mounted) return;
    final String id = match.id;
    context.push('/connect/match/$id');
  }

  void _generateMatches() {
    final math.Random random = math.Random();
    final List<String> usernames = <String>[
      'AlexSoulmate',
      'SamDestiny',
      'JordanFate',
      'CaseyMagic',
      'RileySync',
    ];
    final List<String> roles = <String>[
      'Top',
      'Vers Top',
      'Vers',
      'Vers Bottom',
      'Bottom',
      'Power Bottom',
    ];
    final List<String> signs = <String>[
      'Aries',
      'Taurus',
      'Gemini',
      'Cancer',
      'Leo',
      'Virgo',
      'Libra',
      'Scorpio',
    ];
    final List<String> locations = <String>[
      'New York',
      'Los Angeles',
      'Chicago',
      'San Francisco',
      'Miami',
    ];

    _matches = List.generate(5, (int index) {
      return MatchUser(
        id: 'match_$index',
        username: usernames[index],
        displayName: usernames[index],
        role: roles[random.nextInt(roles.length)],
        age: 22 + random.nextInt(20),
        location: locations[random.nextInt(locations.length)],
        tags: <String>['Kinky', 'Romantic', 'Experimental'].take(2 + random.nextInt(2)).toList(),
        interests: <String>['Music', 'Art', 'Fitness', 'Travel'].take(3).toList(),
        traits: <String, int>{
          'obsession': 7 + random.nextInt(3),
          'control': 6 + random.nextInt(4),
          'emotional_sync': 8 + random.nextInt(2),
          'trust': 7 + random.nextInt(3),
          'kink_alignment': 8 + random.nextInt(2),
          'communication': 7 + random.nextInt(3),
          'adventure': 6 + random.nextInt(4),
          'commitment': 8 + random.nextInt(2),
        },
        sun: signs[random.nextInt(signs.length)],
        moon: signs[random.nextInt(signs.length)],
        rising: signs[random.nextInt(signs.length)],
        compatibilityScore: 85 + random.nextInt(15),
        aiAnalysis: <String, dynamic>{
          'connection_type': <String>['instant', 'slow_burn', 'intellectual'][random.nextInt(3)],
          'attraction_level': 8 + random.nextInt(2),
          'compatibility_summary': 'High synergy in emotional and physical domains',
        },
        connectionType: 'instant',
      );
    });

    setState(() {});
  }

  @override
  void dispose() {
    _cardController.dispose();
    _glowController.dispose();
    _pageController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      appBar: AppBar(
        backgroundColor: NVSColors.pureBlack,
        elevation: 0,
        title: Text(
          'CONNECT',
          style: TextStyle(
            color: NVSColors.ultraLightMint,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'MagdaCleanMono',
            letterSpacing: 2,
            shadows: <Shadow>[
              Shadow(color: NVSColors.ultraLightMint.withValues(alpha: 0.5), blurRadius: 8),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              _buildAnalysisIndicator(),
              _buildProgressIndicator(),
              Expanded(child: _matches.isEmpty ? _buildLoadingState() : _buildMatchCards()),
              _buildActionButtons(),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 16,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: NVSColors.ultraLightMint.withValues(alpha: 0.5)),
              ),
              child: IconButton(
                icon: const Icon(Icons.android, color: NVSColors.ultraLightMint),
                onPressed: _openOnboarding,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisIndicator() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: NVSColors.cardBackground,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: NVSColors.ultraLightMint.withValues(alpha: 0.6)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: NVSColors.ultraLightMint.withValues(alpha: 0.2),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          AnimatedBuilder(
            animation: _glowController,
            builder: (BuildContext context, Widget? child) {
              return Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: NVSColors.electricPink,
                  shape: BoxShape.circle,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: NVSColors.electricPink.withValues(alpha: _glowAnimation.value * 0.8),
                      blurRadius: 6,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'AI MATCHMAKER • DEEP COMPATIBILITY ANALYSIS',
              style: TextStyle(
                color: NVSColors.ultraLightMint,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: NVSFonts.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(9, (int index) {
          final bool isActive = index <= _currentIndex;
          return Expanded(
            child: Container(
              height: 3,
              margin: EdgeInsets.only(right: index < 8 ? 4 : 0),
              decoration: BoxDecoration(
                color: isActive
                    ? NVSColors.ultraLightMint
                    : NVSColors.ultraLightMint.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
                boxShadow: isActive
                    ? <BoxShadow>[
                        BoxShadow(
                          color: NVSColors.ultraLightMint.withValues(alpha: 0.5),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AnimatedBuilder(
            animation: _glowController,
            builder: (BuildContext context, Widget? child) {
              return Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: <Color>[
                      NVSColors.electricPink.withValues(alpha: _glowAnimation.value * 0.6),
                      NVSColors.ultraLightMint.withValues(alpha: _glowAnimation.value * 0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    '🔮',
                    style: TextStyle(
                      fontSize: 48,
                      shadows: <Shadow>[
                        Shadow(
                          color: NVSColors.electricPink.withValues(alpha: 0.8),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            _analysisSteps[_currentIndex % _analysisSteps.length],
            style: const TextStyle(
              color: NVSColors.ultraLightMint,
              fontSize: 16,
              fontFamily: 'MagdaCleanMono',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMatchCards() {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (int index) {
        setState(() => _currentIndex = index % 9);
      },
      itemCount: _matches.length,
      itemBuilder: (BuildContext context, int index) {
        final MatchUser match = _matches[index];
        return AnimatedBuilder(
          animation: _cardAnimation,
          builder: (BuildContext context, Widget? child) {
            return Transform.scale(
              scale: _cardAnimation.value,
              child: GestureDetector(
                onTap: () => _openMatchDetail(match),
                child: SynapticMatchCard(
                  leftImageUrl: 'assets/images/IMG_2217 2.jpg',
                  rightImageUrl: 'assets/images/IMG_2223 2.jpg',
                  matchPercent: match.compatibilityScore.toDouble(),
                  sharedInterests: const <String, double>{
                    'values': 0.82,
                    'music': 0.66,
                    'nightlife': 0.58,
                    'style': 0.74,
                  },
                  badges: const <String>['chemistry', 'signal', 'trust', 'kink'],
                  onMessageNow: () {
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (BuildContext ctx) {
                        return UniversalMessagingSheet(
                          section: MessagingSection.connect,
                          targetUserId: match.id,
                          displayName: match.displayName ?? match.username,
                          avatarUrl: match.photoURL,
                        );
                      },
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Legacy card builder removed; using NvsMatchCard.

  // Legacy sub-builders removed; superseded by NvsMatchCard.

  // removed

  Widget _buildAstrologicalInfo(MatchUser match) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NVSColors.ultraLightMint.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: NVSColors.ultraLightMint.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: <Widget>[
          const Text(
            'ASTROLOGICAL SYNC',
            style: TextStyle(
              color: NVSColors.ultraLightMint,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: 'MagdaCleanMono',
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(match.astroEmoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 4),
          Text(
            '${match.sun} ☉ ${match.moon} ☽ ${match.rising} ↗',
            style: const TextStyle(
              color: NVSColors.secondaryText,
              fontSize: 12,
              fontFamily: 'MagdaCleanMono',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTraitCompatibility(MatchUser match) {
    final List<MapEntry<String, int>> topTraits = match.traits.entries.toList()
      ..sort((MapEntry<String, int> a, MapEntry<String, int> b) => b.value.compareTo(a.value));

    return Column(
      children: <Widget>[
        const Text(
          'TRAIT COMPATIBILITY',
          style: TextStyle(
            color: NVSColors.ultraLightMint,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            fontFamily: 'MagdaCleanMono',
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        ...topTraits.take(3).map(_buildTraitBar),
      ],
    );
  }

  Widget _buildTraitBar(MapEntry<String, int> trait) {
    final double value = trait.value / 10.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 100,
            child: Text(
              trait.key.replaceAll('_', ' ').toUpperCase(),
              style: const TextStyle(
                color: NVSColors.secondaryText,
                fontSize: 10,
                fontFamily: NVSFonts.primary,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: NVSColors.ultraLightMint.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                widthFactor: value,
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    color: NVSColors.ultraLightMint,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${trait.value}',
            style: const TextStyle(
              color: NVSColors.ultraLightMint,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              fontFamily: 'MagdaCleanMono',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAISummary(MatchUser match) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NVSColors.electricPink.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: NVSColors.electricPink.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: <Widget>[
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('🧠', style: TextStyle(fontSize: 16)),
              SizedBox(width: 8),
              Text(
                'AI VERDICT',
                style: TextStyle(
                  color: NVSColors.electricPink,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: NVSFonts.primary,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            (match.aiAnalysis['compatibility_summary'] ?? 'Perfect synergy detected').toString(),
            style: const TextStyle(
              color: NVSColors.ultraLightMint,
              fontSize: 12,
              fontFamily: 'MagdaCleanMono',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: <Widget>[
          Expanded(child: _buildActionButton('✗', 'PASS', NVSColors.secondaryText, _handlePass)),
          const SizedBox(width: 20),
          Expanded(
            child: _buildActionButton('💖', 'CONNECT', NVSColors.electricPink, _handleConnect),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String icon, String text, Color color, VoidCallback onPressed) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: NVSFonts.primary,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCompatibilityColor(int score) {
    if (score >= 95) return NVSColors.ultraLightMint;
    if (score >= 90) return NVSColors.avocadoGreen;
    if (score >= 85) return NVSColors.turquoiseNeon;
    return NVSColors.electricPink;
  }

  void _handlePass() {
    if (_matches.isNotEmpty) {
      setState(() {
        _matches.removeAt(0);
        _currentIndex = (_currentIndex + 1) % 9;
      });

      if (_matches.isEmpty) {
        _generateMatches();
      }
    }
  }

  void _handleConnect() {
    if (_matches.isNotEmpty) {
      final MatchUser match = _matches.first;

      _triggerMatchAlerts();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connected with ${match.username}! 💖'),
          backgroundColor: NVSColors.electricPink,
          duration: const Duration(seconds: 3),
        ),
      );

      _handlePass();
    }
  }

  Future<void> _triggerMatchAlerts() async {
    // Haptics
    try {
      await HapticFeedback.heavyImpact();
    } catch (_) {}
    try {
      if (await Vibration.hasVibrator() ?? false) {
        await Vibration.vibrate(pattern: <int>[0, 45, 25, 45]);
      }
    } catch (_) {}

    // Minimal sound cue (expects assets/sounds/throat_clear.mp3 to be present)
    try {
      await _audioPlayer.play(AssetSource('sounds/throat_clear.mp3'));
    } catch (_) {
      // Asset not present or unsupported platform; skip sound.
    }
  }
}
