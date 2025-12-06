// lib/core/models/neural_profile.dart

import 'dart:math' as math;

/// Neural profile for AI-powered matching and compatibility analysis
///
/// Generated from biometric data and behavioral patterns using PyTorch models
class NeuralProfile {
  const NeuralProfile({
    required this.userId, // User identifier
    required this.timestamp, // Profile generation time
    required this.moodVector, // 128-dimensional mood embedding
    required this.energyLevel, // Energy/vitality score (0-1)
    required this.socialReadiness, // Social interaction readiness (0-1)
    required this.intimacyPotential, // Intimacy readiness score (0-1)
    required this.communicationStyle, // Communication preference
    required this.quantumSignature, // Privacy-preserving identifier
    this.dominantMood, // Primary mood classification
    this.traits, // Personality traits from biometrics
    this.adventurousness, // Openness to new experiences
    this.empathy, // Emotional intelligence score
    this.preferences, // Dynamic preferences
  });
  factory NeuralProfile.fromJson(Map<String, dynamic> json) {
    return NeuralProfile(
      userId: json['userId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      moodVector: List<double>.from(json['moodVector'] as List),
      energyLevel: (json['energyLevel'] as num).toDouble(),
      socialReadiness: (json['socialReadiness'] as num).toDouble(),
      intimacyPotential: (json['intimacyPotential'] as num).toDouble(),
      communicationStyle: json['communicationStyle'] as String,
      quantumSignature: json['quantumSignature'] as String,
      dominantMood: json['dominantMood'] as String?,
      traits: json['traits'] != null ? List<String>.from(json['traits'] as List) : null,
      adventurousness:
          json['adventurousness'] != null ? (json['adventurousness'] as num).toDouble() : null,
      empathy: json['empathy'] != null ? (json['empathy'] as num).toDouble() : null,
      preferences:
          json['preferences'] != null ? Map<String, double>.from(json['preferences'] as Map) : null,
    );
  }

  /// Create mock neural profile for testing
  factory NeuralProfile.mock(String userId) {
    return NeuralProfile(
      userId: userId,
      timestamp: DateTime.now(),
      moodVector: List.generate(128, (int i) => (i % 10) / 10.0),
      energyLevel: 0.7,
      socialReadiness: 0.8,
      intimacyPotential: 0.6,
      communicationStyle: 'balanced',
      quantumSignature: 'mock_${DateTime.now().millisecondsSinceEpoch}',
      dominantMood: 'content',
      traits: <String>['confident', 'empathetic', 'adventurous'],
      adventurousness: 0.75,
      empathy: 0.85,
      preferences: <String, double>{
        'outdoor_activities': 0.8,
        'intellectual_discussions': 0.9,
        'physical_intimacy': 0.7,
        'emotional_connection': 0.95,
      },
    );
  }

  /// Create calm/relaxed neural profile
  factory NeuralProfile.calm(String userId) {
    return NeuralProfile(
      userId: userId,
      timestamp: DateTime.now(),
      moodVector: List.generate(128, (int i) => 0.3 + (i % 5) / 20.0),
      energyLevel: 0.4,
      socialReadiness: 0.9,
      intimacyPotential: 0.8,
      communicationStyle: 'contemplative',
      quantumSignature: 'calm_${DateTime.now().millisecondsSinceEpoch}',
      dominantMood: 'calm',
      traits: <String>['peaceful', 'thoughtful', 'stable'],
      adventurousness: 0.4,
      empathy: 0.9,
    );
  }

  /// Create energetic/excited neural profile
  factory NeuralProfile.energetic(String userId) {
    return NeuralProfile(
      userId: userId,
      timestamp: DateTime.now(),
      moodVector: List.generate(128, (int i) => 0.6 + (i % 8) / 16.0),
      energyLevel: 0.9,
      socialReadiness: 0.95,
      intimacyPotential: 0.85,
      communicationStyle: 'expressive',
      quantumSignature: 'energetic_${DateTime.now().millisecondsSinceEpoch}',
      dominantMood: 'excited',
      traits: <String>['enthusiastic', 'spontaneous', 'charismatic'],
      adventurousness: 0.9,
      empathy: 0.7,
    );
  }

  /// Create introspective neural profile
  factory NeuralProfile.introspective(String userId) {
    return NeuralProfile(
      userId: userId,
      timestamp: DateTime.now(),
      moodVector: List.generate(128, (int i) => 0.2 + (i % 3) / 15.0),
      energyLevel: 0.3,
      socialReadiness: 0.5,
      intimacyPotential: 0.9,
      communicationStyle: 'contemplative',
      quantumSignature: 'intro_${DateTime.now().millisecondsSinceEpoch}',
      dominantMood: 'contemplative',
      traits: <String>['introspective', 'deep', 'sensitive'],
      adventurousness: 0.3,
      empathy: 0.95,
    );
  }

  final String userId;
  final DateTime timestamp;
  final List<double> moodVector;
  final double energyLevel;
  final double socialReadiness;
  final double intimacyPotential;
  final String communicationStyle;
  final String quantumSignature;
  final String? dominantMood;
  final List<String>? traits;
  final double? adventurousness;
  final double? empathy;
  final Map<String, double>? preferences;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userId': userId,
      'timestamp': timestamp.toIso8601String(),
      'moodVector': moodVector,
      'energyLevel': energyLevel,
      'socialReadiness': socialReadiness,
      'intimacyPotential': intimacyPotential,
      'communicationStyle': communicationStyle,
      'quantumSignature': quantumSignature,
      'dominantMood': dominantMood,
      'traits': traits,
      'adventurousness': adventurousness,
      'empathy': empathy,
      'preferences': preferences,
    };
  }
}

