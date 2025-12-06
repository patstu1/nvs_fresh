// lib/features/connect/presentation/synaptic_transit_view.dart

import 'dart:math';
import 'package:flutter/material.dart';

class SynapticTransitView extends StatefulWidget {
  const SynapticTransitView({
    required this.matchedUserWalletAddress, required this.compatibilityScore, super.key,
  });
  final String matchedUserWalletAddress;
  final double compatibilityScore;

  @override
  _SynapticTransitViewState createState() => _SynapticTransitViewState();
}

class _SynapticTransitViewState extends State<SynapticTransitView> with TickerProviderStateMixin {
  late AnimationController _orbitalController;
  late AnimationController _pulseController;
  late AnimationController _dataFlowController;

  @override
  void initState() {
    super.initState();

    _orbitalController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _dataFlowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _orbitalController.dispose();
    _pulseController.dispose();
    _dataFlowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          // Animated background with data streams
          Positioned.fill(
            child: AnimatedBuilder(
              animation: Listenable.merge(<Listenable?>[
                _orbitalController,
                _pulseController,
                _dataFlowController,
              ]),
              builder: (BuildContext context, Widget? child) {
                return CustomPaint(
                  painter: SynapticTransitPainter(
                    orbitalValue: _orbitalController.value,
                    pulseValue: _pulseController.value,
                    dataFlowValue: _dataFlowController.value,
                    compatibilityScore: widget.compatibilityScore,
                  ),
                  size: Size.infinite,
                );
              },
            ),
          ),

          // Central compatibility display
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Compatibility score indicator
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF04FFF7).withOpacity(0.5),
                      width: 2,
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: const Color(0xFF04FFF7).withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '${(widget.compatibilityScore * 100).toInt()}%',
                          style: const TextStyle(
                            fontFamily: 'BellGothic',
                            color: Color(0xFF04FFF7),
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'SYNAPTIC MATCH',
                          style: TextStyle(
                            fontFamily: 'MagdaCleanMono',
                            color: Colors.white,
                            fontSize: 12,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // User identifier
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: const Color(0xFF04FFF7).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    'ID: ${widget.matchedUserWalletAddress.substring(0, 8)}...',
                    style: const TextStyle(
                      fontFamily: 'MagdaCleanMono',
                      color: Colors.white,
                      fontSize: 14,
                      letterSpacing: 1,
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _buildActionButton(
                      'INITIATE CONTACT',
                      const Color(0xFF04FFF7),
                      _initiateContact,
                    ),
                    _buildActionButton(
                      'DEEPER ANALYSIS',
                      const Color(0xFF8A2BE2),
                      _requestDeeperAnalysis,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Back button
          Positioned(
            top: 50,
            left: 20,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: const Color(0xFF04FFF7).withOpacity(0.3),
                ),
              ),
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFF04FFF7),
                ),
              ),
            ),
          ),

          // Status indicator
          Positioned(
            top: 50,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF00FF9F).withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00FF9F),
                      shape: BoxShape.circle,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: const Color(0xFF00FF9F).withOpacity(0.6),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'TRANSIT ACTIVE',
                    style: TextStyle(
                      fontFamily: 'MagdaCleanMono',
                      color: Color(0xFF00FF9F),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
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

  Widget _buildActionButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.2),
        foregroundColor: color,
        side: BorderSide(color: color),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'BellGothic',
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 1,
        ),
      ),
    );
  }

  void _initiateContact() {
    // Navigate to chat or send connection request
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Contact initiated with ${widget.matchedUserWalletAddress.substring(0, 8)}...',
        ),
        backgroundColor: const Color(0xFF04FFF7),
      ),
    );
  }

  void _requestDeeperAnalysis() {
    // Show detailed compatibility breakdown
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => _buildAnalysisSheet(),
    );
  }

  Widget _buildAnalysisSheet() {
    return Container(
      height: 400,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(
          top: BorderSide(color: Color(0xFF04FFF7)),
          left: BorderSide(color: Color(0xFF04FFF7)),
          right: BorderSide(color: Color(0xFF04FFF7)),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'SYNAPTIC ANALYSIS',
            style: TextStyle(
              fontFamily: 'BellGothic',
              color: Color(0xFF04FFF7),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 20),
          _buildAnalysisMetric('Quantum Resonance', widget.compatibilityScore),
          _buildAnalysisMetric(
            'Neural Alignment',
            widget.compatibilityScore * 0.9,
          ),
          _buildAnalysisMetric(
            'Temporal Sync',
            widget.compatibilityScore * 1.1,
          ),
          _buildAnalysisMetric(
            'Aesthetic Harmony',
            widget.compatibilityScore * 0.8,
          ),
          _buildAnalysisMetric(
            'Synaptic Potential',
            widget.compatibilityScore * 1.2,
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisMetric(String label, double value) {
    final double clampedValue = value.clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'MagdaCleanMono',
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
              Text(
                '${(clampedValue * 100).toInt()}%',
                style: const TextStyle(
                  fontFamily: 'MagdaCleanMono',
                  color: Color(0xFF04FFF7),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: clampedValue,
            backgroundColor: Colors.grey[800],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF04FFF7)),
          ),
        ],
      ),
    );
  }
}

