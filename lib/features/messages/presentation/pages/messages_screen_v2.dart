import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';
import 'package:nvs/core/models/chat_session.dart';
import 'package:nvs/shared/widgets/nvs_logo_app_bar.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/features/messages/data/message_provider.dart';
import 'package:intl/intl.dart';

class MessagesScreenV2 extends ConsumerStatefulWidget {
  const MessagesScreenV2({super.key});

  @override
  ConsumerState<MessagesScreenV2> createState() => _MessagesScreenV2State();
}

class _MessagesScreenV2State extends ConsumerState<MessagesScreenV2> {
  bool _showDirectMessages = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      appBar: const NvsLogoAppBar(),
      body: Column(
        children: <Widget>[
          _buildToggleButtons(),
          Expanded(
            child: AnimatedSwitcher(
              duration: 300.ms,
              child: _buildChatList(isRoom: _showDirectMessages),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: NVSColors.pureBlack.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: NVSColors.dividerColor),
      ),
      child: Row(
        children: <Widget>[
          _buildToggleButton(
            '1-on-1',
            _showDirectMessages,
            () => setState(() => _showDirectMessages = true),
          ),
          Container(width: 1, height: 20, color: NVSColors.dividerColor),
          _buildToggleButton(
            'Rooms',
            !_showDirectMessages,
            () => setState(() => _showDirectMessages = false),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? NVSColors.electricPink.withValues(alpha: 0.3) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: isActive
                ? NvsTextStyles.cardTitle.copyWith(color: NVSColors.electricPink)
                : NvsTextStyles.cardTitle.copyWith(color: NVSColors.secondaryText),
          ),
        ),
      ),
    );
  }

  Widget _buildChatList({required bool isRoom}) {
    final AsyncValue<List<ChatSession>> asyncChatSessions = ref.watch(chatSessionsProvider);

    return asyncChatSessions.when(
      data: (List<ChatSession> chatSessions) {
        // final filteredSessions = chatSessions
        //     .where((session) => isRoom ? session.isRoom : !session.isRoom)
        //     .toList();

        return ListView.separated(
          key: ValueKey(isRoom),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: chatSessions.length,
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(color: NVSColors.dividerColor, height: 1),
          itemBuilder: (BuildContext context, int index) {
            final ChatSession session = chatSessions[index];
            return _buildChatItem(
              name: session.id, // Placeholder
              message: session.lastMessage?.content ?? '',
              time: DateFormat.jm().format(session.updatedAt),
            ).animate().fadeIn(delay: (100 * index).ms).slideX(begin: 0.2);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (Object error, StackTrace stackTrace) => Center(
        child: Text('Error: $error'),
      ),
    );
  }

  Widget _buildChatItem({
    required String name,
    required String message,
    required String time,
    bool isFavorite = false,
    bool isRoom = false,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          CircleAvatar(
            radius: 28,
            backgroundColor: isRoom
                ? NVSColors.neonPurple.withValues(alpha: 0.3)
                : NVSColors.electricPink.withValues(alpha: 0.3),
            backgroundImage: const AssetImage('assets/images/avatar_placeholder.png'),
          ),
          if (!isRoom)
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: NVSColors.avocadoGreen,
                shape: BoxShape.circle,
                border: Border.all(width: 2),
              ),
            ),
        ],
      ),
      title: Text(name, style: NvsTextStyles.cardTitle.copyWith(fontSize: 16)),
      subtitle: Text(
        message,
        style: NvsTextStyles.body.copyWith(
          color: message == 'Typing...' ? NVSColors.neonMint : NVSColors.secondaryText,
          fontStyle: message == 'Typing...' ? FontStyle.italic : FontStyle.normal,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(time, style: NvsTextStyles.caption),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (isFavorite) const Icon(Icons.favorite, color: NVSColors.electricPink, size: 18),
              const SizedBox(width: 8),
              const Text(
                'YO',
                style: TextStyle(
                  color: NVSColors.neonMint,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
