// lib/features/live/presentation/widgets/presence_grid.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/video_participant.dart';
import '../../domain/models/user_role.dart';
import 'package:nvs/meatup_core.dart';

class PresenceGrid extends ConsumerStatefulWidget {
  const PresenceGrid({
    required this.participants,
    super.key,
    this.currentUserId,
    this.onParticipantTap,
    this.onParticipantLongPress,
    this.showControls = true,
    this.maxVisible = 9,
  });
  final List<VideoParticipant> participants;
  final String? currentUserId;
  final Function(VideoParticipant)? onParticipantTap;
  final Function(VideoParticipant)? onParticipantLongPress;
  final bool showControls;
  final int maxVisible;

  @override
  ConsumerState<PresenceGrid> createState() => _PresenceGridState();
}

class _PresenceGridState extends ConsumerState<PresenceGrid> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<VideoParticipant> visibleParticipants =
        widget.participants.take(widget.maxVisible).toList();
    final int extraCount = widget.participants.length - widget.maxVisible;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NVSColors.cardBackground.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: NVSColors.ultraLightMint.withValues(alpha: 0.3),
        ),
        boxShadow: NVSColors.mintGlow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildHeader(),
          const SizedBox(height: 16),
          _buildGrid(visibleParticipants, extraCount),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: <Widget>[
        const Icon(
          Icons.people_alt_outlined,
          color: NVSColors.ultraLightMint,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          'Live (${widget.participants.length})',
          style: const TextStyle(
            fontFamily: 'MagdaClean',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: NVSColors.ultraLightMint,
          ),
        ),
        const Spacer(),
        if (widget.showControls) _buildGridToggle(),
      ],
    );
  }

  Widget _buildGridToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: NVSColors.avocadoGreen.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: NVSColors.avocadoGreen.withValues(alpha: 0.5),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.grid_view, color: NVSColors.avocadoGreen, size: 14),
          SizedBox(width: 4),
          Text(
            'GRID',
            style: TextStyle(
              fontFamily: 'MagdaClean',
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: NVSColors.avocadoGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(List<VideoParticipant> participants, int extraCount) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getCrossAxisCount(
          participants.length + (extraCount > 0 ? 1 : 0),
        ),
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: participants.length + (extraCount > 0 ? 1 : 0),
      itemBuilder: (BuildContext context, int index) {
        if (index < participants.length) {
          return _buildParticipantTile(participants[index]);
        } else {
          return _buildExtraCountTile(extraCount);
        }
      },
    );
  }

  int _getCrossAxisCount(int totalItems) {
    if (totalItems <= 1) return 1;
    if (totalItems <= 4) return 2;
    if (totalItems <= 9) return 3;
    return 4;
  }

  Widget _buildParticipantTile(VideoParticipant participant) {
    final bool isCurrentUser = participant.userId == widget.currentUserId;
    final bool isHost = participant.role == UserRole.host;
    final bool isCoHost = participant.role == UserRole.coHost;

    return GestureDetector(
      onTap: () => widget.onParticipantTap?.call(participant),
      onLongPress: () => widget.onParticipantLongPress?.call(participant),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              NVSColors.pureBlack.withValues(alpha: 0.8),
              NVSColors.cardBackground.withValues(alpha: 0.6),
            ],
          ),
          border: Border.all(
            color: isCurrentUser
                ? NVSColors.avocadoGreen
                : isHost || isCoHost
                    ? NVSColors.electricPink
                    : NVSColors.ultraLightMint.withValues(alpha: 0.3),
            width: isCurrentUser || isHost || isCoHost ? 2 : 1,
          ),
          boxShadow: isCurrentUser
              ? <BoxShadow>[
                  BoxShadow(
                    color: NVSColors.avocadoGreen.withValues(alpha: 0.4),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: <Widget>[
            // Video/Avatar area
            ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: participant.isVideoEnabled
                  ? _buildVideoFeed(participant)
                  : _buildAvatarPlaceholder(participant),
            ),

            // Status indicators
            Positioned(
              top: 4,
              left: 4,
              child: _buildStatusIndicators(participant),
            ),

            // Role badge
            if (isHost || isCoHost)
              Positioned(
                top: 4,
                right: 4,
                child: _buildRoleBadge(participant.role),
              ),

            // Name label
            Positioned(
              bottom: 4,
              left: 4,
              right: 4,
              child: _buildNameLabel(participant),
            ),

            // Pulse animation for speaking
            if (participant.isAudioEnabled)
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (BuildContext context, Widget? child) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(
                          color: NVSColors.turquoiseNeon.withValues(
                            alpha: 0.6 * _pulseAnimation.value,
                          ),
                          width: 2,
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoFeed(VideoParticipant participant) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            NVSColors.cardBackground.withValues(alpha: 0.8),
            NVSColors.pureBlack.withValues(alpha: 0.9),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.videocam,
          color: NVSColors.ultraLightMint.withValues(alpha: 0.6),
          size: 24,
        ),
      ),
    );
  }

  Widget _buildAvatarPlaceholder(VideoParticipant participant) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: <Color>[
            NVSColors.turquoiseNeon.withValues(alpha: 0.3),
            NVSColors.pureBlack.withValues(alpha: 0.9),
          ],
        ),
      ),
      child: Center(
        child: participant.profileImage != null
            ? ClipOval(
                child: Image.asset(
                  participant.profileImage!,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              )
            : Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: NVSColors.ultraLightMint.withValues(alpha: 0.2),
                  border: Border.all(
                    color: NVSColors.ultraLightMint.withValues(alpha: 0.5),
                  ),
                ),
                child: Center(
                  child: Text(
                    participant.displayName.isNotEmpty
                        ? participant.displayName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontFamily: 'MagdaClean',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: NVSColors.ultraLightMint,
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildStatusIndicators(VideoParticipant participant) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (!participant.isAudioEnabled)
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B6B).withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.mic_off, color: Colors.white, size: 12),
          ),
        if (!participant.isVideoEnabled && participant.isAudioEnabled) const SizedBox(width: 2),
        if (participant.isScreenSharing)
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: NVSColors.electricPink.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.screen_share, color: Colors.white, size: 12),
          ),
      ],
    );
  }

  Widget _buildRoleBadge(UserRole role) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: role == UserRole.host
            ? NVSColors.electricPink.withValues(alpha: 0.9)
            : NVSColors.turquoiseNeon.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        role == UserRole.host ? 'HOST' : 'CO-HOST',
        style: const TextStyle(
          fontFamily: 'MagdaClean',
          fontSize: 8,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildNameLabel(VideoParticipant participant) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: NVSColors.pureBlack.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        participant.displayName.length > 8
            ? '${participant.displayName.substring(0, 8)}...'
            : participant.displayName,
        style: const TextStyle(
          fontFamily: 'MagdaClean',
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: NVSColors.ultraLightMint,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildExtraCountTile(int extraCount) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: NVSColors.cardBackground.withValues(alpha: 0.5),
        border: Border.all(
          color: NVSColors.ultraLightMint.withValues(alpha: 0.3),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.more_horiz,
              color: NVSColors.ultraLightMint.withValues(alpha: 0.7),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              '+$extraCount',
              style: TextStyle(
                fontFamily: 'MagdaClean',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: NVSColors.ultraLightMint.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