/// Extensions for neural profile analysis
extension NeuralProfileAnalysis on NeuralProfile {
  /// Check compatibility with another neural profile
  double compatibilityWith(NeuralProfile other) {
    // Energy level compatibility (opposites can attract)
    final double energyCompat = 1.0 - (energyLevel - other.energyLevel).abs() * 0.5;

    // Social readiness alignment
    final double socialCompat = 1.0 - (socialReadiness - other.socialReadiness).abs();

    // Intimacy potential alignment
    final double intimacyCompat = 1.0 - (intimacyPotential - other.intimacyPotential).abs();

    // Communication style compatibility
    final double commCompat = _communicationStyleCompatibility(other.communicationStyle);

    // Mood vector similarity (cosine similarity)
    final double moodCompat = _calculateMoodSimilarity(other.moodVector);

    // Weighted average
    return (energyCompat * 0.2 +
            socialCompat * 0.2 +
            intimacyCompat * 0.25 +
            commCompat * 0.15 +
            moodCompat * 0.2)
        .clamp(0.0, 1.0);
  }

  /// Calculate communication style compatibility
  double _communicationStyleCompatibility(String otherStyle) {
    const Map<String, Map<String, double>> compatibilityMatrix = <String, Map<String, double>>{
      'direct': <String, double>{
        'direct': 0.9,
        'expressive': 0.7,
        'contemplative': 0.4,
        'balanced': 0.8,
      },
      'expressive': <String, double>{
        'direct': 0.7,
        'expressive': 0.9,
        'contemplative': 0.6,
        'balanced': 0.8,
      },
      'contemplative': <String, double>{
        'direct': 0.4,
        'expressive': 0.6,
        'contemplative': 0.9,
        'balanced': 0.7,
      },
      'balanced': <String, double>{
        'direct': 0.8,
        'expressive': 0.8,
        'contemplative': 0.7,
        'balanced': 0.9,
      },
    };

    return compatibilityMatrix[communicationStyle]?[otherStyle] ?? 0.5;
  }

  /// Calculate mood vector similarity using cosine similarity
  double _calculateMoodSimilarity(List<double> otherMoodVector) {
    if (moodVector.length != otherMoodVector.length) return 0.5;

    double dotProduct = 0.0;
    double norm1 = 0.0;
    double norm2 = 0.0;

    for (int i = 0; i < moodVector.length; i++) {
      dotProduct += moodVector[i] * otherMoodVector[i];
      norm1 += moodVector[i] * moodVector[i];
      norm2 += otherMoodVector[i] * otherMoodVector[i];
    }

    if (norm1 == 0.0 || norm2 == 0.0) return 0.0;

    final double similarity = dotProduct / (math.sqrt(norm1) * math.sqrt(norm2));
    return (similarity + 1.0) / 2.0; // Normalize from [-1,1] to [0,1]
  }

  /// Get personality archetype based on neural profile
  String get personalityArchetype {
    if (energyLevel > 0.7 && socialReadiness > 0.8) {
      return 'Energetic Connector';
    } else if (intimacyPotential > 0.8 && empathy != null && empathy! > 0.8) {
      return 'Intimate Empath';
    } else if (adventurousness != null && adventurousness! > 0.8) {
      return 'Bold Explorer';
    } else if (communicationStyle == 'contemplative' && socialReadiness < 0.6) {
      return 'Thoughtful Introvert';
    } else {
      return 'Balanced Individual';
    }
  }

  /// Get recommended interaction style
  String get recommendedInteractionStyle {
    if (energyLevel > 0.8) return 'high_energy';
    if (intimacyPotential > 0.8) return 'intimate';
    if (socialReadiness > 0.8) return 'social';
    return 'relaxed';
  }

  /// Check if profile is fresh (less than 5 minutes old)
  bool get isFresh {
    return DateTime.now().difference(timestamp).inMinutes < 5;
  }

  /// Get profile freshness score (1.0 = just created, 0.0 = very old)
  double get freshness {
    final int minutes = DateTime.now().difference(timestamp).inMinutes;
    return (1.0 - (minutes / 60.0)).clamp(0.0, 1.0);
  }

  /// Get dominant trait from traits list
  String? get dominantTrait {
    return traits?.isNotEmpty ?? false ? traits!.first : null;
  }

  /// Check if user is in optimal state for matching
  bool get isOptimalForMatching {
    return socialReadiness > 0.6 && energyLevel > 0.4 && isFresh;
  }

  /// Get bio-responsive UI configuration
  Map<String, double> get uiConfiguration {
    return <String, double>{
      'glowIntensity': (energyLevel * 0.5 + socialReadiness * 0.5),
      'animationSpeed': energyLevel,
      'colorSaturation': intimacyPotential,
      'particleDensity': (energyLevel + socialReadiness) / 2.0,
    };
  }
}
