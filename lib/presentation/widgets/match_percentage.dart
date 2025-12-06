import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

class MatchPercentage extends StatefulWidget {
  final int percentage;

  const MatchPercentage({
    super.key,
    required this.percentage,
  });

  @override
  State<MatchPercentage> createState() => _MatchPercentageState();
}

class _MatchPercentageState extends State<MatchPercentage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getPercentageColor() {
    if (widget.percentage >= 80) return NVSColors.neonLime;
    if (widget.percentage >= 60) return NVSColors.neonMint;
    if (widget.percentage >= 40) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getPercentageColor();

    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withValues(alpha: _glowAnimation.value),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: _glowAnimation.value * 0.6),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Text(
            '${widget.percentage}%',
            style: TextStyle(
              fontFamily: 'MagdaCleanMono',
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}
