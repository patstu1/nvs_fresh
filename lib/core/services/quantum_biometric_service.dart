import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

/// Comprehensive biometric data collection and analysis service
/// Interfaces with native iOS/Android bridges for real-time biometric monitoring
class QuantumBiometricService {
  static const MethodChannel _methodChannel = MethodChannel('nvs/biometric');
  static const EventChannel _eventChannel = EventChannel('nvs/biometric_stream');

  // Stream controllers for real-time data
  final StreamController<BiometricReading> _biometricStreamController =
      StreamController<BiometricReading>.broadcast();
  final StreamController<MoodInference> _moodStreamController =
      StreamController<MoodInference>.broadcast();
  final StreamController<BioSignature> _bioSignatureStreamController =
      StreamController<BioSignature>.broadcast();

  // Current biometric state
  BiometricReading? _currentReading;
  MoodInference? _currentMood;
  BioSignature? _currentBioSignature;
  BiometricThresholds? _personalizedThresholds;

  // Monitoring state
  bool _isMonitoring = false;
  StreamSubscription<dynamic>? _nativeStreamSubscription;

  // Calibration and personalization
  final Map<String, List<double>> _historicalData = <String, List<double>>{
    'heart_rate': <double>[],
    'hrv': <double>[],
    'stress_level': <double>[],
    'arousal_level': <double>[],
    'social_receptiveness': <double>[],
  };

  // Getters for public access
  Stream<BiometricReading> get biometricStream => _biometricStreamController.stream;
  Stream<MoodInference> get moodStream => _moodStreamController.stream;
  Stream<BioSignature> get bioSignatureStream => _bioSignatureStreamController.stream;

  BiometricReading? get currentReading => _currentReading;
  MoodInference? get currentMood => _currentMood;
  BioSignature? get currentBioSignature => _currentBioSignature;
  bool get isMonitoring => _isMonitoring;

  /// Initialize the biometric service and request permissions
  Future<BiometricServiceStatus> initialize() async {
    try {
      final result = await _methodChannel.invokeMethod('requestPermissions');

      if (result['status'] == 'authorized') {
        return BiometricServiceStatus.authorized;
      } else {
        return BiometricServiceStatus.denied;
      }
    } on PlatformException catch (e) {
      debugPrint('❌ Biometric permission error: ${e.message}');
      return BiometricServiceStatus.error;
    }
  }

  /// Start real-time biometric monitoring
  Future<bool> startMonitoring() async {
    if (_isMonitoring) return true;

    try {
      final result = await _methodChannel.invokeMethod('startBiometricMonitoring');

      if (result['status'] == 'monitoring_started') {
        _isMonitoring = true;
        _setupNativeStream();
        debugPrint('🫀 Biometric monitoring started');
        return true;
      }

      return false;
    } on PlatformException catch (e) {
      debugPrint('❌ Failed to start biometric monitoring: ${e.message}');
      return false;
    }
  }

  /// Stop biometric monitoring
  Future<void> stopMonitoring() async {
    if (!_isMonitoring) return;

    try {
      await _methodChannel.invokeMethod('stopBiometricMonitoring');
      _isMonitoring = false;
      await _nativeStreamSubscription?.cancel();
      _nativeStreamSubscription = null;
      debugPrint('🫀 Biometric monitoring stopped');
    } on PlatformException catch (e) {
      debugPrint('❌ Failed to stop biometric monitoring: ${e.message}');
    }
  }

  /// Get current biometric snapshot
  Future<BiometricSnapshot?> getCurrentSnapshot() async {
    try {
      final result = await _methodChannel.invokeMethod('getCurrentBiometrics');
      return BiometricSnapshot.fromMap(result);
    } on PlatformException catch (e) {
      debugPrint('❌ Failed to get current biometrics: ${e.message}');
      return null;
    }
  }

  /// Initialize Oura Ring connection
  Future<bool> initializeOuraRing() async {
    try {
      final result = await _methodChannel.invokeMethod('initializeOuraRing');
      return result['status'] == 'initializing' || result['status'] == 'connected';
    } on PlatformException catch (e) {
      debugPrint('❌ Failed to initialize Oura Ring: ${e.message}');
      return false;
    }
  }

  /// Calibrate personalized biometric thresholds
  Future<BiometricThresholds?> calibrateThresholds({
    required int age,
    required String gender,
    required String fitnessLevel,
  }) async {
    try {
      final result = await _methodChannel.invokeMethod('calibrateBioThresholds', <String, Object>{
        'age': age,
        'gender': gender,
        'fitness_level': fitnessLevel,
      });

      if (result['status'] == 'calibrated') {
        _personalizedThresholds = BiometricThresholds.fromMap(result['thresholds']);
        return _personalizedThresholds;
      }

      return null;
    } on PlatformException catch (e) {
      debugPrint('❌ Failed to calibrate thresholds: ${e.message}');
      return null;
    }
  }

