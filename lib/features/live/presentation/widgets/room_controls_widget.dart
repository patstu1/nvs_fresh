import 'package:flutter/material.dart';
import '../../data/room_theme.dart';

/// Room controls widget with media controls, quality settings, and cyberpunk aesthetics.
///
/// Features:
/// - Video/audio toggle controls
/// - Screen sharing controls
/// - Quality settings
/// - Room statistics
/// - Cyberpunk styling with neon effects
class RoomControlsWidget extends StatefulWidget {
  const RoomControlsWidget({
    required this.onToggleVideo,
    required this.onToggleAudio,
    required this.onToggleScreenShare,
    required this.onLeaveRoom,
    required this.statistics,
    required this.theme,
    super.key,
  });
  final VoidCallback onToggleVideo;
  final VoidCallback onToggleAudio;
  final VoidCallback onToggleScreenShare;
  final VoidCallback onLeaveRoom;
  final Map<String, dynamic> statistics;
  final RoomTheme theme;

  @override
  State<RoomControlsWidget> createState() => _RoomControlsWidgetState();
}

class _RoomControlsWidgetState extends State<RoomControlsWidget> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _glowController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;

  bool _isVideoEnabled = true;
  bool _isAudioEnabled = true;
  bool _isScreenSharing = false;
  String _currentQuality = 'medium';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _updateStateFromStatistics();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    // Pulse animation for active controls
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
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

  void _updateStateFromStatistics() {
    setState(() {
      _isVideoEnabled = (widget.statistics['isVideoEnabled'] as bool?) ?? true;
      _isAudioEnabled = (widget.statistics['isAudioEnabled'] as bool?) ?? true;
      _isScreenSharing = (widget.statistics['isScreenSharing'] as bool?) ?? false;
      _currentQuality = (widget.statistics['currentQuality'] as String?) ?? 'medium';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.8),
        border: Border(
          top: BorderSide(
            color: const Color(0xFF4BEFE0).withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          // Left side - Media controls
          Expanded(
            flex: 2,
            child: _buildMediaControls(),
          ),

          // Center - Quality and stats
          Expanded(
            flex: 3,
            child: _buildQualityAndStats(),
          ),

          // Right side - Leave room
          Expanded(
            child: _buildLeaveButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        // Video toggle
        _buildControlButton(
          icon: _isVideoEnabled ? Icons.videocam : Icons.videocam_off,
          label: _isVideoEnabled ? 'Video On' : 'Video Off',
          isActive: _isVideoEnabled,
          onPressed: () {
            widget.onToggleVideo();
            setState(() {
              _isVideoEnabled = !_isVideoEnabled;
            });
          },
        ),

        // Audio toggle
        _buildControlButton(
          icon: _isAudioEnabled ? Icons.mic : Icons.mic_off,
          label: _isAudioEnabled ? 'Audio On' : 'Audio Off',
          isActive: _isAudioEnabled,
          onPressed: () {
            widget.onToggleAudio();
            setState(() {
              _isAudioEnabled = !_isAudioEnabled;
            });
          },
        ),

        // Screen share toggle
        _buildControlButton(
          icon: _isScreenSharing ? Icons.stop_screen_share : Icons.screen_share,
          label: _isScreenSharing ? 'Stop Share' : 'Share Screen',
          isActive: _isScreenSharing,
          onPressed: () {
            widget.onToggleScreenShare();
            setState(() {
              _isScreenSharing = !_isScreenSharing;
            });
          },
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AnimatedBuilder(
          animation: _glowAnimation,
          builder: (BuildContext context, Widget? child) {
            return Transform.scale(
              scale: isActive ? 1.0 + (0.1 * _glowAnimation.value) : 1.0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? const Color(0xFF4BEFE0) : Colors.grey.withValues(alpha: 0.3),
                  boxShadow: isActive
                      ? <BoxShadow>[
                          BoxShadow(
                            color: const Color(0xFF4BEFE0).withValues(alpha: 0.5),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: IconButton(
                  onPressed: onPressed,
                  icon: Icon(
                    icon,
                    color: isActive ? Colors.black : Colors.white,
                    size: 24,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? const Color(0xFF4BEFE0) : Colors.grey,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildQualityAndStats() {
    return Column(
      children: <Widget>[
        // Quality selector
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Quality: ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF4BEFE0).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF4BEFE0).withValues(alpha: 0.5),
                ),
              ),
              child: DropdownButton<String>(
                value: _currentQuality,
                dropdownColor: const Color(0xFF1A1A1A),
                style: const TextStyle(
                  color: Color(0xFF4BEFE0),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                underline: const SizedBox(),
                items: const <DropdownMenuItem<String>>[
                  DropdownMenuItem(
                    value: 'low',
                    child: Text('360p'),
                  ),
                  DropdownMenuItem(
                    value: 'medium',
                    child: Text('720p'),
                  ),
                  DropdownMenuItem(
                    value: 'high',
                    child: Text('1080p'),
                  ),
                ],
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      _currentQuality = value;
                    });
                    // This would trigger quality change in video service
                  }
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Statistics
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildStatItem(
              icon: Icons.people,
              label: 'Participants',
              value: '${widget.statistics['participantCount'] ?? 0}',
            ),
            _buildStatItem(
              icon: Icons.speed,
              label: 'Bitrate',
              value: '${(widget.statistics['averageBitrate'] ?? 0).toStringAsFixed(1)} Mbps',
            ),
            _buildStatItem(
              icon: Icons.timer,
              label: 'Latency',
              value: '${(widget.statistics['averageLatency'] ?? 0).toStringAsFixed(0)}ms',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: <Widget>[
        Icon(
          icon,
          color: const Color(0xFF4BEFE0),
          size: 16,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildLeaveButton() {
    return Center(
      child: Column(
        children: <Widget>[
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (BuildContext context, Widget? child) {
              return Transform.scale(
                scale: 1.0 + (0.05 * _pulseAnimation.value),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.withValues(alpha: 0.8),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.red.withValues(alpha: 0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: _showLeaveConfirmation,
                    icon: const Icon(
                      Icons.call_end,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 4),
          const Text(
            'Leave',
            style: TextStyle(
              color: Colors.red,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showLeaveConfirmation() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Leave Room?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Are you sure you want to leave this room? You will lose your connection to all participants.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
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
              Navigator.of(context).pop();
              widget.onLeaveRoom();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }
}
