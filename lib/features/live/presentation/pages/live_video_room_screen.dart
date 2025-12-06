import 'package:flutter/material.dart';
// Agora disabled on simulator
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/live_room_model.dart';
import '../../data/user_role.dart';
import '../../data/room_theme.dart';
import '../../data/room_participant.dart';
import '../../services/video_room_service.dart';
// Agora removed
import '../../data/live_repository.dart' show LiveMessage;
import '../widgets/chat_sidebar_widget.dart';
import '../widgets/theme_selector_widget.dart';
import '../widgets/room_controls_widget.dart';
import '../widgets/icebreaker_widget.dart';
import '../widgets/breakout_rooms_widget.dart';

/// Main live video room screen with cyberpunk aesthetics and AI-powered features.
///
/// Features:
/// - Video grid with up to 10 participants
/// - Real-time chat with AI moderation
/// - Dynamic theme system with AI curation
/// - Icebreaker games and activities
/// - Breakout room support
/// - Advanced media controls
/// - Performance monitoring
class LiveVideoRoomScreen extends ConsumerStatefulWidget {
  const LiveVideoRoomScreen({
    required this.roomId,
    super.key,
    this.initialRole = UserRole.participant,
  });
  final String roomId;
  final UserRole initialRole;

  @override
  ConsumerState<LiveVideoRoomScreen> createState() => _LiveVideoRoomScreenState();
}

