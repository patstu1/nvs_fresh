import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/message_thread.dart';
import '../domain/models/message.dart' show Message, MessageType, ChatContextType;

// Sample mock threads for each context
final List<MessageThread> _mockThreads = <MessageThread>[
  // Grid context threads
  MessageThread(
    id: 'grid_alex',
    participantWalletAddresses: const <String>['me', 'alex_grid'],
    displayName: 'Alex Martinez',
    avatarUrl: '',
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    unreadCount: 0,
    isFavorite: false,
    lastMessage: Message(
      id: '1',
      threadId: 'grid_alex',
      senderWalletAddress: 'alex_grid',
      content: 'Hey! I saw your profile on the grid. Want to grab coffee?',
      type: MessageType.text,
      context: ChatContextType.grid,
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    metadata: const <String, dynamic>{'context': 'grid'},
  ),
  MessageThread(
    id: 'grid_sam',
    participantWalletAddresses: const <String>['me', 'sam_grid'],
    displayName: 'Sam Chen',
    avatarUrl: '',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    unreadCount: 0,
    isFavorite: false,
    lastMessage: Message(
      id: '2',
      threadId: 'grid_sam',
      senderWalletAddress: 'sam_grid',
      content: 'That workout routine sounds intense! 💪',
      type: MessageType.text,
      context: ChatContextType.grid,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    metadata: const <String, dynamic>{'context': 'grid'},
  ),

  // Now context threads
  MessageThread(
    id: 'now_maya',
    participantWalletAddresses: const <String>['me', 'maya_now'],
    displayName: 'Maya Rodriguez',
    avatarUrl: '',
    createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
    unreadCount: 0,
    isFavorite: false,
    lastMessage: Message(
      id: '3',
      threadId: 'now_maya',
      senderWalletAddress: 'maya_now',
      content: "I'm at the same location right now! 📍",
      type: MessageType.text,
      context: ChatContextType.now,
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    metadata: const <String, dynamic>{'context': 'now'},
  ),

  // Connect context threads
  MessageThread(
    id: 'connect_jordan',
    participantWalletAddresses: const <String>['me', 'jordan_connect'],
    displayName: 'Jordan Taylor',
    avatarUrl: '',
    createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    unreadCount: 0,
    isFavorite: false,
    lastMessage: Message(
      id: '4',
      threadId: 'connect_jordan',
      senderWalletAddress: 'jordan_connect',
      content: 'Our compatibility score is off the charts! 🔥',
      type: MessageType.text,
      context: ChatContextType.connect,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    metadata: const <String, dynamic>{'context': 'connect'},
  ),

  // Live context threads
  MessageThread(
    id: 'live_casey',
    participantWalletAddresses: const <String>['me', 'casey_live'],
    displayName: 'Casey Johnson',
    avatarUrl: '',
    createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
    unreadCount: 0,
    isFavorite: false,
    lastMessage: Message(
      id: '5',
      threadId: 'live_casey',
      senderWalletAddress: 'casey_live',
      content: "Great session today! Let's do it again soon",
      type: MessageType.text,
      context: ChatContextType.live,
      createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    metadata: const <String, dynamic>{'context': 'live'},
  ),
];

// State notifier for managing chat threads
class ChatThreadNotifier extends StateNotifier<List<MessageThread>> {
  ChatThreadNotifier() : super(_mockThreads);

  // Add or update a thread
  void addOrUpdateThread(MessageThread thread) {
    final int existingIndex = state.indexWhere((MessageThread t) => t.id == thread.id);
    if (existingIndex >= 0) {
      state = <MessageThread>[
        ...state.sublist(0, existingIndex),
        thread,
        ...state.sublist(existingIndex + 1),
      ];
    } else {
      state = <MessageThread>[thread, ...state];
    }
  }

  // Send a message to a thread
  void sendMessage({
    required String threadId,
    required String text,
    MessageType type = MessageType.text,
    String? mediaUrl,
    String? replyToId,
    bool isPrivate = false,
  }) {
    final int threadIndex = state.indexWhere((MessageThread t) => t.id == threadId);
    if (threadIndex >= 0) {
      final MessageThread thread = state[threadIndex];
      final Message newMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        threadId: thread.id,
        senderWalletAddress: 'me',
        content: text,
        type: type,
        context: ChatContextType.fromString((thread.metadata['context'] as String?) ?? 'direct'),
        createdAt: DateTime.now(),
        replyToId: replyToId,
      );

      final MessageThread updatedThread = thread.copyWith(
        lastMessage: newMessage,
      );

      state = <MessageThread>[
        ...state.sublist(0, threadIndex),
        updatedThread,
        ...state.sublist(threadIndex + 1),
      ];

      // Simulate response after a delay
      _simulateResponse(threadId);
    }
  }

  // toggleBlock removed: not supported by domain model

  // Toggle favorite status
  void toggleFavorite(String threadId) {
    final int threadIndex = state.indexWhere((MessageThread t) => t.id == threadId);
    if (threadIndex >= 0) {
      final MessageThread thread = state[threadIndex];
      final MessageThread updatedThread = thread.copyWith(isFavorite: !thread.isFavorite);

      state = <MessageThread>[
        ...state.sublist(0, threadIndex),
        updatedThread,
        ...state.sublist(threadIndex + 1),
      ];
    }
  }

  // Unlock private media (premium feature)
  void unlockPrivateMedia(String threadId, String messageId) {
    // Implementation for unlocking premium media
    print('Unlocking private media for message $messageId in thread $threadId');
  }

  // Create a new thread
  MessageThread createThread({
    required String userId,
    required String displayName,
    required ChatContextType context,
    String? avatarUrl,
  }) {
    final MessageThread thread = MessageThread(
      id: '${context.toString().split('.').last}_${userId.toLowerCase()}',
      participantWalletAddresses: <String>['me', userId],
      displayName: displayName,
      avatarUrl: avatarUrl ?? '',
      createdAt: DateTime.now(),
      unreadCount: 0,
      isFavorite: false,
      metadata: <String, dynamic>{'context': context.toString().split('.').last},
    );

    addOrUpdateThread(thread);
    return thread;
  }

  // Simulate response from other user
  void _simulateResponse(String threadId) {
    Future.delayed(const Duration(seconds: 2), () {
      final int threadIndex = state.indexWhere((MessageThread t) => t.id == threadId);
      if (threadIndex >= 0) {
        final MessageThread thread = state[threadIndex];
        final List<String> responses = <String>[
          "Hey! How's it going?",
          'That sounds awesome!',
          'Want to meet up sometime?',
          "I'm free this weekend",
          "Let's chat more about this",
          'Thanks for reaching out!',
          'Looking forward to connecting',
        ];

        final Message responseMessage = Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          threadId: thread.id,
          senderWalletAddress:
              thread.participantWalletAddresses.firstWhere((String p) => p != 'me'),
          content: responses[(thread.unreadCount) % responses.length],
          type: MessageType.text,
          context: ChatContextType.fromString((thread.metadata['context'] as String?) ?? 'direct'),
          createdAt: DateTime.now(),
        );

        final MessageThread updatedThread = thread.copyWith(
          lastMessage: responseMessage,
        );

        state = <MessageThread>[
          ...state.sublist(0, threadIndex),
          updatedThread,
          ...state.sublist(threadIndex + 1),
        ];
      }
    });
  }
}

// Providers
final StateNotifierProvider<ChatThreadNotifier, List<MessageThread>> chatThreadListProvider =
    StateNotifierProvider<ChatThreadNotifier, List<MessageThread>>(
  (StateNotifierProviderRef<ChatThreadNotifier, List<MessageThread>> ref) => ChatThreadNotifier(),
);

// Provider for a specific thread
final ProviderFamily<MessageThread?, String> chatThreadProvider =
    Provider.family<MessageThread?, String>((ProviderRef<MessageThread?> ref, String threadId) {
  final List<MessageThread> threads = ref.watch(chatThreadListProvider);
  return threads.firstWhere(
    (MessageThread thread) => thread.id == threadId,
    orElse: () => threads.first, // Fallback to first thread if not found
  );
});

// Provider for threads filtered by context
final ProviderFamily<List<MessageThread>, ChatContextType> contextThreadsProvider =
    Provider.family<List<MessageThread>, ChatContextType>((
  ProviderRef<List<MessageThread>> ref,
  ChatContextType context,
) {
  final List<MessageThread> allThreads = ref.watch(chatThreadListProvider);
  final String key = context.toString().split('.').last;
  return allThreads
      .where((MessageThread thread) => (thread.metadata['context'] as String?) == key)
      .toList();
});
