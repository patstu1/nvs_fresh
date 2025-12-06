// lib/features/messages/data/graphql_client.dart
import 'package:graphql_flutter/graphql_flutter.dart';

class NVSGraphQLClient {
  static GraphQLClient? _client;
  // Endpoint can be overridden at build time:
  // flutter run --dart-define=NVS_GQL_ENDPOINT=api.yourdomain/graphql --dart-define=NVS_GQL_TOKEN=...
  static const String _endpointEnv = String.fromEnvironment(
    'NVS_GQL_ENDPOINT',
    // Use local gateway by default in debug/dev; can be overridden via --dart-define
    defaultValue: 'http://localhost:4000/graphql',
  );

  static GraphQLClient get client {
    if (_client == null) {
      _initializeClient();
    }
    return _client!;
  }

  static void _initializeClient() {
    // Resolve URIs based on endpoint
    final bool isExplicitHttp =
        _endpointEnv.startsWith('http://') || _endpointEnv.startsWith('https://');
    final bool isExplicitWs = _endpointEnv.startsWith('ws://') || _endpointEnv.startsWith('wss://');
    final bool isLocal = _endpointEnv.contains('localhost') || _endpointEnv.contains('127.0.0.1');

    final String httpUri = isExplicitHttp
        ? _endpointEnv
        : (isLocal ? 'http://$_endpointEnv' : 'https://$_endpointEnv');
    final String wsUri = isExplicitWs
        ? _endpointEnv
        : (isLocal
            ? (httpUri.startsWith('https://')
                ? httpUri.replaceFirst('https://', 'wss://')
                : httpUri.replaceFirst('http://', 'ws://'))
            : (httpUri.startsWith('https://')
                ? httpUri.replaceFirst('https://', 'wss://')
                : httpUri.replaceFirst('http://', 'ws://')));

    // HTTP Link for queries and mutations
    final HttpLink httpLink = HttpLink(
      httpUri,
      defaultHeaders: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    // WebSocket Link for subscriptions
    final WebSocketLink websocketLink = WebSocketLink(
      wsUri,
      config: const SocketClientConfig(
        initialPayload: <String, dynamic>{},
      ),
    );

    // Auth Link for JWT tokens
    final AuthLink authLink = AuthLink(
      getToken: () async {
        // Token can be provided via dart-define. Falls back to provided token.
        const String tokenEnv = String.fromEnvironment(
          'NVS_GQL_TOKEN',
          defaultValue: 'ca8917bb803049268aa18c074a58e8de',
        );
        if (tokenEnv.isEmpty) return null;
        return tokenEnv.startsWith('Bearer ') ? tokenEnv : 'Bearer $tokenEnv';
      },
    );

    // Combine links: Auth -> HTTP for queries/mutations, WebSocket for subscriptions
    final Link link = Link.split(
      (Request request) => request.isSubscription,
      websocketLink,
      authLink.concat(httpLink),
    );

    // Create client with optimistic caching
    _client = GraphQLClient(
      link: link,
      cache: GraphQLCache(store: InMemoryStore()),
    );
  }

  // Dispose of the client and close connections
  static void dispose() {
    _client?.cache.store.reset();
    _client = null;
  }

  // Helper method to handle authentication errors
  static bool isAuthError(OperationException exception) {
    return exception.graphqlErrors.any(
      (GraphQLError error) => error.extensions?['code'] == 'UNAUTHENTICATED',
    );
  }
}

// GraphQL Query and Mutation Strings
class MessageQueries {
  static const String getMyThreads = '''
    query GetMyThreads {
      myThreads {
        id
        participants {
          walletAddress
          username
          avatarUrl
        }
        lastMessage {
          id
          threadId
          senderWalletAddress
          content
          messageType
          context
          createdAt
          replyToId
        }
        createdAt
        unreadCount
        isFavorite
      }
    }
  ''';

  static const String getMessages = r'''
    query GetMessages($threadId: ID!, $limit: Int = 50, $before: String) {
      messages(threadId: $threadId, limit: $limit, before: $before) {
        id
        threadId
        senderWalletAddress
        content
        messageType
        context
        createdAt
        replyToId
      }
    }
  ''';

  static const String sendMessage = r'''
    mutation SendMessage($threadId: ID!, $content: String!, $messageType: String!, $context: String!) {
      sendMessage(threadId: $threadId, content: $content, messageType: $messageType, context: $context) {
        id
        threadId
        senderWalletAddress
        content
        messageType
        context
        createdAt
        replyToId
      }
    }
  ''';

  static const String subscribeToNewMessages = r'''
    subscription OnNewMessage($threadId: ID!) {
      onNewMessage(threadId: $threadId) {
        id
        threadId
        senderWalletAddress
        content
        messageType
        context
        createdAt
        replyToId
      }
    }
  ''';
}
