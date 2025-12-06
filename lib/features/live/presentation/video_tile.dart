// lib/features/live/presentation/video_tile.dart

import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';

class VideoTile extends StatefulWidget {
  const VideoTile({
    required this.participant, super.key,
    this.isListMode = false,
    this.isPinned = false,
    this.isSmall = false,
    this.onTap,
    this.onLongPress,
  });
  final Participant participant;
  final bool isListMode;
  final bool isPinned;
  final bool isSmall;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  State<VideoTile> createState() => _VideoTileState();
}

class _VideoTileState extends State<VideoTile> with TickerProviderStateMixin {
  late AnimationController _glowController;
  VideoTrack? _videoTrack;
  bool _isVideoEnabled = false;
  bool _isAudioEnabled = false;

  @override
  void initState() {
    super.initState();

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _updateTrackStatus();

    // Listen for track changes
    widget.participant.addListener(_onParticipantChanged);
  }

  void _onParticipantChanged() {
    _updateTrackStatus();
  }

  void _updateTrackStatus() {
    setState(() {
      // Get video track
      final TrackPublication<Track>? videoTrackPublication =
          widget.participant.videoTrackPublications
              .where(
                (TrackPublication<Track> pub) => pub.source == TrackSource.camera,
              )
              .firstOrNull;
      _videoTrack = videoTrackPublication?.track as VideoTrack?;
      _isVideoEnabled = videoTrackPublication?.subscribed ?? false && !videoTrackPublication!.muted;

      // Get audio status
      final TrackPublication<Track>? audioTrackPublication =
          widget.participant.audioTrackPublications
              .where(
                (TrackPublication<Track> pub) => pub.source == TrackSource.microphone,
              )
              .firstOrNull;
      _isAudioEnabled = audioTrackPublication?.subscribed ?? false && !audioTrackPublication!.muted;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isListMode) {
      return _buildListTile();
    } else {
      return _buildGridTile();
    }
  }

  Widget _buildGridTile() {
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: AnimatedBuilder(
        animation: _glowController,
        builder: (BuildContext context, Widget? child) {
          final double glowIntensity = _isAudioEnabled ? (0.8 + _glowController.value * 0.4) : 0.3;
          final Color borderColor = widget.participant is LocalParticipant
              ? Colors.yellow.withOpacity(glowIntensity)
              : Colors.cyan.withOpacity(glowIntensity);

          return DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: borderColor,
                width: widget.isPinned ? 3 : 2,
              ),
              boxShadow: _isAudioEnabled
                  ? <BoxShadow>[
                      BoxShadow(
                        color: borderColor.withOpacity(0.4),
                        blurRadius: 15 * _glowController.value,
                        spreadRadius: 3 * _glowController.value,
                      ),
                    ]
                  : <BoxShadow>[],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: <Widget>[
                  // Video content or avatar
                  _buildVideoContent(),

                  // Status indicators overlay
                  _buildStatusOverlay(),

                  // Name overlay
                  _buildNameOverlay(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildListTile() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900]?.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.participant is LocalParticipant
              ? Colors.yellow.withOpacity(0.5)
              : Colors.cyan.withOpacity(0.3),
        ),
      ),
      child: InkWell(
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        child: Row(
          children: <Widget>[
            // Video thumbnail
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[800],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _buildVideoContent(),
              ),
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
                        _getDisplayName(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (widget.participant is LocalParticipant) ...<Widget>[
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
                            'YOU',
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
                    widget.participant.identity,
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
                  _isAudioEnabled ? Icons.mic : Icons.mic_off,
                  color: _isAudioEnabled ? Colors.green : Colors.red,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Icon(
                  _isVideoEnabled ? Icons.videocam : Icons.videocam_off,
                  color: _isVideoEnabled ? Colors.green : Colors.red,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoContent() {
    if (_isVideoEnabled && _videoTrack != null) {
      return VideoTrackRenderer(_videoTrack!);
    } else {
      // Avatar placeholder
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey[800],
        child: Center(
          child: CircleAvatar(
            radius: widget.isSmall ? 20 : 30,
            backgroundColor: Colors.cyan.withOpacity(0.2),
            child: Text(
              _getDisplayName().substring(0, 1).toUpperCase(),
              style: TextStyle(
                color: Colors.cyan,
                fontSize: widget.isSmall ? 16 : 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildStatusOverlay() {
    return Positioned(
      top: 8,
      right: 8,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (!_isAudioEnabled)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.mic_off,
                color: Colors.white,
                size: 12,
              ),
            ),
          if (!_isAudioEnabled && !_isVideoEnabled) const SizedBox(width: 4),
          if (!_isVideoEnabled)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.videocam_off,
                color: Colors.white,
                size: 12,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNameOverlay() {
    if (widget.isSmall) return const SizedBox.shrink();

    return Positioned(
      bottom: 8,
      left: 8,
      right: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                _getDisplayName(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (widget.participant is LocalParticipant)
              Container(
                margin: const EdgeInsets.only(left: 4),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'YOU',
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
    );
  }

  String _getDisplayName() {
    final String name = widget.participant.name;
    if (name.isNotEmpty) {
      return name;
    }

    // Fallback to shortened identity (wallet address)
    final String identity = widget.participant.identity;
    if (identity.length > 8) {
      return '${identity.substring(0, 6)}...';
    }

    return identity;
  }

  @override
  void dispose() {
    widget.participant.removeListener(_onParticipantChanged);
    _glowController.dispose();
    super.dispose();
  }
}
