// lib/features/connect/presentation/radar_painter.dart

import 'package:flutter/material.dart';
import 'package:nvs/features/connect/domain/models/compatibility_match.dart';
import 'dart:math';

class RadarPainter extends CustomPainter {
  RadarPainter({required this.matches, required this.rotation});
  final List<CompatibilityMatch> matches;
  final double rotation;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double maxRadius = min(size.width, size.height) / 2 * 0.9;

    // --- Draw the central user node ---
    final Paint userPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, 8, userPaint);

    // --- Draw the grid lines ---
    final Paint gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    canvas.drawCircle(center, maxRadius * 0.33, gridPaint);
    canvas.drawCircle(center, maxRadius * 0.66, gridPaint);
    canvas.drawCircle(center, maxRadius, gridPaint);

    // --- Draw each match as an orbiting node ---
    for (int i = 0; i < matches.length; i++) {
      final CompatibilityMatch match = matches[i];
      final double score = match.score; // 0.0 to 1.0

      // Map score to distance (higher score = closer)
      final double distance = maxRadius * (1.0 - score * 0.8);

      // Calculate angular position
      final double angle = (2 * pi / matches.length) * i + rotation;

      final Offset nodePosition = Offset(
        center.dx + distance * cos(angle),
        center.dy + distance * sin(angle),
      );

      // --- Draw the connecting line ---
      final Paint linePaint = Paint()
        ..color = Colors.cyan.withOpacity(score * 0.5)
        ..strokeWidth = 1.0;
      canvas.drawLine(center, nodePosition, linePaint);

      // --- Draw the node ---
      final double nodeSize = 4 + (score * 4); // Larger node for better match
      final Paint nodePaint = Paint()
        ..color = Color.lerp(Colors.red, Colors.cyan, score)!
        ..maskFilter =
            MaskFilter.blur(BlurStyle.normal, score * 5); // Glow effect
      canvas.drawCircle(nodePosition, nodeSize, nodePaint);
    }
  }

  @override
  bool shouldRepaint(covariant RadarPainter oldDelegate) {
    return rotation != oldDelegate.rotation || matches != oldDelegate.matches;
  }
}
