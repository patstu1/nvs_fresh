import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/quantum_shader_service.dart';

class GlitchScannerMask extends ConsumerWidget {
  const GlitchScannerMask({required this.child, this.intensity = 1.0, super.key});
  final Widget child;
  final double intensity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final QuantumShaderService shaderService = ref.watch(quantumShaderServiceProvider);
    final ui.FragmentShader? shader = shaderService.getShader('glitch_scanner_mask');
    if (shader == null) return child;

    final Size size = MediaQuery.of(context).size;

    return CustomPaint(
      painter: _GlitchScannerMaskPainter(shader: shader, intensity: intensity),
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: child,
      ),
    );
  }
}

class _GlitchScannerMaskPainter extends CustomPainter {
  _GlitchScannerMaskPainter({required this.shader, required this.intensity});
  final ui.FragmentShader shader;
  final double intensity;

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, DateTime.now().millisecondsSinceEpoch / 1000.0);
    shader.setFloat(1, size.width);
    shader.setFloat(2, size.height);
    shader.setFloat(3, intensity);

    final Paint paint = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant _GlitchScannerMaskPainter oldDelegate) {
    return oldDelegate.intensity != intensity || oldDelegate.shader != shader;
  }
}

