import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../data/mock_data.dart';
import '../../widgets/filter_button.dart';
import '../../widgets/user_cluster_avatar.dart';
import '../../widgets/user_profile_drawer.dart';
import '../../data/mock_user_data.dart';

class SimpleNowView extends StatefulWidget {
  const SimpleNowView({super.key});

  @override
  State<SimpleNowView> createState() => _SimpleNowViewState();
}

class _SimpleNowViewState extends State<SimpleNowView>
    with TickerProviderStateMixin {
  late VideoPlayerController _videoController;
  bool _showGlobe = true;
  bool _showMap = false;
  bool _showDrawer = false;
  MockUser? _selectedUser;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    _initializeAnimations();
  }

  void _initializeVideo() {
    _videoController = VideoPlayerController.asset(
      'assets/videos/spinning_globe_now_loading.mp4',
    );
    _videoController.initialize().then((_) {
      setState(() {});
      _videoController.play();
    });

    _videoController.addListener(() {
      if (_videoController.value.position >= const Duration(seconds: 3)) {
        _transitionToMap();
      }
    });
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
  }

  void _transitionToMap() {
    setState(() {
      _showGlobe = false;
      _showMap = true;
    });
    _fadeController.forward();
  }

  void _onUserTap(MockUser user) {
    setState(() {
      _selectedUser = user;
      _showDrawer = true;
    });
  }

  void _closeDrawer() {
    setState(() {
      _showDrawer = false;
      _selectedUser = null;
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Globe Intro
          if (_showGlobe)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black,
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: VideoPlayer(_videoController),
                ),
              ),
            ),

          // 3D City Map
          if (_showMap)
            FadeTransition(opacity: _fadeAnimation, child: _build3DMap()),

          // User Clusters
          if (_showMap)
            FadeTransition(
              opacity: _fadeAnimation,
              child: _buildUserClusters(),
            ),

          // Floating Filter Button
          if (_showMap)
            Positioned(
              top: MediaQuery.of(context).padding.top + 20,
              right: 20,
              child: const FilterButton(),
            ),

          // User Profile Drawer
          if (_showDrawer && _selectedUser != null)
            UserProfileDrawer(user: _selectedUser!, onClose: _closeDrawer),
        ],
      ),
    );
  }

  Widget _build3DMap() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(color: Colors.black),
      child: Stack(
        children: [
          // 3D Map Container (placeholder for Mapbox/Cesium)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black, Color(0xFF1a1a1a), Colors.black],
              ),
            ),
            child: CustomPaint(painter: CyberpunkMapPainter()),
          ),

          // Ambient Fog Overlay
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 0.8,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.3),
                  Colors.black.withValues(alpha: 0.6),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserClusters() {
    return Stack(
      children: nowMockUsers.map((user) {
        return Positioned(
          top: user.top,
          left: user.left,
          child: GestureDetector(
            onTap: () => _onUserTap(user),
            child: UserClusterAvatar(user: user),
          ),
        );
      }).toList(),
    );
  }
}

class CyberpunkMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00FF88)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw grid base
    const gridSpacing = 50.0;
    for (double x = 0; x < size.width; x += gridSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += gridSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw glowing buildings
    final buildingPaint = Paint()
      ..color = const Color(0xFF00FF88)
      ..style = PaintingStyle.fill;

    final buildings = [
      const Rect.fromLTWH(100, 200, 80, 120),
      const Rect.fromLTWH(300, 150, 60, 180),
      const Rect.fromLTWH(500, 250, 100, 100),
      const Rect.fromLTWH(200, 400, 70, 140),
      const Rect.fromLTWH(450, 350, 90, 160),
    ];

    for (final building in buildings) {
      // Building glow
      final glowPaint = Paint()
        ..color = const Color(0xFF00FF88).withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

      canvas.drawRect(building.inflate(5), glowPaint);
      canvas.drawRect(building, buildingPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}








