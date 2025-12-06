import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';
import '../../data/now_map_model.dart';
import 'dart:math' as math;

class ClusterWidget extends StatefulWidget {
  final UserCluster cluster;
  final VoidCallback? onTap;
  final double size;

  const ClusterWidget({
    super.key,
    required this.cluster,
    this.onTap,
    this.size = 60,
  });

  @override
  State<ClusterWidget> createState() => _ClusterWidgetState();
}

class _ClusterWidgetState extends State<ClusterWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_rotationController);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulseAnimation, _rotationAnimation]),
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      NVSColors.neonMint.withValues(alpha: 0.8),
                      NVSColors.neonMint.withValues(alpha: 0.4),
                      NVSColors.neonMint.withValues(alpha: 0.1),
                    ],
                    stops: const [0.3, 0.7, 1.0],
                  ),
                  border: Border.all(color: NVSColors.neonMint, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: NVSColors.neonMint.withValues(alpha: 0.5),
                      blurRadius: 15,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: _buildClusterContent(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildClusterContent() {
    return Stack(
      children: [
        // Background pattern
        _buildHexagonPattern(),

        // Main content
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${widget.cluster.userCount}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: widget.size * 0.25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'users',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: widget.size * 0.12,
                ),
              ),
            ],
          ),
        ),

        // Orbital users
        ..._buildOrbitalUsers(),
      ],
    );
  }

  Widget _buildHexagonPattern() {
    return CustomPaint(
      size: Size(widget.size, widget.size),
      painter: HexagonPatternPainter(
        color: NVSColors.neonMint.withValues(alpha: 0.3),
      ),
    );
  }

  List<Widget> _buildOrbitalUsers() {
    final users = <Widget>[];
    final radius = widget.size * 0.35;
    final userCount = math.min(widget.cluster.userCount, 6);

    for (int i = 0; i < userCount; i++) {
      final angle = (2 * math.pi * i) / userCount;
      final x = radius * math.cos(angle);
      final y = radius * math.sin(angle);

      users.add(
        Positioned(
          left: (widget.size / 2) + x - 4,
          top: (widget.size / 2) + y - 4,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getUserColor(i),
              boxShadow: [
                BoxShadow(
                  color: _getUserColor(i).withValues(alpha: 0.5),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return users;
  }

  Color _getUserColor(int index) {
    final colors = [
      const Color(0xFF00FF88), // Neon green
      const Color(0xFF00FFFF), // Cyan
      const Color(0xFFFF0080), // Pink
      const Color(0xFFFFFF00), // Yellow
      const Color(0xFF8000FF), // Purple
      const Color(0xFFFF4000), // Orange
    ];
    return colors[index % colors.length];
  }
}

class ClusterPreviewSheet extends StatelessWidget {
  final UserCluster cluster;
  final VoidCallback? onViewAll;
  final Function(String userId)? onUserTap;

  const ClusterPreviewSheet({
    super.key,
    required this.cluster,
    this.onViewAll,
    this.onUserTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border.all(
          color: NVSColors.neonMint.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildUserGrid()),
          _buildActions(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: NVSColors.neonMint.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: NVSColors.neonMint.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Cluster Group',
            style: TextStyle(
              color: NVSColors.neonMint,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${cluster.userCount} users nearby',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: math.min(cluster.userCount, 9),
      itemBuilder: (context, index) {
        return _buildUserTile(index);
      },
    );
  }

  Widget _buildUserTile(int index) {
    return GestureDetector(
      onTap: () => onUserTap?.call('user_$index'),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              NVSColors.cardBackground.withValues(alpha: 0.8),
              NVSColors.cardBackground.withValues(alpha: 0.4),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: NVSColors.neonMint.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [NVSColors.neonMint, NVSColors.electricBlue],
                ),
                border: Border.all(color: NVSColors.neonMint, width: 1),
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              'User ${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${(math.Random().nextDouble() * 500).toInt()}m',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: NVSColors.neonMint.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onViewAll,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [NVSColors.neonMint, NVSColors.electricBlue],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: NVSColors.neonMint.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  'View All Users',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: NVSColors.cardBackground.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: NVSColors.neonMint.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.close,
                color: NVSColors.neonMint,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HexagonPatternPainter extends CustomPainter {
  final Color color;

  HexagonPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.15;

    // Draw hexagon
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (math.pi / 3) * i;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);

    // Draw inner lines
    for (int i = 0; i < 6; i++) {
      final angle = (math.pi / 3) * i;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      canvas.drawLine(center, Offset(x, y), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
