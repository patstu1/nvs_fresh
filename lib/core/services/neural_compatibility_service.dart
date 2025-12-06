// lib/core/services/neural_compatibility_service.dart
// Flutter service for interfacing with the PyTorch Neural Compatibility Engine

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/biometric_state.dart';
import '../models/quantum_user_profile.dart';

/// Neural Compatibility Service
/// Interfaces with the PyTorch-powered AI backend for quantum-level compatibility analysis
class NeuralCompatibilityService {
  factory NeuralCompatibilityService() => _instance;
  NeuralCompatibilityService._internal() : _httpClient = http.Client();
  static const String _baseUrl = 'http://localhost:8000'; // AI service URL
  static const Duration _timeout = Duration(seconds: 10);

  final http.Client _httpClient;
  final StreamController<CompatibilityUpdate> _compatibilityUpdateController =
      StreamController<CompatibilityUpdate>.broadcast();

  // Singleton instance
  static final NeuralCompatibilityService _instance = NeuralCompatibilityService._internal();

  /// Stream of real-time compatibility updates
  Stream<CompatibilityUpdate> get compatibilityUpdates => _compatibilityUpdateController.stream;

  /// Predict compatibility between two users using neural network
  Future<CompatibilityAnalysis> predictCompatibility({
    required String user1Id,
    required BiometricState user1Biometrics,
    required BehavioralProfile user1Behavioral,
    required List<String> user1Messages,
    required String user2Id,
    required BiometricState user2Biometrics,
    required BehavioralProfile user2Behavioral,
    required List<String> user2Messages,
    int cacheTtl = 3600,
  }) async {
    try {
      final Map<String, Object> requestBody = <String, Object>{
        'user1_id': user1Id,
        'user1_biometric': _biometricStateToMap(user1Biometrics),
        'user1_behavioral': _behavioralProfileToMap(user1Behavioral),
        'user1_messages': user1Messages,
        'user2_id': user2Id,
        'user2_biometric': _biometricStateToMap(user2Biometrics),
        'user2_behavioral': _behavioralProfileToMap(user2Behavioral),
        'user2_messages': user2Messages,
        'cache_ttl': cacheTtl,
      };

      final http.Response response = await _httpClient
          .post(
            Uri.parse('$_baseUrl/predict-compatibility'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
        final CompatibilityAnalysis analysis = CompatibilityAnalysis.fromJson(data);

        debugPrint(
          '🧠 Neural compatibility analysis: $user1Id <-> $user2Id = ${analysis.overallScore.toStringAsFixed(3)}',
        );

        return analysis;
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      debugPrint('❌ Neural compatibility prediction error: $e');
      throw NeuralCompatibilityException('Failed to predict compatibility: $e');
    }
  }

  /// Batch predict compatibility for a target user against multiple candidates
  Future<List<CompatibilityAnalysis>> batchPredictCompatibility({
    required String targetUserId,
    required BiometricState targetBiometrics,
    required BehavioralProfile targetBehavioral,
    required List<String> targetMessages,
    required List<CandidateUser> candidates,
    int maxResults = 50,
    double minScoreThreshold = 0.3,
  }) async {
    try {
      final List<Map<String, Object>> candidateData = candidates
          .map(
            (CandidateUser candidate) => <String, Object>{
              'user_id': candidate.userId,
              'biometric': _biometricStateToMap(candidate.biometrics),
              'behavioral': _behavioralProfileToMap(candidate.behavioral),
              'messages': candidate.messages,
            },
          )
          .toList();

      final Map<String, Object> requestBody = <String, Object>{
        'target_user_id': targetUserId,
        'target_biometric': _biometricStateToMap(targetBiometrics),
        'target_behavioral': _behavioralProfileToMap(targetBehavioral),
        'target_messages': targetMessages,
        'candidate_users': candidateData,
        'max_results': maxResults,
        'min_score_threshold': minScoreThreshold,
      };

      final http.Response response = await _httpClient
          .post(
            Uri.parse('$_baseUrl/batch-compatibility'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body) as List<dynamic>;
        final List<CompatibilityAnalysis> analyses = data
            .map(
              (item) => CompatibilityAnalysis.fromJson(item as Map<String, dynamic>),
            )
            .toList();

        debugPrint(
          '🚀 Batch neural analysis: ${candidates.length} candidates -> ${analyses.length} matches',
        );

        return analyses;
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      debugPrint('❌ Batch neural compatibility error: $e');
      throw NeuralCompatibilityException(
        'Failed to batch predict compatibility: $e',
      );
    }
  }

  /// Update user vectors for faster batch processing
  Future<void> updateUserVectors({
    required String userId,
    required BiometricState biometrics,
    required BehavioralProfile behavioral,
  }) async {
    try {
      final Map<String, Object> requestBody = <String, Object>{
        'user_id': userId,
        'biometric': _biometricStateToMap(biometrics),
        'behavioral': _behavioralProfileToMap(behavioral),
      };

      final http.Response response = await _httpClient
          .post(
            Uri.parse('$_baseUrl/update-user-vectors'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        debugPrint('✅ Updated neural vectors for user: $userId');
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      debugPrint('❌ Vector update error: $e');
      // Non-critical error, don't throw
    }
  }

  /// Get API statistics
  Future<NeuralEngineStats> getStats() async {
    try {
      final http.Response response = await _httpClient.get(
        Uri.parse('$_baseUrl/stats'),
        headers: <String, String>{'Accept': 'application/json'},
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
        return NeuralEngineStats.fromJson(data);
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      debugPrint('❌ Stats retrieval error: $e');
      throw NeuralCompatibilityException('Failed to get stats: $e');
    }
  }

  /// Clear prediction cache
  Future<void> clearCache() async {
    try {
      final http.Response response = await _httpClient.delete(
        Uri.parse('$_baseUrl/cache/clear'),
        headers: <String, String>{'Accept': 'application/json'},
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        debugPrint('🧹 Neural compatibility cache cleared');
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      debugPrint('❌ Cache clear error: $e');
      throw NeuralCompatibilityException('Failed to clear cache: $e');
    }
  }

  // Helper methods for data conversion
  Map<String, dynamic> _biometricStateToMap(BiometricState biometrics) {
    return <String, dynamic>{
      'heart_rate': biometrics.heartRate,
      'heart_rate_variability': biometrics.heartRateVariability,
      'electrodermal_activity': biometrics.electrodermalActivity,
      'body_temperature': 36.5, // Default body temperature (could be from biometrics)
      'respiratory_rate': 16.0, // Default respiratory rate
      'stress_level': biometrics.stress,
      'arousal_level': biometrics.arousal,
      'sleep_quality': 0.8, // Could be from sleep tracking
      'activity_level': 0.7, // Could be from activity tracking
      'timestamp': biometrics.timestamp.toIso8601String(),
    };
  }

  Map<String, dynamic> _behavioralProfileToMap(BehavioralProfile behavioral) {
    return <String, dynamic>{
      'communication_style': behavioral.communicationStyle,
      'social_energy': behavioral.socialEnergy,
      'risk_tolerance': behavioral.riskTolerance,
      'emotional_stability': behavioral.emotionalStability,
      'openness_to_experience': behavioral.opennessToExperience,
      'interaction_frequency': behavioral.interactionFrequency,
      'response_time_pattern': behavioral.responseTimePattern,
      'preferred_activity_types': behavioral.preferredActivityTypes,
    };
  }

  /// Trigger real-time compatibility update
  void triggerCompatibilityUpdate(CompatibilityUpdate update) {
    _compatibilityUpdateController.add(update);
  }

  /// Health check
  Future<bool> isHealthy() async {
    try {
      final http.Response response = await _httpClient.get(
        Uri.parse('$_baseUrl/health'),
        headers: <String, String>{'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
        return data['status'] == 'healthy' && data['neural_engine'] == true;
      }
      return false;
    } catch (e) {
      debugPrint('❌ Neural engine health check failed: $e');
      return false;
    }
  }

  /// Dispose resources
  void dispose() {
    _httpClient.close();
    _compatibilityUpdateController.close();
  }
}

/// Compatibility analysis result from neural network
class CompatibilityAnalysis {
  const CompatibilityAnalysis({
    required this.user1Id,
    required this.user2Id,
    required this.overallScore,
    required this.biometricHarmony,
    required this.behavioralSync,
    required this.communicationCompatibility,
    required this.energyLevelMatch,
    required this.stressComplementarity,
    required this.arousalCompatibility,
    required this.confidenceScore,
    required this.explanation,
    required this.timestamp,
    this.processingTimeMs,
  });

  factory CompatibilityAnalysis.fromJson(Map<String, dynamic> json) {
    return CompatibilityAnalysis(
      user1Id: json['user1_id'] as String,
      user2Id: json['user2_id'] as String,
      overallScore: (json['overall_score'] as num).toDouble(),
      biometricHarmony: (json['biometric_harmony'] as num).toDouble(),
      behavioralSync: (json['behavioral_sync'] as num).toDouble(),
      communicationCompatibility: (json['communication_compatibility'] as num).toDouble(),
      energyLevelMatch: (json['energy_level_match'] as num).toDouble(),
      stressComplementarity: (json['stress_complementarity'] as num).toDouble(),
      arousalCompatibility: (json['arousal_compatibility'] as num).toDouble(),
      confidenceScore: (json['confidence_score'] as num).toDouble(),
      explanation: Map<String, double>.from(
        (json['explanation'] as Map<String, dynamic>).map(
          (String key, value) => MapEntry(key, (value as num).toDouble()),
        ),
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      processingTimeMs: (json['processing_time_ms'] as num?)?.toDouble(),
    );
  }
  final String user1Id;
  final String user2Id;
  final double overallScore;
  final double biometricHarmony;
  final double behavioralSync;
  final double communicationCompatibility;
  final double energyLevelMatch;
  final double stressComplementarity;
  final double arousalCompatibility;
  final double confidenceScore;
  final Map<String, double> explanation;
  final DateTime timestamp;
  final double? processingTimeMs;

  /// Get compatibility level description
  String get compatibilityLevel {
    if (overallScore >= 0.8) return 'Quantum Resonance';
    if (overallScore >= 0.6) return 'High Compatibility';
    if (overallScore >= 0.4) return 'Moderate Compatibility';
    if (overallScore >= 0.2) return 'Low Compatibility';
    return 'Incompatible';
  }

  /// Get primary compatibility factor
  String get primaryFactor {
    final Map<String, double> factors = <String, double>{
      'Biometric': biometricHarmony,
      'Behavioral': behavioralSync,
      'Communication': communicationCompatibility,
      'Energy': energyLevelMatch,
    };

    final MapEntry<String, double> maxEntry = factors.entries.reduce(
      (MapEntry<String, double> a, MapEntry<String, double> b) => a.value > b.value ? a : b,
    );

    return maxEntry.key;
  }
}

/// Candidate user for batch prediction
class CandidateUser {
  const CandidateUser({
    required this.userId,
    required this.biometrics,
    required this.behavioral,
    required this.messages,
  });
  final String userId;
  final BiometricState biometrics;
  final BehavioralProfile behavioral;
  final List<String> messages;
}

/// Real-time compatibility update
class CompatibilityUpdate {
  const CompatibilityUpdate({
    required this.userId,
    required this.updatedMatches,
    required this.timestamp,
  });
  final String userId;
  final List<CompatibilityAnalysis> updatedMatches;
  final DateTime timestamp;
}

/// Neural engine statistics
class NeuralEngineStats {
  const NeuralEngineStats({
    required this.neuralEngineLoaded,
    required this.cacheEnabled,
    required this.timestamp, this.cacheKeys,
    this.cacheMemoryMb,
    this.cacheHits,
    this.cacheMisses,
  });

  factory NeuralEngineStats.fromJson(Map<String, dynamic> json) {
    return NeuralEngineStats(
      neuralEngineLoaded: json['neural_engine_loaded'] as bool,
      cacheEnabled: json['cache_enabled'] as bool,
      cacheKeys: json['cache_keys'] as int?,
      cacheMemoryMb: (json['cache_memory_mb'] as num?)?.toDouble(),
      cacheHits: json['cache_hits'] as int?,
      cacheMisses: json['cache_misses'] as int?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
  final bool neuralEngineLoaded;
  final bool cacheEnabled;
  final int? cacheKeys;
  final double? cacheMemoryMb;
  final int? cacheHits;
  final int? cacheMisses;
  final DateTime timestamp;

  double? get cacheHitRate {
    if (cacheHits == null || cacheMisses == null) return null;
    final int total = cacheHits! + cacheMisses!;
    if (total == 0) return null;
    return cacheHits! / total;
  }
}

/// Custom exception for neural compatibility errors
class NeuralCompatibilityException implements Exception {
  const NeuralCompatibilityException(this.message);
  final String message;

  @override
  String toString() => 'NeuralCompatibilityException: $message';
}

// Riverpod providers
final Provider<NeuralCompatibilityService> neuralCompatibilityServiceProvider =
    Provider<NeuralCompatibilityService>((ProviderRef<NeuralCompatibilityService> ref) {
  return NeuralCompatibilityService();
});

final FutureProvider<NeuralEngineStats> neuralEngineStatsProvider =
    FutureProvider<NeuralEngineStats>((FutureProviderRef<NeuralEngineStats> ref) async {
  final NeuralCompatibilityService service = ref.watch(neuralCompatibilityServiceProvider);
  return service.getStats();
});

final FutureProvider<bool> neuralEngineHealthProvider =
    FutureProvider<bool>((FutureProviderRef<bool> ref) async {
  final NeuralCompatibilityService service = ref.watch(neuralCompatibilityServiceProvider);
  return service.isHealthy();
});

final StreamProvider<CompatibilityUpdate> compatibilityUpdatesProvider =
    StreamProvider<CompatibilityUpdate>((StreamProviderRef<CompatibilityUpdate> ref) {
  final NeuralCompatibilityService service = ref.watch(neuralCompatibilityServiceProvider);
  return service.compatibilityUpdates;
});
