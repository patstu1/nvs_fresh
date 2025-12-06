// lib/features/live/application/nexus_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/core/api/unified_graphql_client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

// Provider for the current room state
final StateNotifierProvider<NexusRoomController, AsyncValue<NexusRoomState>> nexusRoomProvider =
    StateNotifierProvider<NexusRoomController, AsyncValue<NexusRoomState>>((
  StateNotifierProviderRef<NexusRoomController, AsyncValue<NexusRoomState>> ref,
) {
  return NexusRoomController(ref);
});

// Provider for global rooms discovery
final FutureProvider<List<GlobalRoom>> globalRoomsProvider =
    FutureProvider<List<GlobalRoom>>((FutureProviderRef<List<GlobalRoom>> ref) async {
  final GraphQLClient gqlClient = ref.watch(unifiedGraphQLClientProvider);

  const String query = '''
    query GetGlobalRooms {
      globalRooms {
        id
        name
        description
        participantCount
        maxParticipants
        city
        country
        latitude
        longitude
        audioStreamUrl
        theme
        tags
        isDiscoverable
      }
    }
  ''';

  final QueryResult<Object?> result = await gqlClient.query(
    QueryOptions(document: gql(query)),
  );

  if (result.hasException) {
    throw result.exception!;
  }

  final List roomsData = result.data?['globalRooms'] as List? ?? <dynamic>[];
  return roomsData.map((room) => GlobalRoom.fromJson(room)).toList();
});

// Provider for room participants
final StreamProviderFamily<List<RoomParticipant>, String> roomParticipantsProvider =
    StreamProvider.family<List<RoomParticipant>, String>(
        (StreamProviderRef<List<RoomParticipant>> ref, String roomId) {
  final GraphQLClient gqlClient = ref.watch(unifiedGraphQLClientProvider);

  const String subscription = r'''
    subscription OnRoomParticipantsUpdate($roomId: String!) {
      roomParticipantsUpdate(roomId: $roomId) {
        walletAddress
        displayName
        isVideoEnabled
        isAudioEnabled
        role
        joinedAt
        lastActive
        pinnedUsers
      }
    }
  ''';

  return gqlClient
      .subscribe(
    SubscriptionOptions(
      document: gql(subscription),
      variables: <String, dynamic>{'roomId': roomId},
    ),
  )
      .map((QueryResult<Object?> result) {
    if (result.hasException) {
      throw result.exception!;
    }

    final List participantsData = result.data?['roomParticipantsUpdate'] as List? ?? <dynamic>[];
    return participantsData.map((p) => RoomParticipant.fromJson(p)).toList();
  });
});

class NexusRoomController extends StateNotifier<AsyncValue<NexusRoomState>> {
  NexusRoomController(this._ref) : super(const AsyncValue.loading());
  final Ref _ref;

