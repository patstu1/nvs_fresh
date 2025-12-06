// lib/core/models/biometric_state.dart

/// Real-time biometric state from wearable devices
///
/// Captures physiological indicators for mood analysis and bio-responsive UI
class BiometricState {
  const BiometricState({
    required this.heartRate, // BPM from Apple Watch/Oura Ring
    required this.heartRateVariability, // HRV in milliseconds
    required this.electrodermalActivity, // EDA/GSR for arousal
    required this.timestamp, // Measurement timestamp
    required this.stress, // Calculated stress level (0-1)
    required this.arousal, // Calculated arousal level (0-1)
    required this.mood, // AI-analyzed mood state
    this.bodyTemperature, // Optional body temp
    this.respiratoryRate, // Optional breathing rate
    this.sleepQuality, // Optional sleep analysis
  });
  factory BiometricState.fromJson(Map<String, dynamic> json) {
    return BiometricState(
      heartRate: (json['heartRate'] as num).toDouble(),
      heartRateVariability: (json['heartRateVariability'] as num).toDouble(),
      electrodermalActivity: (json['electrodermalActivity'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      stress: (json['stress'] as num).toDouble(),
      arousal: (json['arousal'] as num).toDouble(),
      mood: json['mood'] as String,
      bodyTemperature:
          json['bodyTemperature'] != null ? (json['bodyTemperature'] as num).toDouble() : null,
      respiratoryRate:
          json['respiratoryRate'] != null ? (json['respiratoryRate'] as num).toDouble() : null,
      sleepQuality: json['sleepQuality'] != null ? (json['sleepQuality'] as num).toDouble() : null,
    );
  }

  /// Create default/mock biometric state for testing
  factory BiometricState.mock() {
    return BiometricState(
      heartRate: 72.0,
      heartRateVariability: 35.0,
      electrodermalActivity: 0.5,
      timestamp: DateTime.now(),
      stress: 0.3,
      arousal: 0.4,
      mood: 'calm',
    );
  }

  /// Create relaxed biometric state
  factory BiometricState.relaxed() {
    return BiometricState(
      heartRate: 65.0,
      heartRateVariability: 45.0,
      electrodermalActivity: 0.2,
      timestamp: DateTime.now(),
      stress: 0.1,
      arousal: 0.2,
      mood: 'calm',
    );
  }

  /// Create excited biometric state
  factory BiometricState.excited() {
    return BiometricState(
      heartRate: 95.0,
      heartRateVariability: 25.0,
      electrodermalActivity: 0.8,
      timestamp: DateTime.now(),
      stress: 0.4,
      arousal: 0.9,
      mood: 'excited',
    );
  }

  /// Create stressed biometric state
  factory BiometricState.stressed() {
    return BiometricState(
      heartRate: 88.0,
      heartRateVariability: 20.0,
      electrodermalActivity: 0.7,
      timestamp: DateTime.now(),
      stress: 0.8,
      arousal: 0.6,
      mood: 'anxious',
    );
  }

  final double heartRate;
  final double heartRateVariability;
  final double electrodermalActivity;
  final DateTime timestamp;
  final double stress;
  final double arousal;
  final String mood;
  final double? bodyTemperature;
  final double? respiratoryRate;
  final double? sleepQuality;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'heartRate': heartRate,
      'heartRateVariability': heartRateVariability,
      'electrodermalActivity': electrodermalActivity,
      'timestamp': timestamp.toIso8601String(),
      'stress': stress,
      'arousal': arousal,
      'mood': mood,
      'bodyTemperature': bodyTemperature,
      'respiratoryRate': respiratoryRate,
      'sleepQuality': sleepQuality,
    };
  }
}

/// Extensions for biometric state analysis
extension BiometricStateAnalysis on BiometricState {
  /// Check if user is in optimal state for social interaction
  bool get isOptimalForSocial {
    return stress < 0.6 && arousal > 0.3 && arousal < 0.8;
  }

  /// Check if user is ready for intimate interaction
  bool get isReadyForIntimacy {
    return stress < 0.4 && arousal > 0.5;
  }

  /// Get bio-responsive UI intensity (0-1)
  double get uiIntensity {
    return (arousal + (1.0 - stress)) / 2.0;
  }

  /// Get recommended haptic feedback strength
  double get hapticStrength {
    return arousal.clamp(0.1, 1.0);
  }

  /// Get biometric stability score
  double get stabilityScore {
    final double hrStability = (100.0 - (heartRate - 72.0).abs()) / 100.0;
    final double stressStability = 1.0 - stress;
    return (hrStability + stressStability) / 2.0;
  }

  /// Check if significant change from previous state
  bool hasSignificantChangeFrom(BiometricState? previous) {
    if (previous == null) return true;

    final double stressDiff = (stress - previous.stress).abs();
    final double arousalDiff = (arousal - previous.arousal).abs();
    final double hrDiff = (heartRate - previous.heartRate).abs();

    return stressDiff > 0.2 || arousalDiff > 0.2 || hrDiff > 10.0;
  }

  /// Get color intensity for bio-responsive UI
  double get colorIntensity {
    return (0.5 + (arousal * 0.5)).clamp(0.3, 1.0);
  }

  /// Get glow radius for neon effects
  double get glowRadius {
    return (2.0 + (arousal * 6.0)).clamp(2.0, 8.0);
  }
}
