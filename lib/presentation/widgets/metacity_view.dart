// packages/now/lib/presentation/widgets/metacity_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// import 'package:unity_widget/unity_widget.dart'; // Unity integration package
import 'package:nvs/meatup_core.dart';
import '../../services/unity_bridge_service.dart';
import '../../services/map_websocket_service.dart';
import '../../data/models/map_models.dart';

class UnityWidget extends StatefulWidget {
  const UnityWidget({
    super.key,
    this.onUnityCreated,
    this.onUnityMessage,
    this.onUnitySceneLoaded,
  });

  final Future<void> Function(UnityWidgetController controller)? onUnityCreated;
  final void Function(dynamic message)? onUnityMessage;
  final void Function(String sceneName)? onUnitySceneLoaded;

  @override
  State<UnityWidget> createState() => _UnityWidgetState();
}

class _UnityWidgetState extends State<UnityWidget> {
  bool _dispatched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_dispatched) return;
    _dispatched = true;
    Future.microtask(() async {
      if (widget.onUnityCreated != null) {
        await widget.onUnityCreated!(UnityWidgetController._());
      }
      widget.onUnitySceneLoaded?.call('placeholder_scene');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

class UnityWidgetController {
  UnityWidgetController._();

  Future<void> resume() async {}
}


/// The MetacityView - Unity 3D scene for The Map experience
/// This handles the entire 3D map with real-time user auras and interactions
class MetacityView extends ConsumerStatefulWidget {
  const MetacityView({super.key});

  @override
  ConsumerState<MetacityView> createState() => _MetacityViewState();
}

class _MetacityViewState extends ConsumerState<MetacityView> {
  bool _isUnityReady = false;
  final bool _hasLocationPermission = false;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    // Initialize Unity bridge
    final unityBridge = ref.read(unityBridgeServiceProvider);
    await unityBridge.initialize();

    // Connect to WebSocket
    final webSocketService = ref.read(mapWebSocketServiceProvider);
    await webSocketService.connect();

    // Set up listeners
    _setupUnityMessageListener();
    _setupWebSocketEventListener();
  }

  void _setupUnityMessageListener() {
    ref.listen(unityMessagesProvider, (previous, next) {
      next.when(
        data: (message) => _handleUnityMessage(message),
        loading: () {},
        error: (error, stack) => print('Unity message error: $error'),
      );
    });
  }

  void _setupWebSocketEventListener() {
    ref.listen(mapEventsProvider, (previous, next) {
      next.when(
        data: (event) => _handleMapEvent(event),
        loading: () {},
        error: (error, stack) => print('WebSocket event error: $error'),
      );
    });
  }

  void _handleUnityMessage(UnityMessage message) {
    switch (message.type) {
      case UnityMessageType.unityReady:
        setState(() => _isUnityReady = true);
        _onUnityReady();
        break;

      case UnityMessageType.profileTapped:
        _openProfile(message.data['userId'] as String);
        break;

      case UnityMessageType.auraTapped:
        _handleAuraTapped(message.data);
        break;

      case UnityMessageType.mapTapped:
        _handleMapTapped(message.data);
        break;

      case UnityMessageType.cameraChanged:
        _handleCameraChanged(message.data);
        break;

      case UnityMessageType.unityError:
        _handleUnityError(message.data['error'] as String);
        break;
    }
  }

  void _handleMapEvent(MapEvent event) {
    if (!_isUnityReady) return;

    final unityBridge = ref.read(unityBridgeServiceProvider);

    switch (event.type) {
      case 'batch_user_update':
        final batchEvent = event as BatchUserUpdateEvent;
        unityBridge.updateUsers(batchEvent.users);
        break;

      case 'user_update':
        final updateEvent = event as UserUpdateEvent;
        unityBridge.updateUser(updateEvent.user);
        break;

      case 'user_leave':
        final leaveEvent = event as UserLeaveEvent;
        unityBridge.removeUser(leaveEvent.userId);
        break;

      case 'vibe_pulse':
        final pulseEvent = event as VibePulseEvent;
        unityBridge.showVibePulse(pulseEvent.pulse);
        break;

      case 'new_feed_post':
        final feedEvent = event as NewFeedPostEvent;
        unityBridge.showFeedPost(feedEvent.post);
        break;
    }
  }

  void _onUnityReady() {
    // Unity is ready, initialize the map
    final unityBridge = ref.read(unityBridgeServiceProvider);

    // Set initial map theme
    unityBridge.setMapTheme('cyberpunk_night');

    // Enable heatmap by default
    unityBridge.setHeatmapVisible(true);

    // Set initial camera position (San Francisco by default)
    unityBridge.setCameraPosition(37.7749, -122.4194, 12.0);
  }

  void _initializeQuantumMetacity() {
    debugPrint('Initializing Metacity scene bootstrap');
  }

  void _openProfile(String userId) {
    // Navigate to user profile
    context.push('/profile/$userId');
  }

  void _handleAuraTapped(Map<String, dynamic> data) {
    final userId = data['userId'] as String;
    final position = data['position'] as Map<String, dynamic>?;

    // Show quick actions overlay or navigate to profile
    _showUserActions(userId, position);
  }

  void _handleMapTapped(Map<String, dynamic> data) {
    final position = data['position'] as Map<String, dynamic>;
    final lat = position['lat'] as double;
    final lon = position['lon'] as double;

    // Handle map tap - could show location options or create new post
    _showLocationActions(lat, lon);
  }

  void _handleCameraChanged(Map<String, dynamic> data) {
    // Update local state with new camera position
    // Could be used for analytics or saving user preferences
  }

  void _handleUnityError(String error) {
    // Handle Unity errors
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Map error: $error'),
        backgroundColor: NVSColors.errorColor,
      ),
    );
  }

  void _showUserActions(String userId, Map<String, dynamic>? position) {
    showModalBottomSheet(
      context: context,
      backgroundColor: NVSColors.cardBackground,
      builder: (context) => _UserActionsSheet(userId: userId),
    );
  }

  void _showLocationActions(double lat, double lon) {
    showModalBottomSheet(
      context: context,
      backgroundColor: NVSColors.cardBackground,
      builder: (context) => _LocationActionsSheet(lat: lat, lon: lon),
    );
  }

  @override
  Widget build(BuildContext context) {
    final connectionState = ref.watch(mapConnectionStateProvider);

    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      body: Stack(
        children: [
          // Unity View (full screen)
          _buildUnityView(),

          // Connection status overlay
          if (!_isUnityReady ||
              connectionState.value != WebSocketConnectionState.connected)
            _buildStatusOverlay(connectionState.value),

          // Map controls overlay
          if (_isUnityReady) _buildMapControls(),
        ],
      ),
    );
  }

  Widget _buildUnityView() {
    // Unity widget integration
    return Stack(
      children: [
        // Background for Unity scene
        Container(
          color: NVSColors.pureBlack,
          width: double.infinity,
          height: double.infinity,
        ),

        // Unity Widget placeholder - in production this would be the actual Unity widget
        if (!_isUnityReady)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.language,
                  size: 120,
                  color: NVSColors.ultraLightMint.withOpacity(0.5),
                ),
                const SizedBox(height: 24),
                Text(
                  'METACITY',
                  style: NvsTextStyles.display.copyWith(
                    fontSize: 32,
                    color: NVSColors.ultraLightMint,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Unity Scene Loading...',
                  style: NvsTextStyles.body.copyWith(
                    color: NVSColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: NVSColors.ultraLightMint,
                  ),
                ),
              ],
            ),
          ),

        // Unity Widget - Active Integration
        if (_isUnityReady)
          Positioned.fill(
            child: UnityWidget(
              onUnityCreated: (controller) async {
                await controller.resume();
                setState(() => _isUnityReady = true);
                _onUnityReady();
              },
              onUnityMessage: (message) {
                _handleUnityMessage(UnityMessage.fromJson(message));
              },
              onUnitySceneLoaded: (scene) {
                debugPrint('🎮 Unity scene loaded: $scene');
                _initializeQuantumMetacity();
              },
            ),
          ),

        //     useAndroidViewSurface: false,
        //   ),
        // ),
      ],
    );
  }

  Widget _buildStatusOverlay(WebSocketConnectionState? connectionState) {
    String status = 'Initializing...';
    Color statusColor = NVSColors.secondaryText;

    if (!_isUnityReady) {
      status = 'Loading Metacity...';
    } else if (connectionState != WebSocketConnectionState.connected) {
      status = 'Connecting to reality...';
      statusColor = NVSColors.turquoiseNeon;
    }

    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: NVSColors.cardBackground.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: statusColor.withOpacity(0.3), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: statusColor,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              status,
              style: NvsTextStyles.body.copyWith(
                fontSize: 14,
                color: statusColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapControls() {
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + 16,
      right: 16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildControlButton(icon: Icons.my_location, onTap: _centerOnUser),
          const SizedBox(height: 12),
          _buildControlButton(icon: Icons.layers, onTap: _toggleHeatmap),
          const SizedBox(height: 12),
          _buildControlButton(icon: Icons.add, onTap: _createPost),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: NVSColors.cardBackground.withOpacity(0.9),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: NVSColors.ultraLightMint.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Icon(icon, color: NVSColors.ultraLightMint, size: 24),
      ),
    );
  }

  void _centerOnUser() {
    // TODO: Get user location and center map
  }

  void _toggleHeatmap() {
    // TODO: Toggle heatmap visibility
    final unityBridge = ref.read(unityBridgeServiceProvider);
    unityBridge.setHeatmapVisible(true); // Toggle logic needed
  }

  void _createPost() {
    // TODO: Show create post dialog
  }
}

