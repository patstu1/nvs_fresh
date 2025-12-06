// lib/core/api/unified_graphql_client.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/foundation.dart';

/// Unified GraphQL client provider for NVS enterprise operations
/// Handles authentication, caching, and real-time subscriptions
final Provider<GraphQLClient> unifiedGraphQLClientProvider =
    Provider<GraphQLClient>((ref) {
  return _createGraphQLClient();
});

GraphQLClient _createGraphQLClient() {
  // Configure HTTP link with authentication
  final HttpLink httpLink = HttpLink(
    _getGraphQLEndpoint(),
    defaultHeaders: <String, String>{
      'Content-Type': 'application/json',
      'User-Agent': 'NVS-Flutter/1.0.0',
    },
  );

  // Configure auth link for token management
  final AuthLink authLink = AuthLink(
    getToken: () async {
      // TODO: Implement actual token retrieval
      return 'Bearer token';
    },
  );

  // Combine links for authentication
  final Link link = authLink.concat(httpLink);

  // Configure caching
  final GraphQLCache cache = GraphQLCache(store: InMemoryStore());

  return GraphQLClient(
    link: link,
    cache: cache,
  );
}

String _getGraphQLEndpoint() {
  if (kDebugMode) {
    return 'http://localhost:4000/graphql';
  }
  return 'https://api.nvs.app/graphql';
}

/// Enterprise error handling for GraphQL operations
class GraphQLErrorHandler {
  static void handleQueryError(OperationException exception) {
    if (kDebugMode) {
      print('GraphQL Query Error: ${exception.toString()}');
    }
  }

  static void handleMutationError(OperationException exception) {
    if (kDebugMode) {
      print('GraphQL Mutation Error: ${exception.toString()}');
    }
  }
}