  Future<void> joinRoom(String roomId) async {
    try {
      state = const AsyncValue.loading();

      final GraphQLClient gqlClient = _ref.read(unifiedGraphQLClientProvider);

      const String mutation = r'''
        mutation JoinRoom($roomId: String!) {
          joinRoom(roomId: $roomId) {
            success
            room {
              id
              name
              description
              audioStreamUrl
              participantCount
              maxParticipants
            }
          }
        }
      ''';

      final QueryResult<Object?> result = await gqlClient.mutate(
        MutationOptions(
          document: gql(mutation),
          variables: <String, dynamic>{'roomId': roomId},
        ),
      );

      if (result.hasException) {
        state = AsyncValue.error(result.exception!, StackTrace.current);
        return;
      }

      final roomData = result.data?['joinRoom']['room'];
      if (roomData != null) {
        state = AsyncValue.data(NexusRoomState.fromJson(roomData));
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> leaveRoom() async {
    try {
      final GraphQLClient gqlClient = _ref.read(unifiedGraphQLClientProvider);

      const String mutation = '''
        mutation LeaveRoom {
          leaveRoom {
            success
          }
        }
      ''';

      await gqlClient.mutate(
        MutationOptions(document: gql(mutation)),
      );

      state = AsyncValue.data(NexusRoomState.empty());
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> sendRoomMessage(String content) async {
    try {
      final GraphQLClient gqlClient = _ref.read(unifiedGraphQLClientProvider);

      const String mutation = r'''
        mutation SendRoomMessage($content: String!) {
          sendRoomMessage(content: $content) {
            id
            content
            senderWalletAddress
            timestamp
          }
        }
      ''';

      await gqlClient.mutate(
        MutationOptions(
          document: gql(mutation),
          variables: <String, dynamic>{'content': content},
        ),
      );
    } catch (e) {
      print('Error sending room message: $e');
    }
  }

  Future<void> sendWhisper(String toWalletAddress, String content) async {
    try {
      final GraphQLClient gqlClient = _ref.read(unifiedGraphQLClientProvider);

      const String mutation = r'''
        mutation SendWhisper($toWalletAddress: String!, $content: String!) {
          sendWhisper(toWalletAddress: $toWalletAddress, content: $content) {
            id
            content
            fromWalletAddress
            toWalletAddress
            timestamp
          }
        }
      ''';

      await gqlClient.mutate(
        MutationOptions(
          document: gql(mutation),
          variables: <String, dynamic>{
            'toWalletAddress': toWalletAddress,
            'content': content,
          },
        ),
      );
    } catch (e) {
      print('Error sending whisper: $e');
    }
  }

  Future<void> createBreakoutRoom(String withWalletAddress) async {
    try {
      final GraphQLClient gqlClient = _ref.read(unifiedGraphQLClientProvider);

      const String mutation = r'''
        mutation CreateBreakoutRoom($withWalletAddress: String!) {
          createBreakoutRoom(withWalletAddress: $withWalletAddress) {
            sessionId
            participant1Wallet
            participant2Wallet
          }
        }
      ''';

      final QueryResult<Object?> result = await gqlClient.mutate(
        MutationOptions(
          document: gql(mutation),
          variables: <String, dynamic>{'withWalletAddress': withWalletAddress},
        ),
      );

      if (result.hasException) {
        throw result.exception!;
      }

      final breakoutData = result.data?['createBreakoutRoom'];
      if (breakoutData != null) {
        // Wire LiveKit breakout flow using sessionId
        print("Breakout room created: ${breakoutData['sessionId']}");
      }
    } catch (e) {
      print('Error creating breakout room: $e');
    }
  }

  Future<void> pinUser(String walletAddress) async {
    // TODO: Update user's pinned list
    print('Pinning user: $walletAddress');
  }

  Future<void> unpinUser(String walletAddress) async {
    // TODO: Remove user from pinned list
    print('Unpinning user: $walletAddress');
  }
}

class NexusRoomState {
  const NexusRoomState({
    required this.id,
    required this.name,
    required this.description,
    required this.participantCount,
    required this.maxParticipants,
    required this.tags,
    this.audioStreamUrl,
    this.city,
    this.country,
  });

  factory NexusRoomState.empty() => const NexusRoomState(
        id: '',
        name: '',
        description: '',
        participantCount: 0,
        maxParticipants: 0,
        tags: <String>[],
      );

  factory NexusRoomState.fromJson(Map<String, dynamic> json) => NexusRoomState(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        audioStreamUrl: json['audioStreamUrl'],
        participantCount: json['participantCount'] ?? 0,
        maxParticipants: json['maxParticipants'] ?? 0,
        city: json['city'],
        country: json['country'],
        tags: List<String>.from(json['tags'] ?? <dynamic>[]),
      );
  final String id;
  final String name;
  final String description;
  final String? audioStreamUrl;
  final int participantCount;
  final int maxParticipants;
  final String? city;
  final String? country;
  final List<String> tags;
}

class GlobalRoom {
  const GlobalRoom({
    required this.id,
    required this.name,
    required this.description,
    required this.participantCount,
    required this.maxParticipants,
    required this.theme,
    required this.tags,
    required this.isDiscoverable,
    this.city,
    this.country,
    this.latitude,
    this.longitude,
    this.audioStreamUrl,
  });

  factory GlobalRoom.fromJson(Map<String, dynamic> json) => GlobalRoom(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        participantCount: json['participantCount'],
        maxParticipants: json['maxParticipants'],
        city: json['city'],
        country: json['country'],
        latitude: json['latitude']?.toDouble(),
        longitude: json['longitude']?.toDouble(),
        audioStreamUrl: json['audioStreamUrl'],
        theme: json['theme'],
        tags: List<String>.from(json['tags'] ?? <dynamic>[]),
        isDiscoverable: json['isDiscoverable'],
      );
  final String id;
  final String name;
  final String description;
  final int participantCount;
  final int maxParticipants;
  final String? city;
  final String? country;
  final double? latitude;
  final double? longitude;
  final String? audioStreamUrl;
  final String theme;
  final List<String> tags;
  final bool isDiscoverable;
}

class RoomParticipant {
  const RoomParticipant({
    required this.walletAddress,
    required this.displayName,
    required this.isVideoEnabled,
    required this.isAudioEnabled,
    required this.role,
    required this.joinedAt,
    required this.lastActive,
    required this.pinnedUsers,
  });

  factory RoomParticipant.fromJson(Map<String, dynamic> json) => RoomParticipant(
        walletAddress: json['walletAddress'],
        displayName: json['displayName'],
        isVideoEnabled: json['isVideoEnabled'],
        isAudioEnabled: json['isAudioEnabled'],
        role: json['role'],
        joinedAt: DateTime.parse(json['joinedAt']),
        lastActive: DateTime.parse(json['lastActive']),
        pinnedUsers: List<String>.from(json['pinnedUsers'] ?? <dynamic>[]),
      );
  final String walletAddress;
  final String displayName;
  final bool isVideoEnabled;
  final bool isAudioEnabled;
  final String role;
  final DateTime joinedAt;
  final DateTime lastActive;
  final List<String> pinnedUsers;
}
