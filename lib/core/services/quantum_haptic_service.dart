import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'quantum_biometric_service.dart';

/// Haptic Service - Bio-synced vibration patterns for meaningful connections
/// Creates custom haptic feedback based on biometric compatibility
class HapticService {
  static const MethodChannel _methodChannel = MethodChannel('nvs/haptic');
  static const int _maxPatternLength = 10; // Limit pattern complexity

  // Haptic pattern library for different compatibility levels
  static const Map<String, List<int>> _patternLibrary = <String, List<int>>{
    'perfect_match': <int>[150, 100, 200, 50, 150, 150, 100], // 90%+ compatibility
    'high_match': <int>[120, 150, 120, 100, 120], // 80-89% compatibility
    'moderate_match': <int>[100, 200, 80, 150], // 60-79% compatibility
    'low_match': <int>[80, 300, 50], // 40-59% compatibility
    'basic_feedback': <int>[50, 100], // <40% compatibility
    'heartbeat': <int>[100, 60, 100, 400], // Heart rate sync pattern
    'breathing': <int>[200, 300, 200, 300], // Breathing sync pattern
    'connection_made': <int>[100, 50, 100, 50, 200], // Successful connection
    'notification': <int>[80, 100], // General notification
    'alert': <int>[150, 50, 150], // Alert pattern
  };

  // Bio-responsive pattern modifiers
  static const Map<String, double> _intensityModifiers = <String, double>{
    'excited': 1.3,
    'content': 1.0,
    'neutral': 0.8,
    'anxious': 0.6,
    'melancholy': 0.4,
  };

  /// Initialize haptic feedback system
  static Future<bool> initialize() async {
    try {
      await _methodChannel.invokeMethod('initialize');
      debugPrint('🫨 Quantum Haptic Service initialized');
      return true;
    } on PlatformException catch (e) {
      debugPrint('❌ Haptic initialization failed: ${e.message}');
      return false;
    }
  }

  /// Generate and play haptic feedback based on biometric compatibility
  static Future<void> playCompatibilityFeedback({
    required double compatibilityScore,
    MoodInference? userMood,
    BioSignature? userBioSignature,
    BioSignature? targetBioSignature,
  }) async {
    final List<int> pattern = generateCompatibilityPattern(
      compatibilityScore: compatibilityScore,
      userMood: userMood,
      userBioSignature: userBioSignature,
      targetBioSignature: targetBioSignature,
    );

    await playCustomPattern(pattern);
  }

  /// Generate bio-synced haptic pattern
  static List<int> generateCompatibilityPattern({
    required double compatibilityScore,
    MoodInference? userMood,
    BioSignature? userBioSignature,
    BioSignature? targetBioSignature,
  }) {
    // Select base pattern based on compatibility score
    List<int> basePattern;

    if (compatibilityScore >= 0.9) {
      basePattern = List.from(_patternLibrary['perfect_match']!);
    } else if (compatibilityScore >= 0.8) {
      basePattern = List.from(_patternLibrary['high_match']!);
    } else if (compatibilityScore >= 0.6) {
      basePattern = List.from(_patternLibrary['moderate_match']!);
    } else if (compatibilityScore >= 0.4) {
      basePattern = List.from(_patternLibrary['low_match']!);
    } else {
      basePattern = List.from(_patternLibrary['basic_feedback']!);
    }

    // Apply mood-based intensity modifiers
    if (userMood != null) {
      final double moodModifier = _intensityModifiers[userMood.mood] ?? 1.0;
      basePattern = basePattern.map((int intensity) {
        return (intensity * moodModifier).clamp(10, 255).round();
      }).toList();
    }

    // Apply bio-signature synchronization
    if (userBioSignature != null && targetBioSignature != null) {
      basePattern = _appliBioSignatureSync(
        basePattern,
        userBioSignature,
        targetBioSignature,
      );
    }

    // Apply arousal-based timing adjustments
    if (userMood != null) {
      basePattern = _applyArousalTiming(basePattern, userMood.arousal);
    }

    // Ensure pattern doesn't exceed maximum length
    if (basePattern.length > _maxPatternLength) {
      basePattern = basePattern.take(_maxPatternLength).toList();
    }

    return basePattern;
  }

  /// Apply bio-signature synchronization to haptic pattern
  static List<int> _appliBioSignatureSync(
    List<int> basePattern,
    BioSignature userSignature,
    BioSignature targetSignature,
  ) {
    // Calculate signature similarity for pattern adjustment
    final double energyDifference = (userSignature.energyLevel - targetSignature.energyLevel).abs();
    final double stabilityDifference =
        (userSignature.emotionalStability - targetSignature.emotionalStability).abs();

    // Adjust pattern based on energy level synchronization
    final double energyModifier = 1.0 - (energyDifference * 0.3);

    // Adjust pattern based on emotional stability sync
    final double stabilityModifier = 1.0 - (stabilityDifference * 0.2);

    final double syncModifier = (energyModifier + stabilityModifier) / 2;

    return basePattern.map((int intensity) {
      return (intensity * syncModifier).clamp(10, 255).round();
    }).toList();
  }

