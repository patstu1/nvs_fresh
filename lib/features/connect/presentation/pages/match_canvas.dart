import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/meatup_core.dart';
import 'package:nvs/features/messages/domain/models/message_thread.dart';
import 'package:nvs/features/messages/domain/models/message.dart' show ChatContextType;
import '../widgets/aura_signature.dart';
import '../../domain/providers/connect_providers.dart';
import '../../domain/models/connect_models.dart';
import '../../data/ai_matchmaking_service.dart';
import '../../domain/models/compatibility_match.dart' as ai;
import '../../../messages/state/chat_thread_provider.dart';

/// One-by-one match presentation screen with cinematic 3D transitions
/// Displays compatibility scores and AI-generated insights from The Curator
class MatchCanvas extends ConsumerStatefulWidget {
  const MatchCanvas({super.key});

  @override
  ConsumerState<MatchCanvas> createState() => _MatchCanvasState();
}

class _MatchCanvasState extends ConsumerState<MatchCanvas> with TickerProviderStateMixin {
  late AnimationController _transitionController;
  late AnimationController _pulseController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  bool _isTransitioning = false;
  // final int _currentMatchIndex = 0; // unused

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadMatches();
  }

  void _setupAnimations() {
    _transitionController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _transitionController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _transitionController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(
        parent: _transitionController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _loadMatches() {
    final AIMatchmakingService svc = AIMatchmakingService();
    svc.findMatches(limit: 20).then((List<ai.CompatibilityMatch> list) {
      final List<MatchProfile> mapped = list
          .where((ai.CompatibilityMatch m) => (m.userProfile.avatarUrl ?? '').isNotEmpty)
          .map(
            (ai.CompatibilityMatch m) => MatchProfile(
              userId: m.userProfile.walletAddress,
              name: m.userProfile.effectiveDisplayName,
              photos: <String>[if (m.userProfile.avatarUrl != null) m.userProfile.avatarUrl!],
              compatibilityScore: m.score,
              curatorInsight: 'neural synergy index ${(m.score * 100).toStringAsFixed(1)}%',
              auraSignatureData: AuraSignatureData.defaultSignature(),
              profileData: <String, dynamic>{
                'age': m.userProfile.age,
                'distance': m.userProfile.location ?? 'nearby',
                'roles': m.userProfile.roles,
              },
            ),
          )
          .toList();
      ref.read(matchQueueProvider.notifier).loadMatches(mapped);
    }).catchError((Object e) {
      // Keep empty list on error; no mocks
      debugPrint('findMatches error: $e');
    });
  }

  Future<void> _passOnMatch() async {
    if (_isTransitioning) return;

    setState(() {
      _isTransitioning = true;
    });

    HapticFeedback.mediumImpact();

    await _transitionController.forward();

    ref.read(matchQueueProvider.notifier).passOnCurrentMatch();

    _transitionController.reset();

    setState(() {
      _isTransitioning = false;
    });
  }

  void _connectWithMatch() {
    if (_isTransitioning) return;

    final List<MatchProfile> matches = ref.read(matchQueueProvider);
    if (matches.isNotEmpty) {
      final MatchProfile currentMatch = matches.first;

      HapticFeedback.heavyImpact();

      // Show connection success dialog
      _showConnectionDialog(currentMatch);

      ref.read(matchQueueProvider.notifier).connectWithCurrentMatch();

      // Create/open thread immediately
      final MessageThread thread = ref.read(chatThreadListProvider.notifier).createThread(
            userId: currentMatch.userId,
            displayName: currentMatch.name,
            context: ChatContextType.connect,
            avatarUrl: currentMatch.photos.isNotEmpty ? currentMatch.photos.first : null,
          );
      // Navigate to messages screen for this thread
      Navigator.of(context).pushNamed('/messages');
    }
  }

  void _showConnectionDialog(MatchProfile match) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: NVSColors.cardBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: NVSColors.neonMint.withValues(alpha: 0.5),
              width: 2,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: NVSColors.neonMint.withValues(alpha: 0.3),
                blurRadius: 30,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                Icons.favorite,
                color: NVSColors.neonMint,
                size: 60,
              ),
              const SizedBox(height: 16),
              const Text(
                'Connection Created!',
                style: TextStyle(
                  fontFamily: 'MagdaCleanMono',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: NVSColors.neonMint,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'You and ${match.name} have been connected. Your conversation awaits in Messages.',
                style: const TextStyle(
                  fontFamily: 'MagdaCleanMono',
                  fontSize: 16,
                  color: NVSColors.ultraLightMint,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // Go back to dashboard
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: NVSColors.neonMint,
                  foregroundColor: NVSColors.pureBlack,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontFamily: 'MagdaCleanMono',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _transitionController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<MatchProfile> matches = ref.watch(matchQueueProvider);
    final AuraSignatureData? userAura = ref.watch(userAuraSignatureProvider);

    if (matches.isEmpty) {
      return _buildNoMatchesScreen();
    }

    final MatchProfile currentMatch = matches.first;

    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            // Background effects
            _buildBackgroundEffects(),

            // Main content
            AnimatedBuilder(
              animation: Listenable.merge(<Listenable?>[
                _fadeAnimation,
                _scaleAnimation,
                _pulseAnimation,
              ]),
              builder: (BuildContext context, Widget? child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: _buildMatchContent(currentMatch, userAura),
                  ),
                );
              },
            ),

            // Sliding new match preview
            AnimatedBuilder(
              animation: _slideAnimation,
              builder: (BuildContext context, Widget? child) {
                if (!_isTransitioning || matches.length < 2) {
                  return const SizedBox.shrink();
                }

                return Transform.translate(
                  offset: Offset(
                    MediaQuery.of(context).size.width * (1 - _slideAnimation.value),
                    0,
                  ),
                  child: Opacity(
                    opacity: _slideAnimation.value,
                    child: _buildMatchContent(matches[1], userAura),
                  ),
                );
              },
            ),

            // Header
            _buildHeader(matches.length),

            // Action buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundEffects() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            radius: 1.2,
            colors: <Color>[
              NVSColors.neonMint.withValues(alpha: 0.02),
              NVSColors.pureBlack,
              NVSColors.ultraLightMint.withValues(alpha: 0.01),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(int remainingMatches) {
    return Positioned(
      top: 20,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back,
              color: NVSColors.ultraLightMint,
              size: 28,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: NVSColors.cardBackground.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: NVSColors.neonMint.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              '$remainingMatches matches remaining',
              style: const TextStyle(
                fontFamily: 'MagdaCleanMono',
                fontSize: 14,
                color: NVSColors.ultraLightMint,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchContent(MatchProfile match, AuraSignatureData? userAura) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Column(
        children: <Widget>[
          // Match profile section
          Expanded(
            flex: 2,
            child: _buildProfileSection(match),
          ),

          // Aura comparison
          if (userAura != null)
            Expanded(
              child: AuraComparison(
                userAura: userAura,
                matchAura: match.auraSignatureData,
                compatibilityScore: match.compatibilityScore,
              ),
            ),

          // Curator insight
          Expanded(
            child: _buildCuratorInsight(match),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(MatchProfile match) {
    return Column(
      children: <Widget>[
        // Profile photo placeholder
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: NVSColors.cardBackground,
            border: Border.all(
              color: NVSColors.neonMint.withValues(alpha: 0.3),
              width: 3,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: NVSColors.neonMint.withValues(alpha: 0.2),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Icon(
            Icons.person,
            color: NVSColors.neonMint.withValues(alpha: 0.7),
            size: 80,
          ),
        ),

        const SizedBox(height: 20),

        // Name
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (BuildContext context, Widget? child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Text(
                match.name,
                style: const TextStyle(
                  fontFamily: 'MagdaCleanMono',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: NVSColors.ultraLightMint,
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 12),

        // Basic info
        Text(
          '${match.profileData['age'] ?? 'Unknown'} years old • ${match.profileData['distance'] ?? 'Nearby'}',
          style: const TextStyle(
            fontFamily: 'MagdaCleanMono',
            fontSize: 16,
            color: NVSColors.secondaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildCuratorInsight(MatchProfile match) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: NVSColors.cardBackground.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: NVSColors.neonMint.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: <Widget>[
          const Row(
            children: <Widget>[
              Icon(
                Icons.auto_awesome,
                color: NVSColors.neonMint,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'THE CURATOR SAYS',
                style: TextStyle(
                  fontFamily: 'MagdaCleanMono',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: NVSColors.neonMint,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            match.curatorInsight,
            style: const TextStyle(
              fontFamily: 'MagdaCleanMono',
              fontSize: 16,
              color: NVSColors.ultraLightMint,
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Positioned(
      bottom: 40,
      left: 24,
      right: 24,
      child: Row(
        children: <Widget>[
          // Pass button
          Expanded(
            child: GestureDetector(
              onTap: _passOnMatch,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: NVSColors.cardBackground.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: NVSColors.secondaryText.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: const Text(
                  'PASS',
                  style: TextStyle(
                    fontFamily: 'MagdaCleanMono',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: NVSColors.secondaryText,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Connect button
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: _connectWithMatch,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: <Color>[
                      NVSColors.neonMint,
                      NVSColors.ultraLightMint,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: NVSColors.neonMint.withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Text(
                  'CONNECT',
                  style: TextStyle(
                    fontFamily: 'MagdaCleanMono',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: NVSColors.pureBlack,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoMatchesScreen() {
    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.favorite_border,
                color: NVSColors.neonMint.withValues(alpha: 0.5),
                size: 80,
              ),
              const SizedBox(height: 24),
              const Text(
                'No more matches',
                style: TextStyle(
                  fontFamily: 'MagdaCleanMono',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: NVSColors.ultraLightMint,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Check back later for new connections',
                style: TextStyle(
                  fontFamily: 'MagdaCleanMono',
                  fontSize: 16,
                  color: NVSColors.secondaryText,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: NVSColors.neonMint,
                  foregroundColor: NVSColors.pureBlack,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Back to Dashboard',
                  style: TextStyle(
                    fontFamily: 'MagdaCleanMono',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
