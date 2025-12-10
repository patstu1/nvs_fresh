// NVS Lookout Main Room (Prompt 35)
// Main video chat room with grid view of live users
// Up to 200 closest users, 6 pinnable spots, real-time video feeds

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LookoutMainRoom extends StatefulWidget {
  const LookoutMainRoom({super.key});

  @override
  State<LookoutMainRoom> createState() => _LookoutMainRoomState();
}

class _LookoutMainRoomState extends State<LookoutMainRoom>
    with TickerProviderStateMixin {
  static const Color _mint = Color(0xFFE3F2DE);
  static const Color _olive = Color(0xFF6B7F4A);
  static const Color _aqua = Color(0xFF20B2A6);
  static const Color _black = Color(0xFF000000);

  late AnimationController _pulseController;
  
  // Room state
  int _viewerCount = 147;
  bool _isMuted = false;
  bool _isCameraOn = true;
  // ignore: unused_field
  bool _isGridView = true;
  int _gridSize = 2; // 2x2, 3x3, 4x4
  
  // Pinned users (up to 6)
  final List<String> _pinnedUsers = [];
  
  // Mock users in room
  final List<_RoomUser> _roomUsers = List.generate(
    24,
    (i) => _RoomUser(
      id: 'user_$i',
      name: ['Alex', 'Jordan', 'Casey', 'Sam', 'Riley', 'Morgan'][i % 6],
      distance: '${(i * 0.3 + 0.1).toStringAsFixed(1)} mi',
      isOnCamera: i % 3 != 0,
      position: ['Top', 'Bottom', 'Verse', 'Side'][i % 4],
      isOnline: true,
    ),
  );

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    
    // Simulate viewer count changes
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          _viewerCount += (DateTime.now().second % 3) - 1;
        });
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _black,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildPinnedSection(),
            Expanded(child: _buildMainGrid()),
            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: _mint.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_back, color: _mint, size: 20),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MY ROOM',
                  style: TextStyle(
                    color: _mint,
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 2,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _aqua,
                        boxShadow: [
                          BoxShadow(
                            color: _aqua.withOpacity(0.5),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$_viewerCount watching',
                      style: TextStyle(color: _olive, fontSize: 12),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.music_note, color: _olive, size: 14),
                    Text(
                      ' Station Berlin',
                      style: TextStyle(color: _olive, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Grid size toggle
          GestureDetector(
            onTap: _cycleGridSize,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: _mint.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _gridSize == 2 ? Icons.grid_view : Icons.view_module,
                color: _mint,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Chat toggle
          GestureDetector(
            onTap: _openChat,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: _mint.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.chat_bubble_outline, color: _mint, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinnedSection() {
    if (_pinnedUsers.isEmpty) return const SizedBox.shrink();
    
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.push_pin, color: _aqua, size: 14),
              const SizedBox(width: 6),
              Text(
                'PINNED (${_pinnedUsers.length}/6)',
                style: TextStyle(
                  color: _aqua,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _pinnedUsers.length,
              itemBuilder: (context, index) {
                final user = _roomUsers.firstWhere(
                  (u) => u.id == _pinnedUsers[index],
                  orElse: () => _roomUsers[0],
                );
                return _buildPinnedTile(user);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinnedTile(_RoomUser user) {
    return GestureDetector(
      onTap: () => _openUserProfile(user),
      onLongPress: () => _unpinUser(user.id),
      child: Container(
        width: 70,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _aqua, width: 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                color: _mint.withOpacity(0.1),
                child: user.isOnCamera
                    ? Icon(Icons.videocam, color: _mint.withOpacity(0.3))
                    : Icon(Icons.videocam_off, color: _olive),
              ),
              Positioned(
                bottom: 4,
                left: 4,
                right: 4,
                child: Text(
                  user.name,
                  style: const TextStyle(
                    color: _mint,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainGrid() {
    final crossAxisCount = _gridSize + 1; // 2->3, 3->4, 4->5
    
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 0.8,
      ),
      itemCount: _roomUsers.length,
      itemBuilder: (context, index) => _buildUserTile(_roomUsers[index]),
    );
  }

  Widget _buildUserTile(_RoomUser user) {
    final isPinned = _pinnedUsers.contains(user.id);
    
    return GestureDetector(
      onTap: () => _openUserProfile(user),
      onDoubleTap: () => _pinUser(user.id),
      onLongPress: () => _showUserOptions(user),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isPinned ? _aqua : _mint.withOpacity(0.15),
            width: isPinned ? 2 : 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Video placeholder
              Container(
                color: _mint.withOpacity(0.05),
                child: user.isOnCamera
                    ? Center(
                        child: Icon(
                          Icons.person,
                          color: _mint.withOpacity(0.2),
                          size: 40,
                        ),
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.videocam_off, color: _olive, size: 24),
                            const SizedBox(height: 4),
                            Text(
                              'Camera off',
                              style: TextStyle(color: _olive, fontSize: 10),
                            ),
                          ],
                        ),
                      ),
              ),
              // Pin indicator
              if (isPinned)
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: _aqua,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.push_pin, color: _black, size: 10),
                  ),
                ),
              // User info overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, _black.withOpacity(0.8)],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          color: _mint,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            user.distance,
                            style: TextStyle(color: _olive, fontSize: 9),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            user.position,
                            style: TextStyle(color: _aqua, fontSize: 9),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        16 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: _black,
        border: Border(top: BorderSide(color: _mint.withOpacity(0.1))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Mute button
          _buildControlButton(
            icon: _isMuted ? Icons.mic_off : Icons.mic,
            label: _isMuted ? 'Unmute' : 'Mute',
            isActive: !_isMuted,
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() => _isMuted = !_isMuted);
            },
          ),
          // Camera button
          _buildControlButton(
            icon: _isCameraOn ? Icons.videocam : Icons.videocam_off,
            label: _isCameraOn ? 'Cam On' : 'Cam Off',
            isActive: _isCameraOn,
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() => _isCameraOn = !_isCameraOn);
            },
          ),
          // Flip camera
          _buildControlButton(
            icon: Icons.flip_camera_ios,
            label: 'Flip',
            isActive: true,
            onTap: () {
              HapticFeedback.selectionClick();
              // Flip camera
            },
          ),
          // Users list
          _buildControlButton(
            icon: Icons.people,
            label: 'Users',
            isActive: true,
            onTap: _showUsersList,
          ),
          // Leave button
          _buildControlButton(
            icon: Icons.exit_to_app,
            label: 'Leave',
            isActive: false,
            isDestructive: true,
            onTap: () {
              HapticFeedback.heavyImpact();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive
        ? Colors.redAccent.shade200
        : (isActive ? _aqua : _olive);
    
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.5)),
              color: isActive ? color.withOpacity(0.15) : Colors.transparent,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 10),
          ),
        ],
      ),
    );
  }

  void _cycleGridSize() {
    HapticFeedback.selectionClick();
    setState(() {
      _gridSize = (_gridSize % 3) + 1;
    });
  }

  void _pinUser(String id) {
    if (_pinnedUsers.length >= 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Maximum 6 pinned users'),
          backgroundColor: _olive,
        ),
      );
      return;
    }
    if (!_pinnedUsers.contains(id)) {
      HapticFeedback.mediumImpact();
      setState(() => _pinnedUsers.add(id));
    }
  }

  void _unpinUser(String id) {
    HapticFeedback.selectionClick();
    setState(() => _pinnedUsers.remove(id));
  }

  void _openUserProfile(_RoomUser user) {
    // Open profile sheet
  }

  void _showUserOptions(_RoomUser user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _UserOptionsSheet(user: user),
    );
  }

  void _showUsersList() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _black,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => _UsersListSheet(
          users: _roomUsers,
          scrollController: scrollController,
        ),
      ),
    );
  }

  void _openChat() {
    // Open room chat
  }
}

