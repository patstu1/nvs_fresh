// lib/features/messages/presentation/pages/simple_messages_page.dart

import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

/// MESSAGES - Universal messaging system
/// Enterprise-grade messaging with real-time capabilities
class SimpleMessagesPage extends StatefulWidget {
  const SimpleMessagesPage({super.key});

  @override
  State<SimpleMessagesPage> createState() => _SimpleMessagesPageState();
}

class _SimpleMessagesPageState extends State<SimpleMessagesPage> with TickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  final List<MessageThread> _threads = <MessageThread>[];

  @override
  void initState() {
    super.initState();

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _loadMessages();
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  void _loadMessages() {
    // Mock data for now
    setState(() {
      _threads.addAll(<MessageThread>[
        MessageThread(
          id: '1',
          participantName: 'ALEX',
          lastMessage: "Hey, what's up?",
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          unreadCount: 2,
          isOnline: true,
        ),
        MessageThread(
          id: '2',
          participantName: 'JORDAN',
          lastMessage: 'See you tonight!',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          unreadCount: 0,
          isOnline: false,
        ),
        MessageThread(
          id: '3',
          participantName: 'CASEY',
          lastMessage: 'Thanks for the great night',
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          unreadCount: 1,
          isOnline: true,
        ),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _buildHeader(),
            _buildSearchBar(),
            Expanded(
              child: _buildThreadsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (BuildContext context, Widget? child) {
          return Row(
            children: <Widget>[
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: NVSColors.primaryNeonMint,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: NVSColors.primaryNeonMint.withValues(
                        alpha: _glowAnimation.value * 0.6,
                      ),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'MESSAGES',
                  style: TextStyle(
                    fontFamily: 'BellGothic',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: NVSColors.ultraLightMint,
                    letterSpacing: 2.0,
                    shadows: <Shadow>[
                      Shadow(
                        color: NVSColors.primaryNeonMint.withValues(
                          alpha: _glowAnimation.value * 0.8,
                        ),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: NVSColors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: NVSColors.primaryNeonMint.withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.add,
                  color: NVSColors.primaryNeonMint,
                  size: 24,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: NVSColors.darkBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: NVSColors.primaryNeonMint.withValues(alpha: 0.3),
        ),
      ),
      child: const Row(
        children: <Widget>[
          Icon(
            Icons.search,
            color: NVSColors.secondaryText,
            size: 20,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Search conversations...',
              style: TextStyle(
                fontFamily: 'MagdaCleanMono',
                fontSize: 14,
                color: NVSColors.secondaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThreadsList() {
    if (_threads.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.chat_bubble_outline,
              size: 80,
              color: NVSColors.secondaryText,
            ),
            SizedBox(height: 20),
            Text(
              'NO CONVERSATIONS YET',
              style: TextStyle(
                fontFamily: 'BellGothic',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: NVSColors.secondaryText,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Start a conversation from MEATUP or NOW',
              style: TextStyle(
                fontFamily: 'MagdaCleanMono',
                fontSize: 12,
                color: NVSColors.secondaryText,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _threads.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildThreadTile(_threads[index]);
      },
    );
  }

  Widget _buildThreadTile(MessageThread thread) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NVSColors.darkBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: NVSColors.primaryNeonMint.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: <Widget>[
          // Avatar
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: NVSColors.primaryNeonMint.withValues(alpha: 0.3),
              shape: BoxShape.circle,
              border: Border.all(
                color: thread.isOnline ? NVSColors.primaryNeonMint : NVSColors.secondaryText,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                thread.participantName[0],
                style: const TextStyle(
                  fontFamily: 'BellGothic',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: NVSColors.ultraLightMint,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Thread info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        thread.participantName,
                        style: const TextStyle(
                          fontFamily: 'BellGothic',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: NVSColors.ultraLightMint,
                        ),
                      ),
                    ),
                    if (thread.unreadCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: NVSColors.primaryNeonMint,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${thread.unreadCount}',
                          style: const TextStyle(
                            fontFamily: 'MagdaCleanMono',
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: NVSColors.pureBlack,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  thread.lastMessage,
                  style: const TextStyle(
                    fontFamily: 'MagdaCleanMono',
                    fontSize: 12,
                    color: NVSColors.secondaryText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTime(thread.timestamp),
                  style: const TextStyle(
                    fontFamily: 'MagdaCleanMono',
                    fontSize: 10,
                    color: NVSColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final DateTime now = DateTime.now();
    final Duration diff = now.difference(time);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }
}

/// Message thread model
class MessageThread {
  const MessageThread({
    required this.id,
    required this.participantName,
    required this.lastMessage,
    required this.timestamp,
    required this.unreadCount,
    required this.isOnline,
  });

  final String id;
  final String participantName;
  final String lastMessage;
  final DateTime timestamp;
  final int unreadCount;
  final bool isOnline;
}
