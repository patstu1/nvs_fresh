import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/meatup_core.dart';
// Use core theme via nvs_core export to avoid duplicate imports
import '../../../../models/now_user_model.dart';

class NowViewWidget extends ConsumerStatefulWidget {
  const NowViewWidget({super.key});

  @override
  ConsumerState<NowViewWidget> createState() => _NowViewWidgetState();
}

class _NowViewWidgetState extends ConsumerState<NowViewWidget> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  List<NowUserModel> _nearbyUsers = <NowUserModel>[];
  Timer? _userUpdateTimer;
  bool _isMapMode = false;

  List<String> _userNames = <String>[];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadNearbyUsers();
    _startUserUpdates();

    // Auto-switch to map mode after 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _isMapMode = true);
      }
    });
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );
  }

  Future<void> _loadNearbyUsers() async {
    final UserService userService = UserService();
    final List<UserProfile> profiles = await userService.getNearbyUsers(
      latitude: 0,
      longitude: 0,
      radiusKm: 50,
      limit: 60,
    );
    final List<NowUserModel> mapped = <NowUserModel>[];
    final List<String> names = <String>[];
    for (int i = 0; i < profiles.length; i++) {
      final UserProfile p = profiles[i];
      final double baseX = (i % 3) * 0.01;
      final double baseY = (i ~/ 3) * 0.01;
      mapped.add(
        NowUserModel(
          id: p.id,
          latitude: 40.0 + baseY + (p.id.hashCode % 100) / 10000.0,
          longitude: -74.0 + baseX + (p.displayName.hashCode % 100) / 10000.0,
          avatarUrl: p.avatarUrl,
        ),
      );
      names.add(p.displayName.isNotEmpty ? p.displayName : (p.name.isNotEmpty ? p.name : p.id));
    }
    if (!mounted) return;
    setState(() {
      _nearbyUsers = mapped;
      _userNames = names;
    });
  }

  void _startUserUpdates() {
    _userUpdateTimer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (mounted && _isMapMode) {
        // Simulate users moving
        setState(() {
          for (int i = 0; i < _nearbyUsers.length; i++) {
            final math.Random random = math.Random();
            if (random.nextBool()) {
              _nearbyUsers[i] = NowUserModel(
                id: _nearbyUsers[i].id,
                latitude: _nearbyUsers[i].latitude + (random.nextDouble() - 0.5) * 0.001,
                longitude: _nearbyUsers[i].longitude + (random.nextDouble() - 0.5) * 0.001,
                avatarUrl: _nearbyUsers[i].avatarUrl,
              );
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    _userUpdateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      body: Stack(
        children: <Widget>[
          // Main content
          if (!_isMapMode) _buildGlobeIntro() else _buildLiveMap(),

          // Header overlay
          if (_isMapMode) _buildHeader(),

          // Controls overlay
          if (_isMapMode) _buildControls(),
        ],
      ),
    );
  }

  Widget _buildGlobeIntro() {
    return ColoredBox(
      color: NVSColors.pureBlack,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedBuilder(
              animation: Listenable.merge(<Listenable?>[_pulseAnimation, _rotationAnimation]),
              builder: (BuildContext context, Widget? child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Transform.rotate(
                    angle: _rotationAnimation.value,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: <Color>[
                            NVSColors.ultraLightMint.withValues(alpha: 0.8),
                            NVSColors.avocadoGreen.withValues(alpha: 0.4),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '🌍',
                          style: TextStyle(
                            fontSize: 80,
                            shadows: <Shadow>[
                              Shadow(
                                color: NVSColors.ultraLightMint.withValues(alpha: 0.8),
                                blurRadius: 20,
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
            const SizedBox(height: 40),
            Text(
              'SCANNING NOW VICINITY',
              style: TextStyle(
                color: NVSColors.ultraLightMint,
                fontSize: 18,
                fontFamily: 'MagdaCleanMono',
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                shadows: <Shadow>[
                  Shadow(
                    color: NVSColors.ultraLightMint.withValues(alpha: 0.5),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            AnimatedBuilder(
              animation: _pulseController,
              builder: (BuildContext context, Widget? child) {
                return Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: NVSColors.ultraLightMint.withValues(
                      alpha: _pulseAnimation.value * 0.3,
                    ),
                  ),
                  child: const CircularProgressIndicator(
                    color: NVSColors.ultraLightMint,
                    strokeWidth: 3,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveMap() {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          radius: 1.5,
          colors: <Color>[
            NVSColors.ultraLightMint.withValues(alpha: 0.05),
            NVSColors.pureBlack,
          ],
        ),
      ),
      child: Stack(
        children: <Widget>[
          // Grid pattern background
          CustomPaint(
            painter: GridPatternPainter(),
            size: Size.infinite,
          ),

          // User bubbles
          ..._buildUserBubbles(),

          // Pulse rings
          _buildPulseRings(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Positioned(
      top: 60,
      left: 20,
      right: 20,
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: NVSColors.cardBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: NVSColors.ultraLightMint.withValues(alpha: 0.6),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: NVSColors.ultraLightMint.withValues(alpha: 0.2),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (BuildContext context, Widget? child) {
                    return Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: NVSColors.avocadoGreen,
                        shape: BoxShape.circle,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: NVSColors.avocadoGreen.withValues(
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
                const SizedBox(width: 8),
                Text(
                  'NOW LIVE • ${_nearbyUsers.length} NEARBY',
                  style: const TextStyle(
                    color: NVSColors.ultraLightMint,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'MagdaCleanMono',
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Text(
            'NOW',
            style: TextStyle(
              color: NVSColors.ultraLightMint,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'MagdaCleanMono',
              letterSpacing: 2,
              shadows: <Shadow>[
                Shadow(
                  color: NVSColors.ultraLightMint.withValues(alpha: 0.5),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Positioned(
      top: 60,
      right: 20,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 50),
          _buildControlButton(Icons.filter_list, 'Filters'),
          const SizedBox(height: 12),
          _buildControlButton(Icons.my_location, 'Center'),
          const SizedBox(height: 12),
          _buildControlButton(Icons.refresh, 'Refresh'),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon, String tooltip) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: NVSColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: NVSColors.ultraLightMint.withValues(alpha: 0.3),
        ),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: NVSColors.ultraLightMint,
          size: 20,
        ),
        onPressed: () {
          if (icon == Icons.refresh) {
            _loadNearbyUsers();
          }
        },
        tooltip: tooltip,
      ),
    );
  }

  List<Widget> _buildUserBubbles() {
    return _nearbyUsers.asMap().entries.map((MapEntry<int, NowUserModel> entry) {
      final int index = entry.key;
      final NowUserModel user = entry.value;

      // Position users in clusters around the screen
      final int clusterIndex = index ~/ 3;
      final int positionInCluster = index % 3;

      final double centerX = 80.0 + (clusterIndex % 3) * 120.0;
      final double centerY = 150.0 + (clusterIndex ~/ 3) * 150.0;

      final double offsetX = positionInCluster == 0
          ? 0.0
          : positionInCluster == 1
              ? 30.0
              : -30.0;
      final double offsetY = positionInCluster == 0
          ? 0.0
          : positionInCluster == 1
              ? 30.0
              : -20.0;

      return Positioned(
        left: centerX + offsetX,
        top: centerY + offsetY,
        child: GestureDetector(
          onTap: () => _handleUserTap(user),
          child: _buildUserBubble(user, index),
        ),
      );
    }).toList();
  }

  Widget _buildUserBubble(NowUserModel user, int index) {
    final String username =
        index < _userNames.length && _userNames[index].isNotEmpty ? _userNames[index] : 'USER';

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (BuildContext context, Widget? child) {
        final bool shouldPulse = index % 3 == 0; // Every third user pulses
        final double scale = shouldPulse ? _pulseAnimation.value * 0.1 + 0.9 : 1.0;

        return Transform.scale(
          scale: scale,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: NVSColors.cardBackground,
              border: Border.all(
                color: shouldPulse
                    ? NVSColors.ultraLightMint.withValues(alpha: _pulseAnimation.value * 0.8)
                    : NVSColors.ultraLightMint.withValues(alpha: 0.3),
                width: shouldPulse ? 2 : 1,
              ),
              boxShadow: shouldPulse
                  ? <BoxShadow>[
                      BoxShadow(
                        color:
                            NVSColors.ultraLightMint.withValues(alpha: _pulseAnimation.value * 0.4),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                username[0].toUpperCase(),
                style: const TextStyle(
                  color: NVSColors.ultraLightMint,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'MagdaCleanMono',
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPulseRings() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (BuildContext context, Widget? child) {
          return CustomPaint(
            painter: PulseRingsPainter(_pulseAnimation.value),
          );
        },
      ),
    );
  }

  void _handleUserTap(NowUserModel user) {
    final int idx = _nearbyUsers.indexOf(user);
    final String username = idx >= 0 && idx < _userNames.length && _userNames[idx].isNotEmpty
        ? _userNames[idx]
        : 'USER';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => Container(
        height: 300,
        decoration: BoxDecoration(
          color: NVSColors.pureBlack,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border.all(
            color: NVSColors.ultraLightMint.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: <Widget>[
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: NVSColors.secondaryText,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: NVSColors.ultraLightMint.withValues(alpha: 0.1),
                        border: Border.all(
                          color: NVSColors.ultraLightMint.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          username[0].toUpperCase(),
                          style: const TextStyle(
                            color: NVSColors.ultraLightMint,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'MagdaCleanMono',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      username,
                      style: const TextStyle(
                        color: NVSColors.ultraLightMint,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'MagdaCleanMono',
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Active now • 50m away',
                      style: TextStyle(
                        color: NVSColors.secondaryText,
                        fontSize: 14,
                        fontFamily: 'MagdaCleanMono',
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: _buildActionButton('YO', NVSColors.avocadoGreen),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildActionButton('MESSAGE', NVSColors.ultraLightMint),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, Color color) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.5),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'MagdaCleanMono',
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = NVSColors.ultraLightMint.withValues(alpha: 0.05)
      ..strokeWidth = 0.5;

    const double spacing = 50.0;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PulseRingsPainter extends CustomPainter {
  PulseRingsPainter(this.animationValue);
  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw concentric pulse rings
    for (int i = 0; i < 3; i++) {
      final double radius = 100.0 + (i * 50) + (animationValue * 30);
      final double opacity = (1.0 - animationValue) * (1.0 - i * 0.3);

      paint.color = NVSColors.ultraLightMint.withValues(alpha: opacity * 0.3);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant PulseRingsPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
