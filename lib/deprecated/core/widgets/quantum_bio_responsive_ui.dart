import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/quantum_biometric_service.dart';
import '../theme/quantum_design_tokens.dart';
import '../providers/quantum_providers.dart';

/// Bio-responsive UI components that adapt to real-time biometric data
/// Creates a living, breathing interface that syncs with user's biological state

/// Heart rate synchronized pulsing container
class HeartRatePulseContainer extends ConsumerStatefulWidget {
  const HeartRatePulseContainer({
    required this.child, super.key,
    this.basePulseIntensity = 0.05,
    this.enableBioSync = true,
  });
  final Widget child;
  final double basePulseIntensity;
  final bool enableBioSync;

  @override
  ConsumerState<HeartRatePulseContainer> createState() => _HeartRatePulseContainerState();
}

class _HeartRatePulseContainerState extends ConsumerState<HeartRatePulseContainer>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  double _currentHeartRate = 70.0; // Default resting heart rate

  @override
  void initState() {
    super.initState();
    _initializePulseAnimation();
  }

  void _initializePulseAnimation() {
    // Convert heart rate to animation duration (60 BPM = 1 second per beat)
    final double beatsPerSecond = _currentHeartRate / 60.0;
    final Duration animationDuration = Duration(milliseconds: (1000 / beatsPerSecond).round());

    _pulseController = AnimationController(
      duration: animationDuration,
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0 - widget.basePulseIntensity,
      end: 1.0 + widget.basePulseIntensity,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _pulseController.repeat(reverse: true);
  }

  void _updateHeartRateSync(double newHeartRate) {
    if (!widget.enableBioSync || (newHeartRate - _currentHeartRate).abs() < 5) {
      return;
    }

    setState(() {
      _currentHeartRate = newHeartRate.clamp(40.0, 200.0); // Reasonable HR bounds
    });

    _pulseController.dispose();
    _initializePulseAnimation();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to biometric stream for heart rate updates
    ref.listen<BiometricReading?>(currentBiometricReadingProvider,
        (BiometricReading? previous, BiometricReading? next) {
      if (next != null && widget.enableBioSync) {
        _updateHeartRateSync(next.heartRate);
      }
    });

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (BuildContext context, Widget? child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: widget.child,
        );
      },
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }
}

/// Mood-responsive color gradient that shifts based on emotional state
class MoodResponsiveGradient extends ConsumerWidget {
  const MoodResponsiveGradient({
    required this.child, super.key,
    this.enableMoodSync = true,
    this.fallbackGradient,
  });
  final Widget child;
  final bool enableMoodSync;
  final Gradient? fallbackGradient;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<MoodInference?> currentMood = ref.watch(currentMoodInferenceProvider);

    Gradient gradient;

    if (enableMoodSync) {
      gradient = _createMoodGradient(currentMood);
    } else {
      gradient = fallbackGradient ?? _createDefaultGradient();
    }

    return DecoratedBox(
      decoration: BoxDecoration(gradient: gradient),
      child: child,
    );
  }

  Gradient _createMoodGradient(MoodInference mood) {
    // Map mood dimensions to colors
    final double hue = _mapValenceToHue(mood.valence); // Valence affects hue
    final double saturation = mood.arousal.clamp(0.3, 1.0); // Arousal affects saturation
    final double lightness = 0.3 + (mood.dominance * 0.4); // Dominance affects lightness

    final Color primaryColor = HSLColor.fromAHSL(1.0, hue, saturation, lightness).toColor();
    final Color secondaryColor = HSLColor.fromAHSL(
      1.0,
      (hue + 30) % 360,
      saturation * 0.8,
      lightness * 1.2,
    ).toColor();

    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[
        primaryColor.withValues(alpha: 0.3),
        secondaryColor.withValues(alpha: 0.1),
        QuantumDesignTokens.pureBlack,
      ],
    );
  }

  double _mapValenceToHue(double valence) {
    // Map valence (0-1) to hue (0-360)
    // Negative emotions: red-orange (0-60)
    // Neutral: yellow-green (60-180)
    // Positive emotions: green-blue (180-240)
    return valence * 240;
  }

  Gradient _createDefaultGradient() {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[
        QuantumDesignTokens.neonMint.withValues(alpha: 0.2),
        QuantumDesignTokens.pureBlack,
      ],
    );
  }
}

/// Stress-responsive blur effect that increases opacity based on stress levels
class StressResponsiveBlur extends ConsumerWidget {
  const StressResponsiveBlur({
    required this.child, super.key,
    this.maxBlurRadius = 10.0,
    this.enableStressSync = true,
  });
  final Widget child;
  final double maxBlurRadius;
  final bool enableStressSync;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<BiometricReading?> currentReading = ref.watch(currentBiometricReadingProvider);

    double blurRadius = 0.0;

