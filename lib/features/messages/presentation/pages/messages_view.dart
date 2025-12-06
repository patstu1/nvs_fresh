// 💬 MESSAGES (UNIVERSAL DM) - Universal messaging system with toggles
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/meatup_core.dart';
import 'package:nvs/core/models/chat_session.dart';
import 'package:nvs/features/messages/data/message_provider.dart';
// Removed unused MessageThread import

class MessagesView extends ConsumerWidget {
  const MessagesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<ChatSession>> messagesAsync = ref.watch(chatSessionsProvider);

    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      appBar: AppBar(
        backgroundColor: NVSColors.pureBlack,
        elevation: 0,
        title: const Text(
          'MESSAGES',
          style: TextStyle(
            fontFamily: 'MagdaCleanMono',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: NVSColors.ultraLightMint,
            letterSpacing: 2,
          ),
        ),
        actions: <Widget>[
          // Universal messaging toggles for different sections
          IconButton(
            icon: const Icon(Icons.tune, color: NVSColors.ultraLightMint),
            onPressed: () => _showSectionToggles(context, ref),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          // Section toggles for universal messaging
          _buildSectionToggles(ref),

          // Messages list
          Expanded(
            child: messagesAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: NVSColors.ultraLightMint),
              ),
              error: (Object error, StackTrace stack) => Center(
                child: Text(
                  'Error loading messages: $error',
                  style: const TextStyle(
                    fontFamily: 'MagdaCleanMono',
                    color: NVSColors.ultraLightMint,
                  ),
                ),
              ),
              data: (List<ChatSession> messages) {
                if (messages.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.message_outlined,
                          size: 64,
                          color: NVSColors.secondaryText,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'no messages yet',
                          style: TextStyle(
                            fontFamily: 'MagdaCleanMono',
                            color: NVSColors.secondaryText,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'start connecting with people!',
                          style: TextStyle(
                            fontFamily: 'MagdaCleanMono',
                            color: NVSColors.secondaryText,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    final ChatSession message = messages[index];
                    return _MessageThreadTile(
                      thread: message,
                      onTap: () => _openThread(context, message),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionToggles(WidgetRef ref) {
    final Map<String, bool> sectionToggles = ref.watch(sectionToggleProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: <Widget>[
          const Text(
            'SECTIONS:',
            style: TextStyle(
              fontFamily: 'MagdaCleanMono',
              color: NVSColors.secondaryText,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Wrap(
              spacing: 8,
              children: <Widget>[
                _SectionToggleChip(
                  label: 'GRID',
                  isEnabled: sectionToggles['grid'] ?? true,
                  onToggle: (bool value) =>
                      ref.read(sectionToggleProvider.notifier).toggle('grid', value),
                ),
                _SectionToggleChip(
                  label: 'NOW',
                  isEnabled: sectionToggles['now'] ?? true,
                  onToggle: (bool value) =>
                      ref.read(sectionToggleProvider.notifier).toggle('now', value),
                ),
                _SectionToggleChip(
                  label: 'CONNECT',
                  isEnabled: sectionToggles['connect'] ?? true,
                  onToggle: (bool value) =>
                      ref.read(sectionToggleProvider.notifier).toggle('connect', value),
                ),
                _SectionToggleChip(
                  label: 'LIVE',
                  isEnabled: sectionToggles['live'] ?? true,
                  onToggle: (bool value) =>
                      ref.read(sectionToggleProvider.notifier).toggle('live', value),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSectionToggles(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: NVSColors.cardBackground,
      builder: (BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'MESSAGE SECTIONS',
              style: TextStyle(
                fontFamily: 'MagdaCleanMono',
                color: NVSColors.ultraLightMint,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Choose which sections can send you messages:',
              style: TextStyle(
                fontFamily: 'MagdaCleanMono',
                color: NVSColors.secondaryText,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionToggles(ref),
          ],
        ),
      ),
    );
  }

  void _openThread(BuildContext context, ChatSession thread) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => _ThreadDetailPage(thread: thread),
      ),
    );
  }
}

class _SectionToggleChip extends StatelessWidget {
  const _SectionToggleChip({
    required this.label,
    required this.isEnabled,
    required this.onToggle,
  });
  final String label;
  final bool isEnabled;
  final Function(bool) onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onToggle(!isEnabled),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isEnabled ? NVSColors.neonMint.withOpacity(0.2) : Colors.transparent,
          border: Border.all(
            color: isEnabled ? NVSColors.neonMint : NVSColors.dividerColor,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'MagdaCleanMono',
            color: isEnabled ? NVSColors.ultraLightMint : NVSColors.secondaryText,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _MessageThreadTile extends StatelessWidget {
  const _MessageThreadTile({
    required this.thread,
    required this.onTap,
  });
  final ChatSession thread;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: NVSColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: NVSColors.dividerColor.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 24,
              backgroundColor: NVSColors.neonMint.withOpacity(0.2),
              child: Text(
                thread.participants.first[0].toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'MagdaCleanMono',
                  color: NVSColors.ultraLightMint,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    thread.participants.first,
                    style: const TextStyle(
                      fontFamily: 'MagdaCleanMono',
                      color: NVSColors.ultraLightMint,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    thread.lastMessage?.content ?? '',
                    style: const TextStyle(
                      fontFamily: 'MagdaCleanMono',
                      color: NVSColors.secondaryText,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  _formatTime(thread.updatedAt),
                  style: const TextStyle(
                    fontFamily: 'MagdaCleanMono',
                    color: NVSColors.secondaryText,
                    fontSize: 12,
                  ),
                ),
                // Active indicator removed for now; can be reintroduced with a suitable flag
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }
}

class _ThreadDetailPage extends StatelessWidget {
  const _ThreadDetailPage({required this.thread});
  final ChatSession thread;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      appBar: AppBar(
        backgroundColor: NVSColors.pureBlack,
        elevation: 0,
        title: Text(
          thread.participants.first,
          style: const TextStyle(
            fontFamily: 'MagdaCleanMono',
            color: NVSColors.ultraLightMint,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Text(
                'Chat with ${thread.participants.first}',
                style: const TextStyle(
                  fontFamily: 'MagdaCleanMono',
                  color: NVSColors.secondaryText,
                ),
              ),
            ),
          ),
          // Message input would go here
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              style: const TextStyle(
                fontFamily: 'MagdaCleanMono',
                color: NVSColors.ultraLightMint,
              ),
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: const TextStyle(
                  fontFamily: 'MagdaCleanMono',
                  color: NVSColors.secondaryText,
                ),
                filled: true,
                fillColor: NVSColors.cardBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Providers for section toggles and messages
final StateNotifierProvider<SectionToggleNotifier, Map<String, bool>> sectionToggleProvider =
    StateNotifierProvider<SectionToggleNotifier, Map<String, bool>>(
        (StateNotifierProviderRef<SectionToggleNotifier, Map<String, bool>> ref) {
  return SectionToggleNotifier();
});

class SectionToggleNotifier extends StateNotifier<Map<String, bool>> {
  SectionToggleNotifier()
      : super(<String, bool>{
          'grid': true,
          'now': true,
          'connect': true,
          'live': true,
        });

  void toggle(String section, bool value) {
    state = <String, bool>{...state, section: value};
  }
}
