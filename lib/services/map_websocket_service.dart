// packages/now/lib/services/map_websocket_service.dart

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/map_models.dart';

/// WebSocket service for real-time map communication
class MapWebSocketService {
  static const String _endpoint = 'wss://realtime.nvs.app/map';

  WebSocket? _socket;
  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;

  final StreamController<MapEvent> _eventController =
      StreamController.broadcast();
  final StreamController<WebSocketConnectionState> _connectionController =
      StreamController.broadcast();

  bool _isConnecting = false;
  bool _shouldReconnect = true;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  static const Duration _reconnectDelay = Duration(seconds: 2);
  static const Duration _heartbeatInterval = Duration(seconds: 30);

  /// Stream of incoming map events
  Stream<MapEvent> get events => _eventController.stream;

  /// Stream of connection state changes
  Stream<WebSocketConnectionState> get connectionState =>
      _connectionController.stream;

  /// Connect to the map WebSocket
  Future<void> connect({String? authToken}) async {
    if (_isConnecting || _socket != null) return;

    _isConnecting = true;
    _connectionController.add(WebSocketConnectionState.connecting);

    try {
      final uri = Uri.parse(_endpoint);
      final headers = <String, String>{};

      if (authToken != null) {
        headers['Authorization'] = 'Bearer $authToken';
      }

      _socket = await WebSocket.connect(uri.toString(), headers: headers);

      _isConnecting = false;
      _reconnectAttempts = 0;
      _connectionController.add(WebSocketConnectionState.connected);

      _setupSocketListeners();
      _startHeartbeat();
    } catch (e) {
      _isConnecting = false;
      _connectionController.add(WebSocketConnectionState.disconnected);
      _handleConnectionError(e);
    }
  }

  /// Disconnect from the WebSocket
  void disconnect() {
    _shouldReconnect = false;
    _cleanup();
    _connectionController.add(WebSocketConnectionState.disconnected);
  }

  /// Send a message to the server
  void sendMessage(Map<String, dynamic> message) {
    if (_socket?.readyState == WebSocket.open) {
      _socket!.add(jsonEncode(message));
    }
  }

  /// Send vibe pulse to another user
  void sendVibePulse(String toUserId, String pulseType) {
    sendMessage({
      'type': 'send_vibe_pulse',
      'toUserId': toUserId,
      'pulseType': pulseType,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Update user location
  void updateLocation(double lat, double lon) {
    sendMessage({
      'type': 'location_update',
      'lat': lat,
      'lon': lon,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Post to live feed
  void postToFeed(String text, double lat, double lon, Duration expiration) {
    sendMessage({
      'type': 'post_feed',
      'text': text,
      'lat': lat,
      'lon': lon,
      'expiration': DateTime.now().add(expiration).toIso8601String(),
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  void _setupSocketListeners() {
    _socket!.listen(
      _handleMessage,
      onError: _handleConnectionError,
      onDone: _handleDisconnection,
    );
  }

  void _handleMessage(dynamic data) {
    try {
      final message = jsonDecode(data as String) as Map<String, dynamic>;

      // Handle heartbeat response
      if (message['type'] == 'pong') {
        return;
      }

      // Parse and emit map event
      final event = MapEvent.fromJson(message);
      _eventController.add(event);
    } catch (e) {
      print('Error parsing WebSocket message: $e');
    }
  }

  void _handleConnectionError(dynamic error) {
    print('WebSocket error: $error');
    _connectionController.add(WebSocketConnectionState.error);

    if (_shouldReconnect && _reconnectAttempts < _maxReconnectAttempts) {
      _scheduleReconnect();
    }
  }

  void _handleDisconnection() {
    print('WebSocket disconnected');
    _cleanup();
    _connectionController.add(WebSocketConnectionState.disconnected);

    if (_shouldReconnect && _reconnectAttempts < _maxReconnectAttempts) {
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    _reconnectAttempts++;
    final delay = Duration(
      seconds: _reconnectDelay.inSeconds * _reconnectAttempts,
    );

    _reconnectTimer = Timer(delay, () {
      if (_shouldReconnect) {
        connect();
      }
    });
  }

  void _startHeartbeat() {
    _heartbeatTimer = Timer.periodic(_heartbeatInterval, (timer) {
      if (_socket?.readyState == WebSocket.open) {
        sendMessage({'type': 'ping'});
      }
    });
  }

  void _cleanup() {
    _socket?.close();
    _socket = null;
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  void dispose() {
    _shouldReconnect = false;
    _cleanup();
    _eventController.close();
    _connectionController.close();
  }
}

/// WebSocket connection states
enum WebSocketConnectionState { disconnected, connecting, connected, error }

/// Provider for the map WebSocket service
final mapWebSocketServiceProvider = Provider<MapWebSocketService>((ref) {
  final service = MapWebSocketService();

  // Auto-dispose when no longer needed
  ref.onDispose(() {
    service.dispose();
  });

  return service;
});

/// Provider for WebSocket connection state
final mapConnectionStateProvider = StreamProvider<WebSocketConnectionState>((
  ref,
) {
  final service = ref.watch(mapWebSocketServiceProvider);
  return service.connectionState;
});

/// Provider for map events
final mapEventsProvider = StreamProvider<MapEvent>((ref) {
  final service = ref.watch(mapWebSocketServiceProvider);
  return service.events;
});








