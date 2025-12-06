// lib/features/live/presentation/holographic_globe_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

class HolographicGlobeView extends ConsumerStatefulWidget {
  const HolographicGlobeView({super.key});

  @override
  ConsumerState<HolographicGlobeView> createState() => _HolographicGlobeViewState();
}

class _HolographicGlobeViewState extends ConsumerState<HolographicGlobeView>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;

  // Globe interaction state
  double _rotationX = 0.0;
  double _rotationY = 0.0;

  // Sample global rooms data
  final List<GlobalRoom> _globalRooms = <GlobalRoom>[
    const GlobalRoom(
      id: 'berlin_underground',
      name: 'Berlin Underground',
      city: 'Berlin',
      country: 'Germany',
      latitude: 52.5200,
      longitude: 13.4050,
      participantCount: 47,
      theme: 'techno',
      color: Colors.cyan,
    ),
    const GlobalRoom(
      id: 'tokyo_neon',
      name: 'Tokyo Neon',
      city: 'Tokyo',
      country: 'Japan',
      latitude: 35.6762,
      longitude: 139.6503,
      participantCount: 23,
      theme: 'cyberpunk',
      color: Colors.pink,
    ),
    const GlobalRoom(
      id: 'nyc_after_dark',
      name: 'NYC After Dark',
      city: 'New York',
      country: 'USA',
      latitude: 40.7128,
      longitude: -74.0060,
      participantCount: 89,
      theme: 'finance',
      color: Colors.yellow,
    ),
    const GlobalRoom(
      id: 'la_creative',
      name: 'LA Creative Hub',
      city: 'Los Angeles',
      country: 'USA',
      latitude: 34.0522,
      longitude: -118.2437,
      participantCount: 34,
      theme: 'creative',
      color: Colors.purple,
    ),
    const GlobalRoom(
      id: 'london_underground',
      name: 'London Underground',
      city: 'London',
      country: 'UK',
      latitude: 51.5074,
      longitude: -0.1278,
      participantCount: 67,
      theme: 'culture',
      color: Colors.green,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.black.withOpacity(0.9),
      child: Stack(
        children: <Widget>[
          // Background grid effect
          _buildBackgroundGrid(),

          // Close button
          Positioned(
            top: 60,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),

          // Title
          Positioned(
            top: 80,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'THE NEXUS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  'Global Social Fabric',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),

          // Main globe
          Center(
            child: GestureDetector(
              onPanUpdate: (DragUpdateDetails details) {
                setState(() {
                  _rotationY += details.delta.dx * 0.01;
                  _rotationX += details.delta.dy * 0.01;
                  _rotationX = _rotationX.clamp(-math.pi / 4, math.pi / 4);
                });
              },
              child: AnimatedBuilder(
                animation: Listenable.merge(
                  <Listenable?>[_rotationController, _pulseController],
                ),
                builder: (BuildContext context, Widget? child) {
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001) // Perspective
                      ..rotateX(_rotationX)
                      ..rotateY(
                        _rotationY + _rotationController.value * 2 * math.pi,
                      ),
                    child: _buildGlobe(),
                  );
                },
              ),
            ),
          ),

          // Room details sidebar
          _buildRoomSidebar(),
        ],
      ),
    );
  }

  Widget _buildBackgroundGrid() {
    return CustomPaint(
      painter: GridPainter(),
      size: Size.infinite,
    );
  }

  Widget _buildGlobe() {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: <Color>[
            Colors.cyan.withOpacity(0.1),
            Colors.blue.withOpacity(0.05),
            Colors.transparent,
          ],
        ),
        border: Border.all(
          color: Colors.cyan.withOpacity(0.3),
        ),
      ),
      child: Stack(
        children: _globalRooms.map(_buildRoomMarker).toList(),
      ),
    );
  }

  Widget _buildRoomMarker(GlobalRoom room) {
    // Convert lat/lng to globe position (simplified projection)
    final double x = (room.longitude + 180) / 360;
    final double y = (90 - room.latitude) / 180;

    return Positioned(
      left: x * 280 + 10,
      top: y * 280 + 10,
      child: GestureDetector(
        onTap: () => _joinRoom(room),
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (BuildContext context, Widget? child) {
            final double pulseScale = 1.0 + (_pulseController.value * 0.3);
            return Transform.scale(
              scale: pulseScale,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: room.color,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: room.color.withOpacity(0.6),
                      blurRadius: 10 * pulseScale,
                      spreadRadius: 2 * pulseScale,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    room.participantCount.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
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

  Widget _buildRoomSidebar() {
    return Positioned(
      left: 20,
      top: 150,
      bottom: 100,
      child: Container(
        width: 250,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.cyan.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'ACTIVE ROOMS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _globalRooms.length,
                itemBuilder: (BuildContext context, int index) {
                  final GlobalRoom room = _globalRooms[index];
                  return _buildRoomListItem(room);
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Create new room functionality
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  foregroundColor: Colors.black,
                ),
                icon: const Icon(Icons.add),
                label: const Text('CREATE ROOM'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomListItem(GlobalRoom room) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900]?.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: room.color.withOpacity(0.3)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: room.color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  room.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${room.city} • ${room.participantCount} users',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.cyan,
              size: 16,
            ),
            onPressed: () => _joinRoom(room),
          ),
        ],
      ),
    );
  }

  void _joinRoom(GlobalRoom room) {
    // Navigate to the selected room
    print('Joining room: ${room.name}');
    // This would trigger the room join logic and close the globe
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.cyan.withOpacity(0.1)
      ..strokeWidth = 0.5;

    // Draw grid lines
    for (double i = 0; i < size.width; i += 50) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 50) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GlobalRoom {
  const GlobalRoom({
    required this.id,
    required this.name,
    required this.city,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.participantCount,
    required this.theme,
    required this.color,
  });
  final String id;
  final String name;
  final String city;
  final String country;
  final double latitude;
  final double longitude;
  final int participantCount;
  final String theme;
  final Color color;
}
