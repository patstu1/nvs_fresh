import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

class GenesisSplashScreen extends StatefulWidget {
  const GenesisSplashScreen({required this.onFinished, super.key});
  final VoidCallback onFinished;

  @override
  State<GenesisSplashScreen> createState() => _GenesisSplashScreenState();
}

class _GenesisSplashScreenState extends State<GenesisSplashScreen> with TickerProviderStateMixin {
  late final AnimationController _scanController;
  late final AnimationController _glitchController;
  Timer? _glitchTimer;
  String _typedText = '';
  Timer? _typingTimer;
  final String _fullText = '//: CONNECTION PROTOCOL INITIATED...';
  bool _showCursor = true;
  Timer? _cursorTimer;
  bool _glitchTriggered = false;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _glitchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _startTyping();
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (mounted) {
        setState(() => _showCursor = !_showCursor);
      }
    });
  }

  void _startTyping() {
    _typingTimer = Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {
      if (mounted) {
        if (_typedText.length < _fullText.length) {
          setState(() {
            _typedText = _fullText.substring(0, _typedText.length + 1);
          });
        } else {
          timer.cancel();
        }
      } else {
        timer.cancel();
      }
    });
  }

  void _triggerGlitch() {
    if (!mounted) return;
    _glitchController.forward(from: 0);
    _glitchTimer?.cancel();
    _glitchTimer = Timer(const Duration(milliseconds: 200), () {
      if (mounted) {
        _glitchController.reset();
      }
    });
  }

  @override
  void dispose() {
    _scanController.dispose();
    _glitchController.dispose();
    _glitchTimer?.cancel();
    _typingTimer?.cancel();
    _cursorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: widget.onFinished,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            // The Scanner Line
            AnimatedBuilder(
              animation: _scanController,
              builder: (BuildContext context, Widget? child) {
                final double scannerY = lerpDouble(
                  -MediaQuery.of(context).size.height / 2,
                  MediaQuery.of(context).size.height / 2,
                  _scanController.value,
                )!;

                // Check for intersection with logo area
                if ((scannerY > -50 && scannerY < 50) && !_glitchTriggered) {
                  _glitchTriggered = true;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _triggerGlitch();
                  });
                } else if (scannerY < -50 || scannerY > 50) {
                  _glitchTriggered = false;
                }

                return Transform.translate(
                  offset: Offset(0, scannerY),
                  child: Container(
                    width: double.infinity,
                    height: 2.0,
                    decoration: const BoxDecoration(
                      color: NVSColors.ultraLightMint,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: NVSColors.ultraLightMint,
                          blurRadius: 20.0,
                          spreadRadius: 2.0,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // The NVS Logo & Text - FORCED TO CENTER
            Center(
              child: AnimatedBuilder(
                animation: _glitchController,
                builder: (BuildContext context, Widget? child) {
                  final bool isGlitching = _glitchController.isAnimating;
                  final bool isVisible = isGlitching || _glitchController.isCompleted;

                  if (!isVisible) return const SizedBox.shrink();

                  return Transform.translate(
                    offset: isGlitching
                        ? Offset(
                            Random().nextDouble() * 10 - 5,
                            Random().nextDouble() * 10 - 5,
                          )
                        : Offset.zero,
                    child: Opacity(
                      opacity: isGlitching ? (0.5 + Random().nextDouble() * 0.5) : 1.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'NVS',
                            style: TextStyle(
                              fontFamily: 'Orbitron',
                              fontSize: 80,
                              fontWeight: FontWeight.w700,
                              color: NVSColors.ultraLightMint,
                              letterSpacing: 10,
                              shadows: <Shadow>[
                                Shadow(
                                  blurRadius: 15,
                                  color: NVSColors.ultraLightMint.withValues(
                                    alpha: 0.8,
                                  ),
                                ),
                                Shadow(
                                  blurRadius: 30,
                                  color: NVSColors.turquoiseNeon.withValues(
                                    alpha: 0.6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                _typedText,
                                style: TextStyle(
                                  fontFamily: 'MagdaClean',
                                  fontSize: 16,
                                  color: NVSColors.ultraLightMint.withValues(
                                    alpha: 0.8,
                                  ),
                                  letterSpacing: 2,
                                ),
                              ),
                              if (_showCursor && _typedText.length < _fullText.length)
                                Container(
                                  width: 10,
                                  height: 20,
                                  color: NVSColors.ultraLightMint.withValues(
                                    alpha: 0.8,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