  /// Apply arousal-based timing adjustments
  static List<int> _applyArousalTiming(List<int> pattern, double arousalLevel) {
    // Higher arousal = faster/shorter pulses
    // Lower arousal = slower/longer pulses
    final double timingModifier = 0.5 + (arousalLevel * 0.5); // Range: 0.5 - 1.0

    final List<int> adjustedPattern = <int>[];
    for (int i = 0; i < pattern.length; i += 2) {
      // Intensity values remain the same
      adjustedPattern.add(pattern[i]);

      // Duration values are adjusted based on arousal
      if (i + 1 < pattern.length) {
        final int adjustedDuration = (pattern[i + 1] * timingModifier).clamp(20, 1000).round();
        adjustedPattern.add(adjustedDuration);
      }
    }

    return adjustedPattern;
  }

  /// Play heart rate synchronized pulse
  static Future<void> playHeartRateSync(double heartRate) async {
    if (heartRate <= 0) return;

    // Convert heart rate to pulse interval
    final int beatInterval = (60000 / heartRate).round(); // ms per beat
    final int pulseIntensity = _calculateHeartRateIntensity(heartRate);

    final List<int> pattern = <int>[pulseIntensity, 100, 0, beatInterval - 100];
    await playCustomPattern(pattern);
  }

  static int _calculateHeartRateIntensity(double heartRate) {
    // Map heart rate to haptic intensity
    if (heartRate < 60) return 50; // Bradycardia - gentle
    if (heartRate < 100) return 80; // Normal - moderate
    if (heartRate < 150) return 120; // Elevated - strong
    return 180; // Tachycardia - intense
  }

  /// Play breathing synchronized pattern
  static Future<void> playBreathingSync(double respiratoryRate) async {
    if (respiratoryRate <= 0) return;

    // Convert respiratory rate to breathing cycle duration
    final int breathCycleDuration = (60000 / respiratoryRate).round(); // ms per breath
    final int inhaleTime = (breathCycleDuration * 0.4).round();
    final int exhaleTime = (breathCycleDuration * 0.6).round();

    final List<int> pattern = <int>[
      60, inhaleTime, // Inhale - gentle rise
      0, 100, // Brief pause
      40, exhaleTime, // Exhale - gentle fall
      0, 200, // Inter-breath pause
    ];

    await playCustomPattern(pattern);
  }

  /// Play predefined haptic pattern
  static Future<void> playPattern(String patternName) async {
    final List<int>? pattern = _patternLibrary[patternName];
    if (pattern != null) {
      await playCustomPattern(pattern);
    } else {
      debugPrint('⚠️ Unknown haptic pattern: $patternName');
    }
  }

  /// Play custom haptic pattern
  static Future<void> playCustomPattern(List<int> pattern) async {
    if (pattern.isEmpty) return;

    try {
      await _methodChannel.invokeMethod('playPattern', <String, Object>{
        'pattern': pattern,
        'repeat': false,
      });

      debugPrint(
        '🫨 Played haptic pattern: ${pattern.take(6).join(', ')}${pattern.length > 6 ? '...' : ''}',
      );
    } on PlatformException catch (e) {
      debugPrint('❌ Haptic playback failed: ${e.message}');
    }
  }

  /// Play connection success haptic
  static Future<void> playConnectionSuccess() async {
    await playPattern('connection_made');

    // Follow up with a gentle pulse
    Timer(const Duration(milliseconds: 800), () {
      playPattern('pulse_check');
    });
  }

  /// Play notification haptic
  static Future<void> playNotification() async {
    await playPattern('notification');
  }

  /// Play alert haptic
  static Future<void> playAlert() async {
    await playPattern('alert');
  }

  /// Create haptic pattern for match quality
  static Future<void> playMatchQuality(double matchScore) async {
    final List<int> pattern = generateCompatibilityPattern(compatibilityScore: matchScore);
    await playCustomPattern(pattern);
  }

  /// Stop all haptic feedback
  static Future<void> stopHaptics() async {
    try {
      await _methodChannel.invokeMethod('stop');
    } on PlatformException catch (e) {
      debugPrint('❌ Failed to stop haptics: ${e.message}');
    }
  }

  /// Check if haptic feedback is available
  static Future<bool> isHapticAvailable() async {
    try {
      final result = await _methodChannel.invokeMethod('isAvailable');
      return result as bool? ?? false;
    } on PlatformException catch (e) {
      debugPrint('❌ Haptic availability check failed: ${e.message}');
      return false;
    }
  }

