import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:nvs/meatup_core.dart';
// Removed mock data import - will be replaced with proper data layer
import '../widgets/presence_marker.dart';

enum NowViewState { intro, globeLoading, mapLive, profileOpen }

final nowStateProvider = StateNotifierProvider<NowController, NowViewState>((
  ref,
) {
  return NowController();
});

class NowController extends StateNotifier<NowViewState> {
  NowController() : super(NowViewState.intro);

  void completeIntro() {
    if (state == NowViewState.intro) {
      state = NowViewState.globeLoading;
      Future.delayed(const Duration(seconds: 3), () {
        state = NowViewState.mapLive;
      });
    }
  }

  void openProfile() {
    state = NowViewState.profileOpen;
  }

  void closeProfile() {
    state = NowViewState.mapLive;
  }
}

/// Main Now view with state machine: intro → 3D globe → map
/// Features real-time location clustering and presence indicators
class NowViewWidget extends ConsumerStatefulWidget {
  const NowViewWidget({super.key});

  @override
  ConsumerState<NowViewWidget> createState() => _NowViewWidgetState();
}

class _NowViewWidgetState extends ConsumerState<NowViewWidget>
    with TickerProviderStateMixin {
  VideoPlayerController? _introVideoController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  Timer? _introTimer;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeIntroVideo();
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _initializeIntroVideo() {
    _introVideoController = VideoPlayerController.asset(
      'assets/videos/blurrr_mint.mov', // Using existing intro video
    );

    _introVideoController!.initialize().then((_) {
      if (mounted) {
        setState(() {});
        _introVideoController!.play();
        _introVideoController!.setLooping(false);

        // Auto-advance after video
        _introTimer = Timer(const Duration(seconds: 4), () {
          if (mounted) {
            ref.read(nowStateProvider.notifier).completeIntro();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _introVideoController?.dispose();
    _pulseController.dispose();
    _introTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nowState = ref.watch(nowStateProvider);

    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 800),
        child: _buildStateContent(nowState),
      ),
    );
  }

  Widget _buildStateContent(NowViewState state) {
    switch (state) {
      case NowViewState.intro:
        return _buildIntroView();
      case NowViewState.globeLoading:
        return _buildGlobeLoadingView();
      case NowViewState.mapLive:
        return _buildMapLiveView();
      case NowViewState.profileOpen:
        return _buildProfileView();
    }
  }

  Widget _buildIntroView() {
    return Stack(
      key: const ValueKey('intro'),
      children: [
        // Background video
        if (_introVideoController?.value.isInitialized == true)
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _introVideoController!.value.size.width,
                height: _introVideoController!.value.size.height,
                child: VideoPlayer(_introVideoController!),
              ),
            ),
          ),

        // Overlay content
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  NVSColors.pureBlack.withValues(alpha: 0.6),
                  NVSColors.pureBlack,
                ],
              ),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'NOW',
                    style: TextStyle(
                      fontFamily: 'MagdaCleanMono',
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: NVSColors.ultraLightMint,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Scanning live connections...',
                    style: TextStyle(
                      fontFamily: 'MagdaCleanMono',
                      fontSize: 16,
                      color: NVSColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGlobeLoadingView() {
    return Container(
      key: const ValueKey('globe'),
      child: Stack(
        children: [
          // Production globe visualization
          Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF4BEFE0).withValues(alpha: 0.3),
                    const Color(0xFF4BEFE0).withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
                border: Border.all(color: const Color(0xFF4BEFE0), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4BEFE0).withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: const Icon(
                      Icons.public,
                      size: 120,
                      color: Color(0xFF4BEFE0),
                    ),
                  );
                },
              ),
            ),
          ),

          // Loading text
          Positioned(
            bottom: 200,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _pulseAnimation.value,
                  child: const Column(
                    children: [
                      Text(
                        'Mapping live presence...',
                        style: TextStyle(
                          fontFamily: 'MagdaCleanMono',
                          fontSize: 18,
                          color: NVSColors.ultraLightMint,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Finding connections nearby',
                        style: TextStyle(
                          fontFamily: 'MagdaCleanMono',
                          fontSize: 14,
                          color: NVSColors.secondaryText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapLiveView() {
    // Simple placeholder data for now
    final nearbyUsers = List.generate(
      6,
      (index) => {
        'id': index,
        'name': 'Nearby User ${index + 1}',
        'distance': '${50 + (index * 100)}m',
        'status': 'online',
      },
    );

    return Container(
      key: const ValueKey('map'),
      child: Stack(
        children: [
          // Mock map background
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [Color(0xFF001122), NVSColors.pureBlack],
              ),
            ),
          ),

          // Grid overlay
          CustomPaint(painter: _GridPainter(), size: Size.infinite),

          // Header
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'NOW',
                        style: TextStyle(
                          fontFamily: 'MagdaCleanMono',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: NVSColors.ultraLightMint,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: NVSColors.cardBackground,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: NVSColors.ultraLightMint.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                        child: Text(
                          '${nearbyUsers.length} nearby',
                          style: const TextStyle(
                            fontFamily: 'MagdaCleanMono',
                            fontSize: 12,
                            color: NVSColors.ultraLightMint,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Live presence map',
                    style: TextStyle(
                      fontFamily: 'MagdaCleanMono',
                      fontSize: 14,
                      color: NVSColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // User presence markers
          ...nearbyUsers.asMap().entries.map((entry) {
            final index = entry.key;
            final user = entry.value;
            return _buildPresenceMarker(user, index);
          }),

          // Controls
          Positioned(
            bottom: 120,
            right: 16,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'center',
                  mini: true,
                  backgroundColor: NVSColors.cardBackground,
                  onPressed: () {
                    // Center on user location
                  },
                  child: const Icon(
                    Icons.my_location,
                    color: NVSColors.ultraLightMint,
                  ),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'refresh',
                  mini: true,
                  backgroundColor: NVSColors.cardBackground,
                  onPressed: () {
                    // Refresh live data
                  },
                  child: const Icon(
                    Icons.refresh,
                    color: NVSColors.ultraLightMint,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresenceMarker(dynamic user, int index) {
    final random = Random(index);
    final x = 50.0 + random.nextDouble() * 200;
    final y = 150.0 + random.nextDouble() * 300;

    // Assign signal quality based on distance simulation
    SignalQuality quality;
    final qualityRandom = random.nextDouble();
    if (qualityRandom < 0.6) {
      quality = SignalQuality.perfect;
    } else if (qualityRandom < 0.85) {
      quality = SignalQuality.weak;
    } else {
      quality = SignalQuality.echo;
    }

    return Positioned(
      left: x,
      top: y,
      child: GestureDetector(
        onTap: () {
          ref.read(nowStateProvider.notifier).openProfile();
        },
        child: PresenceMarker(quality: quality),
      ),
    );
  }

  Widget _buildProfileView() {
    return Container(
      key: const ValueKey('profile'),
      color: NVSColors.pureBlack,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: NVSColors.ultraLightMint,
                    ),
                    onPressed: () {
                      ref.read(nowStateProvider.notifier).closeProfile();
                    },
                  ),
                  const Expanded(
                    child: Text(
                      'User Profile',
                      style: TextStyle(
                        fontFamily: 'MagdaCleanMono',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: NVSColors.ultraLightMint,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Profile content placeholder
            const Expanded(
              child: Center(
                child: Text(
                  'Profile details coming soon...',
                  style: TextStyle(
                    fontFamily: 'MagdaCleanMono',
                    fontSize: 16,
                    color: NVSColors.secondaryText,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = NVSColors.ultraLightMint.withValues(alpha: 0.1)
      ..strokeWidth = 0.5;

    const spacing = 30.0;

    // Vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