  /// Setup native stream listener for real-time data
  void _setupNativeStream() {
    _nativeStreamSubscription = _eventChannel.receiveBroadcastStream().listen(
      _processNativeBiometricData,
      onError: (error) {
        debugPrint('❌ Biometric stream error: $error');
      },
    );
  }

  /// Process incoming biometric data from native bridge
  void _processNativeBiometricData(dynamic data) {
    if (data == null || data is! Map<String, dynamic>) return;

    final Map<String, dynamic> dataMap = Map<String, dynamic>.from(data);
    final String? type = dataMap['type'] as String?;

    switch (type) {
      case 'heart_rate':
        _processHeartRateUpdate(dataMap);
        break;
      case 'hrv':
        _processHRVUpdate(dataMap);
        break;
      case 'oura_ring':
        _processOuraRingUpdate(dataMap);
        break;
      default:
        _processComprehensiveBiometricUpdate(dataMap);
    }
  }

  void _processHeartRateUpdate(Map<String, dynamic> data) {
    final double heartRate = (data['value'] as num?)?.toDouble() ?? 0.0;
    final int timestamp = data['timestamp'] as int? ?? DateTime.now().millisecondsSinceEpoch;

    // Update historical data
    _historicalData['heart_rate']?.add(heartRate);
    _limitHistoricalData('heart_rate');

    // Create partial reading update
    _updateCurrentReading(heartRate: heartRate, timestamp: timestamp);
  }

  void _processHRVUpdate(Map<String, dynamic> data) {
    final double hrv = (data['value'] as num?)?.toDouble() ?? 0.0;
    final int timestamp = data['timestamp'] as int? ?? DateTime.now().millisecondsSinceEpoch;

    // Update historical data
    _historicalData['hrv']?.add(hrv);
    _limitHistoricalData('hrv');

    // Create partial reading update
    _updateCurrentReading(hrv: hrv, timestamp: timestamp);
  }

  void _processOuraRingUpdate(Map<String, dynamic> data) {
    final double temperature = (data['temperature'] as num?)?.toDouble() ?? 98.6;
    final int timestamp = data['timestamp'] as int? ?? DateTime.now().millisecondsSinceEpoch;

    // Update current reading with Oura data
    _updateCurrentReading(bodyTemperature: temperature, timestamp: timestamp);
  }

  void _processComprehensiveBiometricUpdate(Map<String, dynamic> data) {
    // Process full biometric data packet
    final BiometricReading reading = BiometricReading.fromMap(data);
    final MoodInference? mood =
        data['mood_inference'] != null ? MoodInference.fromMap(data['mood_inference']) : null;
    final BioSignature? bioSignature =
        data['bio_signature'] != null ? BioSignature.fromMap(data['bio_signature']) : null;

    // Update current state
    _currentReading = reading;
    _currentMood = mood;
    _currentBioSignature = bioSignature;

    // Update historical data
    _updateHistoricalData(reading);

    // Stream updates
    _biometricStreamController.add(reading);
    if (mood != null) _moodStreamController.add(mood);
    if (bioSignature != null) _bioSignatureStreamController.add(bioSignature);
  }

  void _updateCurrentReading({
    required int timestamp,
    double? heartRate,
    double? hrv,
    double? bodyTemperature,
    double? stressLevel,
    double? arousalLevel,
    double? socialReceptiveness,
  }) {
    _currentReading = BiometricReading(
      heartRate: heartRate ?? _currentReading?.heartRate ?? 0.0,
      hrv: hrv ?? _currentReading?.hrv ?? 0.0,
      bodyTemperature: bodyTemperature ?? _currentReading?.bodyTemperature ?? 98.6,
      stressLevel: stressLevel ?? _currentReading?.stressLevel ?? 0.0,
      arousalLevel: arousalLevel ?? _currentReading?.arousalLevel ?? 0.0,
      socialReceptiveness: socialReceptiveness ?? _currentReading?.socialReceptiveness ?? 0.5,
      timestamp: DateTime.fromMillisecondsSinceEpoch(timestamp),
      deviceSources: _currentReading?.deviceSources ?? <String>[],
    );

    _biometricStreamController.add(_currentReading!);
  }

