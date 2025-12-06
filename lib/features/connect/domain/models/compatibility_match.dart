// lib/features/connect/domain/models/compatibility_match.dart
import 'package:flutter/material.dart';

/// Represents a compatibility match from the NVS Synaptic Core
/// Each match contains a user profile and their neural compatibility score
@immutable
class CompatibilityMatch {
  const CompatibilityMatch({
    required this.userProfile,
    required this.score,
    required this.breakdown,
    required this.generatedAt,
  });

  factory CompatibilityMatch.fromJson(Map<String, dynamic> json) {
    return CompatibilityMatch(
      userProfile: UserProfile.fromJson(json['userProfile']),
      score: (json['score'] as num).toDouble(),
      breakdown: CompatibilityBreakdown.fromJson(json['breakdown'] ?? <String, dynamic>{}),
      generatedAt: DateTime.parse(
        json['generatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
  final UserProfile userProfile;
  final double score; // 0.0 to 1.0 from the neural network
  final CompatibilityBreakdown breakdown;
  final DateTime generatedAt;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userProfile': userProfile.toJson(),
      'score': score,
      'breakdown': breakdown.toJson(),
      'generatedAt': generatedAt.toIso8601String(),
    };
  }

  // Visual radar properties
  double get orbitalDistance => (1.0 - score) * 300.0; // Higher score = closer orbit
  double get glowIntensity => score; // Direct correlation with compatibility
  double get nodeSize => 20.0 + (score * 40.0); // Larger nodes for better matches

  // Compatibility tier classification
  CompatibilityTier get tier {
    if (score >= 0.9) return CompatibilityTier.cosmic;
    if (score >= 0.75) return CompatibilityTier.stellar;
    if (score >= 0.6) return CompatibilityTier.synergetic;
    if (score >= 0.4) return CompatibilityTier.resonant;
    return CompatibilityTier.distant;
  }

  // Angular position for visual radar (pseudo-random but deterministic)
  double get orbitalAngle {
    final int hash = userProfile.walletAddress.hashCode;
    return (hash % 360).toDouble() * (3.14159 / 180.0); // Convert to radians
  }
}

/// User profile data structure for compatibility matching
@immutable
class UserProfile {
  const UserProfile({
    required this.walletAddress,
    required this.username,
    required this.age,
    this.displayName,
    this.avatarUrl,
    this.location,
    this.astroProfile,
    this.tags = const <String>[],
    this.roles = const <String>[],
    this.biometrics,
    this.behavioral,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      walletAddress: json['walletAddress'],
      username: json['username'],
      displayName: json['displayName'],
      avatarUrl: json['avatarUrl'],
      age: json['age'] ?? 0,
      location: json['location'],
      astroProfile:
          json['astroProfile'] != null ? AstrologicalProfile.fromJson(json['astroProfile']) : null,
      tags: List<String>.from(json['tags'] ?? <dynamic>[]),
      roles: List<String>.from(json['roles'] ?? <dynamic>[]),
      biometrics:
          json['biometrics'] != null ? BiometricSignature.fromJson(json['biometrics']) : null,
      behavioral:
          json['behavioral'] != null ? BehavioralProfile.fromJson(json['behavioral']) : null,
    );
  }
  final String walletAddress;
  final String username;
  final String? displayName;
  final String? avatarUrl;
  final int age;
  final String? location;
  final AstrologicalProfile? astroProfile;
  final List<String> tags;
  final List<String> roles;
  final BiometricSignature? biometrics;
  final BehavioralProfile? behavioral;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'walletAddress': walletAddress,
      'username': username,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'age': age,
      'location': location,
      'astroProfile': astroProfile?.toJson(),
      'tags': tags,
      'roles': roles,
      'biometrics': biometrics?.toJson(),
      'behavioral': behavioral?.toJson(),
    };
  }

  String get effectiveDisplayName => displayName ?? username;
}

/// Detailed breakdown of compatibility factors
@immutable
class CompatibilityBreakdown {
  const CompatibilityBreakdown({
    required this.astrologicalAlignment,
    required this.roleCompatibility,
    required this.biometricResonance,
    required this.behavioralSynergy,
    required this.semanticSimilarity,
  });

  factory CompatibilityBreakdown.fromJson(Map<String, dynamic> json) {
    return CompatibilityBreakdown(
      astrologicalAlignment: (json['astrologicalAlignment'] as num?)?.toDouble() ?? 0.0,
      roleCompatibility: (json['roleCompatibility'] as num?)?.toDouble() ?? 0.0,
      biometricResonance: (json['biometricResonance'] as num?)?.toDouble() ?? 0.0,
      behavioralSynergy: (json['behavioralSynergy'] as num?)?.toDouble() ?? 0.0,
      semanticSimilarity: (json['semanticSimilarity'] as num?)?.toDouble() ?? 0.0,
    );
  }
  final double astrologicalAlignment;
  final double roleCompatibility;
  final double biometricResonance;
  final double behavioralSynergy;
  final double semanticSimilarity;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'astrologicalAlignment': astrologicalAlignment,
      'roleCompatibility': roleCompatibility,
      'biometricResonance': biometricResonance,
      'behavioralSynergy': behavioralSynergy,
      'semanticSimilarity': semanticSimilarity,
    };
  }
}

