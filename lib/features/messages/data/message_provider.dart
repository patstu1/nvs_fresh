import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/core/models/chat_session.dart';
import 'package:nvs/features/messages/data/message_repository.dart';

final Provider<MessageRepository> messageRepositoryProvider =
    Provider<MessageRepository>((ProviderRef<MessageRepository> ref) {
  return MessageRepository();
});

final StreamProvider<List<ChatSession>> chatSessionsProvider =
    StreamProvider<List<ChatSession>>((StreamProviderRef<List<ChatSession>> ref) {
  final MessageRepository repo = ref.watch(messageRepositoryProvider);
  return repo.getChatSessions();
});