  void _updateHistoricalData(BiometricReading reading) {
    _historicalData['heart_rate']?.add(reading.heartRate);
    _historicalData['hrv']?.add(reading.hrv);
    _historicalData['stress_level']?.add(reading.stressLevel);
    _historicalData['arousal_level']?.add(reading.arousalLevel);
    _historicalData['social_receptiveness']?.add(reading.socialReceptiveness);

    // Limit historical data to last 1000 readings
    _historicalData.forEach((String key, List<double> value) => _limitHistoricalData(key));
  }

  void _limitHistoricalData(String key, [int maxItems = 1000]) {
    final List<double>? data = _historicalData[key];
    if (data != null && data.length > maxItems) {
      data.removeRange(0, data.length - maxItems);
    }
  }

  /// Advanced biometric analysis methods

  /// Calculate compatibility score with another user's biometric signature
  double calculateCompatibilityScore(BioSignature otherSignature) {
    if (_currentBioSignature == null) return 0.0;

    final BioSignature current = _currentBioSignature!;
    final Map<String, double> weights = <String, double>{
      'parasympathetic_dominance': 0.3,
      'emotional_stability': 0.25,
      'energy_level': 0.2,
      'cognitive_load': -0.15, // Inverse correlation
      'sympathetic_activation': -0.1, // Inverse correlation
    };

    double totalScore = 0.0;
    double totalWeight = 0.0;

    weights.forEach((String trait, double weight) {
      final double? currentValue = _getBioSignatureValue(current, trait);
      final double? otherValue = _getBioSignatureValue(otherSignature, trait);

      if (currentValue != null && otherValue != null) {
        // Calculate similarity (1 - absolute difference)
        final double similarity = 1.0 - (currentValue - otherValue).abs();
        totalScore += similarity * weight.abs();
        totalWeight += weight.abs();
      }
    });

    return totalWeight > 0 ? totalScore / totalWeight : 0.0;
  }

  double? _getBioSignatureValue(BioSignature signature, String trait) {
    switch (trait) {
      case 'parasympathetic_dominance':
        return signature.parasympatheticDominance;
      case 'emotional_stability':
        return signature.emotionalStability;
      case 'energy_level':
        return signature.energyLevel;
      case 'cognitive_load':
        return signature.cognitiveLoad;
      case 'sympathetic_activation':
        return signature.sympatheticActivation;
      default:
        return null;
    }
  }

  /// Detect optimal times for social interaction based on biometric patterns
  SocialOptimalityScore calculateSocialOptimality() {
    if (_currentReading == null || _currentMood == null) {
      return SocialOptimalityScore.low();
    }

    final BiometricReading reading = _currentReading!;
    final MoodInference mood = _currentMood!;

    // Factors that contribute to social optimality
    final Map<String, double> factors = <String, double>{
      'mood_valence': mood.valence,
      'social_receptiveness': reading.socialReceptiveness,
      'energy_level': _currentBioSignature?.energyLevel ?? 0.5,
      'stress_level': 1.0 - reading.stressLevel, // Inverse correlation
      'emotional_stability': _currentBioSignature?.emotionalStability ?? 0.5,
    };

    double totalScore = 0.0;
    factors.forEach((String factor, double value) {
      totalScore += value * 0.2; // Equal weighting
    });

    return SocialOptimalityScore(
      score: totalScore.clamp(0.0, 1.0),
      factors: factors,
      timestamp: DateTime.now(),
      recommendation: _generateSocialRecommendation(totalScore),
    );
  }

  String _generateSocialRecommendation(double score) {
    if (score >= 0.8) {
      return 'Perfect time for meaningful connections! Your bio-energy is aligned.';
    }
    if (score >= 0.6) {
      return "Good time for social interaction. You're receptive and stable.";
    }
    if (score >= 0.4) {
      return 'Moderate social energy. Consider lighter interactions.';
    }
    if (score >= 0.2) {
      return 'Lower social energy detected. Focus on close connections.';
    }
    return 'Consider some self-care time. Your biometrics suggest rest.';
  }

  /// Generate haptic feedback pattern based on biometric synchronization
  List<int> generateHapticWhisperPattern(BioSignature targetSignature) {
    if (_currentBioSignature == null) return <int>[100, 50, 100]; // Default pattern

    final double compatibility = calculateCompatibilityScore(targetSignature);
    final int intensity = (compatibility * 255).round().clamp(50, 255);

    // Create bio-synced haptic pattern
    if (compatibility >= 0.8) {
      // High compatibility: Smooth, rhythmic pattern
      return <int>[intensity, 100, intensity ~/ 2, 50, intensity, 150];
    } else if (compatibility >= 0.6) {
      // Medium compatibility: Gentle pulsing
      return <int>[intensity, 200, intensity ~/ 3, 100, intensity ~/ 2, 200];
    } else if (compatibility >= 0.4) {
      // Low compatibility: Subtle notification
      return <int>[intensity ~/ 2, 300, intensity ~/ 4, 100];
    } else {
      // Very low compatibility: Single gentle pulse
      return <int>[intensity ~/ 3, 500];
    }
  }

