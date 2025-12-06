import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/meatup_core.dart';

// We're going to need a real 3D rendering library for this. Three.js for Flutter is a good start.
// For this proof of concept, I'll simulate the effect with a CustomPainter and Transformation.

class SynapticDataCube extends ConsumerStatefulWidget {
  final UserProfile user;
  const SynapticDataCube({super.key, required this.user});

  @override
  ConsumerState<SynapticDataCube> createState() => _SynapticDataCubeState();
}

class _SynapticDataCubeState extends ConsumerState<SynapticDataCube>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // Perspective
            ..rotateX(0.2)
            ..rotateY(_controller.value * 2 * pi),
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              // This is a placeholder. A real implementation uses a 3D mesh.
              border: Border.all(color: NVSColors.primaryNeonMint, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: NVSColors.primaryNeonMint.withOpacity(0.6),
                  blurRadius: 20.0,
                  spreadRadius: 2.0,
                ),
              ],
            ),
            child: Stack(
              children: [
                // In a real 3D render, each face would be a texture on the mesh
                Center(
                  child: Image.network(
                    widget.user.avatarUrl,
                    fit: BoxFit.contain,
                  ),
                ),
                // We'd add custom painters for the glitch/data effects
              ],
            ),
          ),
        );
      },
    );
  }
}
