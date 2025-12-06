// lib/features/live/presentation/widgets/presence_grid_example.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/features/live/domain/models/video_participant.dart';
import '../../data/live_room_model.dart';
import 'presence_grid.dart';
import 'package:nvs/meatup_core.dart';

/// Example usage of PresenceGrid widget with mock data
class PresenceGridExample extends ConsumerWidget {
  const PresenceGridExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<dynamic> mockParticipants = _createMockParticipants();

    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      appBar: AppBar(
        backgroundColor: NVSColors.cardBackground,
        title: const Text(
          'Live Presence Grid',
          style: TextStyle(
            fontFamily: 'MagdaCleanMono',
            color: NVSColors.ultraLightMint,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: NVSColors.avocadoGreen),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Room: "Creative Minds Sync"',
                style: TextStyle(
                  fontFamily: 'MagdaCleanMono',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: NVSColors.ultraLightMint,
                ),
              ),
              const SizedBox(height: 16),

              // Main presence grid
              PresenceGrid(
                participants: mockParticipants,
                currentUserId: 'user_001', // Simulating current user
                onParticipantTap: (VideoParticipant participant) {
                  _showParticipantInfo(context, participant);
                },
                onParticipantLongPress: (VideoParticipant participant) {
                  _showParticipantActions(context, participant);
                },
              ),

              const SizedBox(height: 24),

              // Compact version example
              const Text(
                'Compact View (Max 4):',
                style: TextStyle(
                  fontFamily: 'MagdaCleanMono',
                  fontSize: 16,
                  color: NVSColors.secondaryText,
                ),
              ),
              const SizedBox(height: 8),
              PresenceGrid(
                participants: mockParticipants.take(6).toList(),
                currentUserId: 'user_001',
                maxVisible: 4,
                showControls: false,
                onParticipantTap: (VideoParticipant participant) {
                  _showParticipantInfo(context, participant);
                },
              ),

              const Spacer(),

              // Action buttons
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Joining video call...'),
                            backgroundColor: NVSColors.avocadoGreen,
                          ),
                        );
                      },
                      icon: const Icon(Icons.videocam),
                      label: const Text('JOIN VIDEO'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: NVSColors.avocadoGreen,
                        foregroundColor: NVSColors.pureBlack,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Audio only mode...'),
                            backgroundColor: NVSColors.turquoiseNeon,
                          ),
                        );
                      },
                      icon: const Icon(Icons.mic),
                      label: const Text('AUDIO ONLY'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: NVSColors.turquoiseNeon,
                        side: const BorderSide(color: NVSColors.turquoiseNeon),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<VideoParticipant> _createMockParticipants() {
    return <dynamic>[
      VideoParticipant(
        userId: 'user_001',
        displayName: 'You',
        profileImage: 'assets/avatars/avatar1.png',
        role: UserRole.participant,
        joinedAt: DateTime.now().subtract(const Duration(minutes: 15)),
        currentSentiment: SentimentType.focused,
        metadata: <dynamic, dynamic>{},
      ),
      VideoParticipant(
        userId: 'user_002',
        displayName: 'Alex Chen',
        profileImage: 'assets/avatars/avatar2.png',
        role: UserRole.host,
        isScreenSharing: true,
        joinedAt: DateTime.now().subtract(const Duration(minutes: 45)),
        currentSentiment: SentimentType.energetic,
        metadata: <dynamic, dynamic>{},
      ),
      VideoParticipant(
        userId: 'user_003',
        displayName: 'Jordan',
        profileImage: 'assets/avatars/avatar3.png',
        role: UserRole.coHost,
        isVideoEnabled: false,
        joinedAt: DateTime.now().subtract(const Duration(minutes: 30)),
        currentSentiment: SentimentType.social,
        metadata: <dynamic, dynamic>{},
      ),
      VideoParticipant(
        userId: 'user_004',
        displayName: 'Riley Martinez',
        role: UserRole.participant,
        isAudioEnabled: false,
        joinedAt: DateTime.now().subtract(const Duration(minutes: 8)),
        currentSentiment: SentimentType.relaxed,
        metadata: <dynamic, dynamic>{},
      ),
      VideoParticipant(
        userId: 'user_005',
        displayName: 'Sam',
        role: UserRole.participant,
        joinedAt: DateTime.now().subtract(const Duration(minutes: 5)),
        metadata: <dynamic, dynamic>{},
      ),
      VideoParticipant(
        userId: 'user_006',
        displayName: 'Morgan Taylor',
        role: UserRole.participant,
        isVideoEnabled: false,
        joinedAt: DateTime.now().subtract(const Duration(minutes: 2)),
        metadata: <dynamic, dynamic>{},
      ),
      VideoParticipant(
        userId: 'user_007',
        displayName: 'Casey Liu',
        role: UserRole.participant,
        joinedAt: DateTime.now().subtract(const Duration(minutes: 1)),
        metadata: <dynamic, dynamic>{},
      ),
      VideoParticipant(
        userId: 'user_008',
        displayName: 'Avery Kim',
        role: UserRole.participant,
        isAudioEnabled: false,
        joinedAt: DateTime.now(),
        metadata: <dynamic, dynamic>{},
      ),
      VideoParticipant(
        userId: 'user_009',
        displayName: 'Quinn',
        role: UserRole.spectator,
        isVideoEnabled: false,
        isAudioEnabled: false,
        joinedAt: DateTime.now(),
        metadata: <dynamic, dynamic>{},
      ),
      VideoParticipant(
        userId: 'user_010',
        displayName: 'Dakota Green',
        role: UserRole.participant,
        joinedAt: DateTime.now(),
        metadata: <dynamic, dynamic>{},
      ),
    ];
  }

  void _showParticipantInfo(
    BuildContext context,
    VideoParticipant participant,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: NVSColors.cardBackground,
        title: Text(
          participant.displayName,
          style: const TextStyle(
            fontFamily: 'MagdaCleanMono',
            color: NVSColors.ultraLightMint,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildInfoRow('Role:', participant.role.name.toUpperCase()),
            _buildInfoRow('Video:', participant.isVideoEnabled ? 'ON' : 'OFF'),
            _buildInfoRow('Audio:', participant.isAudioEnabled ? 'ON' : 'OFF'),
            _buildInfoRow(
              'Screen:',
              participant.isScreenSharing ? 'SHARING' : 'NOT SHARING',
            ),
            if (participant.currentSentiment != null)
              _buildInfoRow(
                'Mood:',
                participant.currentSentiment!.name.toUpperCase(),
              ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'CLOSE',
              style: TextStyle(color: NVSColors.avocadoGreen),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              color: NVSColors.secondaryText,
              fontFamily: 'MagdaCleanMono',
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: NVSColors.ultraLightMint,
              fontFamily: 'MagdaCleanMono',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showParticipantActions(
    BuildContext context,
    VideoParticipant participant,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: NVSColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              participant.displayName,
              style: const TextStyle(
                fontFamily: 'MagdaCleanMono',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: NVSColors.ultraLightMint,
              ),
            ),
            const SizedBox(height: 16),
            _buildActionButton(
              icon: Icons.message,
              label: 'Send Message',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Opening chat with ${participant.displayName}'),
                  ),
                );
              },
            ),
            _buildActionButton(
              icon: Icons.person,
              label: 'View Profile',
              onTap: () {
                Navigator.pop(context);
                _showParticipantInfo(context, participant);
              },
            ),
            if (participant.role != UserRole.host)
              _buildActionButton(
                icon: Icons.block,
                label: 'Mute/Hide',
                color: const Color(0xFFFF6B6B),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${participant.displayName} muted')),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    final Color buttonColor = color ?? NVSColors.ultraLightMint;

    return ListTile(
      leading: Icon(icon, color: buttonColor),
      title: Text(
        label,
        style: TextStyle(
          fontFamily: 'MagdaCleanMono',
          color: buttonColor,
        ),
      ),
      onTap: onTap,
    );
  }
}
