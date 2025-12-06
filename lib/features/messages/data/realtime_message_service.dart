// lib/features/messages/data/realtime_message_service.dart
import 'dart:async';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/message.dart';
import '../domain/models/message_thread.dart';
import 'graphql_client.dart';

class RealtimeMessageService {
  final GraphQLClient _client = NVSGraphQLClient.client;
  final Map<String, StreamSubscription> _subscriptions = <String, StreamSubscription>{};
  final Map<String, StreamController<Message>> _messageControllers =
      <String, StreamController<Message>>{};

  // Fetch all threads for the current user
  Future<List<MessageThread>> getMyThreads() async {
    final QueryOptions options = QueryOptions(
      document: gql(MessageQueries.getMyThreads),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );

    final QueryResult result = await _client.query(options);

    if (result.hasException) {
      throw Exception('Failed to fetch threads: ${result.exception}');
    }

    final List<dynamic> threadsJson = result.data?['myThreads'] ?? <dynamic>[];
    return threadsJson.map((json) => MessageThread.fromJson(json)).toList();
  }

  // Fetch messages for a specific thread with pagination
  Future<List<Message>> getMessages(
    String threadId, {
    int limit = 50,
    String? before,
  }) async {
    final QueryOptions options = QueryOptions(
      document: gql(MessageQueries.getMessages),
      variables: <String, dynamic>{
        'threadId': threadId,
        'limit': limit,
        if (before != null) 'before': before,
      },
      fetchPolicy: FetchPolicy.cacheFirst,
    );

    final QueryResult result = await _client.query(options);

    if (result.hasException) {
      throw Exception('Failed to fetch messages: ${result.exception}');
    }

    final List<dynamic> messagesJson = result.data?['messages'] ?? <dynamic>[];
    return messagesJson.map((json) => Message.fromJson(json)).toList();
  }

  // Send a new message
  Future<Message> sendMessage({
    required String threadId,
    required String content,
    required MessageType type,
    required ChatContextType context,
    String? replyToId,
  }) async {
    final MutationOptions options = MutationOptions(
      document: gql(MessageQueries.sendMessage),
      variables: <String, dynamic>{
        'threadId': threadId,
        'content': content,
        'messageType': type.toString().split('.').last,
        'context': context.toString().split('.').last,
      },
      fetchPolicy: FetchPolicy.networkOnly,
    );

    final QueryResult result = await _client.mutate(options);

    if (result.hasException) {
      throw Exception('Failed to send message: ${result.exception}');
    }

    final messageJson = result.data?['sendMessage'];
    if (messageJson == null) {
      throw Exception('No message returned from mutation');
    }

    return Message.fromJson(messageJson);
  }

  // Subscribe to real-time messages for a thread
  Stream<Message> subscribeToMessages(String threadId) {
    // Return existing stream if already subscribed
    if (_messageControllers.containsKey(threadId)) {
      return _messageControllers[threadId]!.stream;
    }

    // Create new stream controller
    final StreamController<Message> controller = StreamController<Message>.broadcast();
    _messageControllers[threadId] = controller;

    // Create GraphQL subscription
    final SubscriptionOptions options = SubscriptionOptions(
      document: gql(MessageQueries.subscribeToNewMessages),
      variables: <String, dynamic>{'threadId': threadId},
    );

    final Stream<QueryResult> subscription = _client.subscribe(options);

    _subscriptions[threadId] = subscription.listen(
      (QueryResult result) {
        if (result.hasException) {
          controller.addError(result.exception!);
          return;
        }

        final messageJson = result.data?['onNewMessage'];
        if (messageJson != null) {
          try {
            final Message message = Message.fromJson(messageJson);
            controller.add(message);
          } catch (e) {
            controller.addError(e);
          }
        }
      },
      onError: (error) {
        controller.addError(error);
      },
      onDone: () {
        controller.close();
        _cleanup(threadId);
      },
    );

    return controller.stream;
  }

  // Unsubscribe from a thread's messages
  void unsubscribeFromMessages(String threadId) {
    _cleanup(threadId);
  }

  // Clean up subscriptions and controllers
  void _cleanup(String threadId) {
    _subscriptions[threadId]?.cancel();
    _subscriptions.remove(threadId);

    _messageControllers[threadId]?.close();
    _messageControllers.remove(threadId);
  }

  // Dispose all resources
  void dispose() {
    for (final StreamSubscription subscription in _subscriptions.values) {
      subscription.cancel();
    }
    _subscriptions.clear();

    for (final StreamController<Message> controller in _messageControllers.values) {
      controller.close();
    }
    _messageControllers.clear();
  }

  // Context-aware helper methods for different chat types
  Future<Message> sendGridMessage(String threadId, String content) {
    return sendMessage(
      threadId: threadId,
      content: content,
      type: MessageType.text,
      context: ChatContextType.grid,
    );
  }

  Future<Message> sendNowMessage(String threadId, String content) {
    return sendMessage(
      threadId: threadId,
      content: content,
      type: MessageType.text,
      context: ChatContextType.now,
    );
  }

  Future<Message> sendConnectMessage(String threadId, String content) {
    return sendMessage(
      threadId: threadId,
      content: content,
      type: MessageType.text,
      context: ChatContextType.connect,
    );
  }

  Future<Message> sendLiveMessage(String threadId, String content) {
    return sendMessage(
      threadId: threadId,
      content: content,
      type: MessageType.text,
      context: ChatContextType.live,
    );
  }

  Future<Message> sendDirectMessage(String threadId, String content) {
    return sendMessage(
      threadId: threadId,
      content: content,
      type: MessageType.text,
      context: ChatContextType.direct,
    );
  }

  // Bio-Neural Sync pipeline method - for future haptic/sentiment data
  Future<Message> sendHapticWhisper(String threadId, String hapticData) {
    return sendMessage(
      threadId: threadId,
      content: hapticData,
      type: MessageType.haptic_whisper,
      context: ChatContextType.live,
    );
  }
}

// Riverpod providers for dependency injection
final Provider<RealtimeMessageService> realtimeMessageServiceProvider =
    Provider<RealtimeMessageService>((ProviderRef<RealtimeMessageService> ref) {
  final RealtimeMessageService service = RealtimeMessageService();
  ref.onDispose(service.dispose);
  return service;
});

final FutureProvider<List<MessageThread>> myThreadsProvider =
    FutureProvider<List<MessageThread>>((FutureProviderRef<List<MessageThread>> ref) async {
  final RealtimeMessageService service = ref.read(realtimeMessageServiceProvider);
  return service.getMyThreads();
});

final FutureProviderFamily<List<Message>, String> messagesProvider =
    FutureProvider.family<List<Message>, String>(
        (FutureProviderRef<List<Message>> ref, String threadId) async {
  final RealtimeMessageService service = ref.read(realtimeMessageServiceProvider);
  return service.getMessages(threadId);
});

final StreamProviderFamily<Message, String> messageStreamProvider =
    StreamProvider.family<Message, String>((StreamProviderRef<Message> ref, String threadId) {
  final RealtimeMessageService service = ref.read(realtimeMessageServiceProvider);
  return service.subscribeToMessages(threadId);
});
