// lib/features/connect/data/ai_matchmaking_service.dart
import 'dart:async';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/compatibility_match.dart';
import '../../messages/data/graphql_client.dart';

class AIMatchmakingService {
  final GraphQLClient _client = NVSGraphQLClient.client;

  /// Find compatible matches using the NVS Synaptic Core
  Future<List<CompatibilityMatch>> findMatches({int limit = 50}) async {
    final QueryOptions options = QueryOptions(
      document: gql(MatchmakingQueries.findMatches),
      variables: <String, dynamic>{'limit': limit},
      fetchPolicy: FetchPolicy.networkOnly, // Always get fresh AI results
    );

    final QueryResult result = await _client.query(options);

    if (result.hasException) {
      throw MatchmakingException(
        'Failed to fetch matches: ${result.exception}',
      );
    }

    final List<dynamic> matchesJson = result.data?['findMatches'] ?? <dynamic>[];
    return matchesJson.map((json) => CompatibilityMatch.fromJson(json)).toList();
  }

  /// Refresh user's vector embedding in the AI system
  Future<void> refreshUserEmbedding() async {
    final MutationOptions options = MutationOptions(
      document: gql(MatchmakingQueries.refreshEmbedding),
      fetchPolicy: FetchPolicy.networkOnly,
    );

    final QueryResult result = await _client.mutate(options);

    if (result.hasException) {
      throw MatchmakingException(
        'Failed to refresh embedding: ${result.exception}',
      );
    }
  }

  /// Get detailed compatibility analysis between two users
  Future<CompatibilityAnalysis> analyzeCompatibility(
    String targetWalletAddress,
  ) async {
    final QueryOptions options = QueryOptions(
      document: gql(MatchmakingQueries.analyzeCompatibility),
      variables: <String, dynamic>{'targetWalletAddress': targetWalletAddress},
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );

    final QueryResult result = await _client.query(options);

    if (result.hasException) {
      throw MatchmakingException(
        'Failed to analyze compatibility: ${result.exception}',
      );
    }

    final analysisJson = result.data?['analyzeCompatibility'];
    if (analysisJson == null) {
      throw const MatchmakingException('No compatibility analysis returned');
    }

    return CompatibilityAnalysis.fromJson(analysisJson);
  }

  /// Stream real-time compatibility updates (for live radar)
  Stream<List<CompatibilityMatch>> watchMatches({int limit = 50}) async* {
    // Initial fetch
    yield await findMatches(limit: limit);

    // Set up periodic refresh (every 30 seconds for live updates)
    final Stream timer = Stream.periodic(const Duration(seconds: 30));

    await for (final _ in timer) {
      try {
        yield await findMatches(limit: limit);
      } catch (e) {
        // Continue with existing data on error
        print('Failed to refresh matches: $e');
      }
    }
  }
}

/// GraphQL queries for the AI matchmaking system
class MatchmakingQueries {
  static const String findMatches = r'''
    query FindMatches($limit: Int = 50) {
      findMatches(limit: $limit) {
        userProfile {
          walletAddress
          username
          displayName
          avatarUrl
          age
          location
          astroProfile {
            sunSign
            moonSign
            risingSign
            planetaryPositions
          }
          tags
          roles
          biometrics {
            avgHeartRateVariability
            restingHeartRate
            temperatureDelta
            stressBaseline
            energyPattern
          }
          behavioral {
            sessionLength
            messageRatio
            appOpenFrequency
            interactionDepth
            socialRadius
            activityPatterns
          }
        }
        score
        breakdown {
          astrologicalAlignment
          roleCompatibility
          biometricResonance
          behavioralSynergy
          semanticSimilarity
        }
        generatedAt
      }
    }
  ''';

  static const String refreshEmbedding = '''
    mutation RefreshUserEmbedding {
      refreshUserEmbedding {
        success
        vectorDimension
        lastUpdated
      }
    }
  ''';

  static const String analyzeCompatibility = r'''
    query AnalyzeCompatibility($targetWalletAddress: String!) {
      analyzeCompatibility(targetWalletAddress: $targetWalletAddress) {
        score
        breakdown {
          astrologicalAlignment
          roleCompatibility
          biometricResonance
          behavioralSynergy
          semanticSimilarity
        }
        recommendations
        riskFactors
        bondingPotential
      }
    }
  ''';
}

/// Detailed compatibility analysis between two specific users
class CompatibilityAnalysis {
  const CompatibilityAnalysis({
    required this.score,
    required this.breakdown,
    required this.recommendations,
    required this.riskFactors,
    required this.bondingPotential,
  });

  factory CompatibilityAnalysis.fromJson(Map<String, dynamic> json) {
    return CompatibilityAnalysis(
      score: (json['score'] as num).toDouble(),
      breakdown: CompatibilityBreakdown.fromJson(json['breakdown']),
      recommendations: List<String>.from(json['recommendations'] ?? <dynamic>[]),
      riskFactors: List<String>.from(json['riskFactors'] ?? <dynamic>[]),
      bondingPotential: json['bondingPotential'] ?? '',
    );
  }
  final double score;
  final CompatibilityBreakdown breakdown;
  final List<String> recommendations;
  final List<String> riskFactors;
  final String bondingPotential;
}

/// Custom exception for matchmaking errors
class MatchmakingException implements Exception {
  const MatchmakingException(this.message);
  final String message;

  @override
  String toString() => 'MatchmakingException: $message';
}

// Riverpod providers for dependency injection
final Provider<AIMatchmakingService> aiMatchmakingServiceProvider =
    Provider<AIMatchmakingService>((ProviderRef<AIMatchmakingService> ref) {
  return AIMatchmakingService();
});

final FutureProvider<List<CompatibilityMatch>> compatibilityMatchesProvider =
    FutureProvider<List<CompatibilityMatch>>(
        (FutureProviderRef<List<CompatibilityMatch>> ref) async {
  final AIMatchmakingService service = ref.read(aiMatchmakingServiceProvider);
  return service.findMatches();
});

final StreamProvider<List<CompatibilityMatch>> compatibilityMatchesStreamProvider =
    StreamProvider<List<CompatibilityMatch>>((StreamProviderRef<List<CompatibilityMatch>> ref) {
  final AIMatchmakingService service = ref.read(aiMatchmakingServiceProvider);
  return service.watchMatches();
});

final FutureProviderFamily<CompatibilityAnalysis, String> compatibilityAnalysisProvider =
    FutureProvider.family<CompatibilityAnalysis, String>((
  FutureProviderRef<CompatibilityAnalysis> ref,
  String walletAddress,
) async {
  final AIMatchmakingService service = ref.read(aiMatchmakingServiceProvider);
  return service.analyzeCompatibility(walletAddress);
});
