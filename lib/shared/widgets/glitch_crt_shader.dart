import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:nvs/core/gfx/shader_loader.dart';

class GlitchCRTShader extends StatefulWidget {
  const GlitchCRTShader({required this.child, super.key});
  final Widget child;

  @override
  State<GlitchCRTShader> createState() => _GlitchCRTShaderState();
}

class _GlitchCRTShaderState extends State<GlitchCRTShader> {
  ui.FragmentShader? _shader;

  @override
  void initState() {
    super.initState();
    _loadShader();
  }

  Future<void> _loadShader() async {
    try {
      final ui.FragmentProgram program = await ShaderLoader.load('glitch_crt.frag');
      setState(() {
        _shader = program.fragmentShader();
      });
    } catch (_) {
      // If shader fails (e.g., missing/empty), gracefully fall back to plain child
      setState(() {
        _shader = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_shader == null) return widget.child;
    return CustomPaint(
      painter: _GlitchPainter(_shader!),
      child: widget.child,
    );
  }
}

class _GlitchPainter extends CustomPainter {
  _GlitchPainter(this.shader);
  final ui.FragmentShader shader;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
