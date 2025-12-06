import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../messages/domain/models/message_thread.dart';
import '../../messages/domain/models/message.dart';

class MockMessageService {
  Stream<List<MessageThread>> streamThreads(ChatContextType context) {
    final StreamController<List<MessageThread>> controller =
        StreamController<List<MessageThread>>();
    controller.add(_seed(context));
    return controller.stream;
  }

  List<MessageThread> _seed(ChatContextType context) {
    final DateTime now = DateTime.now();
    return <MessageThread>[
      MessageThread(
        id: '${context.name}_alpha',
        participantWalletAddresses: const <String>['me', 'alpha'],
        displayName: 'Alpha',
        avatarUrl: '',
        createdAt: now.subtract(const Duration(minutes: 20)),
        unreadCount: 2,
        isFavorite: false,
        lastMessage: Message(
          id: 'm1',
          threadId: '${context.name}_alpha',
          senderWalletAddress: 'alpha',
          content: 'meet me tonight',
          type: MessageType.text,
          context: context,
          createdAt: now.subtract(const Duration(minutes: 3)),
        ),
        metadata: <String, dynamic>{'context': context.name},
      ),
      MessageThread(
        id: '${context.name}_beta',
        participantWalletAddresses: const <String>['me', 'beta'],
        displayName: 'Beta',
        avatarUrl: '',
        createdAt: now.subtract(const Duration(hours: 2)),
        unreadCount: 0,
        isFavorite: false,
        lastMessage: Message(
          id: 'm2',
          threadId: '${context.name}_beta',
          senderWalletAddress: 'me',
          content: 'on my way',
          type: MessageType.text,
          context: context,
          createdAt: now.subtract(const Duration(minutes: 30)),
        ),
        metadata: <String, dynamic>{'context': context.name},
      ),
    ];
  }
}

final Provider<MockMessageService> mockMessageServiceProvider =
    Provider<MockMessageService>((ProviderRef<MockMessageService> ref) => MockMessageService());