class SynapticTransitPainter extends CustomPainter {
  SynapticTransitPainter({
    required this.orbitalValue,
    required this.pulseValue,
    required this.dataFlowValue,
    required this.compatibilityScore,
  });
  final double orbitalValue;
  final double pulseValue;
  final double dataFlowValue;
  final double compatibilityScore;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);

    // Draw background grid
    _drawBackgroundGrid(canvas, size);

    // Draw orbital rings
    _drawOrbitalRings(canvas, center, size);

    // Draw data streams
    _drawDataStreams(canvas, center, size);

    // Draw synaptic connections
    _drawSynapticConnections(canvas, center, size);
  }

  void _drawBackgroundGrid(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFF04FFF7).withOpacity(0.05)
      ..strokeWidth = 1;

    const double gridSize = 40.0;

    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void _drawOrbitalRings(Canvas canvas, Offset center, Size size) {
    final double maxRadius = min(size.width, size.height) / 2 * 0.8;

    for (int i = 0; i < 3; i++) {
      final double radius = maxRadius * (0.3 + i * 0.2);
      final double opacity = (1.0 - i * 0.3) * (0.5 + pulseValue * 0.3);

      final Paint paint = Paint()
        ..color = const Color(0xFF04FFF7).withOpacity(opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;

      canvas.drawCircle(center, radius, paint);

      // Draw orbital nodes
      for (int j = 0; j < 6; j++) {
        final double angle = (j / 6) * 2 * pi + (orbitalValue * 2 * pi);
        final Offset nodePosition = Offset(
          center.dx + radius * cos(angle),
          center.dy + radius * sin(angle),
        );

        final Paint nodePaint = Paint()
          ..color = const Color(0xFF04FFF7).withOpacity(opacity * 1.5)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(nodePosition, 2.0 + i.toDouble(), nodePaint);
      }
    }
  }

  void _drawDataStreams(Canvas canvas, Offset center, Size size) {
    final double maxRadius = min(size.width, size.height) / 2;

    for (int i = 0; i < 12; i++) {
      final double angle = (i / 12) * 2 * pi;
      final double distance = maxRadius * (0.3 + dataFlowValue * 0.6);

      final Offset startPoint = Offset(
        center.dx + 50 * cos(angle),
        center.dy + 50 * sin(angle),
      );

      final Offset endPoint = Offset(
        center.dx + distance * cos(angle),
        center.dy + distance * sin(angle),
      );

      final Paint paint = Paint()
        ..color = const Color(0xFF8A2BE2).withOpacity(0.6)
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(startPoint, endPoint, paint);

      // Draw data packets
      final Offset packetPosition = Offset.lerp(startPoint, endPoint, dataFlowValue)!;
      final Paint packetPaint = Paint()
        ..color = const Color(0xFF8A2BE2)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(packetPosition, 3, packetPaint);
    }
  }

  void _drawSynapticConnections(Canvas canvas, Offset center, Size size) {
    final Random random = Random(42); // Fixed seed for consistent pattern

    for (int i = 0; i < 20; i++) {
      final double startAngle = random.nextDouble() * 2 * pi;
      final double endAngle = random.nextDouble() * 2 * pi;
      final double radius1 = 100 + random.nextDouble() * 100;
      final double radius2 = 100 + random.nextDouble() * 100;

      final Offset start = Offset(
        center.dx + radius1 * cos(startAngle),
        center.dy + radius1 * sin(startAngle),
      );

      final Offset end = Offset(
        center.dx + radius2 * cos(endAngle),
        center.dy + radius2 * sin(endAngle),
      );

      final double opacity = (0.1 + pulseValue * 0.3) * compatibilityScore;
      final Paint paint = Paint()
        ..color = const Color(0xFF00FF9F).withOpacity(opacity)
        ..strokeWidth = 1;

      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
