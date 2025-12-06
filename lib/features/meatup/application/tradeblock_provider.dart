// lib/features/meatup/application/tradeblock_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:nvs/core/api/unified_graphql_client.dart';
// Using a local lightweight user model for Meatup grid rendering

final StateNotifierProvider<MeatupController, AsyncValue<List<ProfileWithScore>>>
    meatupControllerProvider =
    StateNotifierProvider<MeatupController, AsyncValue<List<ProfileWithScore>>>((
  StateNotifierProviderRef<MeatupController, AsyncValue<List<ProfileWithScore>>> ref,
) {
  return MeatupController(ref);
});

class MeatupController extends StateNotifier<AsyncValue<List<ProfileWithScore>>> {
  MeatupController(this._ref) : super(const AsyncLoading()) {
    fetchInitialProfiles();
  }
  final Ref _ref;
  int _offset = 0;
  bool _isLoading = false;
  static const int _pageSize = 20;

  Future<void> fetchInitialProfiles() async {
    state = const AsyncLoading();
    _offset = 0;
    await _fetchProfiles();
  }

  Future<void> fetchMoreProfiles() async {
    if (_isLoading || state is AsyncLoading) return;
    _isLoading = true;
    _offset += _pageSize;
    await _fetchProfiles(isPaginating: true);
    _isLoading = false;
  }

  Future<void> _fetchProfiles({bool isPaginating = false}) async {
    try {
      final GraphQLClient client = _ref.read(unifiedGraphQLClientProvider);

      const String query = r'''
        query GetMeatupProfiles($limit: Int!, $offset: Int!, $sortBy: String, $filters: ProfileFilters) {
          getMeatupProfiles(limit: $limit, offset: $offset, sortBy: $sortBy, filters: $filters) {
            profiles {
              id
              walletAddress
              displayName
              age
              location
              bio
              profileImages
              interests
              preferences {
                ageMin
                ageMax
                lookingFor
                tribes
              }
              stats {
                profileViews
                compatibility
                trustScore
              }
              status {
                isOnline
                lastActive
                isVerified
              }
              subscription {
                tier
                isActive
                features
              }
            }
            compatibilityScores {
              userId
              score
              factors {
                interests
                location
                age
                lifestyle
                astrology
              }
            }
            hasMore
            total
          }
        }
      ''';

      final QueryResult<Object?> result = await client.query(
        QueryOptions(
          document: gql(query),
          variables: <String, dynamic>{
            'limit': _pageSize,
            'offset': _offset,
            'sortBy': 'compatibility_desc',
            'filters': const <String, Object>{
              'isOnline': true,
              'hasProfileImage': true,
              'verificationLevel': 'basic',
            },
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        throw result.exception!;
      }

      final data = result.data?['getMeatupProfiles'];
      if (data == null) {
        throw Exception('No data received from server');
      }

      final List profilesData = data['profiles'] as List;
      final List scoresData = data['compatibilityScores'] as List;

      // Create score lookup map
      final Map<String, double> scoresMap = <String, double>{};
      for (final scoreItem in scoresData) {
        final String userId = (scoreItem['userId'] ?? '').toString();
        scoresMap[userId] = (scoreItem['score'] as num).toDouble();
      }

      // Create ProfileWithScore objects
      final List<ProfileWithScore> newProfiles = profilesData.map((profileData) {
        final Map<String, dynamic> data = profileData as Map<String, dynamic>;
        final MeatupUser profile = MeatupUser(
          walletAddress: (data['walletAddress'] ?? data['id'] ?? '').toString(),
          ipfsDataUri: data['ipfsDataUri'] as String?,
          verificationStatus: data['verificationStatus'] as String?,
          gridPhotoURL: (data['offChainData'] != null)
              ? (data['offChainData']['gridPhotoURL'] as String?)
              : null,
        );
        final double score = scoresMap[profile.walletAddress] ?? 0.0;
        return ProfileWithScore(profile, score);
      }).toList();

      // Sort by compatibility score descending
      newProfiles.sort(
        (ProfileWithScore a, ProfileWithScore b) => b.score.compareTo(a.score),
      );

      if (isPaginating) {
        final List<ProfileWithScore> currentProfiles = state.value ?? <ProfileWithScore>[];
        state = AsyncData(<ProfileWithScore>[...currentProfiles, ...newProfiles]);
      } else {
        state = AsyncData(newProfiles);
      }
    } catch (e, st) {
      if (isPaginating) {
        // Don't override existing data on pagination error
        _offset -= _pageSize; // Reset offset
      } else {
        state = AsyncError(e, st);
      }
    }
  }

  Future<void> refreshProfiles() async {
    _offset = 0;
    await _fetchProfiles();
  }

  void updateProfileScore(String profileId, double newScore) {
    final List<ProfileWithScore>? currentState = state.value;
    if (currentState == null) return;

    final List<ProfileWithScore> updatedProfiles =
        currentState.map((ProfileWithScore profileWithScore) {
      if (profileWithScore.profile.walletAddress == profileId) {
        return ProfileWithScore(profileWithScore.profile, newScore);
      }
      return profileWithScore;
    }).toList();

    // Re-sort by score
    updatedProfiles.sort(
      (ProfileWithScore a, ProfileWithScore b) => b.score.compareTo(a.score),
    );
    state = AsyncData(updatedProfiles);
  }
}

class MeatupUser {
  const MeatupUser({
    required this.walletAddress,
    this.ipfsDataUri,
    this.verificationStatus,
    this.gridPhotoURL,
  });
  final String walletAddress;
  final String? ipfsDataUri;
  final String? verificationStatus;
  final String? gridPhotoURL;
}

class ProfileWithScore {
  const ProfileWithScore(this.profile, this.score);
  final MeatupUser profile;
  final double score;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileWithScore &&
          runtimeType == other.runtimeType &&
          profile.walletAddress == other.profile.walletAddress &&
          score == other.score;

  @override
  int get hashCode => profile.walletAddress.hashCode ^ score.hashCode;

  @override
  String toString() => 'ProfileWithScore(${profile.walletAddress}, score: $score)';
}