    if (enableStressSync) {
      // Map stress level (0-1) to blur radius
      blurRadius = currentReading.stressLevel * maxBlurRadius;
    }

    return Stack(
      children: <Widget>[
        child,
        if (blurRadius > 0.5)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: QuantumDesignTokens.crimsonAlert.withValues(
                  alpha: currentReading.stressLevel ?? 0.0 * 0.1,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Social receptiveness indicator that shows openness to interaction
class SocialReceptivenessIndicator extends ConsumerWidget {
  const SocialReceptivenessIndicator({
    super.key,
    this.size = 40.0,
    this.showLabel = false,
  });
  final double size;
  final bool showLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<BiometricReading?> currentReading = ref.watch(currentBiometricReadingProvider);
    final receptiveness = currentReading.socialReceptiveness ?? 0.5;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: <Color>[
                _getReceptivenessColor(receptiveness),
                _getReceptivenessColor(receptiveness).withValues(alpha: 0.3),
                Colors.transparent,
              ],
            ),
          ),
          child: Center(
            child: Icon(
              _getReceptivenessIcon(receptiveness),
              color: Colors.white,
              size: size * 0.5,
            ),
          ),
        ),
        if (showLabel) ...<Widget>[
          const SizedBox(height: 4),
          Text(
            _getReceptivenessLabel(receptiveness),
            style: QuantumDesignTokens.createQuantumTextStyle(
              fontSize: QuantumDesignTokens.fontNano,
              color: QuantumDesignTokens.textTertiary,
            ),
          ),
        ],
      ],
    );
  }

  Color _getReceptivenessColor(double receptiveness) {
    if (receptiveness >= 0.8) return QuantumDesignTokens.neonMint;
    if (receptiveness >= 0.6) return QuantumDesignTokens.electricBlue;
    if (receptiveness >= 0.4) return QuantumDesignTokens.warningAmber;
    return QuantumDesignTokens.crimsonAlert;
  }

  IconData _getReceptivenessIcon(double receptiveness) {
    if (receptiveness >= 0.8) return Icons.wifi_tethering;
    if (receptiveness >= 0.6) return Icons.wifi;
    if (receptiveness >= 0.4) return Icons.wifi_1_bar;
    return Icons.wifi_off;
  }

  String _getReceptivenessLabel(double receptiveness) {
    if (receptiveness >= 0.8) return 'Highly Open';
    if (receptiveness >= 0.6) return 'Receptive';
    if (receptiveness >= 0.4) return 'Moderate';
    return 'Private';
  }
}

