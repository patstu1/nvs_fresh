// lib/features/now/application/metacity_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gql/src/ast/ast.dart';
import 'package:nvs/core/api/unified_graphql_client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

// The provider that will feed live JSON data to the Unity view.
final StreamProvider<String> metacityDataProvider =
    StreamProvider<String>((StreamProviderRef<String> ref) {
  final GraphQLClient gqlClient = ref.watch(unifiedGraphQLClientProvider);

  // Define the GraphQL subscription query
  final DocumentNode subscriptionRequest = gql('''
    subscription OnMetacityUpdate {
      metacityUpdate {
        # The backend sends a pre-formatted JSON string containing all
        # user positions, clusters, auras, etc. This is efficient.
        jsonData
      }
    }
  ''');

  final Stream<QueryResult<Object?>> stream =
      gqlClient.subscribe(SubscriptionOptions(document: subscriptionRequest));

  // Map the GraphQL result to the raw JSON string that Unity will consume.
  return stream.map((QueryResult<Object?> result) {
    if (result.hasException) {
      print(result.exception.toString());
      return '{}'; // Return empty JSON on error
    }
    if (result.data == null) {
      return '{}';
    }
    return result.data!['metacityUpdate']['jsonData'] as String;
  });
});