/// Bottom sheet for user actions
class _UserActionsSheet extends ConsumerWidget {
  final String userId;

  const _UserActionsSheet({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildActionTile(
            icon: Icons.person,
            title: 'View Profile',
            onTap: () {
              Navigator.pop(context);
              context.push('/profile/$userId');
            },
          ),
          _buildActionTile(
            icon: Icons.message,
            title: 'Send Message',
            onTap: () {
              Navigator.pop(context);
              context.push('/messages/$userId');
            },
          ),
          _buildActionTile(
            icon: Icons.favorite,
            title: 'Send Vibe',
            onTap: () {
              Navigator.pop(context);
              final webSocket = ref.read(mapWebSocketServiceProvider);
              webSocket.sendVibePulse(userId, 'yo');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: NVSColors.ultraLightMint),
      title: Text(
        title,
        style: NvsTextStyles.body.copyWith(color: NVSColors.ultraLightMint),
      ),
      onTap: onTap,
    );
  }
}

/// Bottom sheet for location actions
class _LocationActionsSheet extends ConsumerWidget {
  final double lat;
  final double lon;

  const _LocationActionsSheet({required this.lat, required this.lon});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Location Actions',
            style: NvsTextStyles.heading.copyWith(
              color: NVSColors.ultraLightMint,
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.add_comment, color: NVSColors.ultraLightMint),
            title: Text(
              'Post Here',
              style: NvsTextStyles.body.copyWith(
                color: NVSColors.ultraLightMint,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              // TODO: Open post creation dialog
            },
          ),
        ],
      ),
    );
  }
}