class _LiveVideoRoomScreenState extends ConsumerState<LiveVideoRoomScreen>
    with TickerProviderStateMixin {
  late VideoRoomService _videoService;

  // Room state
  LiveRoom? _room;
  final List<RoomParticipant> _participants = <RoomParticipant>[];
  final List<RoomMessage> _messages = <RoomMessage>[];
  RoomState _roomState = RoomState.waiting;
  RoomTheme _currentTheme = RoomTheme.cyberpunkRave;

  // UI state
  bool _isChatVisible = true;
  bool _isThemeSelectorVisible = false;
  bool _isIcebreakerVisible = false;
  bool _isBreakoutVisible = false;
  bool _isLoading = true;
  String? _errorMessage;

  // Animation controllers
  late AnimationController _backgroundController;
  late AnimationController _glowController;
  late AnimationController _pulseController;
  late Animation<double> _glowAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _initializeAnimations();
  }

  @override
  void dispose() {
    _videoService.dispose();
    _backgroundController.dispose();
    _glowController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _initializeServices() async {
    try {
      // Initialize video service
      _videoService = VideoRoomService();
      await _videoService.initialize();

      // Set up callbacks
      _videoService.onLocalStream = (_) {};
      _videoService.onRemoteStream = (_, __) {};
      _videoService.onRemoteStreamRemoved = (_) {};
      _videoService.onParticipantJoined = _onParticipantJoined;
      _videoService.onParticipantLeft = _onParticipantLeft;
      _videoService.onMessageReceived = _onMessageReceived;
      _videoService.onRoomStateChanged = _onRoomStateChanged;
      _videoService.onError = _onError;

      // Join room
      await _videoService.joinRoom(widget.roomId);

      await _loadRoomData();
      _listenToRoomUpdates();
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to initialize: $e';
        _isLoading = false;
      });
    }
  }

  void _initializeAnimations() {
    // Background animation controller
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    // Glow animation controller
    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _glowAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Pulse animation controller
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Start animations
    _backgroundController.repeat();
    _glowController.repeat(reverse: true);
    _pulseController.repeat(reverse: true);
  }

  // Video renderers were removed in this restoration because current VideoRoomService
  // uses AgoraView widgets directly. We'll reintroduce renderers when WebRTC paths are merged.

  Future<void> _loadRoomData() async {
    // This would load room data from Firestore
    // For now, we'll use mock data
    setState(() {
      _room = LiveRoom(
        id: widget.roomId,
        title: 'Cyberpunk Rave Room',
        description: 'High-energy neon vibes with electronic beats',
        emoji: '🎛️',
        activeUsers: 3,
        hostId: 'host_id',
        participants: <String>['user1', 'user2', 'user3'],
        coHosts: <String>[],
        maxParticipants: 10,
        createdAt: DateTime.now(),
        settings: <String, dynamic>{},
        tags: <String>['cyberpunk', 'rave', 'electronic'],
        themeData: <String, dynamic>{},
      );
      _currentTheme = _room!.theme;
    });
  }

  void _listenToRoomUpdates() {
    // Listen to room updates from Firestore
    // This would be implemented with Firestore streams
  }

  // Video service callbacks
  void _onLocalStream(dynamic _) {}
  void _onRemoteStream(String streamId, dynamic stream) {}
  void _onRemoteStreamRemoved(String streamId) {}

  void _onParticipantJoined(String userId) {
    // Handle participant joined
  }

  void _onParticipantLeft(String userId) {
    // Handle participant left
  }

  void _onMessageReceived(String channel, String message) {
    // Handle data channel message
  }

  void _onRoomStateChanged(RoomState state) {
    setState(() {
      _roomState = state;
    });
  }

  void _onError(String error) {
    setState(() {
      _errorMessage = error;
    });
  }

  // Theme management
  Future<void> _changeTheme(RoomTheme theme) async {
    try {
      setState(() {
        _currentTheme = theme;
        _isThemeSelectorVisible = false;
      });

      // Update room theme in Firestore
      // This would be implemented with Firestore update
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to change theme: $e';
      });
    }
  }

  // Chat management
  Future<void> _sendMessage(String message) async {
    try {
      await _videoService.sendMessage(message);
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to send message: $e';
      });
    }
  }

  // Media controls
  Future<void> _toggleVideo() async {
    await _videoService.toggleVideo();
  }

  Future<void> _toggleAudio() async {
    await _videoService.toggleAudio();
  }

  Future<void> _toggleScreenShare() async {
    final Map<String, dynamic> stats = await _videoService.getRoomStatistics();
    if (stats['isScreenSharing'] == true) {
      await _videoService.stopScreenSharing();
    } else {
      await _videoService.startScreenSharing();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingScreen();
    }

    if (_errorMessage != null) {
      return _buildErrorScreen();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          // Animated background
          _buildAnimatedBackground(),

          // Main content
          _buildMainContent(),

          // Overlays
          if (_isThemeSelectorVisible) _buildThemeSelectorOverlay(),
          if (_isIcebreakerVisible) _buildIcebreakerOverlay(),
          if (_isBreakoutVisible) _buildBreakoutOverlay(),

          // Error overlay
          if (_errorMessage != null) _buildErrorOverlay(),
        ],
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Animated loading icon (manual rotation instead of flutter_animate)
            AnimatedBuilder(
              animation: _backgroundController,
              builder: (BuildContext context, Widget? child) {
                return Transform.rotate(
                  angle: _backgroundController.value * 6.28318, // 2π
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color(0xFF4BEFE0),
                          Color(0xFF6366F1),
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.videocam,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            const Text(
              'Joining Room...',
              style: TextStyle(
                color: Color(0xFF4BEFE0),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Preparing cyberpunk experience',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.error_outline,
              color: Colors.red[400],
              size: 80,
            ),
            const SizedBox(height: 24),
            Text(
              'Connection Error',
              style: TextStyle(
                color: Colors.red[400],
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'Unknown error occurred',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _errorMessage = null;
                  _isLoading = true;
                });
                _initializeServices();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4BEFE0),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    final ThemeConfig themeConfig = ThemeConfig.getConfig(_currentTheme)!;

    return AnimatedBuilder(
      animation: Listenable.merge(<Listenable?>[_backgroundController, _glowAnimation]),
      builder: (BuildContext context, Widget? child) {
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                const Color(0xFF4BEFE0).withOpacity(0.1),
                const Color(0xFF4BEFE0).withOpacity(0.05),
                Colors.black,
              ],
              stops: const <double>[
                0.0,
                0.5,
                1.0,
              ],
            ),
          ),
          child: CustomPaint(
            painter: CyberpunkBackgroundPainter(
              themeConfig: themeConfig,
              animationValue: _backgroundController.value,
              glowIntensity: _glowAnimation.value,
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainContent() {
    return SafeArea(
      child: Column(
        children: <Widget>[
          // Header
          _buildHeader(),

          // Main content area
          Expanded(
            child: Row(
              children: <Widget>[
                // Video grid
                Expanded(
                  flex: 3,
                  child: _buildVideoGrid(),
                ),

                // Chat sidebar
                if (_isChatVisible)
                  SizedBox(
                    width: 320,
                    child: ChatSidebarWidget(
                      messages: const <LiveMessage>[],
                      onSendMessage: _sendMessage,
                      onClose: () => setState(() => _isChatVisible = false),
                    ),
                  ),
              ],
            ),
          ),

          // Bottom controls
          _buildBottomControls(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: <Widget>[
          // Room info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _room?.title ?? 'Live Room',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: <Widget>[
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _roomState == RoomState.active
                            ? const Color(0xFF4BEFE0)
                            : Colors.grey[600],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_participants.length} participants',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      _roomState.name.toUpperCase(),
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Theme indicator
          GestureDetector(
            onTap: () => setState(() => _isThemeSelectorVisible = true),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF4BEFE0)),
              ),
              child: Row(
                children: <Widget>[
                  const Icon(
                    Icons.palette,
                    color: Color(0xFF4BEFE0),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    ThemeConfig.getConfig(_currentTheme)!.name,
                    style: const TextStyle(
                      color: Color(0xFF4BEFE0),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Chat toggle
          IconButton(
            onPressed: () => setState(() => _isChatVisible = !_isChatVisible),
            icon: Icon(
              _isChatVisible ? Icons.chat_bubble : Icons.chat_bubble_outline,
              color: const Color(0xFF4BEFE0),
            ),
          ),

          // Icebreaker toggle
          IconButton(
            onPressed: () => setState(() => _isIcebreakerVisible = !_isIcebreakerVisible),
            icon: const Icon(
              Icons.games,
              color: Color(0xFF4BEFE0),
            ),
          ),

          // Breakout rooms toggle
          if (widget.initialRole == UserRole.host || widget.initialRole == UserRole.coHost)
            IconButton(
              onPressed: () => setState(() => _isBreakoutVisible = !_isBreakoutVisible),
              icon: const Icon(
                Icons.group_work,
                color: Color(0xFF4BEFE0),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVideoGrid() {
    // Video engine disabled on simulator; show placeholder
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4BEFE0).withOpacity(0.3)),
      ),
      child: const Stack(
        children: <Widget>[
          // Remote grid placeholder (shows when a remote joins)
          Positioned.fill(
            child: Center(
              child: Text(
                'Initializing video...',
                style: TextStyle(color: Color(0xFF4BEFE0)),
              ),
            ),
          ),

          // Local preview inset
          Positioned(
            right: 16,
            top: 16,
            child: SizedBox(
              width: 120,
              height: 180,
              child: SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: RoomControlsWidget(
        onToggleVideo: _toggleVideo,
        onToggleAudio: _toggleAudio,
        onToggleScreenShare: _toggleScreenShare,
        onLeaveRoom: () => _videoService.leaveRoom(),
        statistics: const <String, dynamic>{},
        theme: _currentTheme,
      ),
    );
  }

  Widget _buildThemeSelectorOverlay() {
    return ThemeSelectorWidget(
      currentTheme: _currentTheme,
      onThemeSelected: _changeTheme,
      onClose: () => setState(() => _isThemeSelectorVisible = false),
    );
  }

  Widget _buildIcebreakerOverlay() {
    return IcebreakerWidget(
      onClose: () => setState(() => _isIcebreakerVisible = false),
    );
  }

  Widget _buildBreakoutOverlay() {
    return BreakoutRoomsWidget(
      roomId: widget.roomId,
      onClose: () => setState(() => _isBreakoutVisible = false),
    );
  }

  Widget _buildErrorOverlay() {
    return ColoredBox(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.red),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.error_outline,
                color: Colors.red[400],
                size: 48,
              ),
              const SizedBox(height: 16),
              const Text(
                'Error',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage ?? 'Unknown error',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextButton(
                    onPressed: () => setState(() => _errorMessage = null),
                    child: const Text('Dismiss'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() => _errorMessage = null);
                      _initializeServices();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4BEFE0),
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom painter for cyberpunk background effects
class CyberpunkBackgroundPainter extends CustomPainter {
  CyberpunkBackgroundPainter({
    required this.themeConfig,
    required this.animationValue,
    required this.glowIntensity,
  });
  final ThemeConfig themeConfig;
  final double animationValue;
  final double glowIntensity;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw animated grid lines
    const double gridSpacing = 50.0;
    final double offset = animationValue * gridSpacing;

    paint.color = themeConfig.primaryColor.withOpacity(0.3 * glowIntensity);

    for (double x = -offset; x < size.width + gridSpacing; x += gridSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = -offset; y < size.height + gridSpacing; y += gridSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw pulsing circles
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double maxRadius = size.width * 0.3;

    paint.color = themeConfig.accentColor.withOpacity(0.1 * glowIntensity);
    paint.style = PaintingStyle.fill;

    for (int i = 0; i < 3; i++) {
      final double radius = maxRadius * (0.3 + 0.7 * animationValue) * (i + 1) / 3;
      canvas.drawCircle(Offset(centerX, centerY), radius, paint);
    }
  }

  @override
  bool shouldRepaint(CyberpunkBackgroundPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.glowIntensity != glowIntensity ||
        oldDelegate.themeConfig != themeConfig;
  }
}
