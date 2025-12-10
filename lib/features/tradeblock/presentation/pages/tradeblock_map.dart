// NVS TradeBlock Map - Full Implementation
// Based on Prompts 46-59: Real-time cruising map with Sniffies features
// Colors: #000000 matte black, #E4FFF0 mint ONLY - no fills, outline glows only

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TradeBlockMap extends StatefulWidget {
  const TradeBlockMap({super.key});

  @override
  State<TradeBlockMap> createState() => _TradeBlockMapState();
}

class _TradeBlockMapState extends State<TradeBlockMap>
    with TickerProviderStateMixin {
  // Global NVS colors - mint and black only, no fills
  static const Color _mint = Color(0xFFE4FFF0);
  static const Color _olive = Color(0xFFE4FFF0); // Map to mint
  static const Color _aqua = Color(0xFFE4FFF0);  // Map to mint
  static const Color _black = Color(0xFF000000);

  late AnimationController _pulseController;
  late AnimationController _radarController;

  bool _isCruising = false;
  bool _showListView = false;
  Offset _mapOffset = Offset.zero;
  double _mapScale = 1.0;

  // Mock cruisers
  final List<_Cruiser> _cruisers = List.generate(35, (i) => _Cruiser.generate(i));

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _radarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _black,
      body: SafeArea(
        child: Stack(
          children: [
            // Map background
            _buildMapView(),
            
            // Header
            _buildHeader(),
            
            // Bottom controls
            _buildBottomControls(),
            
            // Cruise button
            _buildCruiseButton(),
            
            // List view overlay
            if (_showListView) _buildListViewOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_black, _black.withOpacity(0.8), Colors.transparent],
          ),
        ),
        child: Row(
          children: [
            // Menu button
            GestureDetector(
              onTap: _openSidebar,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: _mint.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.menu, color: _mint, size: 20),
              ),
            ),
            const SizedBox(width: 16),
            // Title with cruiser count
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TRADEBLOCK',
                  style: TextStyle(
                    color: _mint,
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 3,
                  ),
                ),
                Text(
                  '${_cruisers.where((c) => c.isOnline).length} cruisers nearby',
                  style: TextStyle(
                    color: _aqua,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Filters
            GestureDetector(
              onTap: _openFilters,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: _mint.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.tune, color: _mint, size: 20),
              ),
            ),
            const SizedBox(width: 10),
            // Settings
            GestureDetector(
              onTap: _openSettings,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: _mint.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.settings, color: _mint, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapView() {
    return GestureDetector(
      onScaleStart: (details) {},
      onScaleUpdate: (details) {
        setState(() {
          _mapScale = (_mapScale * details.scale).clamp(0.5, 3.0);
          _mapOffset += details.focalPointDelta;
        });
      },
      child: Container(
        color: const Color(0xFF0A0A0A),
        child: CustomPaint(
          painter: _MapPainter(
            offset: _mapOffset,
            scale: _mapScale,
            pulseAnimation: _pulseController,
            radarAnimation: _radarController,
            isCruising: _isCruising,
          ),
          child: Stack(
            children: [
              // User pins
              ..._cruisers.map((cruiser) => _buildCruiserPin(cruiser)),
              // Your location (center)
              Center(child: _buildYourLocationPin()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCruiserPin(_Cruiser cruiser) {
    final screenSize = MediaQuery.of(context).size;
    final centerX = screenSize.width / 2;
    final centerY = screenSize.height / 2;
    
    // Position based on distance and angle
    final dx = centerX + (cruiser.posX * _mapScale) + _mapOffset.dx;
    final dy = centerY + (cruiser.posY * _mapScale) + _mapOffset.dy;

    if (dx < -50 || dx > screenSize.width + 50 || dy < -50 || dy > screenSize.height + 50) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: dx - 25,
      top: dy - 25,
      child: GestureDetector(
        onTap: () => _showProfileCard(cruiser),
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: cruiser.isOnline 
                      ? _aqua 
                      : _olive.withOpacity(0.5),
                  width: cruiser.isOnline ? 3 : 2,
                ),
                boxShadow: cruiser.isOnline
                    ? [
                        BoxShadow(
                          color: _aqua.withOpacity(0.3 * _pulseController.value),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Stack(
                children: [
                  // Profile pic placeholder
                  ClipOval(
                    child: Container(
                      color: cruiser.isAnonymous 
                          ? _olive.withOpacity(0.3)
                          : _mint.withOpacity(0.15),
                      child: Center(
                        child: Icon(
                          cruiser.isAnonymous ? Icons.person_off : Icons.person,
                          color: cruiser.isAnonymous 
                              ? _olive.withOpacity(0.5)
                              : _mint.withOpacity(0.4),
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  // Status badges
                  if (cruiser.isLivePlay)
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: _black, width: 2),
                        ),
                        child: const Icon(Icons.videocam, color: Colors.white, size: 10),
                      ),
                    ),
                  if (cruiser.isHosting)
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: _aqua,
                          shape: BoxShape.circle,
                          border: Border.all(color: _black, width: 2),
                        ),
                        child: const Icon(Icons.home, color: _black, size: 10),
                      ),
                    ),
                  if (cruiser.isMobile)
                    Positioned(
                      bottom: -2,
                      left: -2,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: _olive,
                          shape: BoxShape.circle,
                          border: Border.all(color: _black, width: 2),
                        ),
                        child: const Icon(Icons.directions_car, color: _mint, size: 10),
                      ),
                    ),
                ],
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
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _aqua, width: 3),
            boxShadow: [
              BoxShadow(
                color: _aqua.withOpacity(0.4 + 0.3 * _pulseController.value),
                blurRadius: 20,
                spreadRadius: 5 * _pulseController.value,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Pulsing ring
              Container(
                width: 60 + (20 * _pulseController.value),
                height: 60 + (20 * _pulseController.value),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _aqua.withOpacity(0.3 * (1 - _pulseController.value)),
                    width: 2,
                  ),
                ),
              ),
              // Your profile pic
              ClipOval(
                child: Container(
                  width: 54,
                  height: 54,
                  color: _aqua.withOpacity(0.2),
                  child: const Icon(Icons.person, color: _aqua, size: 28),
                ),
              ),
              // You label
              Positioned(
                bottom: -20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _aqua,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'YOU',
                    style: TextStyle(
                      color: _black,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 120,
      right: 16,
      child: Column(
        children: [
          // Follow me
          _buildControlButton(Icons.my_location, 'Center', () {
            setState(() {
              _mapOffset = Offset.zero;
              _mapScale = 1.0;
            });
          }),
          const SizedBox(height: 10),
          // List view toggle
          _buildControlButton(
            _showListView ? Icons.map : Icons.list,
            _showListView ? 'Map' : 'List',
            () => setState(() => _showListView = !_showListView),
          ),
          const SizedBox(height: 10),
          // Travel mode
          _buildControlButton(Icons.flight, 'Travel', _openTravelMode),
          const SizedBox(height: 10),
          // Zoom in
          _buildControlButton(Icons.add, 'Zoom +', () {
            setState(() => _mapScale = (_mapScale * 1.2).clamp(0.5, 3.0));
          }),
          const SizedBox(height: 10),
          // Zoom out
          _buildControlButton(Icons.remove, 'Zoom -', () {
            setState(() => _mapScale = (_mapScale / 1.2).clamp(0.5, 3.0));
          }),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon, String tooltip, VoidCallback onTap) {
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

  Widget _buildCruiseButton() {
    return Positioned(
      bottom: 40,
      left: 20,
      right: 20,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.heavyImpact();
          setState(() => _isCruising = !_isCruising);
        },
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Container(
              height: 56,
              decoration: BoxDecoration(
                color: _isCruising ? Colors.red.shade700 : _aqua,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: (_isCruising ? Colors.red : _aqua).withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: _isCruising ? 2 * _pulseController.value : 0,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isCruising ? Icons.stop : Icons.sailing,
                    color: _isCruising ? Colors.white : _black,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _isCruising ? 'STOP CRUISING' : 'CRUISE THIS AREA',
                    style: TextStyle(
                      color: _isCruising ? Colors.white : _black,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildListViewOverlay() {
    final onlineCruisers = _cruisers.where((c) => c.isOnline).toList()
      ..sort((a, b) => a.distanceMiles.compareTo(b.distanceMiles));

    return Positioned.fill(
      child: Container(
        color: _black.withOpacity(0.95),
        child: Column(
          children: [
            const SizedBox(height: 80),
            // Sort header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Text(
                    'Sort by: ',
                    style: TextStyle(color: _olive, fontSize: 13),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: _mint.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Text('Distance', style: TextStyle(color: _mint, fontSize: 13)),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_drop_down, color: _mint, size: 18),
                      ],
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => setState(() => _showListView = false),
                    child: Icon(Icons.close, color: _mint),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white10),
            // Cruiser list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: onlineCruisers.length,
                itemBuilder: (context, index) {
                  final cruiser = onlineCruisers[index];
                  return _buildListItem(cruiser);
                },
              ),
            ),
            // Broadcast input
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _black,
                border: Border(top: BorderSide(color: _mint.withOpacity(0.1))),
              ),
              child: SafeArea(
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: _mint.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: const TextStyle(color: _mint),
                          decoration: InputDecoration(
                            hintText: 'Post a Cruising Update...',
                            hintStyle: TextStyle(color: _olive),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Icon(Icons.send, color: _aqua),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(_Cruiser cruiser) {
    return GestureDetector(
      onTap: () => _showProfileCard(cruiser),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(color: _mint.withOpacity(0.15)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile pic
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: cruiser.isOnline ? _aqua : _olive.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: Container(
                  color: _mint.withOpacity(0.1),
                  child: Icon(
                    cruiser.isAnonymous ? Icons.person_off : Icons.person,
                    color: _mint.withOpacity(0.4),
                    size: 28,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats line
                  Text(
                    cruiser.statsLine,
                    style: TextStyle(
                      color: _mint,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Time and distance
                  Text(
                    '${cruiser.lastActive} · ${cruiser.distanceMiles.toStringAsFixed(2)} miles',
                    style: TextStyle(color: _olive, fontSize: 11),
                  ),
                  const SizedBox(height: 6),
                  // Bio
                  Text(
                    cruiser.bio,
                    style: TextStyle(color: _mint.withOpacity(0.7), fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // Actions
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    // Center on map
                    setState(() {
                      _showListView = false;
                      _mapOffset = Offset(-cruiser.posX, -cruiser.posY);
                    });
                  },
                  child: Icon(Icons.gps_fixed, color: _aqua, size: 20),
                ),
                const SizedBox(height: 12),
                Icon(Icons.more_horiz, color: _olive, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showProfileCard(_Cruiser cruiser) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _ProfileCard(cruiser: cruiser),
    );
  }

  void _openSidebar() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _SidebarMenu(),
    );
  }

  void _openFilters() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _FilterPanel(),
    );
  }

  void _openSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _SettingsMenu(),
    );
  }

  void _openTravelMode() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _TravelModeOverlay(),
    );
  }
}

// Map Painter for custom map rendering
class _MapPainter extends CustomPainter {
  final Offset offset;
  final double scale;
  final Animation<double> pulseAnimation;
  final Animation<double> radarAnimation;
  final bool isCruising;

  _MapPainter({
    required this.offset,
    required this.scale,
    required this.pulseAnimation,
    required this.radarAnimation,
    required this.isCruising,
  }) : super(repaint: Listenable.merge([pulseAnimation, radarAnimation]));

  static const Color _mint = Color(0xFFE3F2DE);
  static const Color _olive = Color(0xFF6B7F4A);
  static const Color _aqua = Color(0xFF20B2A6);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Draw grid lines
    final gridPaint = Paint()
      ..color = _olive.withOpacity(0.1)
      ..strokeWidth = 1;

    final gridSpacing = 50.0 * scale;
    for (double x = (offset.dx % gridSpacing); x < size.width; x += gridSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = (offset.dy % gridSpacing); y < size.height; y += gridSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw radar rings when cruising
    if (isCruising) {
      final radarPaint = Paint()
        ..color = _aqua.withOpacity(0.15 * (1 - radarAnimation.value))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      final maxRadius = size.width * 0.4;
      final radius = maxRadius * radarAnimation.value;
      canvas.drawCircle(center, radius, radarPaint);
    }

    // Draw distance rings
    final ringPaint = Paint()
      ..color = _mint.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var i = 1; i <= 3; i++) {
      canvas.drawCircle(center, 80.0 * i * scale, ringPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _MapPainter oldDelegate) =>
      offset != oldDelegate.offset ||
      scale != oldDelegate.scale ||
      isCruising != oldDelegate.isCruising;
}

// Profile Card Widget
class _ProfileCard extends StatelessWidget {
  final _Cruiser cruiser;

  const _ProfileCard({required this.cruiser});

  static const Color _mint = Color(0xFFE3F2DE);
  static const Color _olive = Color(0xFF6B7F4A);
  static const Color _aqua = Color(0xFF20B2A6);
  static const Color _black = Color(0xFF000000);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: _black,
            border: Border.all(color: _mint.withOpacity(0.2)),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: _mint.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Photo carousel placeholder
              Container(
                height: 300,
                decoration: BoxDecoration(
                  color: _mint.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _mint.withOpacity(0.1)),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        cruiser.isAnonymous ? Icons.person_off : Icons.person,
                        color: _mint.withOpacity(0.3),
                        size: 80,
                      ),
                      const SizedBox(height: 12),
                      if (cruiser.isVerified)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified, color: _aqua, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              'Verified Cruiser',
                              style: TextStyle(color: _aqua, fontSize: 12),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Stats line
              Text(
                cruiser.statsLine,
                style: TextStyle(
                  color: _olive,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              
              // Bio
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: _mint.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '"${cruiser.bio}"',
                  style: TextStyle(
                    color: _mint,
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Tags
              _buildSection('INTO PUBLIC', cruiser.intoPublic),
              const SizedBox(height: 16),
              _buildSection('KINKS', cruiser.kinks),
              const SizedBox(height: 16),
              _buildSection('INTO', cruiser.into),
              const SizedBox(height: 16),
              
              // Health info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: _olive.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(Icons.shield, 'HIV Status', cruiser.hivStatus),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.medical_services, 'Practices', cruiser.practices),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.calendar_today, 'Last Tested', cruiser.lastTested),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Connection status
              Row(
                children: [
                  Icon(Icons.circle, color: cruiser.isOnline ? _aqua : _olive, size: 10),
                  const SizedBox(width: 8),
                  Text(
                    cruiser.isOnline ? 'Connected now' : cruiser.lastActive,
                    style: TextStyle(color: cruiser.isOnline ? _aqua : _olive),
                  ),
                  const Spacer(),
                  Icon(Icons.location_on, color: _olive, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${cruiser.distanceMiles.toStringAsFixed(2)} miles',
                    style: TextStyle(color: _olive),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Message input
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: _mint.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: const TextStyle(color: _mint),
                        decoration: InputDecoration(
                          hintText: 'Send a message...',
                          hintStyle: TextStyle(color: _olive),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Icon(Icons.send, color: _aqua),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: _olive,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: _mint.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              item,
              style: TextStyle(color: _mint, fontSize: 12),
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: _olive, size: 18),
        const SizedBox(width: 10),
        Text('$label:', style: TextStyle(color: _olive, fontSize: 13)),
        const SizedBox(width: 8),
        Text(value, style: TextStyle(color: _mint, fontSize: 13)),
      ],
    );
  }
}

// Sidebar Menu
class _SidebarMenu extends StatelessWidget {
  static const Color _mint = Color(0xFFE3F2DE);
  static const Color _olive = Color(0xFF6B7F4A);
  static const Color _aqua = Color(0xFF20B2A6);
  static const Color _black = Color(0xFF000000);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: _black,
        border: Border.all(color: _mint.withOpacity(0.2)),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: _mint.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          // Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _buildTab('Recents', Icons.chat_bubble_outline, true),
                _buildTab('Taps', Icons.touch_app, false),
                _buildTab('Places', Icons.location_on_outlined, false),
                _buildTab('Groups', Icons.group_outlined, false),
              ],
            ),
          ),
          const Divider(color: Colors.white10),
          // Messages list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 5,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: _aqua, width: 2),
                    ),
                    child: ClipOval(
                      child: Container(
                        color: _mint.withOpacity(0.1),
                        child: Icon(Icons.person, color: _mint.withOpacity(0.4)),
                      ),
                    ),
                  ),
                  title: Text(
                    'Cruiser ${index + 1}',
                    style: const TextStyle(color: _mint, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    index == 0 ? 'New message' : '${index * 2} hours ago',
                    style: TextStyle(color: _olive, fontSize: 12),
                  ),
                  trailing: index == 0
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _aqua,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text('NEW', style: TextStyle(color: _black, fontSize: 10, fontWeight: FontWeight.w700)),
                        )
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, IconData icon, bool isActive) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? _aqua : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isActive ? _aqua : _olive, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? _aqua : _olive,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Filter Panel
class _FilterPanel extends StatelessWidget {
  static const Color _mint = Color(0xFFE3F2DE);
  static const Color _olive = Color(0xFF6B7F4A);
  static const Color _aqua = Color(0xFF20B2A6);
  static const Color _black = Color(0xFF000000);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: _black,
        border: Border.all(color: _mint.withOpacity(0.2)),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text(
                  'Cruisers',
                  style: TextStyle(color: _mint, fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Icon(Icons.refresh, color: _olive),
              ],
            ),
          ),
          const Divider(color: Colors.white10),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildToggle('🔥 Cruising Now', false),
                _buildToggle('📊 Cruiser Stats', true),
                const Divider(color: Colors.white10, height: 32),
                _buildExpandable('Age', 'Select'),
                _buildExpandable('Position', 'All'),
                _buildExpandable('Endowment', 'Select'),
                _buildExpandable('Body Type', 'Select'),
                const Divider(color: Colors.white10, height: 32),
                _buildToggle('📷 Has Photos', false),
                _buildToggle('💬 Has Chat History', false),
                _buildToggle('✈️ Is Visiting', false),
                const Divider(color: Colors.white10, height: 32),
                _buildLink('📍 Places'),
                _buildLink('👥 Groups'),
                _buildLink('🏥 Testing Clinics'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggle(String label, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: _mint, fontSize: 15)),
          const Spacer(),
          Container(
            width: 44,
            height: 24,
            decoration: BoxDecoration(
              color: value ? _aqua : _olive.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Align(
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandable(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: _mint, fontSize: 15)),
          const Spacer(),
          Text(value, style: TextStyle(color: _olive, fontSize: 14)),
          const SizedBox(width: 8),
          Icon(Icons.arrow_forward_ios, color: _olive, size: 14),
        ],
      ),
    );
  }

  Widget _buildLink(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: _mint, fontSize: 15)),
          const Spacer(),
          Icon(Icons.arrow_forward_ios, color: _olive, size: 14),
        ],
      ),
    );
  }
}

// Settings Menu
class _SettingsMenu extends StatelessWidget {
  static const Color _mint = Color(0xFFE3F2DE);
  static const Color _olive = Color(0xFF6B7F4A);
  static const Color _aqua = Color(0xFF20B2A6);
  static const Color _black = Color(0xFF000000);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: _black,
        border: Border.all(color: _mint.withOpacity(0.2)),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: _mint.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildSettingsRow(Icons.person, 'Your Cruiser Profile', 'PLUS', true),
          _buildSettingsRow(Icons.settings, 'Account Settings', null, true),
          const Divider(color: Colors.white10, height: 32),
          _buildToggleRow('👁️ Vanilla Mode', 'NSFW media is shown', true),
          _buildToggleRow('📍 Cluster Markers', null, true),
          _buildToggleRow('🌙 Night Mode', null, true),
          _buildToggleRow('🔊 Sounds', null, false),
          const Divider(color: Colors.white10, height: 32),
          _buildSettingsRow(Icons.group, 'Host a Group', 'PLUS', false),
          _buildSettingsRow(Icons.add_location, 'Add a Place', 'PLUS', false),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {},
                child: Text('Logout', style: TextStyle(color: Colors.red.shade300)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Refresh App', style: TextStyle(color: _olive)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsRow(IconData icon, String label, String? badge, bool hasArrow) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: _mint, size: 20),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: _mint, fontSize: 15)),
          if (badge != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _aqua.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(badge, style: TextStyle(color: _aqua, fontSize: 10, fontWeight: FontWeight.w700)),
            ),
          ],
          const Spacer(),
          if (hasArrow) Icon(Icons.arrow_forward_ios, color: _olive, size: 14),
        ],
      ),
    );
  }

  Widget _buildToggleRow(String label, String? subtitle, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: _mint, fontSize: 15)),
                if (subtitle != null)
                  Text(subtitle, style: TextStyle(color: _olive, fontSize: 11)),
              ],
            ),
          ),
          Container(
            width: 44,
            height: 24,
            decoration: BoxDecoration(
              color: value ? _aqua : _olive.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Align(
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Travel Mode Overlay
class _TravelModeOverlay extends StatelessWidget {
  static const Color _mint = Color(0xFFE3F2DE);
  static const Color _olive = Color(0xFF6B7F4A);
  static const Color _aqua = Color(0xFF20B2A6);
  static const Color _black = Color(0xFF000000);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: _black,
        border: Border.all(color: _mint.withOpacity(0.2)),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, color: _mint),
                ),
                const SizedBox(width: 16),
                const Text(
                  'TRAVEL MODE',
                  style: TextStyle(color: _mint, fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 2),
                ),
              ],
            ),
          ),
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: _mint.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: _olive),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      style: const TextStyle(color: _mint),
                      decoration: InputDecoration(
                        hintText: 'Search City or Use the Map...',
                        hintStyle: TextStyle(color: _olive),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Map placeholder
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0A0A0A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _mint.withOpacity(0.1)),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.map, color: _mint.withOpacity(0.3), size: 64),
                    const SizedBox(height: 16),
                    Text(
                      'Select a location to travel to',
                      style: TextStyle(color: _olive, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Action buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          border: Border.all(color: _olive),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text('Cancel', style: TextStyle(color: _olive)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: _aqua,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Text('✓ Travel here', style: TextStyle(color: _black, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Cruiser model
class _Cruiser {
  final String id;
  final int age;
  final String height;
  final String weight;
  final String bodyType;
  final String position;
  final String bio;
  final double distanceMiles;
  final double posX;
  final double posY;
  final bool isOnline;
  final bool isVerified;
  final bool isAnonymous;
  final bool isLivePlay;
  final bool isHosting;
  final bool isMobile;
  final String lastActive;
  final String hivStatus;
  final String practices;
  final String lastTested;
  final List<String> intoPublic;
  final List<String> kinks;
  final List<String> into;

  _Cruiser({
    required this.id,
    required this.age,
    required this.height,
    required this.weight,
    required this.bodyType,
    required this.position,
    required this.bio,
    required this.distanceMiles,
    required this.posX,
    required this.posY,
    required this.isOnline,
    required this.isVerified,
    required this.isAnonymous,
    required this.isLivePlay,
    required this.isHosting,
    required this.isMobile,
    required this.lastActive,
    required this.hivStatus,
    required this.practices,
    required this.lastTested,
    required this.intoPublic,
    required this.kinks,
    required this.into,
  });

  String get statsLine => "$age, $height, $weight, $bodyType, $position";

  static const List<String> _heights = ["5'7\"", "5'8\"", "5'9\"", "5'10\"", "5'11\"", "6'0\"", "6'1\"", "6'2\""];
  static const List<String> _weights = ['145lb', '155lb', '165lb', '175lb', '185lb', '195lb', '205lb'];
  static const List<String> _bodyTypes = ['Slim', 'Toned', 'Average', 'Muscular', 'Athletic', 'Stocky', 'Bear'];
  static const List<String> _positions = ['Top', 'Bottom', 'Vers', 'Vers Top', 'Vers Bottom', 'Dom Top', 'Sub Bottom'];
  static const List<String> _bios = [
    'Looking for fun. Can host.',
    'DL masc here. HMU if serious.',
    'Visiting this weekend. Open to anything.',
    'Regular guy looking to connect.',
    'Just moved to the area. Show me around?',
    'Night owl. Hit me up late.',
    'Work from home. Free most days.',
    'Gym bro looking for similar.',
  ];
  static const List<String> _publicOptions = ['Arcades', 'Parks', 'Parties/Events', 'Bathhouses', 'Gyms'];
  static const List<String> _kinkOptions = ['Voyeurism', 'Exhibitionism', 'Leather', 'Roleplay', 'Edge'];
  static const List<String> _intoOptions = ['Oral', 'Mutual JO', 'Massage', 'Kissing', 'Cuddling'];

  factory _Cruiser.generate(int index) {
    final random = Random(index);
    final angle = random.nextDouble() * 2 * pi;
    final distance = 30 + random.nextDouble() * 150;
    
    return _Cruiser(
      id: 'cruiser_$index',
      age: 21 + random.nextInt(30),
      height: _heights[random.nextInt(_heights.length)],
      weight: _weights[random.nextInt(_weights.length)],
      bodyType: _bodyTypes[random.nextInt(_bodyTypes.length)],
      position: _positions[random.nextInt(_positions.length)],
      bio: _bios[random.nextInt(_bios.length)],
      distanceMiles: random.nextDouble() * 10,
      posX: cos(angle) * distance,
      posY: sin(angle) * distance,
      isOnline: random.nextDouble() > 0.3,
      isVerified: random.nextDouble() > 0.6,
      isAnonymous: random.nextDouble() > 0.8,
      isLivePlay: random.nextDouble() > 0.9,
      isHosting: random.nextDouble() > 0.85,
      isMobile: random.nextDouble() > 0.9,
      lastActive: random.nextDouble() > 0.5 ? 'a minute ago' : '${random.nextInt(60)} minutes ago',
      hivStatus: random.nextDouble() > 0.5 ? 'Negative, On PrEP' : 'Negative',
      practices: random.nextDouble() > 0.5 ? 'Bareback or Condoms' : 'Condoms Only',
      lastTested: 'Oct 2024',
      intoPublic: List.generate(2 + random.nextInt(3), (i) => _publicOptions[random.nextInt(_publicOptions.length)]).toSet().toList(),
      kinks: List.generate(1 + random.nextInt(4), (i) => _kinkOptions[random.nextInt(_kinkOptions.length)]).toSet().toList(),
      into: List.generate(2 + random.nextInt(3), (i) => _intoOptions[random.nextInt(_intoOptions.length)]).toSet().toList(),
    );
  }
}