/// Astrological profile for compatibility analysis
@immutable
class AstrologicalProfile {
  const AstrologicalProfile({
    required this.sunSign,
    this.moonSign,
    this.risingSign,
    this.planetaryPositions = const <String, String>{},
  });

  factory AstrologicalProfile.fromJson(Map<String, dynamic> json) {
    return AstrologicalProfile(
      sunSign: json['sunSign'],
      moonSign: json['moonSign'],
      risingSign: json['risingSign'],
      planetaryPositions:
          Map<String, String>.from(json['planetaryPositions'] ?? <dynamic, dynamic>{}),
    );
  }
  final String sunSign;
  final String? moonSign;
  final String? risingSign;
  final Map<String, String> planetaryPositions;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'sunSign': sunSign,
      'moonSign': moonSign,
      'risingSign': risingSign,
      'planetaryPositions': planetaryPositions,
    };
  }
}

/// Biometric signature for neural compatibility analysis
@immutable
class BiometricSignature {
  const BiometricSignature({
    required this.avgHeartRateVariability,
    required this.restingHeartRate,
    required this.temperatureDelta,
    required this.stressBaseline,
    required this.energyPattern,
  });

  factory BiometricSignature.fromJson(Map<String, dynamic> json) {
    return BiometricSignature(
      avgHeartRateVariability: (json['avgHeartRateVariability'] as num?)?.toDouble() ?? 0.0,
      restingHeartRate: (json['restingHeartRate'] as num?)?.toDouble() ?? 0.0,
      temperatureDelta: (json['temperatureDelta'] as num?)?.toDouble() ?? 0.0,
      stressBaseline: (json['stressBaseline'] as num?)?.toDouble() ?? 0.0,
      energyPattern: (json['energyPattern'] as num?)?.toDouble() ?? 0.0,
    );
  }
  final double avgHeartRateVariability;
  final double restingHeartRate;
  final double temperatureDelta;
  final double stressBaseline;
  final double energyPattern;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'avgHeartRateVariability': avgHeartRateVariability,
      'restingHeartRate': restingHeartRate,
      'temperatureDelta': temperatureDelta,
      'stressBaseline': stressBaseline,
      'energyPattern': energyPattern,
    };
  }
}

/// Behavioral profile for pattern matching
@immutable
class BehavioralProfile {
  const BehavioralProfile({
    required this.sessionLength,
    required this.messageRatio,
    required this.appOpenFrequency,
    required this.interactionDepth,
    required this.socialRadius,
    this.activityPatterns = const <String, double>{},
  });

  factory BehavioralProfile.fromJson(Map<String, dynamic> json) {
    return BehavioralProfile(
      sessionLength: (json['sessionLength'] as num?)?.toDouble() ?? 0.0,
      messageRatio: (json['messageRatio'] as num?)?.toDouble() ?? 0.0,
      appOpenFrequency: (json['appOpenFrequency'] as num?)?.toDouble() ?? 0.0,
      interactionDepth: (json['interactionDepth'] as num?)?.toDouble() ?? 0.0,
      socialRadius: (json['socialRadius'] as num?)?.toDouble() ?? 0.0,
      activityPatterns: Map<String, double>.from(
        (json['activityPatterns'] ?? <dynamic, dynamic>{})
            .map((k, v) => MapEntry(k, (v as num).toDouble())),
      ),
    );
  }
  final double sessionLength;
  final double messageRatio;
  final double appOpenFrequency;
  final double interactionDepth;
  final double socialRadius;
  final Map<String, double> activityPatterns;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'sessionLength': sessionLength,
      'messageRatio': messageRatio,
      'appOpenFrequency': appOpenFrequency,
      'interactionDepth': interactionDepth,
      'socialRadius': socialRadius,
      'activityPatterns': activityPatterns,
    };
  }
}

/// Compatibility tiers for visual classification
enum CompatibilityTier {
  cosmic, // 0.9+ - Perfect neural resonance
  stellar, // 0.75+ - High compatibility
  synergetic, // 0.6+ - Good match potential
  resonant, // 0.4+ - Some compatibility
  distant; // <0.4 - Low compatibility

  String get label {
    switch (this) {
      case CompatibilityTier.cosmic:
        return 'COSMIC RESONANCE';
      case CompatibilityTier.stellar:
        return 'STELLAR ALIGNMENT';
      case CompatibilityTier.synergetic:
        return 'SYNERGETIC BOND';
      case CompatibilityTier.resonant:
        return 'NEURAL RESONANCE';
      case CompatibilityTier.distant:
        return 'DISTANT SIGNAL';
    }
  }

  Color get color {
    switch (this) {
      case CompatibilityTier.cosmic:
        return const Color(0xFFFFD700); // Gold
      case CompatibilityTier.stellar:
        return const Color(0xFF00FF88); // Neon mint
      case CompatibilityTier.synergetic:
        return const Color(0xFF88AAFF); // Neon blue
      case CompatibilityTier.resonant:
        return const Color(0xFFAA88FF); // Neon purple
      case CompatibilityTier.distant:
        return const Color(0xFF666666); // Dim gray
    }
  }
}
