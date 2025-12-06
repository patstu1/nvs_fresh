// lib/features/live/application/live_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart'; // For getting device location
import 'package:gql/src/ast/ast.dart';
import 'package:nvs/core/api/unified_graphql_client.dart';
import 'package:nvs/core/models/user_profile.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

// Provider to get the current device position
final StreamProvider<Position> positionProvider =
    StreamProvider<Position>((StreamProviderRef<Position> ref) {
  return Geolocator.getPositionStream();
});

// The main provider for the Live screen
final StreamProvider<ProximitySphereUpdate> proximitySphereProvider =
    StreamProvider<ProximitySphereUpdate>((StreamProviderRef<ProximitySphereUpdate> ref) {
  final AsyncValue<Position> positionAsyncValue = ref.watch(positionProvider);

  // Only start the GraphQL subscription when we have a valid location
  return positionAsyncValue.when(
    data: (Position position) {
      final GraphQLClient gqlClient = ref.watch(unifiedGraphQLClientProvider);

      // Define the GraphQL subscription
      final DocumentNode subscriptionRequest = gql(r'''
        subscription OnProximitySphereUpdate($latitude: Float!, $longitude: Float!) {
          proximitySphereUpdate(latitude: $latitude, longitude: $longitude) {
            users {
              walletAddress
              ipfsDataUri
            }
            messages {
              id
              senderWalletAddress
              content
              messageType
            }
          }
        }
      ''');

      // Start the subscription
      return gqlClient
          .subscribe(
        Operation(
          document: subscriptionRequest,
          variables: <String, double>{
            'latitude': position.latitude,
            'longitude': position.longitude,
          },
        ),
      )
          .map((QueryResult result) {
        if (result.hasException) {
          throw result.exception!;
        }

        // Parse the response data
        final data = result.data?['proximitySphereUpdate'];
        if (data == null) return ProximitySphereUpdate.empty();

        final List<UserProfile> users = (data['users'] as List? ?? <dynamic>[])
            .map(
              (u) => UserProfile(
                walletAddress: u['walletAddress'],
                ipfsDataUri: u['ipfsDataUri'],
              ),
            )
            .toList();

        final List<SphereMessage> messages = (data['messages'] as List? ?? <dynamic>[])
            .map(
              (m) => SphereMessage(
                id: m['id'],
                senderWalletAddress: m['senderWalletAddress'],
                content: m['content'],
                messageType: m['messageType'],
              ),
            )
            .toList();

        return ProximitySphereUpdate(users: users, messages: messages);
      });
    },
    loading: () => Stream.value(ProximitySphereUpdate.empty()),
    error: Stream.error,
  );
});

// Data class for the update
class ProximitySphereUpdate {
  const ProximitySphereUpdate({required this.users, required this.messages});

  factory ProximitySphereUpdate.empty() =>
      const ProximitySphereUpdate(users: <dynamic>[], messages: <SphereMessage>[]);
  final List<UserProfile> users;
  final List<SphereMessage> messages;
}

// Data class for sphere messages
class SphereMessage {
  const SphereMessage({
    required this.id,
    required this.senderWalletAddress,
    required this.content,
    required this.messageType,
  });
  final String id;
  final String senderWalletAddress;
  final String content;
  final String messageType;
}
