// lib/core/services/quantum_shader_service.dart
// Bio-Responsive Shader Management for NVS Quantum Architecture
// Manages GLSL shaders that respond to real-time biometric data

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/core/gfx/shader_loader.dart';

/// Service for managing bio-responsive quantum shaders
class QuantumShaderService {
  QuantumShaderService._();
  static QuantumShaderService? _instance;
  static QuantumShaderService get instance => _instance ??= QuantumShaderService._();

  // Shader cache
  final Map<String, ui.FragmentShader> _shaderCache = <String, ui.FragmentShader>{};
  final Map<String, ui.FragmentProgram> _programCache = <String, ui.FragmentProgram>{};

  // Current biometric state
  double _currentHeartRate = 60.0;
  double _currentArousalLevel = 0.0;
  double _currentStressLevel = 0.0;
  Color _baseColor = const Color(0xFF00FFF0); // Quantum mint
  Color _pulseColor = const Color(0xFF00FFAA); // Pulse green

  /// Initialize shader service and load shader programs
  Future<void> initialize() async {
    try {
      await _loadShaderProgram('quantum_bio_pulse', 'quantum_bio_pulse.frag');
      await _loadShaderProgram('glitch_scanner_mask', 'glitch_scanner_mask.frag');
      await _loadShaderProgram('glitch_scanner', 'glitch_scanner.frag');
      await _loadShaderProgram('glitch_crt', 'glitch_crt.frag');
      debugPrint('🎨 Quantum Shader Service initialized');
    } catch (e) {
      debugPrint('❌ Failed to initialize shader service: $e');
    }
  }

  /// Load a shader program from assets
  Future<void> _loadShaderProgram(String name, String fileName) async {
    try {
      final ui.FragmentProgram program = await ShaderLoader.load(fileName);
      _programCache[name] = program;
      debugPrint('✅ Loaded shader program: $name');
    } catch (e) {
      debugPrint('❌ Failed to load shader $name: $e');
    }
  }

  /// Get or create a shader instance
  ui.FragmentShader? getShader(String name) {
    if (_shaderCache.containsKey(name)) {
      return _shaderCache[name];
    }

    final ui.FragmentProgram? program = _programCache[name];
    if (program != null) {
      final ui.FragmentShader shader = program.fragmentShader();
      _shaderCache[name] = shader;
      return shader;
    }

    return null;
  }

  /// Update biometric data for shader uniforms
  void updateBiometricData({
    double? heartRate,
    double? arousalLevel,
    double? stressLevel,
    Color? baseColor,
    Color? pulseColor,
  }) {
    if (heartRate != null) _currentHeartRate = heartRate.clamp(30.0, 200.0);
    if (arousalLevel != null) {
      _currentArousalLevel = arousalLevel.clamp(0.0, 1.0);
    }
    if (stressLevel != null) _currentStressLevel = stressLevel.clamp(0.0, 1.0);
    if (baseColor != null) _baseColor = baseColor;
    if (pulseColor != null) _pulseColor = pulseColor;

    // Update all active shaders with new biometric data
    _updateShaderUniforms();
  }

  /// Update shader uniforms with current biometric data
  void _updateShaderUniforms() {
    for (final ui.FragmentShader shader in _shaderCache.values) {
      _setBiometricUniforms(shader);
    }
  }

  /// Set biometric uniforms for a shader
  void _setBiometricUniforms(ui.FragmentShader shader) {
    // Time uniform (index 0)
    shader.setFloat(0, DateTime.now().millisecondsSinceEpoch / 1000.0);

    // Resolution uniform (index 1, 2)
    shader.setFloat(1, 390.0); // Default iPhone width
    shader.setFloat(2, 844.0); // Default iPhone height

    // Biometric uniforms
    shader.setFloat(3, _currentHeartRate);
    shader.setFloat(4, _currentArousalLevel);
    shader.setFloat(5, _currentStressLevel);

    // Color uniforms (RGB)
    shader.setFloat(6, _baseColor.red / 255.0);
    shader.setFloat(7, _baseColor.green / 255.0);
    shader.setFloat(8, _baseColor.blue / 255.0);

    shader.setFloat(9, _pulseColor.red / 255.0);
    shader.setFloat(10, _pulseColor.green / 255.0);
    shader.setFloat(11, _pulseColor.blue / 255.0);

    // Intensity based on arousal + stress
    final double intensity =
        (0.5 + (_currentArousalLevel * 0.3) + (_currentStressLevel * 0.2)).clamp(0.0, 1.0);
    shader.setFloat(12, intensity);
  }

  /// Create a bio-responsive shader widget
  Widget createBioShaderWidget({
    required String shaderName,
    required Widget child,
    required Size size,
    double intensity = 1.0,
  }) {
    final ui.FragmentShader? shader = getShader(shaderName);
    if (shader == null) {
      return child; // Fallback to child if shader not available
    }

    return CustomPaint(
      size: size,
      painter: BioShaderPainter(
        shader: shader,
        intensity: intensity,
        shaderService: this,
      ),
      child: child,
    );
  }

  /// Get current biometric state for debugging
  BiometricState getCurrentBiometricState() {
    return BiometricState(
      heartRate: _currentHeartRate,
      arousalLevel: _currentArousalLevel,
      stressLevel: _currentStressLevel,
      baseColor: _baseColor,
      pulseColor: _pulseColor,
    );
  }

  /// Dispose of shader resources
  void dispose() {
    for (final ui.FragmentShader shader in _shaderCache.values) {
      shader.dispose();
    }
    _shaderCache.clear();
    _programCache.clear();
  }
}

/// Custom painter for bio-responsive shaders
class BioShaderPainter extends CustomPainter {
  BioShaderPainter({
    required this.shader,
    required this.intensity,
    required this.shaderService,
  });
  final ui.FragmentShader shader;
  final double intensity;
  final QuantumShaderService shaderService;

  @override
  void paint(Canvas canvas, Size size) {
    // Update shader uniforms with current size and time
    shader.setFloat(1, size.width);
    shader.setFloat(2, size.height);
    shader.setFloat(0, DateTime.now().millisecondsSinceEpoch / 1000.0);

    // Update intensity
    shader.setFloat(12, intensity);

    // Update biometric data
    shaderService._setBiometricUniforms(shader);

    // Create paint with shader
    final ui.Paint paint = Paint()..shader = shader;

    // Draw shader effect
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Biometric state data class
class BiometricState {
  const BiometricState({
    required this.heartRate,
    required this.arousalLevel,
    required this.stressLevel,
    required this.baseColor,
    required this.pulseColor,
  });
  final double heartRate;
  final double arousalLevel;
  final double stressLevel;
  final Color baseColor;
  final Color pulseColor;

  @override
  String toString() {
    return 'BiometricState(HR: ${heartRate.toStringAsFixed(1)} BPM, '
        'Arousal: ${(arousalLevel * 100).toStringAsFixed(1)}%, '
        'Stress: ${(stressLevel * 100).toStringAsFixed(1)}%)';
  }
}

/// Quantum shader provider for Riverpod
final Provider<QuantumShaderService> quantumShaderServiceProvider =
    Provider<QuantumShaderService>((ProviderRef<QuantumShaderService> ref) {
  return QuantumShaderService.instance;
});
