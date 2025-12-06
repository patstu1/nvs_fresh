import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Breakout rooms widget for creating and managing smaller group sessions.
///
/// Features:
/// - Create breakout rooms for smaller discussions
/// - Assign participants to rooms
/// - Monitor room activity
/// - Cyberpunk styling with neon effects
/// - Smooth animations and transitions
class BreakoutRoomsWidget extends StatefulWidget {
  const BreakoutRoomsWidget({
    required this.roomId,
    required this.onClose,
    super.key,
  });
  final String roomId;
  final VoidCallback onClose;

  @override
  State<BreakoutRoomsWidget> createState() => _BreakoutRoomsWidgetState();
}

class _BreakoutRoomsWidgetState extends State<BreakoutRoomsWidget> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;

  final List<BreakoutRoom> _breakoutRooms = <BreakoutRoom>[];
  final bool _isCreatingRoom = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadBreakoutRooms();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    // Slide animation for overlay
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Pulse animation for active rooms
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Start animations
    _slideController.forward();
    _pulseController.repeat(reverse: true);
  }

  void _loadBreakoutRooms() {
    // This would load breakout rooms from Firestore
    // For now, we'll use mock data
    setState(() {
      _breakoutRooms.addAll(<BreakoutRoom>[
        BreakoutRoom(
          id: '1',
          name: 'Tech Discussion',
          parentRoomId: widget.roomId,
          hostId: 'host1',
          participants: <String>['user1', 'user2', 'user3'],
          createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
          state: 'active',
        ),
        BreakoutRoom(
          id: '2',
          name: 'Gaming Corner',
          parentRoomId: widget.roomId,
          hostId: 'host2',
          participants: <String>['user4', 'user5'],
          createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
          state: 'active',
        ),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black.withValues(alpha: 0.8),
      child: SlideTransition(
        position: _slideAnimation,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Color(0xFF1A1A1A),
                Colors.black,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                // Header
                _buildHeader(),

                // Content
                Expanded(
                  child: _buildContent(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: <Widget>[
          const Icon(
            Icons.group_work,
            color: Color(0xFF8B5CF6),
            size: 24,
          ),

          const SizedBox(width: 12),

          const Text(
            'Breakout Rooms',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Spacer(),

          // Room count
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.5),
              ),
            ),
            child: Text(
              '${_breakoutRooms.length} Rooms',
              style: const TextStyle(
                color: Color(0xFF8B5CF6),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Close button
          IconButton(
            onPressed: widget.onClose,
            icon: const Icon(
              Icons.close,
              color: Color(0xFF8B5CF6),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Create room button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _showCreateRoomDialog,
              icon: const Icon(Icons.add),
              label: const Text('Create Breakout Room'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Rooms list
          const Text(
            'Active Rooms',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: _breakoutRooms.isEmpty ? _buildEmptyState() : _buildRoomsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.group_work_outlined,
            color: const Color(0xFF8B5CF6).withValues(alpha: 0.5),
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'No Breakout Rooms',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create a breakout room to start smaller discussions',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRoomsList() {
    return ListView.builder(
      itemCount: _breakoutRooms.length,
      itemBuilder: (BuildContext context, int index) {
        final BreakoutRoom room = _breakoutRooms[index];
        return _buildRoomCard(room);
      },
    );
  }

  Widget _buildRoomCard(BreakoutRoom room) {
    final bool isActive = room.state == 'active';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive
              ? const Color(0xFF8B5CF6).withValues(alpha: 0.5)
              : Colors.grey.withValues(alpha: 0.3),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            const Color(0xFF8B5CF6).withValues(alpha: 0.1),
            const Color(0xFF6366F1).withValues(alpha: 0.05),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                // Room status indicator
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (BuildContext context, Widget? child) {
                    return Transform.scale(
                      scale: isActive ? _pulseAnimation.value : 1.0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: isActive ? const Color(0xFF8B5CF6) : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(width: 12),

                // Room name
                Expanded(
                  child: Text(
                    room.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Participant count
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${room.participants.length}',
                    style: const TextStyle(
                      color: Color(0xFF8B5CF6),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Room info
            Row(
              children: <Widget>[
                Icon(
                  Icons.access_time,
                  color: Colors.grey[400],
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  _formatDuration(DateTime.now().difference(room.createdAt)),
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.person,
                  color: Colors.grey[400],
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  'Host: ${room.hostId}',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Action buttons
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _joinRoom(room),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF8B5CF6),
                      side: const BorderSide(color: Color(0xFF8B5CF6)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Join'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _manageRoom(room),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey,
                      side: BorderSide(color: Colors.grey.withValues(alpha: 0.5)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Manage'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _deleteRoom(room),
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red.withValues(alpha: 0.7),
                    size: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 300))
        .slideX(begin: 0.2, duration: const Duration(milliseconds: 300));
  }

  void _showCreateRoomDialog() {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Create Breakout Room',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Room Name',
                labelStyle: TextStyle(color: Color(0xFF8B5CF6)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF8B5CF6)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF8B5CF6), width: 2),
                ),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final String name = nameController.text.trim();
              if (name.isNotEmpty) {
                _createRoom(name);
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
              foregroundColor: Colors.white,
            ),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _createRoom(String name) {
    final BreakoutRoom newRoom = BreakoutRoom(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      parentRoomId: widget.roomId,
      hostId: 'current_user', // This would be the current user's ID
      participants: <String>[],
      createdAt: DateTime.now(),
      state: 'waiting',
    );

    setState(() {
      _breakoutRooms.add(newRoom);
    });

    // This would create the room in Firestore
  }

  void _joinRoom(BreakoutRoom room) {
    // This would navigate to the breakout room
    // For now, we'll just show a message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Joining ${room.name}...'),
        backgroundColor: const Color(0xFF8B5CF6),
      ),
    );
  }

  void _manageRoom(BreakoutRoom room) {
    // This would show room management options
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Manage ${room.name}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.people, color: Color(0xFF8B5CF6)),
              title: const Text(
                'View Participants',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).pop();
                // Show participants list
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Color(0xFF8B5CF6)),
              title: const Text(
                'Room Settings',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).pop();
                // Show room settings
              },
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteRoom(BreakoutRoom room) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Delete Room',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${room.name}"? All participants will be returned to the main room.',
          style: const TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _breakoutRooms.remove(room);
              });
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inMinutes < 1) {
      return 'Just now';
    } else if (duration.inMinutes < 60) {
      return '${duration.inMinutes}m ago';
    } else {
      return '${duration.inHours}h ago';
    }
  }
}

/// Breakout room data structure
class BreakoutRoom {
  const BreakoutRoom({
    required this.id,
    required this.name,
    required this.parentRoomId,
    required this.hostId,
    required this.participants,
    required this.createdAt,
    required this.state,
  });
  final String id;
  final String name;
  final String parentRoomId;
  final String hostId;
  final List<String> participants;
  final DateTime createdAt;
  final String state;
}