// ============ DATA MODELS ============
class _RoomUser {
  final String id;
  final String name;
  final String distance;
  final bool isOnCamera;
  final String position;
  final bool isOnline;

  _RoomUser({
    required this.id,
    required this.name,
    required this.distance,
    required this.isOnCamera,
    required this.position,
    required this.isOnline,
  });
}

// ============ USER OPTIONS SHEET ============
class _UserOptionsSheet extends StatelessWidget {
  static const Color _mint = Color(0xFFE3F2DE);
  static const Color _olive = Color(0xFF6B7F4A);
  static const Color _aqua = Color(0xFF20B2A6);
  static const Color _black = Color(0xFF000000);

  final _RoomUser user;

  const _UserOptionsSheet({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: _olive.withOpacity(0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          // User info
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _aqua),
                ),
                child: Icon(Icons.person, color: _mint.withOpacity(0.4)),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      color: _mint,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${user.distance} · ${user.position}',
                    style: TextStyle(color: _olive, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Options
          _buildOption(context, Icons.push_pin, 'Pin to top', () {}),
          _buildOption(context, Icons.chat_bubble, 'Send message', () {}),
          _buildOption(context, Icons.videocam, 'Start 1-on-1 cam', () {}),
          _buildOption(context, Icons.person, 'View profile', () {}),
          _buildOption(context, Icons.block, 'Block user', () {}, isDestructive: true),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    final color = isDestructive ? Colors.redAccent.shade200 : _mint;
    
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        Navigator.pop(context);
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(color: color, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}

// ============ USERS LIST SHEET ============
class _UsersListSheet extends StatelessWidget {
  static const Color _mint = Color(0xFFE3F2DE);
  static const Color _olive = Color(0xFF6B7F4A);
  static const Color _aqua = Color(0xFF20B2A6);

  final List<_RoomUser> users;
  final ScrollController scrollController;

  const _UsersListSheet({
    required this.users,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              const Text(
                'USERS IN ROOM',
                style: TextStyle(
                  color: _mint,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 2,
                ),
              ),
              const Spacer(),
              Text(
                '${users.length}',
                style: const TextStyle(color: _aqua, fontSize: 16),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: _mint.withOpacity(0.3)),
                  ),
                  child: Icon(Icons.person, color: _mint.withOpacity(0.4)),
                ),
                title: Text(
                  user.name,
                  style: const TextStyle(color: _mint),
                ),
                subtitle: Text(
                  '${user.distance} · ${user.position}',
                  style: TextStyle(color: _olive, fontSize: 12),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (user.isOnCamera)
                      Icon(Icons.videocam, color: _aqua, size: 18)
                    else
                      Icon(Icons.videocam_off, color: _olive, size: 18),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

