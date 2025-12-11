// NVS Meat Market - Map View (Prompt 32)
// Nearby users on a dark themed map with pin clustering
// Colors: #000000 background, #E3F2DE mint, #6B7F4A olive, #20B2A6 aqua

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MeatMarketMapView extends StatefulWidget {
  const MeatMarketMapView({super.key});

  @override
  State<MeatMarketMapView> createState() => _MeatMarketMapViewState();
}

class _MeatMarketMapViewState extends State<MeatMarketMapView>
    with TickerProviderStateMixin {
  static const Color _mint = Color(0xFFE4FFF0);
  static const Color _olive = Color(0xFFE4FFF0);
  static const Color _aqua = Color(0xFFE4FFF0);
  static const Color _black = Color(0xFF000000);

  late AnimationController _pulseController;
  
  Offset _mapOffset = Offset.zero;
  double _mapScale = 1.0;
  _MapUser? _selectedUser;
  
  final List<_MapUser> _users = List.generate(25, (i) => _MapUser.generate(i));

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _black,
      body: Stack(
        children: [
          // Map with pins
          _buildMap(),
          // Header
          _buildHeader(),
          // Map controls
          _buildMapControls(),
          // Selected user preview card
          if (_selectedUser != null) _buildUserPreviewCard(),
          // Bottom drawer hint
          _buildBottomDrawerHint(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 8, 16, 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_black, _black.withOpacity(0.8), Colors.transparent],
          ),
        ),
        child: Row(
          children: [
            const Text(
              'MEAT MARKET',
              style: TextStyle(
                color: _mint,
                fontSize: 18,
                fontWeight: FontWeight.w300,
                letterSpacing: 3,
              ),
            ),
            const Spacer(),
            // Grid/Map toggle (map active)
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: _mint.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.grid_view, color: _mint, size: 20),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _aqua.withOpacity(0.2),
                border: Border.all(color: _aqua),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.map, color: _aqua, size: 20),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: _mint.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.search, color: _mint, size: 20),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: _mint.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.tune, color: _mint, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMap() {
    return GestureDetector(
      onScaleStart: (_) {},
      onScaleUpdate: (details) {
        setState(() {
          _mapScale = (_mapScale * details.scale).clamp(0.5, 3.0);
          _mapOffset += details.focalPointDelta;
        });
      },
      onTap: () {
        if (_selectedUser != null) {
          setState(() => _selectedUser = null);
        }
      },
      child: Container(
        color: const Color(0xFF0A0A0A),
        child: CustomPaint(
          painter: _MapBackgroundPainter(
            offset: _mapOffset,
            scale: _mapScale,
          ),
          child: Stack(
            children: [
              // User pins
              ..._users.map((user) => _buildUserPin(user)),
              // Your location (center)
              Center(child: _buildYourLocationPin()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserPin(_MapUser user) {
    final screenSize = MediaQuery.of(context).size;
    final centerX = screenSize.width / 2;
    final centerY = screenSize.height / 2;
    
    final dx = centerX + (user.posX * _mapScale) + _mapOffset.dx;
    final dy = centerY + (user.posY * _mapScale) + _mapOffset.dy;

    if (dx < -30 || dx > screenSize.width + 30 || dy < -30 || dy > screenSize.height + 30) {
      return const SizedBox.shrink();
    }

    final isSelected = _selectedUser?.id == user.id;

    return Positioned(
      left: dx - 16,
      top: dy - 16,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() => _selectedUser = user);
        },
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? _aqua
                      : user.isOnline
                          ? _aqua
                          : _olive.withOpacity(0.5),
                  width: isSelected ? 3 : 2,
                ),
                boxShadow: user.isOnline
                    ? [
                        BoxShadow(
                          color: _aqua.withOpacity(0.3 * _pulseController.value),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
              child: ClipOval(
                child: Container(
                  color: _mint.withOpacity(0.15),
                  child: Icon(
                    Icons.person,
                    color: _mint.withOpacity(0.5),
                    size: 18,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildYourLocationPin() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _aqua, width: 3),
            boxShadow: [
              BoxShadow(
                color: _aqua.withOpacity(0.4 + 0.2 * _pulseController.value),
                blurRadius: 15,
                spreadRadius: 3 * _pulseController.value,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Pulsing ring
              Container(
                width: 50 + (15 * _pulseController.value),
                height: 50 + (15 * _pulseController.value),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _aqua.withOpacity(0.3 * (1 - _pulseController.value)),
                    width: 2,
                  ),
                ),
              ),
              // Profile
              ClipOval(
                child: Container(
                  width: 44,
                  height: 44,
                  color: _aqua.withOpacity(0.2),
                  child: const Icon(Icons.person, color: _aqua, size: 24),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMapControls() {
    return Positioned(
      bottom: 200,
      right: 16,
      child: Column(
        children: [
          // Recenter
          _buildMapControlButton(Icons.my_location, () {
            setState(() {
              _mapOffset = Offset.zero;
              _mapScale = 1.0;
            });
          }),
          const SizedBox(height: 8),
          // Zoom in
          _buildMapControlButton(Icons.add, () {
            setState(() => _mapScale = (_mapScale * 1.2).clamp(0.5, 3.0));
          }),
          const SizedBox(height: 8),
          // Zoom out
          _buildMapControlButton(Icons.remove, () {
            setState(() => _mapScale = (_mapScale / 1.2).clamp(0.5, 3.0));
          }),
        ],
      ),
    );
  }

  Widget _buildMapControlButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: _black.withOpacity(0.8),
          border: Border.all(color: _mint.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: _mint, size: 20),
      ),
    );
  }

  Widget _buildUserPreviewCard() {
    final user = _selectedUser!;
    
    return Positioned(
      bottom: 100,
      left: 16,
      right: 16,
      child: GestureDetector(
        onTap: () {
          // Open full profile
        },
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            // Swipe up -> open full profile
          }
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _black,
            border: Border.all(color: _mint.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              // Photo
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: user.isOnline ? _aqua : _mint.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: _mint.withOpacity(0.1),
                    child: Icon(Icons.person, color: _mint.withOpacity(0.4), size: 40),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${user.name}, ${user.age}',
                          style: const TextStyle(
                            color: _mint,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (user.isOnline) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: _aqua,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${user.distance} mi away',
                      style: const TextStyle(color: _olive, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${user.height} • ${user.bodyType}',
                      style: TextStyle(color: _mint.withOpacity(0.6), fontSize: 12),
                    ),
                  ],
                ),
              ),
              // View profile button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: _aqua,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'View Profile',
                  style: TextStyle(
                    color: _black,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomDrawerHint() {
    return Positioned(
      bottom: 16,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: _black.withOpacity(0.8),
            border: Border.all(color: _mint.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.swipe_up, color: _olive, size: 16),
              const SizedBox(width: 8),
              Text(
                'Swipe up for grid view',
                style: TextStyle(color: _olive, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapBackgroundPainter extends CustomPainter {
  final Offset offset;
  final double scale;

  _MapBackgroundPainter({required this.offset, required this.scale});

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFFE4FFF0).withOpacity(0.1)
      ..strokeWidth = 1;

    final gridSpacing = 60.0 * scale;
    
    // Vertical lines
    for (double x = (offset.dx % gridSpacing); x < size.width; x += gridSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    // Horizontal lines
    for (double y = (offset.dy % gridSpacing); y < size.height; y += gridSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw distance rings from center
    final center = Offset(size.width / 2, size.height / 2);
    final ringPaint = Paint()
      ..color = const Color(0xFFE4FFF0).withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var i = 1; i <= 4; i++) {
      canvas.drawCircle(center, 60.0 * i * scale, ringPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _MapBackgroundPainter oldDelegate) =>
      offset != oldDelegate.offset || scale != oldDelegate.scale;
}

class _MapUser {
  final String id;
  final String name;
  final int age;
  final double distance;
  final String height;
  final String bodyType;
  final bool isOnline;
  final double posX;
  final double posY;

  _MapUser({
    required this.id,
    required this.name,
    required this.age,
    required this.distance,
    required this.height,
    required this.bodyType,
    required this.isOnline,
    required this.posX,
    required this.posY,
  });

  static const List<String> _names = [
    'Marcus', 'Jordan', 'Alex', 'Ryan', 'Tyler', 'Chris', 'Jake', 'Matt',
  ];

  factory _MapUser.generate(int index) {
    final random = Random(index);
    final angle = random.nextDouble() * 2 * pi;
    final dist = 40 + random.nextDouble() * 150;
    
    return _MapUser(
      id: 'map_user_$index',
      name: _names[index % _names.length],
      age: 21 + random.nextInt(20),
      distance: random.nextDouble() * 5,
      height: "${5 + random.nextInt(2)}'${random.nextInt(12)}\"",
      bodyType: ['Slim', 'Toned', 'Average', 'Muscular'][random.nextInt(4)],
      isOnline: random.nextDouble() > 0.4,
      posX: cos(angle) * dist,
      posY: sin(angle) * dist,
    );
  }
}


