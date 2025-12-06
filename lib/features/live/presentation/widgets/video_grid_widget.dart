import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../../data/room_participant.dart';
import '../../data/video_participant.dart';
import '../../data/room_theme.dart';
import 'video_participant_widget.dart';

/// Responsive video grid widget that displays up to 10 participants
/// with cyberpunk aesthetics and smooth animations.
///
/// Features:
/// - Adaptive grid layout based on participant count
/// - Smooth transitions and animations
/// - Cyberpunk styling with neon effects
/// - Participant status indicators
/// - Screen sharing support
class VideoGridWidget extends StatefulWidget {
  const VideoGridWidget({
    required this.remoteStreams,
    required this.renderers,
    required this.participants,
    required this.theme,
    super.key,
    this.localStream,
  });
  final MediaStream? localStream;
  final Map<String, MediaStream> remoteStreams;
  final Map<String, RTCVideoRenderer> renderers;
  final List<RoomParticipant> participants;
  final RoomTheme theme;

  @override
  State<VideoGridWidget> createState() => _VideoGridWidgetState();
}

class _VideoGridWidgetState extends State<VideoGridWidget> with TickerProviderStateMixin {
  late AnimationController _gridAnimationController;
  late Animation<double> _gridAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void dispose() {
    _gridAnimationController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _gridAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _gridAnimation = CurvedAnimation(
      parent: _gridAnimationController,
      curve: Curves.easeInOutCubic,
    );

    _gridAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final List<RoomParticipant> allParticipants = _getAllParticipants();
    final GridLayout gridLayout = _calculateGridLayout(allParticipants.length);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF4BEFE0).withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF4BEFE0).withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: AnimatedBuilder(
          animation: _gridAnimation,
          builder: (BuildContext context, Widget? child) {
            return Transform.scale(
              scale: 0.8 + (0.2 * _gridAnimation.value),
              child: Opacity(
                opacity: _gridAnimation.value,
                child: _buildGridLayout(allParticipants, gridLayout),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGridLayout(
    List<RoomParticipant> participants,
    GridLayout layout,
  ) {
    switch (layout) {
      case GridLayout.single:
        return _buildSingleParticipant(participants.first);

      case GridLayout.horizontal:
        return _buildHorizontalLayout(participants);

      case GridLayout.vertical:
        return _buildVerticalLayout(participants);

      case GridLayout.grid2x2:
        return _build2x2Grid(participants);

      case GridLayout.grid3x3:
        return _build3x3Grid(participants);

      case GridLayout.grid4x4:
        return _build4x4Grid(participants);

      default:
        return _buildDefaultGrid(participants);
    }
  }

  Widget _buildSingleParticipant(RoomParticipant participant) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: VideoParticipantWidget(
        participant: VideoParticipant.fromParticipant(participant),
        renderer: _getRenderer(participant.userId),
        theme: widget.theme,
        isLocal: participant.userId == 'local',
        isLarge: true,
      ),
    );
  }

  Widget _buildHorizontalLayout(List<RoomParticipant> participants) {
    return Row(
      children: participants.map((RoomParticipant participant) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.all(4),
            child: VideoParticipantWidget(
              participant: VideoParticipant.fromParticipant(participant),
              renderer: _getRenderer(participant.userId),
              theme: widget.theme,
              isLocal: participant.userId == 'local',
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildVerticalLayout(List<RoomParticipant> participants) {
    return Column(
      children: participants.map((RoomParticipant participant) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.all(4),
            child: VideoParticipantWidget(
              participant: VideoParticipant.fromParticipant(participant),
              renderer: _getRenderer(participant.userId),
              theme: widget.theme,
              isLocal: participant.userId == 'local',
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _build2x2Grid(List<RoomParticipant> participants) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Row(
            children: participants.take(2).map((RoomParticipant participant) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.all(4),
                  child: VideoParticipantWidget(
                    participant: VideoParticipant.fromParticipant(participant),
                    renderer: _getRenderer(participant.userId),
                    theme: widget.theme,
                    isLocal: participant.userId == 'local',
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        if (participants.length > 2)
          Expanded(
            child: Row(
              children: participants.skip(2).take(2).map((RoomParticipant participant) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    child: VideoParticipantWidget(
                      participant: VideoParticipant.fromParticipant(
                        participant,
                      ),
                      renderer: _getRenderer(participant.userId),
                      theme: widget.theme,
                      isLocal: participant.userId == 'local',
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _build3x3Grid(List<RoomParticipant> participants) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Row(
            children: participants.take(3).map((RoomParticipant participant) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.all(4),
                  child: VideoParticipantWidget(
                    participant: VideoParticipant.fromParticipant(participant),
                    renderer: _getRenderer(participant.userId),
                    theme: widget.theme,
                    isLocal: participant.userId == 'local',
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        if (participants.length > 3)
          Expanded(
            child: Row(
              children: participants.skip(3).take(3).map((RoomParticipant participant) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    child: VideoParticipantWidget(
                      participant: VideoParticipant.fromParticipant(
                        participant,
                      ),
                      renderer: _getRenderer(participant.userId),
                      theme: widget.theme,
                      isLocal: participant.userId == 'local',
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _build4x4Grid(List<RoomParticipant> participants) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Row(
            children: participants.take(4).map((RoomParticipant participant) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.all(4),
                  child: VideoParticipantWidget(
                    participant: VideoParticipant.fromParticipant(participant),
                    renderer: _getRenderer(participant.userId),
                    theme: widget.theme,
                    isLocal: participant.userId == 'local',
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: Row(
            children: participants.skip(4).take(4).map((RoomParticipant participant) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.all(4),
                  child: VideoParticipantWidget(
                    participant: VideoParticipant.fromParticipant(participant),
                    renderer: _getRenderer(participant.userId),
                    theme: widget.theme,
                    isLocal: participant.userId == 'local',
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: Row(
            children: participants.skip(8).take(4).map((RoomParticipant participant) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.all(4),
                  child: VideoParticipantWidget(
                    participant: VideoParticipant.fromParticipant(participant),
                    renderer: _getRenderer(participant.userId),
                    theme: widget.theme,
                    isLocal: participant.userId == 'local',
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        if (participants.length > 12)
          Expanded(
            child: Row(
              children: participants.skip(12).take(4).map((RoomParticipant participant) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    child: VideoParticipantWidget(
                      participant: VideoParticipant.fromParticipant(
                        participant,
                      ),
                      renderer: _getRenderer(participant.userId),
                      theme: widget.theme,
                      isLocal: participant.userId == 'local',
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildDefaultGrid(List<RoomParticipant> participants) {
    // Fallback grid layout for any number of participants
    final int columns = (participants.length / 3).ceil();
    final int rows = (participants.length / columns).ceil();

    return Column(
      children: List.generate(rows, (int rowIndex) {
        return Expanded(
          child: Row(
            children: List.generate(columns, (int colIndex) {
              final int index = rowIndex * columns + colIndex;
              if (index >= participants.length) {
                return const Expanded(child: SizedBox());
              }

              final RoomParticipant participant = participants[index];
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.all(4),
                  child: VideoParticipantWidget(
                    participant: VideoParticipant.fromParticipant(participant),
                    renderer: _getRenderer(participant.userId),
                    theme: widget.theme,
                    isLocal: participant.userId == 'local',
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  List<RoomParticipant> _getAllParticipants() {
    final List<RoomParticipant> participants = <RoomParticipant>[];

    // Add local participant
    if (widget.localStream != null) {
      participants.add(
        RoomParticipant(
          userId: 'local',
          displayName: 'You',
          isScreenSharing: false,
          joinedAt: DateTime.now(),
          metadata: <String, dynamic>{},
        ),
      );
    }

    // Add remote participants
    participants.addAll(widget.participants);

    return participants;
  }

  GridLayout _calculateGridLayout(int participantCount) {
    if (participantCount == 1) return GridLayout.single;
    if (participantCount == 2) return GridLayout.horizontal;
    if (participantCount == 3) return GridLayout.horizontal;
    if (participantCount <= 4) return GridLayout.grid2x2;
    if (participantCount <= 6) return GridLayout.grid3x3;
    if (participantCount <= 10) return GridLayout.grid4x4;
    return GridLayout.defaultGrid;
  }

  RTCVideoRenderer? _getRenderer(String participantId) {
    if (participantId == 'local') {
      return widget.renderers['local'];
    }

    // Find available remote renderer
    for (final MapEntry<String, RTCVideoRenderer> entry in widget.renderers.entries) {
      if (entry.key.startsWith('remote_')) {
        return entry.value;
      }
    }

    return null;
  }
}

/// Grid layout types
enum GridLayout {
  single,
  horizontal,
  vertical,
  grid2x2,
  grid3x3,
  grid4x4,
  defaultGrid,
}