  /// Get statistical insights from historical biometric data
  BiometricInsights getHistoricalInsights() {
    return BiometricInsights(
      averageHeartRate: _calculateAverage('heart_rate'),
      averageHRV: _calculateAverage('hrv'),
      averageStressLevel: _calculateAverage('stress_level'),
      averageArousalLevel: _calculateAverage('arousal_level'),
      averageSocialReceptiveness: _calculateAverage('social_receptiveness'),
      dataPointCount: _historicalData['heart_rate']?.length ?? 0,
      timeSpan: _calculateTimeSpan(),
      patterns: _identifyPatterns(),
    );
  }

  double _calculateAverage(String metric) {
    final List<double>? data = _historicalData[metric];
    if (data == null || data.isEmpty) return 0.0;
    return data.reduce((double a, double b) => a + b) / data.length;
  }

  Duration _calculateTimeSpan() {
    final int dataCount = _historicalData['heart_rate']?.length ?? 0;
    // Assuming 5-second intervals between readings
    return Duration(seconds: dataCount * 5);
  }

  Map<String, String> _identifyPatterns() {
    // Simplified pattern identification
    final Map<String, String> patterns = <String, String>{};

    final double avgHR = _calculateAverage('heart_rate');
    final double avgStress = _calculateAverage('stress_level');

    if (avgHR > 80) patterns['heart_rate'] = 'Elevated';
    if (avgStress > 0.6) patterns['stress'] = 'High stress detected';
    if (_calculateAverage('social_receptiveness') > 0.7) {
      patterns['social'] = 'Highly social period';
    }

    return patterns;
  }

  /// Dispose of resources
  void dispose() {
    _biometricStreamController.close();
    _moodStreamController.close();
    _bioSignatureStreamController.close();
    _nativeStreamSubscription?.cancel();
  }
}

// Supporting data classes

enum BiometricServiceStatus {
  authorized,
  denied,
  error,
  unavailable,
}

class BiometricReading {
  const BiometricReading({
    required this.heartRate,
    required this.hrv,
    required this.bodyTemperature,
    required this.stressLevel,
    required this.arousalLevel,
    required this.socialReceptiveness,
    required this.timestamp,
    required this.deviceSources,
  });

  factory BiometricReading.fromMap(Map<String, dynamic> map) {
    return BiometricReading(
      heartRate: (map['heart_rate'] as num?)?.toDouble() ?? 0.0,
      hrv: (map['hrv'] as num?)?.toDouble() ?? 0.0,
      bodyTemperature: (map['body_temperature'] as num?)?.toDouble() ?? 98.6,
      stressLevel: (map['stress_level'] as num?)?.toDouble() ?? 0.0,
      arousalLevel: (map['arousal_level'] as num?)?.toDouble() ?? 0.0,
      socialReceptiveness: (map['social_receptiveness'] as num?)?.toDouble() ?? 0.5,
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        map['timestamp'] as int? ?? DateTime.now().millisecondsSinceEpoch,
      ),
      deviceSources: List<String>.from(map['device_sources'] ?? <dynamic>[]),
    );
  }
  final double heartRate;
  final double hrv;
  final double bodyTemperature;
  final double stressLevel;
  final double arousalLevel;
  final double socialReceptiveness;
  final DateTime timestamp;
  final List<String> deviceSources;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'heart_rate': heartRate,
      'hrv': hrv,
      'body_temperature': bodyTemperature,
      'stress_level': stressLevel,
      'arousal_level': arousalLevel,
      'social_receptiveness': socialReceptiveness,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'device_sources': deviceSources,
    };
  }
}

class MoodInference {
  const MoodInference({
    required this.mood,
    required this.valence,
    required this.arousal,
    required this.dominance,
    required this.confidence,
    required this.reliability,
  });

