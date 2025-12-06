// lib/features/live/presentation/nexus_video_grid.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum VideoGridMode { gallery, list, pinned }

class NexusVideoGrid extends ConsumerStatefulWidget {
  const NexusVideoGrid({
    required this.mode,
    super.key,
    this.pinnedUsers,
  });
  final VideoGridMode mode;
  final List<String>? pinnedUsers;

  @override
  ConsumerState<NexusVideoGrid> createState() => _NexusVideoGridState();
}

class _NexusVideoGridState extends ConsumerState<NexusVideoGrid> with TickerProviderStateMixin {
  late AnimationController _pulseController;

  // Sample participants data
  final List<RoomParticipant> _participants = <RoomParticipant>[
    RoomParticipant(
      walletAddress: '0x1234...5678',
      displayName: 'CryptoKnight',
      isVideoEnabled: true,
      isAudioEnabled: true,
      role: 'host',
      joinTime: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    RoomParticipant(
      walletAddress: '0x2345...6789',
      displayName: 'NeonDreamer',
      isVideoEnabled: true,
      isAudioEnabled: false,
      role: 'participant',
      joinTime: DateTime.now().subtract(const Duration(minutes: 8)),
    ),
    RoomParticipant(
      walletAddress: '0x3456...7890',
      displayName: 'QuantumSoul',
      isVideoEnabled: false,
      isAudioEnabled: true,
      role: 'participant',
      joinTime: DateTime.now().subtract(const Duration(minutes: 3)),
    ),
  ];

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.mode) {
      case VideoGridMode.gallery:
        return _buildGalleryView();
      case VideoGridMode.list:
        return _buildListView();
      case VideoGridMode.pinned:
        return _buildPinnedView();
    }
  }

  Widget _buildGalleryView() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (BuildContext context, Widget? child) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: _participants.length,
            itemBuilder: (BuildContext context, int index) {
              final RoomParticipant participant = _participants[index];
              return _buildVideoTile(participant, _pulseController.value);
            },
          ),
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _participants.length,
      itemBuilder: (BuildContext context, int index) {
        final RoomParticipant participant = _participants[index];
        return _buildListTile(participant);
      },
    );
  }

  Widget _buildPinnedView() {
    final List<RoomParticipant> pinnedParticipants = _participants
        .where(
          (RoomParticipant p) => widget.pinnedUsers?.contains(p.walletAddress) ?? false,
        )
        .toList();
    final List<RoomParticipant> otherParticipants = _participants
        .where(
          (RoomParticipant p) => !(widget.pinnedUsers?.contains(p.walletAddress) ?? false),
        )
        .toList();

    return Column(
      children: <Widget>[
        // Large pinned videos (2x2 grid)
        if (pinnedParticipants.isNotEmpty)
          Expanded(
            flex: 3,
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: pinnedParticipants.length.clamp(0, 4),
              itemBuilder: (BuildContext context, int index) {
                return _buildLargeVideoTile(pinnedParticipants[index]);
              },
            ),
          ),

        // Small thumbnails for other participants
        if (otherParticipants.isNotEmpty)
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: otherParticipants.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 8),
                  child: _buildSmallVideoTile(otherParticipants[index]),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildVideoTile(RoomParticipant participant, double pulseValue) {
    final bool isActive = participant.isAudioEnabled;
    final double pulseIntensity = isActive ? (0.8 + pulseValue * 0.2) : 0.6;

    return GestureDetector(
      onTap: () => _handleParticipantTap(participant),
      onLongPress: () => _showParticipantOptions(participant),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: participant.role == 'host'
                ? Colors.yellow.withOpacity(pulseIntensity)
                : Colors.cyan.withOpacity(pulseIntensity),
            width: 2,
          ),
          boxShadow: <BoxShadow>[
            if (isActive)
              BoxShadow(
                color: Colors.cyan.withOpacity(0.3 * pulseValue),
                blurRadius: 10,
                spreadRadius: 2,
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: <Widget>[
              // Video content or placeholder
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.grey[900],
                child: participant.isVideoEnabled
                    ? _buildVideoWidget(participant)
                    : _buildAvatarPlaceholder(participant),
              ),

              // Status indicators
              Positioned(
                top: 8,
                left: 8,
                child: Row(
                  children: <Widget>[
                    if (participant.role == 'host')
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'HOST',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Audio/Video status
              Positioned(
                bottom: 8,
                right: 8,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (!participant.isAudioEnabled)
                      const Icon(
                        Icons.mic_off,
                        color: Colors.red,
                        size: 16,
                      ),
                    if (!participant.isVideoEnabled)
                      const Icon(
                        Icons.videocam_off,
                        color: Colors.red,
                        size: 16,
                      ),
                  ],
                ),
              ),

              // Name overlay
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    participant.displayName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(RoomParticipant participant) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900]?.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: participant.role == 'host'
              ? Colors.yellow.withOpacity(0.5)
              : Colors.cyan.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: <Widget>[
          // Avatar/Video thumbnail
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[800],
            ),
            child: participant.isVideoEnabled
                ? _buildVideoWidget(participant)
                : _buildAvatarPlaceholder(participant),
          ),

          const SizedBox(width: 12),

          // Participant info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      participant.displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (participant.role == 'host') ...<Widget>[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'HOST',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  'Joined ${_formatDuration(DateTime.now().difference(participant.joinTime))} ago',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Status icons
          Row(
            children: <Widget>[
              Icon(
                participant.isAudioEnabled ? Icons.mic : Icons.mic_off,
                color: participant.isAudioEnabled ? Colors.green : Colors.red,
                size: 20,
              ),
              const SizedBox(width: 8),
              Icon(
                participant.isVideoEnabled ? Icons.videocam : Icons.videocam_off,
                color: participant.isVideoEnabled ? Colors.green : Colors.red,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLargeVideoTile(RoomParticipant participant) {
    return _buildVideoTile(participant, 0.5); // Static for pinned view
  }

  Widget _buildSmallVideoTile(RoomParticipant participant) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.cyan.withOpacity(0.3)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: participant.isVideoEnabled
            ? _buildVideoWidget(participant)
            : _buildAvatarPlaceholder(participant),
      ),
    );
  }

  Widget _buildVideoWidget(RoomParticipant participant) {
    // LiveKit video rendering is handled by NvsVideoTile elsewhere
    return Container(
      color: Colors.grey[800],
      child: const Center(
        child: Icon(
          Icons.videocam,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  Widget _buildAvatarPlaceholder(RoomParticipant participant) {
    return Container(
      color: Colors.grey[800],
      child: Center(
        child: Text(
          participant.displayName.substring(0, 1).toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _handleParticipantTap(RoomParticipant participant) {
    // Handle tap - could open whisper, pin/unpin, etc.
    print('Tapped participant: ${participant.displayName}');
  }

  void _showParticipantOptions(RoomParticipant participant) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      builder: (BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.message, color: Colors.cyan),
              title: const Text(
                'Send Whisper',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.push_pin, color: Colors.yellow),
              title: const Text('Pin User', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.call, color: Colors.green),
              title: const Text(
                'Start Breakout',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else {
      return '${duration.inMinutes}m';
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }
}

class RoomParticipant {
  const RoomParticipant({
    required this.walletAddress,
    required this.displayName,
    required this.isVideoEnabled,
    required this.isAudioEnabled,
    required this.role,
    required this.joinTime,
  });
  final String walletAddress;
  final String displayName;
  final bool isVideoEnabled;
  final bool isAudioEnabled;
  final String role; // 'host', 'moderator', 'participant'
  final DateTime joinTime;
}
