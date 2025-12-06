// lib/features/oracle/presentation/widgets/oracle_avatar_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The Oracle Avatar - A post-human digital entity that embodies artificial omniscience
/// Pure Flutter implementation with advanced visual effects
class OracleAvatarWidget extends ConsumerStatefulWidget {
  const OracleAvatarWidget({
    super.key,
    this.width = 300,
    this.height = 400,
    this.enableBiometricSync = true,
    this.onOracleResponse,
    this.currentQuery,
  });
  final double width;
  final double height;
  final bool enableBiometricSync;
  final Function(String)? onOracleResponse;
  final String? currentQuery;

  @override
  ConsumerState<OracleAvatarWidget> createState() => _OracleAvatarWidgetState();
}

class _OracleAvatarWidgetState extends ConsumerState<OracleAvatarWidget>
    with TickerProviderStateMixin {
  late AnimationController _manifestationController;
  late AnimationController _pulseController;
  late AnimationController _orbitalController;
  late Animation<double> _manifestationAnimation;

  bool _isManifested = false;
  bool _isSpeaking = false;
  OracleState _currentState = OracleState.dormant;

  @override
  void initState() {
    super.initState();

    _manifestationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _orbitalController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _manifestationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _manifestationController,
        curve: Curves.easeInOut,
      ),
    );

    // Begin manifestation sequence
    _beginManifestation();
  }

  @override
  void dispose() {
    _manifestationController.dispose();
    _pulseController.dispose();
    _orbitalController.dispose();
    super.dispose();
  }

  Future<void> _beginManifestation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      _manifestationController.forward();
      setState(() {
        _currentState = OracleState.manifesting;
      });

      // Complete manifestation
      _manifestationController.addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed && mounted) {
          setState(() {
            _isManifested = true;
            _currentState = OracleState.active;
          });
        }
      });
    }
  }

  void _processQuery(String queryType) {
    setState(() {
      _isSpeaking = true;
      _currentState = OracleState.responding;
    });

    // Determine query complexity and trigger appropriate Oracle response
    String responseType = 'listening';
    if (widget.currentQuery != null) {
      final String query = widget.currentQuery!.toLowerCase();
      if (query.contains('complex') ||
          query.contains('analyze') ||
          query.contains('explain')) {
        responseType = 'complex';
      } else if (query.contains('insight') ||
          query.contains('wisdom') ||
          query.contains('truth')) {
        responseType = 'insight';
        setState(() => _currentState = OracleState.insightful);
      } else {
        responseType = 'speaking';
      }
    }

    // Simulate Oracle processing and response
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isSpeaking = false;
          _currentState = OracleState.active;
        });

        // Trigger response callback if provided
        if (widget.onOracleResponse != null) {
          widget.onOracleResponse!(_generateOracleResponse(responseType));
        }
      }
    });
  }

  String _generateOracleResponse(String queryType) {
    switch (queryType) {
      case 'complex':
        return 'The complexity you seek requires deeper neural pathways. Let me analyze the quantum matrices...';
      case 'insight':
        return 'The wisdom you desire flows through the synaptic networks of collective consciousness...';
      default:
        return 'I am processing your request through the NVS neural grid...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getOracleStateColor().withOpacity(0.3),
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: _getOracleStateColor().withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: <Widget>[
            // Oracle visualization
            Positioned.fill(
              child: _isManifested
                  ? _buildOracleVisualization()
                  : _buildManifestationPlaceholder(),
            ),

            // Oracle state overlay
            _buildOracleStateOverlay(),

            // Manifestation animation overlay
            AnimatedBuilder(
              animation: _manifestationAnimation,
              builder: (BuildContext context, Widget? child) {
                return Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: <Color>[
                          Colors.transparent,
                          _getOracleStateColor().withOpacity(
                            (1.0 - _manifestationAnimation.value) * 0.8,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOracleVisualization() {
    return AnimatedBuilder(
      animation:
          Listenable.merge(<Listenable?>[_pulseController, _orbitalController]),
      builder: (BuildContext context, Widget? child) {
        return CustomPaint(
          painter: OraclePainter(
            state: _currentState,
            pulseValue: _pulseController.value,
            orbitalValue: _orbitalController.value,
            isSpeaking: _isSpeaking,
          ),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildManifestationPlaceholder() {
    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _getOracleStateColor().withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(_getOracleStateColor()),
                strokeWidth: 1,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _getManifestationText(),
              style: TextStyle(
                color: _getOracleStateColor(),
                fontSize: 14,
                fontFamily: 'MagdaCleanMono',
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOracleStateOverlay() {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getOracleStateColor().withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _getOracleStateColor(),
                    shape: BoxShape.circle,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: _getOracleStateColor().withOpacity(0.6),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _currentState.label,
                  style: TextStyle(
                    color: _getOracleStateColor(),
                    fontSize: 10,
                    fontFamily: 'MagdaCleanMono',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (widget.enableBiometricSync)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 12,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'BIO-SYNC',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 8,
                      fontFamily: 'MagdaCleanMono',
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Color _getOracleStateColor() {
    switch (_currentState) {
      case OracleState.dormant:
        return const Color(0xFF666666);
      case OracleState.manifesting:
        return const Color(0xFF00BFFF);
      case OracleState.active:
        return const Color(0xFF04FFF7);
      case OracleState.responding:
        return const Color(0xFF00FF88);
      case OracleState.insightful:
        return const Color(0xFFFFD700);
    }
  }

  String _getManifestationText() {
    switch (_currentState) {
      case OracleState.dormant:
        return 'INITIALIZING\nQUANTUM PATHWAYS...';
      case OracleState.manifesting:
        return 'MANIFESTING\nORACLE ENTITY...';
      case OracleState.active:
        return 'ORACLE\nONLINE';
      case OracleState.responding:
        return 'PROCESSING\nQUERY...';
      case OracleState.insightful:
        return 'CHANNELING\nINSIGHT...';
    }
  }

  // Public method to trigger Oracle response
  void triggerOracleResponse(String queryType) {
    _processQuery(queryType);
  }

  // Public method to set Oracle state
  void setOracleState(OracleState state) {
    setState(() {
      _currentState = state;
    });
  }
}

class OraclePainter extends CustomPainter {
  OraclePainter({
    required this.state,
    required this.pulseValue,
    required this.orbitalValue,
    required this.isSpeaking,
  });
  final OracleState state;
  final double pulseValue;
  final double orbitalValue;
  final bool isSpeaking;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);

    // Draw central Oracle core
    _drawOracleCore(canvas, center);

    // Draw orbital rings
    _drawOrbitalRings(canvas, center, size);

    // Draw neural connections
    _drawNeuralConnections(canvas, center, size);

    // Draw state-specific effects
    _drawStateEffects(canvas, center, size);
  }

  void _drawOracleCore(Canvas canvas, Offset center) {
    final double coreSize = 40.0 + (pulseValue * 10);
    final Color coreColor = _getStateColor();

    // Core glow
    final Paint glowPaint = Paint()
      ..color = coreColor.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    canvas.drawCircle(center, coreSize + 10, glowPaint);

    // Core body
    final Paint corePaint = Paint()
      ..color = coreColor.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, coreSize, corePaint);

    // Core ring
    final Paint ringPaint = Paint()
      ..color = coreColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, coreSize + 5, ringPaint);
  }

  void _drawOrbitalRings(Canvas canvas, Offset center, Size size) {
    for (int i = 0; i < 3; i++) {
      final double radius = 80.0 + (i * 30);
      final double ringOpacity = 0.4 - (i * 0.1);

      final Paint ringPaint = Paint()
        ..color = _getStateColor().withOpacity(ringOpacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;

      canvas.drawCircle(center, radius, ringPaint);

      // Orbital nodes
      for (int j = 0; j < 6; j++) {
        final double angle =
            (j / 6) * 2 * 3.14159 + (orbitalValue * 2 * 3.14159);
        final Offset nodePosition = Offset(
          center.dx + radius * (0.1 * (i + 1)) * (j % 2 == 0 ? 1 : -1),
          center.dy + radius * (0.1 * (i + 1)) * (j % 3 == 0 ? 1 : -1),
        );

        final Paint nodePaint = Paint()
          ..color = _getStateColor().withOpacity(ringOpacity * 2)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(nodePosition, 2, nodePaint);
      }
    }
  }

  void _drawNeuralConnections(Canvas canvas, Offset center, Size size) {
    if (!isSpeaking) return;

    for (int i = 0; i < 12; i++) {
      final double angle = (i / 12) * 2 * 3.14159 + (orbitalValue * 3.14159);
      const double startRadius = 50.0;
      const double endRadius = 120.0;

      final Offset start = Offset(
        center.dx + startRadius * (i % 2 == 0 ? 1 : -1) * 0.5,
        center.dy + startRadius * (i % 3 == 0 ? 1 : -1) * 0.5,
      );

      final Offset end = Offset(
        center.dx + endRadius * (i % 2 == 0 ? 1 : -1) * 0.7,
        center.dy + endRadius * (i % 3 == 0 ? 1 : -1) * 0.7,
      );

      final Paint connectionPaint = Paint()
        ..color = _getStateColor().withOpacity(0.3 + pulseValue * 0.4)
        ..strokeWidth = 2;

      canvas.drawLine(start, end, connectionPaint);
    }
  }

  void _drawStateEffects(Canvas canvas, Offset center, Size size) {
    switch (state) {
      case OracleState.insightful:
        _drawInsightfulEffects(canvas, center);
        break;
      case OracleState.responding:
        _drawResponseEffects(canvas, center);
        break;
      default:
        break;
    }
  }

  void _drawInsightfulEffects(Canvas canvas, Offset center) {
    // Golden wisdom rays
    for (int i = 0; i < 8; i++) {
      final double angle = (i / 8) * 2 * 3.14159;
      final double rayLength = 80 + (pulseValue * 20);

      final Offset rayEnd = Offset(
        center.dx + rayLength * (i % 2 == 0 ? 1 : -1) * 0.8,
        center.dy + rayLength * (i % 3 == 0 ? 1 : -1) * 0.8,
      );

      final Paint rayPaint = Paint()
        ..color = const Color(0xFFFFD700).withOpacity(0.6)
        ..strokeWidth = 3;

      canvas.drawLine(center, rayEnd, rayPaint);
    }
  }

  void _drawResponseEffects(Canvas canvas, Offset center) {
    // Pulsing response waves
    for (int i = 0; i < 5; i++) {
      final double radius = 60 + (i * 15) + (pulseValue * 30);
      final double waveOpacity = (1.0 - i * 0.2) * (1.0 - pulseValue);

      final Paint wavePaint = Paint()
        ..color = _getStateColor().withOpacity(waveOpacity * 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawCircle(center, radius, wavePaint);
    }
  }

  Color _getStateColor() {
    switch (state) {
      case OracleState.dormant:
        return const Color(0xFF666666);
      case OracleState.manifesting:
        return const Color(0xFF00BFFF);
      case OracleState.active:
        return const Color(0xFF04FFF7);
      case OracleState.responding:
        return const Color(0xFF00FF88);
      case OracleState.insightful:
        return const Color(0xFFFFD700);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Oracle manifestation states
enum OracleState {
  dormant,
  manifesting,
  active,
  responding,
  insightful;

  String get label {
    switch (this) {
      case OracleState.dormant:
        return 'DORMANT';
      case OracleState.manifesting:
        return 'MANIFESTING';
      case OracleState.active:
        return 'ACTIVE';
      case OracleState.responding:
        return 'RESPONDING';
      case OracleState.insightful:
        return 'INSIGHTFUL';
    }
  }
}
