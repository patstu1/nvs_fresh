import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../../data/live_room_model.dart';
import '../../data/user_role.dart';
import '../../data/room_theme.dart';

/// Individual video participant widget with cyberpunk aesthetics and status indicators.
///
/// Features:
/// - Video stream rendering with WebRTC
/// - Status indicators (audio/video/screen sharing)
/// - Cyberpunk styling with neon effects
/// - Smooth animations and transitions
/// - Participant information overlay
class VideoParticipantWidget extends StatefulWidget {
  const VideoParticipantWidget({
    required this.participant,
    required this.theme,
    required this.isLocal,
    super.key,
    this.renderer,
    this.isLarge = false,
  });
  final VideoParticipant participant;
  final RTCVideoRenderer? renderer;
  final RoomTheme theme;
  final bool isLocal;
  final bool isLarge;

  @override
  State<VideoParticipantWidget> createState() => _VideoParticipantWidgetState();
}

class _VideoParticipantWidgetState extends State<VideoParticipantWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _glowController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    // Pulse animation for speaking indicator
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Glow animation for cyberpunk effect
    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _glowAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Start animations
    _glowController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getBorderColor(), width: 2),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: _getBorderColor().withValues(alpha: 0.3),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: <Widget>[
            // Video stream
            _buildVideoStream(),

            // Overlay elements
            _buildOverlay(),

            // Status indicators
            _buildStatusIndicators(),

            // Participant info
            _buildParticipantInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoStream() {
    if (widget.renderer != null && widget.participant.isVideoEnabled) {
      return RTCVideoView(
        widget.renderer!,
        objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
      );
    } else {
      // Placeholder when video is disabled or no stream
      return DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              _getThemeColor().withValues(alpha: 0.3),
              _getThemeColor().withValues(alpha: 0.1),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                widget.participant.isScreenSharing ? Icons.screen_share : Icons.person,
                size: widget.isLarge ? 80 : 40,
                color: _getThemeColor().withValues(alpha: 0.7),
              ),
              const SizedBox(height: 8),
              Text(
                widget.participant.displayName,
                style: TextStyle(
                  color: _getThemeColor(),
                  fontSize: widget.isLarge ? 18 : 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildOverlay() {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (BuildContext context, Widget? child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: RadialGradient(
              radius: 0.8,
              colors: <Color>[
                Colors.transparent,
                _getThemeColor().withValues(alpha: 0.1 * _glowAnimation.value),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusIndicators() {
    return Positioned(
      top: 8,
      right: 8,
      child: Column(
        children: <Widget>[
          // Audio indicator
          if (!widget.participant.isAudioEnabled)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.mic_off, color: Colors.white, size: 12),
            ),

          const SizedBox(height: 4),

          // Screen sharing indicator
          if (widget.participant.isScreenSharing)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: _getThemeColor().withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.screen_share, color: Colors.white, size: 12),
            ),

          const SizedBox(height: 4),

          // Role indicator
          if (widget.participant.role == UserRole.host)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700).withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.star, color: Colors.black, size: 12),
            ),
        ],
      ),
    );
  }

  Widget _buildParticipantInfo() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Colors.transparent, Colors.black.withValues(alpha: 0.7)],
          ),
        ),
        child: Row(
          children: <Widget>[
            // Speaking indicator
            if (widget.participant.isAudioEnabled)
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (BuildContext context, Widget? child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _getThemeColor(),
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              ),

            const SizedBox(width: 8),

            // Participant name
            Expanded(
              child: Text(
                widget.participant.displayName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Local indicator
            if (widget.isLocal)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _getThemeColor().withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'YOU',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getBorderColor() {
    if (widget.isLocal) {
      return const Color(0xFF4BEFE0);
    }

    final ThemeConfig themeConfig = ThemeConfig.getTheme(widget.theme);

    switch (widget.participant.role) {
      case UserRole.host:
        return const Color(0xFFFFD700);
      case UserRole.coHost:
        return themeConfig.accentColor;
      case UserRole.participant:
        return themeConfig.primaryColor;
      case UserRole.spectator:
        return Colors.grey;
      default:
        return const Color(0xFF4BEFE0);
    }
  }

  Color _getThemeColor() {
    final ThemeConfig themeConfig = ThemeConfig.getTheme(widget.theme);

    if (widget.isLocal) {
      return const Color(0xFF4BEFE0);
    }

    switch (widget.participant.role) {
      case UserRole.host:
        return const Color(0xFFFFD700);
      case UserRole.coHost:
        return themeConfig.accentColor;
      case UserRole.participant:
        return themeConfig.primaryColor;
      case UserRole.spectator:
        return Colors.grey;
      default:
        return const Color(0xFF4BEFE0);
    }
  }

  /// Start speaking animation
  void startSpeaking() {
    _pulseController.repeat(reverse: true);
  }

  /// Stop speaking animation
  void stopSpeaking() {
    _pulseController.stop();
    _pulseController.reset();
  }
}