  /// Advanced haptic sequences for complex interactions

  /// Play bio-neural synchronization sequence
  static Future<void> playBioNeuralSync({
    required BioSignature userSignature,
    required BioSignature targetSignature,
    required double compatibilityScore,
  }) async {
    // Phase 1: Recognition feedback
    await playPattern('basic_feedback');
    await Future.delayed(const Duration(milliseconds: 300));

    // Phase 2: Compatibility feedback
    final List<int> compatibilityPattern = generateCompatibilityPattern(
      compatibilityScore: compatibilityScore,
      userBioSignature: userSignature,
      targetBioSignature: targetSignature,
    );
    await playCustomPattern(compatibilityPattern);
    await Future.delayed(const Duration(milliseconds: 500));

    // Phase 3: Synchronization confirmation
    if (compatibilityScore >= 0.7) {
      await playPattern('connection_made');
    }
  }

  /// Play social optimality reminder
  static Future<void> playSocialOptimalityReminder(
    double optimalityScore,
  ) async {
    if (optimalityScore >= 0.8) {
      // High optimality - encouraging pattern
      await playCustomPattern(<int>[80, 100, 120, 100, 160, 200]);
    } else if (optimalityScore >= 0.6) {
      // Moderate optimality - gentle reminder
      await playCustomPattern(<int>[60, 150, 60, 150]);
    } else {
      // Low optimality - subtle suggestion to rest
      await playCustomPattern(<int>[40, 300]);
    }
  }

  /// Play quantum entanglement effect (for 90%+ compatibility)
  static Future<void> playQuantumEntanglement() async {
    // Complex pattern that represents quantum entanglement
    const List<int> quantumPattern = <int>[
      50, 50, // Particle 1
      0, 25, // Separation
      50, 50, // Particle 2 (synchronized)
      0, 25, // Brief pause
      100, 25, // Entanglement pulse
      150, 25, // Quantum coherence
      200, 50, // Peak entanglement
      100, 100, // Stabilization
      0, 500, // Quantum decoherence pause
    ];

    await playCustomPattern(quantumPattern);
  }

  /// Play daily biometric summary haptic
  static Future<void> playBiometricSummary({
    required double averageStress,
    required double averageEnergy,
    required int meaningfulConnections,
  }) async {
    // Create summary pattern based on daily metrics
    final int stressComponent = (50 + (averageStress * 50)).round(); // 50-100 intensity
    final int energyComponent = (100 + (averageEnergy * 100)).round(); // 100-200 intensity
    final int connectionBonus = meaningfulConnections * 20; // Bonus for connections

    final List<int> summaryPattern = <int>[
      stressComponent,
      200,
      energyComponent,
      300,
      connectionBonus.clamp(0, 255),
      100,
    ];

    await playCustomPattern(summaryPattern);
  }
}

/// Haptic pattern builder for complex custom patterns
class HapticPatternBuilder {
  final List<int> _pattern = <int>[];

  /// Add a pulse with intensity and duration
  HapticPatternBuilder pulse(int intensity, int duration) {
    _pattern.addAll(<int>[intensity.clamp(0, 255), duration.clamp(10, 2000)]);
    return this;
  }

  /// Add a pause
  HapticPatternBuilder pause(int duration) {
    _pattern.addAll(<int>[0, duration.clamp(10, 2000)]);
    return this;
  }

  /// Add a ramp from start to end intensity over duration
  HapticPatternBuilder ramp(
    int startIntensity,
    int endIntensity,
    int duration, {
    int steps = 5,
  }) {
    final double intensityStep = (endIntensity - startIntensity) / steps;
    final int durationStep = duration ~/ steps;

    for (int i = 0; i <= steps; i++) {
      final int intensity = (startIntensity + (intensityStep * i)).round().clamp(0, 255);
      _pattern.addAll(<int>[intensity, durationStep]);
    }
    return this;
  }

  /// Add a heartbeat pattern
  HapticPatternBuilder heartbeat(double bpm, {int beats = 3}) {
    final int beatInterval = (60000 / bpm).round();
    final int beatDuration = (beatInterval * 0.2).round();
    final int pauseDuration = beatInterval - beatDuration;

    for (int i = 0; i < beats; i++) {
      pulse(100, beatDuration);
      pause(pauseDuration);
    }
    return this;
  }

  /// Build the final pattern
  List<int> build() {
    return List.unmodifiable(_pattern);
  }

  /// Play the built pattern
  Future<void> play() async {
    await QuantumHapticService.playCustomPattern(build());
  }

  /// Clear the pattern
  HapticPatternBuilder clear() {
    _pattern.clear();
    return this;
  }
}