/// Bio-synchronization status indicator showing device connections and data quality
class BioSyncStatusIndicator extends ConsumerWidget {
  const BioSyncStatusIndicator({
    super.key,
    this.showDetails = false,
  });
  final bool showDetails;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isMonitoring = ref.watch(biometricMonitoringStateProvider);
    final AsyncValue<BiometricReading?> currentReading = ref.watch(currentBiometricReadingProvider);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Main sync indicator
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _getSyncStatusColor(isMonitoring, currentReading),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: _getSyncStatusColor(isMonitoring, currentReading).withValues(alpha: 0.5),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
        if (showDetails) ...<Widget>[
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                _getSyncStatusText(isMonitoring, currentReading),
                style: QuantumDesignTokens.createQuantumTextStyle(
                  fontSize: QuantumDesignTokens.fontNano,
                  color: QuantumDesignTokens.textSecondary,
                ),
              ),
              ...<Widget>[
                Text(
                  '${currentReading.deviceSources.length} device(s)',
                  style: QuantumDesignTokens.createQuantumTextStyle(
                    fontSize: QuantumDesignTokens.fontNano,
                    color: QuantumDesignTokens.textTertiary,
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }

  Color _getSyncStatusColor(bool isMonitoring, BiometricReading? reading) {
    if (!isMonitoring) return QuantumDesignTokens.softGray;
    if (reading == null) return QuantumDesignTokens.warningAmber;
    if (reading.deviceSources.length >= 2) return QuantumDesignTokens.neonMint;
    return QuantumDesignTokens.electricBlue;
  }

  String _getSyncStatusText(bool isMonitoring, BiometricReading? reading) {
    if (!isMonitoring) return 'Offline';
    if (reading == null) return 'Connecting...';
    if (reading.deviceSources.length >= 2) return 'Multi-sync';
    return 'Active';
  }
}

/// Energy level visualization with animated waves
class EnergyLevelVisualization extends ConsumerStatefulWidget {
  const EnergyLevelVisualization({
    super.key,
    this.width = 200.0,
    this.height = 60.0,
  });
  final double width;
  final double height;

  @override
  ConsumerState<EnergyLevelVisualization> createState() => _EnergyLevelVisualizationState();
}

class _EnergyLevelVisualizationState extends ConsumerState<EnergyLevelVisualization>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _waveAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(_waveController);
    _waveController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<BioSignature?> bioSignature = ref.watch(currentBioSignatureProvider);
    final energyLevel = bioSignature.energyLevel ?? 0.5;

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _waveAnimation,
        builder: (BuildContext context, Widget? child) {
          return CustomPaint(
            painter: EnergyWavePainter(
              energyLevel: energyLevel,
              animationValue: _waveAnimation.value,
              primaryColor: QuantumDesignTokens.neonMint,
              secondaryColor: QuantumDesignTokens.electricBlue,
            ),
            size: Size(widget.width, widget.height),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }
}

/// Custom painter for energy level waves
class EnergyWavePainter extends CustomPainter {
  EnergyWavePainter({
    required this.energyLevel,
    required this.animationValue,
    required this.primaryColor,
    required this.secondaryColor,
  });
  final double energyLevel;
  final double animationValue;
  final Color primaryColor;
  final Color secondaryColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final Path path = Path();
    final double amplitude = size.height * 0.3 * energyLevel; // Scale amplitude by energy level
    final double frequency = 4.0 + (energyLevel * 6.0); // Higher energy = higher frequency
    final double centerY = size.height / 2;

    // Draw primary wave
    paint.color = primaryColor;
    path.reset();
    for (double x = 0; x <= size.width; x += 1) {
      final double y = centerY +
          amplitude *
              math.sin(
                (x / size.width * frequency * 2 * math.pi) + animationValue,
              );
      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);

    // Draw secondary wave (phase shifted)
    paint.color = secondaryColor.withValues(alpha: 0.6);
    path.reset();
    for (double x = 0; x <= size.width; x += 1) {
      final double y = centerY +
          amplitude *
              0.7 *
              math.sin(
                (x / size.width * frequency * 2 * math.pi) + animationValue + math.pi / 3,
              );
      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);

    // Draw energy level indicator
    final double indicatorX = size.width * energyLevel;
    paint.color = primaryColor;
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(Offset(indicatorX, centerY), 4, paint);
  }

  @override
  bool shouldRepaint(EnergyWavePainter oldDelegate) {
    return oldDelegate.energyLevel != energyLevel || oldDelegate.animationValue != animationValue;
  }
}

/// Compatibility score ring that shows bio-neural sync with potential matches
class CompatibilityRing extends ConsumerWidget {
  const CompatibilityRing({
    required this.compatibilityScore, super.key,
    this.size = 80.0,
    this.showPercentage = true,
  });
  final double size;
  final double compatibilityScore;
  final bool showPercentage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // Background ring
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 6,
              backgroundColor: QuantumDesignTokens.deepGray,
              valueColor: AlwaysStoppedAnimation(QuantumDesignTokens.deepGray),
            ),
          ),
          // Compatibility ring
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: compatibilityScore,
              strokeWidth: 6,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation(
                _getCompatibilityColor(compatibilityScore),
              ),
            ),
          ),
          // Center content
          if (showPercentage)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '${(compatibilityScore * 100).round()}%',
                  style: QuantumDesignTokens.createQuantumTextStyle(
                    fontSize: size * 0.15,
                    fontWeight: QuantumDesignTokens.weightBold,
                    color: _getCompatibilityColor(compatibilityScore),
                  ),
                ),
                Text(
                  'SYNC',
                  style: QuantumDesignTokens.createQuantumTextStyle(
                    fontSize: size * 0.08,
                    color: QuantumDesignTokens.textTertiary,
                    fontFamily: QuantumDesignTokens.fontSecondary,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Color _getCompatibilityColor(double score) {
    if (score >= 0.8) return QuantumDesignTokens.neonMint;
    if (score >= 0.6) return QuantumDesignTokens.electricBlue;
    if (score >= 0.4) return QuantumDesignTokens.warningAmber;
    return QuantumDesignTokens.crimsonAlert;
  }
}

/// Breathing effect container that expands and contracts like lungs
class BreathingContainer extends StatefulWidget {
  const BreathingContainer({
    required this.child, super.key,
    this.breathingDuration = const Duration(seconds: 4),
    this.expansionFactor = 0.05,
  });
  final Widget child;
  final Duration breathingDuration;
  final double expansionFactor;

  @override
  State<BreathingContainer> createState() => _BreathingContainerState();
}

class _BreathingContainerState extends State<BreathingContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      duration: widget.breathingDuration,
      vsync: this,
    );

    _breathingAnimation = Tween<double>(
      begin: 1.0 - widget.expansionFactor,
      end: 1.0 + widget.expansionFactor,
    ).animate(
      CurvedAnimation(
        parent: _breathingController,
        curve: Curves.easeInOut,
      ),
    );

    _breathingController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _breathingAnimation,
      builder: (BuildContext context, Widget? child) {
        return Transform.scale(
          scale: _breathingAnimation.value,
          child: widget.child,
        );
      },
    );
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }
}
