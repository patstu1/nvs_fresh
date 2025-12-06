// packages/now/lib/services/unity_bridge_service.dart

import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/map_models.dart';

/// Bridge service for Flutter-Unity communication
class UnityBridgeService {
  static const String _channelName = 'nvs_unity_bridge';
  static const MethodChannel _methodChannel = MethodChannel(_channelName);

  final StreamController<UnityMessage> _messageController =
      StreamController.broadcast();

  /// Stream of messages from Unity
  Stream<UnityMessage> get messages => _messageController.stream;

  /// Legacy accessor used by older services.
  Stream<UnityMessage> get messageStream => messages;

  UnityBridgeService() {
    _setupMethodCallHandler();
  }

  /// Initialize the Unity bridge
  Future<void> initialize() async {
    try {
      await _methodChannel.invokeMethod('initialize');
    } catch (e) {
      print('Error initializing Unity bridge: $e');
    }
  }

  /// Send message to Unity
  Future<void> sendToUnity(
    String gameObject,
    String method,
    String message,
  ) async {
    try {
      await _methodChannel.invokeMethod('sendToUnity', {
        'gameObject': gameObject,
        'method': method,
        'message': message,
      });
    } catch (e) {
      print('Error sending message to Unity: $e');
    }
  }

  /// Backwards compatible wrapper used by the metacity service.
  Future<void> sendMessage(String method, String payload) {
    return sendToUnity('MetacityManager', method, payload);
  }

  /// Send user data to Unity for aura creation/update
  Future<void> updateUser(MapUser user) async {
    final message = jsonEncode(user.toJson());
    await sendToUnity('AuraManager', 'UpdateUser', message);
  }

  /// Send batch user data to Unity
  Future<void> updateUsers(List<MapUser> users) async {
    final message = jsonEncode({
      'users': users.map((u) => u.toJson()).toList(),
    });
    await sendToUnity('AuraManager', 'BatchUpdateUsers', message);
  }

  /// Remove user from Unity
  Future<void> removeUser(String userId) async {
    await sendToUnity('AuraManager', 'RemoveUser', userId);
  }

  /// Send vibe pulse to Unity
  Future<void> showVibePulse(VibePulse pulse) async {
    final message = jsonEncode(pulse.toJson());
    await sendToUnity('AuraManager', 'ShowVibePulse', message);
  }

  /// Send live feed post to Unity
  Future<void> showFeedPost(LiveFeedPost post) async {
    final message = jsonEncode(post.toJson());
    await sendToUnity('FeedManager', 'ShowPost', message);
  }

  /// Update map camera position
  Future<void> setCameraPosition(double lat, double lon, double zoom) async {
    final message = jsonEncode({'lat': lat, 'lon': lon, 'zoom': zoom});
    await sendToUnity('MapManager', 'SetCameraPosition', message);
  }

  /// Set heatmap visibility
  Future<void> setHeatmapVisible(bool visible) async {
    await sendToUnity('MapManager', 'SetHeatmapVisible', visible.toString());
  }

  /// Set map theme
  Future<void> setMapTheme(String theme) async {
    await sendToUnity('MapManager', 'SetTheme', theme);
  }

  /// Handle incoming method calls from Unity
  void _setupMethodCallHandler() {
    _methodChannel.setMethodCallHandler((call) async {
      try {
        switch (call.method) {
          case 'onProfileTapped':
            _handleProfileTapped(call.arguments);
            break;
          case 'onAuraTapped':
            _handleAuraTapped(call.arguments);
            break;
          case 'onMapTapped':
            _handleMapTapped(call.arguments);
            break;
          case 'onCameraChanged':
            _handleCameraChanged(call.arguments);
            break;
          case 'onUnityReady':
            _handleUnityReady();
            break;
          case 'onUnityError':
            _handleUnityError(call.arguments);
            break;
          default:
            print('Unknown method call from Unity: ${call.method}');
        }
      } catch (e) {
        print('Error handling Unity method call: $e');
      }
    });
  }

  void _handleProfileTapped(dynamic arguments) {
    final userId = arguments['userId'] as String;
    _messageController.add(
      UnityMessage(
        type: UnityMessageType.profileTapped,
        data: {'userId': userId},
      ),
    );
  }

  void _handleAuraTapped(dynamic arguments) {
    final userId = arguments['userId'] as String;
    final position = arguments['position'] as Map<String, dynamic>?;
    _messageController.add(
      UnityMessage(
        type: UnityMessageType.auraTapped,
        data: {'userId': userId, 'position': position},
      ),
    );
  }

  void _handleMapTapped(dynamic arguments) {
    final position = arguments['position'] as Map<String, dynamic>;
    _messageController.add(
      UnityMessage(
        type: UnityMessageType.mapTapped,
        data: {'position': position},
      ),
    );
  }

  void _handleCameraChanged(dynamic arguments) {
    final camera = arguments as Map<String, dynamic>;
    _messageController.add(
      UnityMessage(type: UnityMessageType.cameraChanged, data: camera),
    );
  }

  void _handleUnityReady() {
    _messageController.add(
      UnityMessage(type: UnityMessageType.unityReady, data: {}),
    );
  }

  void _handleUnityError(dynamic arguments) {
    final error = arguments['error'] as String;
    _messageController.add(
      UnityMessage(type: UnityMessageType.unityError, data: {'error': error}),
    );
  }

  void dispose() {
    _messageController.close();
  }
}

/// Types of messages from Unity
enum UnityMessageType {
  profileTapped,
  auraTapped,
  mapTapped,
  cameraChanged,
  unityReady,
  unityError,
}

/// Message from Unity to Flutter
class UnityMessage {
  final UnityMessageType type;
  final Map<String, dynamic> data;

  const UnityMessage({required this.type, required this.data});

  factory UnityMessage.fromJson(dynamic raw) {
    if (raw is Map<String, dynamic>) {
      return UnityMessage(
        type: _unityMessageTypeFromRaw(raw['type'] as String?),
        data: Map<String, dynamic>.from(raw['data'] as Map? ?? <String, dynamic>{}),
      );
    }
    if (raw is String) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(raw) as Map<String, dynamic>;
        return UnityMessage.fromJson(decoded);
      } catch (_) {
        return const UnityMessage(
          type: UnityMessageType.unityError,
          data: <String, dynamic>{'error': 'invalid payload'},
        );
      }
    }
    return const UnityMessage(
      type: UnityMessageType.unityError,
      data: <String, dynamic>{'error': 'unknown payload'},
    );
  }

  static UnityMessageType _unityMessageTypeFromRaw(String? value) {
    switch (value) {
      case 'unityReady':
      case 'unity_ready':
        return UnityMessageType.unityReady;
      case 'profileTapped':
      case 'profile_tapped':
        return UnityMessageType.profileTapped;
      case 'auraTapped':
      case 'aura_tapped':
        return UnityMessageType.auraTapped;
      case 'mapTapped':
      case 'map_tapped':
        return UnityMessageType.mapTapped;
      case 'cameraChanged':
      case 'camera_changed':
        return UnityMessageType.cameraChanged;
      default:
        return UnityMessageType.unityError;
    }
  }
}

/// Provider for Unity bridge service
final unityBridgeServiceProvider = Provider<UnityBridgeService>((ref) {
  final service = UnityBridgeService();

  ref.onDispose(() {
    service.dispose();
  });

  return service;
});

/// Provider for Unity messages
final unityMessagesProvider = StreamProvider<UnityMessage>((ref) {
  final service = ref.watch(unityBridgeServiceProvider);
  return service.messages;
});







