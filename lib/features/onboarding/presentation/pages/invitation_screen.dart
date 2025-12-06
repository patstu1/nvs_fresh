import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nvs/meatup_core.dart';

class GenesisInvitationScreen extends StatefulWidget {
  const GenesisInvitationScreen({required this.onFinished, super.key});
  final VoidCallback onFinished;

  @override
  State<GenesisInvitationScreen> createState() => _GenesisInvitationScreenState();
}

class _GenesisInvitationScreenState extends State<GenesisInvitationScreen>
    with TickerProviderStateMixin {
  int _pageIndex = 0;
  String _typedText = '';
  String _targetText = 'no vanilla shit';
  bool _isDeleting = false;
  Timer? _typingTimer;
  bool _showJockstrap = false;

  late final AnimationController _flashController;
  late final AnimationController _jockstrapController;
  late final AnimationController _glitchController;

  @override
  void initState() {
    super.initState();
    _flashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    );
    _jockstrapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
    _glitchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _startAggressiveSequence();
  }

  @override
  void dispose() {
    _flashController.dispose();
    _jockstrapController.dispose();
    _glitchController.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

  Future<void> _startAggressiveSequence() async {
    // 1. VIOLENT Purple Flashes
    for (int i = 0; i < 4; i++) {
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 60));
      _flashController.forward(from: 0);
    }

    // 2. SUBLIMINAL Envy Glimpse
    if (!mounted) return;
    setState(() => _pageIndex = 1);
    await Future.delayed(const Duration(milliseconds: 400));

    // 3. AGGRESSIVE Typing Catharsis
    if (!mounted) return;
    setState(() => _pageIndex = 2);
    _startTyping();
  }

  void _startTyping() {
    _typingTimer = Timer.periodic(const Duration(milliseconds: 50), (Timer timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_isDeleting) {
          if (_typedText.isNotEmpty) {
            _typedText = _typedText.substring(0, _typedText.length - 1);
          } else {
            _isDeleting = false;
            _targetText = 'freedom is the ultimate turn on';
          }
        } else {
          if (_typedText.length < _targetText.length) {
            _typedText = _targetText.substring(0, _typedText.length + 1);
          } else {
            if (_targetText == 'no vanilla shit') {
              setState(() => _showJockstrap = true);
              timer.cancel();
              Future.delayed(const Duration(milliseconds: 800), () {
                if (mounted) setState(() => _isDeleting = true);
                _startTyping();
              });
            } else if (_targetText == 'freedom is the ultimate turn on') {
              timer.cancel();
              _finalGlitchOut();
            }
          }
        }
      });
    });
  }

  Future<void> _finalGlitchOut() async {
    if (!mounted) return;
    _glitchController.repeat(period: const Duration(milliseconds: 100));
    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) widget.onFinished();
  }

  @override
  Widget build(BuildContext context) {
    // Apply violent glitch to the entire screen during the final sequence
    return AnimatedBuilder(
      animation: _glitchController,
      builder: (BuildContext context, Widget? child) {
        if (!_glitchController.isAnimating) return child!;

        // Create a more intense, screen-tearing glitch
        final int randomInt = Random().nextInt(100);
        return Transform.translate(
          offset: Offset(
            Random().nextDouble() * 30 - 15,
            Random().nextDouble() * 30 - 15,
          ),
          child: Transform(
            transform: Matrix4.skewX(Random().nextDouble() * 0.1 - 0.05),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                <Color>[
                  Colors.red.withValues(alpha: 0.3),
                  Colors.green.withValues(alpha: 0.2),
                  Colors.blue.withValues(alpha: 0.4),
                ][randomInt % 3],
                BlendMode.srcATop,
              ),
              child: child,
            ),
          ),
        );
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 100),
          transitionBuilder: (Widget child, Animation<double> animation) =>
              FadeTransition(opacity: animation, child: child),
          child: _buildCurrentPage(),
        ),
      ),
    );
  }

  Widget _buildCurrentPage() {
    switch (_pageIndex) {
      case 0:
        return _buildPurpleFlash();
      case 1:
        return _buildEnvyGlimpse();
      case 2:
        return _buildTypingCatharsis();
      default:
        return Container(key: const ValueKey('empty'));
    }
  }

  Widget _buildPurpleFlash() {
    return AnimatedBuilder(
      animation: _flashController,
      builder: (_, __) => Container(
        key: const ValueKey('flash'),
        color: Colors.purple.withOpacity(
          _flashController.value * (0.5 + Random().nextDouble() * 0.5),
        ),
      ),
    );
  }

  Widget _buildEnvyGlimpse() {
    return DecoratedBox(
      key: const ValueKey('envy'),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/icons/connect.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
        child: Container(
          color: Colors.black.withValues(alpha: 0.6),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'envy us',
                style: TextStyle(
                  fontFamily: 'MagdaClean',
                  fontSize: 16,
                  color: Colors.white.withValues(alpha: 0.5),
                  letterSpacing: 6,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'we are the view',
                style: TextStyle(
                  fontFamily: 'MagdaClean',
                  fontSize: 36,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypingCatharsis() {
    return Container(
      key: const ValueKey('typing'),
      color: Colors.black,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                _typedText,
                style: TextStyle(
                  fontFamily: 'MagdaClean',
                  fontSize: 28,
                  color: NVSColors.ultraLightMint,
                ),
              ),
              if (_typedText.length != _targetText.length)
                Container(
                  width: 14,
                  height: 32,
                  color: NVSColors.ultraLightMint,
                ).animate(onPlay: (AnimationController c) => c.repeat()).fade(duration: 400.ms),
            ],
          ),
          if (_showJockstrap)
            AnimatedBuilder(
              animation: _jockstrapController,
              builder: (_, __) => Transform.scale(
                scale: 0.9 + (_jockstrapController.value * 0.3),
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Image.asset('assets/icons/jockstrap.png', width: 120),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
