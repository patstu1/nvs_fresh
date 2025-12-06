import 'package:flutter/material.dart';
import 'package:nvs/shared/widgets/glitch_crt_shader.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/meatup_core.dart';
import '../widgets/aura_signature.dart';
import '../../domain/providers/connect_providers.dart';
import '../../domain/models/connect_models.dart';
import 'match_canvas.dart';

/// The user's personal sanctuary and hub for viewing matches
/// Features the AuraSignature visualization prominently
class ConnectDashboard extends ConsumerStatefulWidget {
  const ConnectDashboard({super.key});

  @override
  ConsumerState<ConnectDashboard> createState() => _ConnectDashboardState();
}

class _ConnectDashboardState extends ConsumerState<ConnectDashboard> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _floatController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadUserData());
    // glitch/static background handled in _buildBackgroundEffects via shader
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _floatController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _floatAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  void _loadUserData() {
    // Load user's aura signature if not already set
    final AuraSignatureData? currentAura = ref.read(userAuraSignatureProvider);
    if (currentAura == null) {
      ref.read(userAuraSignatureProvider.notifier).state = AuraSignatureData.defaultSignature();
    }
  }

  void _initBackgroundVideo() {}

  void _navigateToMatches() {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        pageBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) =>
            const MatchCanvas(),
        transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOutCubic,
              ),
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  void _navigateToAIMatchmaker() {
    context.push('/connect/ai');
  }

  void _refineProfile() {
    // Reset the resonance session to allow re-engagement with The Curator
    ref.read(conversationStateProvider.notifier).reset();
    ref.read(resonanceSessionCompleteProvider.notifier).state = false;
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuraSignatureData? userAura = ref.watch(userAuraSignatureProvider);

    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            // Background ambient effects
            _buildBackgroundEffects(),

            // Main content
            SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: <Widget>[
                  // Header
                  _buildHeader(),

                  const SizedBox(height: 40),

                  // AI guide panel (human-like matchmaker)
                  _buildAIGuidePanel(),

                  const SizedBox(height: 24),

                  // Aura Signature (prominent display)
                  _buildAuraSignatureSection(userAura),

                  const SizedBox(height: 60),

                  // Main CTA button
                  _buildMainCTAButton(),

                  const SizedBox(height: 24),

                  // AI character matchmaker CTA
                  _buildAIMatchmakerCTA(),

                  const SizedBox(height: 24),

                  // Quick links to connect modules
                  _buildConnectQuickLinks(),

                  const SizedBox(height: 24),

                  // Refine profile link
                  _buildRefineProfileLink(),

                  const SizedBox(height: 40),

                  // Recent activity or stats
                  _buildActivitySection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectQuickLinks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'explore connect modules',
          style: TextStyle(
            fontFamily: 'MagdaClean',
            fontSize: 16,
            color: NVSColors.ultraLightMint,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: <Widget>[
            _quickLinkButton(label: 'vibe analysis', onTap: () => context.push('/connect/vibe')),
            _quickLinkButton(label: 'heatmap', onTap: () => context.push('/connect/heatmap')),
            _quickLinkButton(label: 'verdict', onTap: () => context.push('/connect/verdict')),
          ],
        ),
      ],
    );
  }

  Widget _quickLinkButton({required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: NVSColors.cardBackground.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: NVSColors.neonMint.withValues(alpha: 0.25)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: NVSColors.neonMint.withValues(alpha: 0.12),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'MagdaClean',
            fontSize: 14,
            color: NVSColors.ultraLightMint,
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundEffects() {
    return Positioned.fill(
      child: Stack(
        children: <Widget>[
          // Glitch CRT/static shader background
          const GlitchCRTShader(child: SizedBox.expand()),
          // Dim overlay for legibility
          Container(color: Colors.black.withOpacity(0.72)),
          // Ambient gradient
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 1.5,
                colors: <Color>[
                  NVSColors.neonMint.withValues(alpha: 0.03),
                  NVSColors.pureBlack,
                  NVSColors.ultraLightMint.withValues(alpha: 0.02),
                ],
                stops: const <double>[0.0, 0.6, 1.0],
              ),
            ),
          ),

          // Floating particles
          AnimatedBuilder(
            animation: _floatAnimation,
            builder: (BuildContext context, Widget? child) {
              return Positioned(
                top: 100 + _floatAnimation.value,
                right: 50,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: NVSColors.neonMint.withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: NVSColors.neonMint.withValues(alpha: 0.3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          AnimatedBuilder(
            animation: _floatAnimation,
            builder: (BuildContext context, Widget? child) {
              return Positioned(
                top: 300 - _floatAnimation.value,
                left: 80,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: NVSColors.ultraLightMint.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: NVSColors.ultraLightMint.withValues(alpha: 0.2),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (BuildContext context, Widget? child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Text(
                'nvs — connect',
                style: TextStyle(
                  fontFamily: 'BellGothic', // Using actual Bell Gothic font file
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: NVSColors.neonMint,
                  letterSpacing: 3,
                  shadows: <Shadow>[
                    Shadow(
                      color: NVSColors.neonMint.withValues(alpha: _pulseAnimation.value),
                      blurRadius: 20,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        const Text(
          'your nvs matchmaker is ready to guide you into compatible connections',
          style: TextStyle(
            fontFamily: 'MagdaClean',
            fontSize: 16,
            color: NVSColors.secondaryText,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAuraSignatureSection(AuraSignatureData? userAura) {
    return Column(
      children: <Widget>[
        const Text(
          'your profile signal',
          style: TextStyle(
            fontFamily: 'MagdaClean',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: NVSColors.ultraLightMint,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 24),

        // Aura visualization
        AnimatedBuilder(
          animation: _floatAnimation,
          builder: (BuildContext context, Widget? child) {
            return Transform.translate(
              offset: Offset(0, _floatAnimation.value * 0.5),
              child: SizedBox(
                width: 280,
                height: 280,
                child: userAura != null ? AuraSignature(userData: userAura) : _buildLoadingAura(),
              ),
            );
          },
        ),

        const SizedBox(height: 20),

        // Aura description
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: NVSColors.cardBackground.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: NVSColors.neonMint.withValues(alpha: 0.2),
            ),
          ),
          child: const Text(
            'we learn from your answers and activity to surface high‑compatibility intros. keep exploring to sharpen your picks.',
            style: TextStyle(
              fontFamily: 'MagdaClean',
              fontSize: 14,
              color: NVSColors.ultraLightMint,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingAura() {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: NVSColors.neonMint.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          color: NVSColors.neonMint,
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildMainCTAButton() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (BuildContext context, Widget? child) {
        return Transform.scale(
          scale: 1.0 + (_pulseAnimation.value - 0.5) * 0.05,
          child: GestureDetector(
            onTap: _navigateToMatches,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
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
                  BoxShadow(
                    color: NVSColors.neonMint.withValues(alpha: _pulseAnimation.value * 0.3),
                    blurRadius: 40,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Text(
                'view potential matches',
                style: TextStyle(
                  fontFamily: 'BellGothic', // Using Bell Gothic as specified
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: NVSColors.pureBlack,
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAIMatchmakerCTA() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (BuildContext context, Widget? child) {
        return Transform.scale(
          scale: 1.0 + (_pulseAnimation.value - 0.5) * 0.03,
          child: GestureDetector(
            onTap: _navigateToAIMatchmaker,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: NVSColors.cardBackground.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: NVSColors.neonMint.withValues(alpha: 0.35)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: NVSColors.neonMint.withValues(alpha: 0.18),
                    blurRadius: 14,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Text(
                'ai matchmaker (domBot)',
                style: TextStyle(
                  fontFamily: 'BellGothic',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: NVSColors.ultraLightMint,
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAIGuidePanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NVSColors.cardBackground.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: NVSColors.neonMint.withValues(alpha: 0.28)),
        boxShadow: const <BoxShadow>[BoxShadow(color: Colors.black54, blurRadius: 10)],
      ),
      child: Row(
        children: <Widget>[
          // Character avatar
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: NVSColors.neonMint.withValues(alpha: 0.5)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset('assets/icons/yo.jpg', fit: BoxFit.cover),
          ),
          const SizedBox(width: 14),
          // Copy
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'DOM — your ai matchmaker',
                  style: TextStyle(
                    fontFamily: 'BellGothic',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                    color: NVSColors.ultraLightMint,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'I’ll steer you to high‑compatibility intros and calibrate your preferences as you swipe. Ready when you are.',
                  style: TextStyle(
                    fontFamily: 'MagdaCleanMono',
                    fontSize: 13,
                    height: 1.35,
                    color: NVSColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Action
          GestureDetector(
            onTap: _navigateToAIMatchmaker,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: NVSColors.neonMint.withValues(alpha: 0.5)),
              ),
              child: const Text(
                'ask dom',
                style: TextStyle(
                  fontFamily: 'BellGothic',
                  fontSize: 12,
                  letterSpacing: 1.2,
                  color: NVSColors.ultraLightMint,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRefineProfileLink() {
    return GestureDetector(
      onTap: _refineProfile,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          'refine your profile',
          style: TextStyle(
            fontFamily: 'MagdaClean',
            fontSize: 16,
            color: NVSColors.secondaryText,
            decoration: TextDecoration.underline,
            decorationColor: NVSColors.secondaryText.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildActivitySection() {
    return Column(
      children: <Widget>[
        const Text(
          'RECENT ACTIVITY',
          style: TextStyle(
            fontFamily: 'MagdaClean',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: NVSColors.ultraLightMint,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool isNarrow = constraints.maxWidth < 400;
            final List<Widget> cards = <Widget>[
              _buildStatCard('Profile Views', '12'),
              _buildStatCard('compatibility', '96%'),
              _buildStatCard('connections', '3'),
            ];
            if (isNarrow) {
              return Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: cards,
              );
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: cards,
            );
          },
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: NVSColors.cardBackground.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: NVSColors.neonMint.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: <Widget>[
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'MagdaClean',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: NVSColors.neonMint,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'MagdaClean',
              fontSize: 12,
              color: NVSColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
