// NVS Complete Onboarding Flow
// Matte black screen → Scanner bar → Glitching NVS → Face scan → NVS meanings
// Colors: #000000 matte black, #E4FFF0 mint ONLY

import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NvsOnboardingComplete extends StatefulWidget {
  final VoidCallback onComplete;
  
  const NvsOnboardingComplete({super.key, required this.onComplete});

  @override
  State<NvsOnboardingComplete> createState() => _NvsOnboardingCompleteState();
}

class _NvsOnboardingCompleteState extends State<NvsOnboardingComplete>
    with TickerProviderStateMixin {
  static const Color _mint = Color(0xFFE4FFF0);
  static const Color _black = Color(0xFF000000);

  int _currentStep = 0; // 0: Scanner, 1: Face Scan, 2: NVS Meanings

  late AnimationController _scannerController;
  late AnimationController _glitchController;
  late AnimationController _pulseController;
  late AnimationController _staticController;

  bool _scanComplete = false;
  bool _faceDetected = false;
  bool _showMeanings = false;

  @override
  void initState() {
    super.initState();
    _scannerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    _glitchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _staticController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..repeat();

    // Auto-advance through steps
    _startOnboardingSequence();
  }

  void _startOnboardingSequence() async {
    // Step 0: Scanner with glitching NVS - 4 seconds
    await Future.delayed(const Duration(seconds: 4));
    if (mounted) {
      HapticFeedback.mediumImpact();
      setState(() {
        _scanComplete = true;
        _currentStep = 1;
      });
    }

    // Step 1: Face scan - 3 seconds
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      HapticFeedback.heavyImpact();
      setState(() {
        _faceDetected = true;
      });
    }

    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _currentStep = 2;
        _showMeanings = true;
      });
    }
  }

  @override
  void dispose() {
    _scannerController.dispose();
    _glitchController.dispose();
    _pulseController.dispose();
    _staticController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _black,
      body: GestureDetector(
        onTap: () {
          if (_currentStep == 2) {
            _completeOnboarding();
          }
        },
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: _buildCurrentStep(),
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildScannerStep();
      case 1:
        return _buildFaceScanStep();
      case 2:
        return _buildMeaningsStep();
      default:
        return _buildScannerStep();
    }
  }

  // ============ STEP 0: SCANNER WITH GLITCHING NVS ============
  Widget _buildScannerStep() {
    return Stack(
      key: const ValueKey('scanner'),
      children: [
        // Scanner line
        AnimatedBuilder(
          animation: _scannerController,
          builder: (context, child) {
            final y = MediaQuery.of(context).size.height * _scannerController.value;
            
            // Trigger glitch when scanner crosses center
            if (_scannerController.value > 0.45 && _scannerController.value < 0.55) {
              if (!_glitchController.isAnimating) {
                _glitchController.forward(from: 0);
              }
            }
            
            return Positioned(
              top: y,
              left: 0,
              right: 0,
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  color: _mint,
                  boxShadow: [
                    BoxShadow(
                      color: _mint.withOpacity(0.8),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        // Glitching NVS text
        Center(
          child: AnimatedBuilder(
            animation: _glitchController,
            builder: (context, child) {
              final glitchOffset = sin(_glitchController.value * pi * 10) * 5;
              
              return Transform.translate(
                offset: Offset(glitchOffset, 0),
                child: Stack(
                  children: [
                    // Glitch layers
                    if (_glitchController.isAnimating) ...[
                      Transform.translate(
                        offset: Offset(-3, 0),
                        child: Text(
                          'NVS',
                          style: TextStyle(
                            fontFamily: 'BellGothic',
                            fontSize: 80,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 20,
                            color: _mint.withOpacity(0.3),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(3, 0),
                        child: Text(
                          'NVS',
                          style: TextStyle(
                            fontFamily: 'BellGothic',
                            fontSize: 80,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 20,
                            color: _mint.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ],
                    // Main text
                    Text(
                      'NVS',
                      style: TextStyle(
                        fontFamily: 'BellGothic',
                        fontSize: 80,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 20,
                        color: _mint,
                        shadows: [
                          Shadow(
                            color: _mint.withOpacity(0.5),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        // Bottom text
        Positioned(
          bottom: 60,
          left: 0,
          right: 0,
          child: Text(
            'INITIALIZING',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _mint.withOpacity(0.4),
              fontSize: 12,
              letterSpacing: 4,
            ),
          ),
        ),
      ],
    );
  }

  // ============ STEP 1: FACE SCAN ============
  Widget _buildFaceScanStep() {
    return Stack(
      key: const ValueKey('facescan'),
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Face scan frame
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Container(
                    width: 220,
                    height: 280,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(110),
                      border: Border.all(
                        color: _faceDetected 
                            ? _mint 
                            : _mint.withOpacity(0.3 + 0.3 * _pulseController.value),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _mint.withOpacity(0.2 * _pulseController.value),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Corner brackets
                        ..._buildCornerBrackets(),
                        // Scan line
                        if (!_faceDetected)
                          AnimatedBuilder(
                            animation: _scannerController,
                            builder: (context, child) {
                              return Positioned(
                                top: 260 * _scannerController.value,
                                left: 20,
                                right: 20,
                                child: Container(
                                  height: 2,
                                  color: _mint.withOpacity(0.6),
                                ),
                              );
                            },
                          ),
                        // Face icon or checkmark
                        Icon(
                          _faceDetected ? Icons.check : Icons.face,
                          color: _mint.withOpacity(_faceDetected ? 1.0 : 0.3),
                          size: 60,
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              // Status text
              Text(
                _faceDetected ? 'VERIFIED' : 'SCANNING FACE',
                style: TextStyle(
                  color: _mint,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _faceDetected 
                    ? 'Catfish detection passed' 
                    : 'Verifying identity...',
                style: TextStyle(
                  color: _mint.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildCornerBrackets() {
    const size = 30.0;
    const thickness = 2.0;
    
    return [
      // Top left
      Positioned(
        top: 10,
        left: 10,
        child: _CornerBracket(size: size, thickness: thickness, color: _mint),
      ),
      // Top right
      Positioned(
        top: 10,
        right: 10,
        child: Transform.scale(
          scaleX: -1,
          child: _CornerBracket(size: size, thickness: thickness, color: _mint),
        ),
      ),
      // Bottom left
      Positioned(
        bottom: 10,
        left: 10,
        child: Transform.scale(
          scaleY: -1,
          child: _CornerBracket(size: size, thickness: thickness, color: _mint),
        ),
      ),
      // Bottom right
      Positioned(
        bottom: 10,
        right: 10,
        child: Transform.scale(
          scaleX: -1,
          scaleY: -1,
          child: _CornerBracket(size: size, thickness: thickness, color: _mint),
        ),
      ),
    ];
  }

  // ============ STEP 2: NVS MEANINGS (GLITCHY, BLURRY, STATIC) ============
  Widget _buildMeaningsStep() {
    final meanings = [
      'NEURAL VIBE SYNC',
      'NIGHT VISION SYSTEM',
      'NATURAL VALIDATION SCORE',
      'NETWORK OF VERIFIED SEEKERS',
      'NEVER VANILLA SOULS',
    ];

    return Stack(
      key: const ValueKey('meanings'),
      children: [
        // Static/noise background
        AnimatedBuilder(
          animation: _staticController,
          builder: (context, child) {
            return CustomPaint(
              size: MediaQuery.of(context).size,
              painter: _StaticNoisePainter(
                seed: (_staticController.value * 1000).toInt(),
                color: _mint,
              ),
            );
          },
        ),
        // Blurred content layer
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Container(
            color: _black.withOpacity(0.7),
          ),
        ),
        // Content
        SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 60),
              // NVS with static effect
              AnimatedBuilder(
                animation: _staticController,
                builder: (context, child) {
                  final jitter = (Random().nextDouble() - 0.5) * 4;
                  return Transform.translate(
                    offset: Offset(jitter, 0),
                    child: Text(
                      'NVS',
                      style: TextStyle(
                        fontFamily: 'BellGothic',
                        fontSize: 60,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 15,
                        color: _mint,
                        shadows: [
                          Shadow(
                            color: _mint.withOpacity(0.5),
                            blurRadius: 15,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Text(
                'CAN MEAN',
                style: TextStyle(
                  color: _mint.withOpacity(0.4),
                  fontSize: 12,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 40),
              // Meanings list with glitch/static effects
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  itemCount: meanings.length,
                  itemBuilder: (context, index) {
                    return _buildMeaningItem(meanings[index], index);
                  },
                ),
              ),
              // Tap to continue
              Padding(
                padding: const EdgeInsets.all(40),
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: 0.3 + 0.4 * _pulseController.value,
                      child: Text(
                        'TAP TO ENTER',
                        style: TextStyle(
                          color: _mint,
                          fontSize: 14,
                          letterSpacing: 3,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // VHS tracking lines
        ..._buildVHSTrackingLines(),
      ],
    );
  }

  Widget _buildMeaningItem(String meaning, int index) {
    return AnimatedBuilder(
      animation: _staticController,
      builder: (context, child) {
        final shouldGlitch = Random().nextDouble() > 0.85;
        final glitchOffset = shouldGlitch ? (Random().nextDouble() - 0.5) * 10 : 0.0;
        
        return Transform.translate(
          offset: Offset(glitchOffset, 0),
          child: Container(
            margin: const EdgeInsets.only(bottom: 24),
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: shouldGlitch ? 2 : 0,
                sigmaY: shouldGlitch ? 1 : 0,
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      border: Border.all(color: _mint.withOpacity(0.5)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      meaning,
                      style: TextStyle(
                        color: _mint.withOpacity(shouldGlitch ? 0.6 : 0.9),
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildVHSTrackingLines() {
    return List.generate(3, (index) {
      return AnimatedBuilder(
        animation: _staticController,
        builder: (context, child) {
          final screenHeight = MediaQuery.of(context).size.height;
          final y = ((_staticController.value * 500 + index * 200) % screenHeight);
          final visible = Random().nextDouble() > 0.7;
          
          if (!visible) return const SizedBox.shrink();
          
          return Positioned(
            top: y,
            left: 0,
            right: 0,
            child: Container(
              height: 2 + Random().nextDouble() * 4,
              color: _mint.withOpacity(0.1 + Random().nextDouble() * 0.1),
            ),
          );
        },
      );
    });
  }

  void _completeOnboarding() async {
    HapticFeedback.heavyImpact();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasOnboarded', true);
    widget.onComplete();
  }
}

// ============ CORNER BRACKET WIDGET ============
class _CornerBracket extends StatelessWidget {
  final double size;
  final double thickness;
  final Color color;

  const _CornerBracket({
    required this.size,
    required this.thickness,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CornerBracketPainter(thickness: thickness, color: color),
      ),
    );
  }
}

class _CornerBracketPainter extends CustomPainter {
  final double thickness;
  final Color color;

  _CornerBracketPainter({required this.thickness, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============ STATIC NOISE PAINTER ============
class _StaticNoisePainter extends CustomPainter {
  final int seed;
  final Color color;

  _StaticNoisePainter({required this.seed, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(seed);
    final paint = Paint();

    for (int i = 0; i < 500; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final opacity = random.nextDouble() * 0.15;
      
      paint.color = color.withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), 1, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _StaticNoisePainter oldDelegate) =>
      seed != oldDelegate.seed;
}

