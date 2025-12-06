import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;

class Cyberpunk3DMap extends StatefulWidget {
  const Cyberpunk3DMap({
    required this.userLat,
    required this.userLng,
    required this.onMapTap,
    required this.users,
    super.key,
  });
  final double userLat;
  final double userLng;
  final Function(double, double) onMapTap;
  final List<MapUser> users;

  @override
  State<Cyberpunk3DMap> createState() => _Cyberpunk3DMapState();
}

class _Cyberpunk3DMapState extends State<Cyberpunk3DMap> with TickerProviderStateMixin {
  late AnimationController _gridController;
  late AnimationController _buildingController;
  late AnimationController _zoomController;

  final double _scale = 1.0;
  final Offset _offset = Offset.zero;
  final bool _isZooming = false;

  @override
  void initState() {
    super.initState();
    _gridController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _buildingController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    _zoomController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Start zoom animation after a delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _zoomController.forward();
    });
  }

  @override
  void dispose() {
    _gridController.dispose();
    _buildingController.dispose();
    _zoomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (TapUpDetails details) {
        final Offset localPosition = details.localPosition;
        final double mapWidth = MediaQuery.of(context).size.width;
        final double mapHeight = MediaQuery.of(context).size.height;

        // Convert tap position to coordinates
        final double lat = widget.userLat + (localPosition.dy - mapHeight / 2) * 0.001;
        final double lng = widget.userLng + (localPosition.dx - mapWidth / 2) * 0.001;

        widget.onMapTap(lat, lng);
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(0xFF0A0A0A),
              Color(0xFF1A1A1A),
              Color(0xFF0A0A0A),
            ],
          ),
        ),
        child: Stack(
          children: <Widget>[
            // Animated grid background
            AnimatedBuilder(
              animation: _gridController,
              builder: (BuildContext context, Widget? child) {
                return CustomPaint(
                  size: Size.infinite,
                  painter: CyberpunkGridPainter(
                    animationValue: _gridController.value,
                  ),
                );
              },
            ),

            // 3D Buildings
            ...List.generate(20, (int index) {
              final math.Random random = math.Random(index);
              final double x = random.nextDouble() * MediaQuery.of(context).size.width;
              final double y = random.nextDouble() * MediaQuery.of(context).size.height;
              final double height = 50.0 + random.nextDouble() * 150.0;

              return Positioned(
                left: x,
                top: y,
                child: AnimatedBuilder(
                  animation: _buildingController,
                  builder: (BuildContext context, Widget? child) {
                    return Container(
                      width: 20 + random.nextDouble() * 30,
                      height: height,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            const Color(0xFF00FFFF).withValues(alpha: 0.8),
                            const Color(0xFF00BFFF).withValues(alpha: 0.4),
                            Colors.transparent,
                          ],
                        ),
                        border: Border.all(
                          color: const Color(0xFF00FFFF).withValues(alpha: 0.6),
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: const Color(0xFF00FFFF).withValues(alpha: 0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ).animate().scaleY(
                          begin: 0.0,
                          end: 1.0,
                          duration: Duration(
                            milliseconds: 1000 + random.nextInt(1000),
                          ),
                          curve: Curves.easeOutCubic,
                        );
                  },
                ),
              );
            }),

            // User avatars
            ...widget.users.map(_buildUserAvatar),

            // Zoom animation overlay
            AnimatedBuilder(
              animation: _zoomController,
              builder: (BuildContext context, Widget? child) {
                return Transform.scale(
                  scale: 1.0 + _zoomController.value * 0.5,
                  child: Transform.translate(
                    offset: Offset(
                      -_zoomController.value * 100,
                      -_zoomController.value * 100,
                    ),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              const Color(0xFF00FFFF).withValues(alpha: 1 - _zoomController.value),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: const Duration(milliseconds: 1000));
  }

  Widget _buildUserAvatar(MapUser user) {
    return Positioned(
      left: user.x * MediaQuery.of(context).size.width,
      top: user.y * MediaQuery.of(context).size.height,
      child: GestureDetector(
        onTap: () => user.onTap(),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: <Color>[
                const Color(0xFF00FFFF),
                const Color(0xFF00BFFF).withValues(alpha: 0.7),
              ],
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: const Color(0xFF00FFFF).withValues(alpha: 0.6),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(user.profileImageUrl),
            ),
          ),
        )
            .animate(
              onPlay: (AnimationController controller) => controller.repeat(),
            )
            .scale(
              begin: const Offset(1.0, 1.0),
              end: const Offset(1.2, 1.2),
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOut,
            )
            .then()
            .scale(
              begin: const Offset(1.2, 1.2),
              end: const Offset(1.0, 1.0),
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOut,
            ),
      ),
    );
  }
}

class CyberpunkGridPainter extends CustomPainter {
  CyberpunkGridPainter({required this.animationValue});
  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFF00FFFF).withValues(alpha: 0.3)
      ..strokeWidth = 1;

    const double gridSize = 50.0;
    final double offset = animationValue * gridSize;

    // Vertical lines
    for (double x = -offset; x < size.width + gridSize; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Horizontal lines
    for (double y = -offset; y < size.height + gridSize; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class MapUser {
  MapUser({
    required this.x,
    required this.y,
    required this.profileImageUrl,
    required this.onTap,
  });
  final double x;
  final double y;
  final String profileImageUrl;
  final VoidCallback onTap;
}