  factory MoodInference.fromMap(Map<String, dynamic> map) {
    final Map<String, dynamic> vector =
        map['vector'] as Map<String, dynamic>? ?? <String, dynamic>{};

    return MoodInference(
      mood: map['mood'] as String? ?? 'neutral',
      valence: (vector['valence'] as num?)?.toDouble() ?? 0.5,
      arousal: (vector['arousal'] as num?)?.toDouble() ?? 0.5,
      dominance: (vector['dominance'] as num?)?.toDouble() ?? 0.5,
      confidence: (vector['confidence'] as num?)?.toDouble() ?? 0.5,
      reliability: (map['reliability'] as num?)?.toDouble() ?? 0.5,
    );
  }
  final String mood;
  final double valence;
  final double arousal;
  final double dominance;
  final double confidence;
  final double reliability;
}

class BioSignature {
  const BioSignature({
    required this.parasympatheticDominance,
    required this.sympatheticActivation,
    required this.cognitiveLoad,
    required this.emotionalStability,
    required this.energyLevel,
  });

  factory BioSignature.fromMap(Map<String, dynamic> map) {
    return BioSignature(
      parasympatheticDominance: (map['parasympathetic_dominance'] as num?)?.toDouble() ?? 0.0,
      sympatheticActivation: (map['sympathetic_activation'] as num?)?.toDouble() ?? 0.0,
      cognitiveLoad: (map['cognitive_load'] as num?)?.toDouble() ?? 0.0,
      emotionalStability: (map['emotional_stability'] as num?)?.toDouble() ?? 0.0,
      energyLevel: (map['energy_level'] as num?)?.toDouble() ?? 0.0,
    );
  }
  final double parasympatheticDominance;
  final double sympatheticActivation;
  final double cognitiveLoad;
  final double emotionalStability;
  final double energyLevel;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'parasympathetic_dominance': parasympatheticDominance,
      'sympathetic_activation': sympatheticActivation,
      'cognitive_load': cognitiveLoad,
      'emotional_stability': emotionalStability,
      'energy_level': energyLevel,
    };
  }
}

class BiometricSnapshot {
  const BiometricSnapshot({
    required this.reading,
    required this.deviceSources,
    this.mood,
    this.bioSignature,
  });

  factory BiometricSnapshot.fromMap(Map<String, dynamic> map) {
    return BiometricSnapshot(
      reading: BiometricReading.fromMap(map),
      mood: map['mood_inference'] != null ? MoodInference.fromMap(map['mood_inference']) : null,
      bioSignature:
          map['bio_signature'] != null ? BioSignature.fromMap(map['bio_signature']) : null,
      deviceSources: List<String>.from(map['device_sources'] ?? <dynamic>[]),
    );
  }
  final BiometricReading reading;
  final MoodInference? mood;
  final BioSignature? bioSignature;
  final List<String> deviceSources;
}

class BiometricThresholds {
  const BiometricThresholds({
    required this.maxHeartRate,
    required this.restingHeartRate,
    required this.hrvBaseline,
    required this.arousalThreshold,
    required this.receptivenessThreshold,
  });

  factory BiometricThresholds.fromMap(Map<String, dynamic> map) {
    return BiometricThresholds(
      maxHeartRate: map['max_heart_rate'] as int? ?? 180,
      restingHeartRate: map['resting_heart_rate'] as int? ?? 70,
      hrvBaseline: (map['hrv_baseline'] as num?)?.toDouble() ?? 40.0,
      arousalThreshold: (map['arousal_threshold'] as num?)?.toDouble() ?? 0.7,
      receptivenessThreshold: (map['receptiveness_threshold'] as num?)?.toDouble() ?? 0.6,
    );
  }
  final int maxHeartRate;
  final int restingHeartRate;
  final double hrvBaseline;
  final double arousalThreshold;
  final double receptivenessThreshold;
}

class SocialOptimalityScore {
  const SocialOptimalityScore({
    required this.score,
    required this.factors,
    required this.timestamp,
    required this.recommendation,
  });

  factory SocialOptimalityScore.low() {
    return SocialOptimalityScore(
      score: 0.2,
      factors: <String, double>{},
      timestamp: DateTime.now(),
      recommendation: 'Insufficient biometric data for social optimization',
    );
  }
  final double score;
  final Map<String, double> factors;
  final DateTime timestamp;
  final String recommendation;
}

class BiometricInsights {
  const BiometricInsights({
    required this.averageHeartRate,
    required this.averageHRV,
    required this.averageStressLevel,
    required this.averageArousalLevel,
    required this.averageSocialReceptiveness,
    required this.dataPointCount,
    required this.timeSpan,
    required this.patterns,
  });
  final double averageHeartRate;
  final double averageHRV;
  final double averageStressLevel;
  final double averageArousalLevel;
  final double averageSocialReceptiveness;
  final int dataPointCount;
  final Duration timeSpan;
  final Map<String, String> patterns;
}
