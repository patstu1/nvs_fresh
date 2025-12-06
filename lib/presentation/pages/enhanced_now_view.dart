import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:nvs/meatup_core.dart';
import '../../../../models/now_user_model.dart';
import '../../../../data/mock_data.dart';
import '../widgets/now_user_bubble_widget.dart';
import '../widgets/now_user_overlay_widget.dart';
import 'package:nvs/theme/nvs_palette.dart';

enum NowViewState { intro, mapLoading, mapLive, profileOpen }

/// Enhanced Now view with proper state machine and clustering
class EnhancedNowView extends ConsumerStatefulWidget {
  const EnhancedNowView({super.key});

  @override
  ConsumerState<EnhancedNowView> createState() => _EnhancedNowViewState();
}

class _EnhancedNowViewState extends ConsumerState<EnhancedNowView>
    with TickerProviderStateMixin {
  NowViewState _currentState = NowViewState.intro;
  late VideoPlayerController _videoController;
  late AnimationController _pulseController;
  late AnimationController _transitionController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  List<NowUser> _nearbyUsers = [];
  NowUser? _selectedUser;
  Timer? _userUpdateTimer;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeVideo();
    _startStateSequence();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _transitionController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 20.0).animate(
      CurvedAnimation(parent: _transitionController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _transitionController, curve: Curves.easeOut),
    );
  }

  void _initializeVideo() {
    _videoController = VideoPlayerController.asset(
        'assets/videos/spinning_globe_now_loading.mp4')
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
          _videoController.setLooping(true);
          _videoController.play();
        }
      });
  }

  void _startStateSequence() {
    // Intro phase (3 seconds)
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _currentState = NowViewState.mapLoading);
        _transitionController.forward();
      }
    });

    // Transition to live map (6 seconds total)
    Timer(const Duration(seconds: 6), () {
      if (mounted) {
        setState(() => _currentState = NowViewState.mapLive);
        _loadNearbyUsers();
        _startUserUpdates();
      }
    });
  }

  void _loadNearbyUsers() {
    setState(() {
      _nearbyUsers = MockData.generateNowUsers(12);
    });
  }

  void _startUserUpdates() {
    _userUpdateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted && _currentState == NowViewState.mapLive) {
        setState(() {
          // Simulate users moving/updating
          for (int i = 0; i < _nearbyUsers.length; i++) {
            if (DateTime.now().millisecondsSinceEpoch % 3 == 0) {
              _nearbyUsers[i] = _nearbyUsers[i].copyWith(
                isViewedByCurrentUser: !_nearbyUsers[i].isViewedByCurrentUser,
              );
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _pulseController.dispose();
    _transitionController.dispose();
    _userUpdateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSPalette.background,
      body: Stack(
        children: [
          // Main content based on state
          _buildCurrentStateContent(),

          // User overlay when selected
          if (_selectedUser != null && _currentState == NowViewState.mapLive)
            NowUserOverlay(
              user: _selectedUser!,
              onClose: () => setState(() => _selectedUser = null),
            ),
        ],
      ),
    );
  }

  Widget _buildCurrentStateContent() {
    switch (_currentState) {
      case NowViewState.intro:
        return _buildIntroContent();
      case NowViewState.mapLoading:
        return _buildMapLoadingContent();
      case NowViewState.mapLive:
        return _buildLiveMapContent();
      case NowViewState.profileOpen:
        return _buildLiveMapContent(); // Keep map visible behind profile
    }
  }

  Widget _buildIntroContent() {
    return Container(
      color: NVSPalette.background,
      child: Stack(
        children: [
          // Video background if available
          if (_videoController.value.isInitialized)
            Center(
              child: AspectRatio(
                aspectRatio: _videoController.value.aspectRatio,
                child: VideoPlayer(_videoController),
              ),
            ),

          // Fallback globe emoji with animation
          if (!_videoController.value.isInitialized)
            Center(
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Text(
                      "🌍",
                      style: TextStyle(
                        fontSize: 120,
                        shadows: [
                          Shadow(
                            color:
                                NVSPalette.primary.withValues(alpha: 0.8),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

          // Overlay text
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  'CONNECTING TO LIVE MAP',
                  style: TextStyle(
                    color: NVSPalette.primary,
                    fontSize: 18,
                    fontFamily: 'MagdaCleanMono',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    shadows: [
                      Shadow(
                        color: NVSPalette.primary.withValues(alpha: 0.5),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: NVSPalette.primary.withValues(
                          alpha: _pulseAnimation.value * 0.3,
                        ),
                      ),
                      child: CircularProgressIndicator(
                        color: NVSPalette.primary,
                        strokeWidth: 3,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapLoadingContent() {
    return Container(
      color: NVSPalette.background,
      child: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([_scaleAnimation, _fadeAnimation]),
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        NVSPalette.primary.withValues(alpha: 0.8),
                        NVSPalette.secondaryDark.withValues(alpha: 0.4),
                        NVSPalette.transparent,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "🌍",
                      style: TextStyle(
                        fontSize: 80,
                        shadows: [
                          Shadow(
                            color:
                                NVSPalette.primary.withValues(alpha: 0.8),
                            blurRadius: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLiveMapContent() {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.5,
          colors: [
            NVSPalette.primary.withValues(alpha: 0.1),
            NVSPalette.background,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background grid pattern
          CustomPaint(
            painter: GridPatternPainter(),
            size: Size.infinite,
          ),

          // User bubbles with clustering
          ..._buildUserBubbles(),

          // Live indicator
          _buildLiveIndicator(),

          // Map controls
          _buildMapControls(),
        ],
      ),
    );
  }

  List<Widget> _buildUserBubbles() {
    return _nearbyUsers.asMap().entries.map((entry) {
      final index = entry.key;
      final user = entry.value;

      // Position users in clusters
      final clusterIndex = index ~/ 3;
      final positionInCluster = index % 3;

      final centerX = 80.0 + (clusterIndex % 3) * 120.0;
      final centerY = 150.0 + (clusterIndex ~/ 3) * 150.0;

      final offsetX = positionInCluster == 0
          ? 0.0
          : positionInCluster == 1
              ? 30.0
              : -30.0;
      final offsetY = positionInCluster == 0
          ? 0.0
          : positionInCluster == 1
              ? 30.0
              : -20.0;

      return Positioned(
        left: centerX + offsetX,
        top: centerY + offsetY,
        child: GestureDetector(
          onTap: () => _handleUserTap(user),
          child: NowUserBubble(user: user),
        ),
      );
    }).toList();
  }

  Widget _buildLiveIndicator() {
    return Positioned(
      top: 60,
      left: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: NVSPalette.surfaceDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: NVSPalette.primary.withValues(alpha: 0.6),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: NVSPalette.primary.withValues(alpha: 0.2),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: NVSPalette.secondaryDark,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: NVSPalette.secondaryDark.withValues(
                          alpha: _pulseAnimation.value * 0.6,
                        ),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(width: 6),
            Text(
              "LIVE MAP • ${_nearbyUsers.length} NEARBY",
              style: TextStyle(
                color: NVSPalette.primary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: 'MagdaCleanMono',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapControls() {
    return Positioned(
      top: 60,
      right: 20,
      child: Column(
        children: [
          _buildMapButton(Icons.filter_list, 'Filters'),
          const SizedBox(height: 12),
          _buildMapButton(Icons.my_location, 'Center'),
          const SizedBox(height: 12),
          _buildMapButton(Icons.refresh, 'Refresh'),
        ],
      ),
    );
  }

  Widget _buildMapButton(IconData icon, String tooltip) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: NVSPalette.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: NVSPalette.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: NVSPalette.primary,
          size: 20,
        ),
        onPressed: () {
          // Handle map control actions
          if (icon == Icons.refresh) {
            _loadNearbyUsers();
          }
        },
        tooltip: tooltip,
      ),
    );
  }

  void _handleUserTap(NowUser user) {
    setState(() {
      _selectedUser = user;
      _currentState = NowViewState.profileOpen;
    });
  }
}

/// Custom painter for grid pattern background
class GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = NVSPalette.primary.withValues(alpha: 0.05)
      ..strokeWidth = 0.5;

    const spacing = 50.0;

    // Vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
