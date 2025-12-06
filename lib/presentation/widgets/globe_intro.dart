import 'package:flutter/material.dart';

class GlobeIntro extends StatefulWidget {
  final VoidCallback onIntroComplete;

  const GlobeIntro({super.key, required this.onIntroComplete});

  @override
  _GlobeIntroState createState() => _GlobeIntroState();
}

class _GlobeIntroState extends State<GlobeIntro> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onIntroComplete();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            ),
          );
        },
        child: Center(
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF4BEFE0).withValues(alpha: 0.4),
                  const Color(0xFF4BEFE0).withValues(alpha: 0.2),
                  Colors.transparent,
                ],
              ),
              border: Border.all(
                color: const Color(0xFF4BEFE0),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4BEFE0).withValues(alpha: 0.5),
                  blurRadius: 25,
                  spreadRadius: 8,
                ),
              ],
            ),
            child: const Icon(
              Icons.public,
              size: 80,
              color: Color(0xFF4BEFE0),
            ),
          ),
        ),
      ),
    );
  }
}
