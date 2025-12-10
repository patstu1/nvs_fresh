// NVS Lookout Messages - Room chat + DM + 1-on-1 cam
// Room chat (public to everyone in room)
// DM with any user in room (private thread)
// 1-on-1 CAM button in DM → starts private video call
// DMs tagged "Met in Lookout"

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LookoutMessages extends StatefulWidget {
  const LookoutMessages({super.key});

  @override
  State<LookoutMessages> createState() => _LookoutMessagesState();
}

class _LookoutMessagesState extends State<LookoutMessages>
    with TickerProviderStateMixin {
  static const Color _mint = Color(0xFFE4FFF0);
  static const Color _black = Color(0xFF000000);

  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  int _selectedTab = 0; // 0 = DMs, 1 = Room Chats

  // Mock DM conversations from Lookout
  final List<_LookoutDM> _dms = [
    _LookoutDM(
      id: '1',
      name: 'Jake',
      age: 29,
      photoUrl: '',
      lastMessage: 'Hey! Saw you in the room 👀',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      roomName: 'SF Night Owls',
      unreadCount: 3,
      isOnline: true,
    ),
    _LookoutDM(
      id: '2',
      name: 'Chris',
      age: 34,
      photoUrl: '',
      lastMessage: 'Let\'s do a 1-on-1?',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      roomName: 'Downtown Vibes',
      unreadCount: 1,
      isOnline: true,
    ),
    _LookoutDM(
      id: '3',
      name: 'Matt',
      age: 27,
      photoUrl: '',
      lastMessage: 'Good chatting with you!',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      roomName: 'Late Night Crew',
      unreadCount: 0,
      isOnline: false,
    ),
    _LookoutDM(
      id: '4',
      name: 'Derek',
      age: 31,
      photoUrl: '',
      lastMessage: 'Same time tomorrow?',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      roomName: 'My Room',
      unreadCount: 0,
      isOnline: false,
    ),
  ];

  // Mock room chat threads
  final List<_RoomChat> _roomChats = [
    _RoomChat(
      id: '1',
      roomName: 'SF Night Owls',
      lastMessage: 'Alex: Anyone still up?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      memberCount: 24,
      unreadCount: 12,
      isLive: true,
    ),
    _RoomChat(
      id: '2',
      roomName: 'Downtown Vibes',
      lastMessage: 'Ryan: Great DJ set tonight!',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      memberCount: 45,
      unreadCount: 0,
      isLive: true,
    ),
    _RoomChat(
      id: '3',
      roomName: 'Late Night Crew',
      lastMessage: 'You: See you all later!',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      memberCount: 12,
      unreadCount: 0,
      isLive: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTabToggle(),
        Expanded(
          child: _selectedTab == 0 ? _buildDMList() : _buildRoomChatList(),
        ),
      ],
    );
  }

  Widget _buildTabToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(color: _mint.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(child: _buildTab('DMs', 0, _dms.fold(0, (a, b) => a + b.unreadCount))),
          Expanded(child: _buildTab('ROOM CHATS', 1, _roomChats.fold(0, (a, b) => a + b.unreadCount))),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index, int unread) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _selectedTab = index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? _mint.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? _mint : _mint.withOpacity(0.5),
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                letterSpacing: 1,
              ),
            ),
            if (unread > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _mint,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$unread',
                  style: const TextStyle(
                    color: _black,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDMList() {
    if (_dms.isEmpty) {
      return _buildEmptyState('No DMs yet', 'Start chatting with people in rooms');
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: _dms.length,
      itemBuilder: (context, index) => _buildDMTile(_dms[index]),
    );
  }

  Widget _buildDMTile(_LookoutDM dm) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => _LookoutChatScreen(dm: dm),
          ),
        );
      },
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          final hasUnread = dm.unreadCount > 0;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: hasUnread ? _mint.withOpacity(0.5) : _mint.withOpacity(0.15),
                width: hasUnread ? 1.5 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: hasUnread
                  ? [
                      BoxShadow(
                        color: _mint.withOpacity(0.15 * _glowAnimation.value),
                        blurRadius: 8,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                _buildAvatar(dm),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  '${dm.name}, ${dm.age}',
                                  style: TextStyle(
                                    color: _mint,
                                    fontSize: 15,
                                    fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: _mint.withOpacity(0.3)),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.remove_red_eye_outlined,
                                        color: _mint.withOpacity(0.5),
                                        size: 10,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        dm.roomName,
                                        style: TextStyle(
                                          color: _mint.withOpacity(0.5),
                                          fontSize: 9,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            _formatTimestamp(dm.timestamp),
                            style: TextStyle(
                              color: _mint.withOpacity(0.4),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dm.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: _mint.withOpacity(hasUnread ? 0.8 : 0.5),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                if (dm.unreadCount > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _mint,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${dm.unreadCount}',
                      style: const TextStyle(
                        color: _black,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatar(_LookoutDM dm) {
    return Stack(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: dm.isOnline ? _mint : _mint.withOpacity(0.3),
              width: dm.isOnline ? 2 : 1,
            ),
            boxShadow: dm.isOnline
                ? [BoxShadow(color: _mint.withOpacity(0.3), blurRadius: 8)]
                : null,
          ),
          child: ClipOval(
            child: Container(
              color: _mint.withOpacity(0.1),
              child: Icon(Icons.person, color: _mint.withOpacity(0.4), size: 28),
            ),
          ),
        ),
        if (dm.isOnline)
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: _mint,
                shape: BoxShape.circle,
                border: Border.all(color: _black, width: 2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRoomChatList() {
    if (_roomChats.isEmpty) {
      return _buildEmptyState('No room chats', 'Join a room to start chatting');
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: _roomChats.length,
      itemBuilder: (context, index) => _buildRoomChatTile(_roomChats[index]),
    );
  }

  Widget _buildRoomChatTile(_RoomChat room) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        // Navigate to room chat
      },
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          final hasUnread = room.unreadCount > 0;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: hasUnread ? _mint.withOpacity(0.5) : _mint.withOpacity(0.15),
                width: hasUnread ? 1.5 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: hasUnread
                  ? [
                      BoxShadow(
                        color: _mint.withOpacity(0.15 * _glowAnimation.value),
                        blurRadius: 8,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: room.isLive ? _mint : _mint.withOpacity(0.3),
                    ),
                    boxShadow: room.isLive
                        ? [BoxShadow(color: _mint.withOpacity(0.3), blurRadius: 8)]
                        : null,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.groups_outlined,
                        color: _mint.withOpacity(0.6),
                        size: 24,
                      ),
                      if (room.isLive)
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _mint,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: _mint.withOpacity(0.6),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    room.roomName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: _mint,
                                      fontSize: 15,
                                      fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w500,
                                    ),
                                  ),
                                ),
                                if (room.isLive) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _mint.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'LIVE',
                                      style: TextStyle(
                                        color: _mint,
                                        fontSize: 8,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Text(
                            _formatTimestamp(room.timestamp),
                            style: TextStyle(
                              color: _mint.withOpacity(0.4),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              room.lastMessage,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: _mint.withOpacity(hasUnread ? 0.8 : 0.5),
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.person_outline,
                                color: _mint.withOpacity(0.4),
                                size: 12,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${room.memberCount}',
                                style: TextStyle(
                                  color: _mint.withOpacity(0.4),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (room.unreadCount > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _mint,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${room.unreadCount}',
                      style: const TextStyle(
                        color: _black,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.remove_red_eye_outlined,
            color: _mint.withOpacity(0.3),
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: _mint.withOpacity(0.6),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: _mint.withOpacity(0.4),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d';
    } else {
      return '${timestamp.month}/${timestamp.day}';
    }
  }
}

class _LookoutDM {
  final String id;
  final String name;
  final int age;
  final String photoUrl;
  final String lastMessage;
  final DateTime timestamp;
  final String roomName;
  final int unreadCount;
  final bool isOnline;

  _LookoutDM({
    required this.id,
    required this.name,
    required this.age,
    required this.photoUrl,
    required this.lastMessage,
    required this.timestamp,
    required this.roomName,
    required this.unreadCount,
    required this.isOnline,
  });
}

class _RoomChat {
  final String id;
  final String roomName;
  final String lastMessage;
  final DateTime timestamp;
  final int memberCount;
  final int unreadCount;
  final bool isLive;

  _RoomChat({
    required this.id,
    required this.roomName,
    required this.lastMessage,
    required this.timestamp,
    required this.memberCount,
    required this.unreadCount,
    required this.isLive,
  });
}

// ============ LOOKOUT CHAT SCREEN WITH 1-ON-1 CAM ============
class _LookoutChatScreen extends StatefulWidget {
  final _LookoutDM dm;

  const _LookoutChatScreen({required this.dm});

  @override
  State<_LookoutChatScreen> createState() => _LookoutChatScreenState();
}

class _LookoutChatScreenState extends State<_LookoutChatScreen>
    with TickerProviderStateMixin {
  static const Color _mint = Color(0xFFE4FFF0);
  static const Color _black = Color(0xFF000000);

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  bool _isInVideoCall = false;

  final List<_LookoutMessage> _messages = [
    _LookoutMessage(
      id: '1',
      text: 'Hey! Saw you in the room 👀',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    _LookoutMessage(
      id: '2',
      text: 'Hey! Yeah I noticed you too',
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
    ),
    _LookoutMessage(
      id: '3',
      text: 'What brings you to SF Night Owls?',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    HapticFeedback.lightImpact();
    setState(() {
      _messages.add(_LookoutMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        isMe: true,
        timestamp: DateTime.now(),
      ));
    });
    _messageController.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _startVideoCall() {
    HapticFeedback.heavyImpact();
    setState(() => _isInVideoCall = true);
  }

  void _endVideoCall() {
    HapticFeedback.mediumImpact();
    setState(() => _isInVideoCall = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isInVideoCall) {
      return _buildVideoCallScreen();
    }

    return Scaffold(
      backgroundColor: _black,
      body: SafeArea(
        child: Column(
          children: [
            _buildChatHeader(),
            _buildMetInLookoutBanner(),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) => _buildMessage(_messages[index]),
              ),
            ),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildChatHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: _mint.withOpacity(0.15)),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).pop();
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: _mint.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.arrow_back, color: _mint, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          Stack(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.dm.isOnline ? _mint : _mint.withOpacity(0.3),
                  ),
                ),
                child: ClipOval(
                  child: Container(
                    color: _mint.withOpacity(0.1),
                    child: Icon(Icons.person, color: _mint.withOpacity(0.4), size: 24),
                  ),
                ),
              ),
              if (widget.dm.isOnline)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _mint,
                      shape: BoxShape.circle,
                      border: Border.all(color: _black, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.dm.name}, ${widget.dm.age}',
                  style: const TextStyle(
                    color: _mint,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.remove_red_eye_outlined,
                      color: _mint.withOpacity(0.5),
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.dm.roomName,
                      style: TextStyle(
                        color: _mint.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 1-on-1 CAM BUTTON
          GestureDetector(
            onTap: _startVideoCall,
            child: AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: _mint),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: _mint.withOpacity(0.3 * _glowAnimation.value),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.videocam, color: _mint, size: 18),
                      const SizedBox(width: 6),
                      const Text(
                        '1-ON-1',
                        style: TextStyle(
                          color: _mint,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetInLookoutBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: _mint.withOpacity(0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.remove_red_eye_outlined, color: _mint.withOpacity(0.5), size: 14),
          const SizedBox(width: 8),
          Text(
            'Met in ${widget.dm.roomName}',
            style: TextStyle(
              color: _mint.withOpacity(0.5),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(_LookoutMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: message.isMe ? _mint.withOpacity(0.1) : Colors.transparent,
                  border: Border.all(
                    color:
                        message.isMe ? _mint.withOpacity(0.4) : _mint.withOpacity(0.2),
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(message.isMe ? 16 : 4),
                    bottomRight: Radius.circular(message.isMe ? 4 : 16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      message.text,
                      style: TextStyle(
                        color: _mint.withOpacity(0.9),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatMessageTime(message.timestamp),
                      style: TextStyle(
                        color: _mint.withOpacity(0.4),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: _mint.withOpacity(0.15)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: _mint.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                style: const TextStyle(color: _mint, fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'Message...',
                  hintStyle: TextStyle(color: _mint.withOpacity(0.4)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _sendMessage,
            child: AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: _mint),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: _mint.withOpacity(0.3 * _glowAnimation.value),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Icon(Icons.send, color: _mint, size: 20),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ============ VIDEO CALL SCREEN ============
  Widget _buildVideoCallScreen() {
    return Scaffold(
      backgroundColor: _black,
      body: Stack(
        children: [
          // Remote video (fullscreen)
          Container(
            width: double.infinity,
            height: double.infinity,
            color: _mint.withOpacity(0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person,
                  color: _mint.withOpacity(0.3),
                  size: 120,
                ),
                const SizedBox(height: 16),
                Text(
                  widget.dm.name,
                  style: TextStyle(
                    color: _mint.withOpacity(0.6),
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Connecting...',
                  style: TextStyle(
                    color: _mint.withOpacity(0.4),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Local video (picture-in-picture)
          Positioned(
            top: 60,
            right: 20,
            child: Container(
              width: 100,
              height: 140,
              decoration: BoxDecoration(
                color: _black,
                border: Border.all(color: _mint.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: _mint.withOpacity(0.2),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Container(
                  color: _mint.withOpacity(0.1),
                  child: Icon(
                    Icons.person,
                    color: _mint.withOpacity(0.4),
                    size: 48,
                  ),
                ),
              ),
            ),
          ),
          // Call controls
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCallControl(Icons.mic_off_outlined, false, () {}),
                const SizedBox(width: 24),
                _buildCallControl(Icons.videocam_off_outlined, false, () {}),
                const SizedBox(width: 24),
                GestureDetector(
                  onTap: _endVideoCall,
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.red, width: 2),
                    ),
                    child: const Icon(
                      Icons.call_end,
                      color: Colors.red,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                _buildCallControl(Icons.cameraswitch_outlined, false, () {}),
                const SizedBox(width: 24),
                _buildCallControl(Icons.fullscreen, false, () {}),
              ],
            ),
          ),
          // Call duration
          Positioned(
            top: 60,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _mint.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _mint,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _mint.withOpacity(0.6),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '0:00',
                    style: TextStyle(
                      color: _mint,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallControl(IconData icon, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: isActive ? _mint.withOpacity(0.2) : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: isActive ? _mint : _mint.withOpacity(0.4),
          ),
        ),
        child: Icon(
          icon,
          color: isActive ? _mint : _mint.withOpacity(0.6),
          size: 24,
        ),
      ),
    );
  }

  String _formatMessageTime(DateTime timestamp) {
    final hour = timestamp.hour > 12 ? timestamp.hour - 12 : timestamp.hour;
    final amPm = timestamp.hour >= 12 ? 'PM' : 'AM';
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute $amPm';
  }
}

class _LookoutMessage {
  final String id;
  final String text;
  final bool isMe;
  final DateTime timestamp;

  _LookoutMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.timestamp,
  });
}

