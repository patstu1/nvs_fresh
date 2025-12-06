import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

/// Berlin Beachhouse Radio Service for NVS Live Rooms
/// Provides ambient electronic music for all video/zoom rooms
class BerlinRadioService {
  factory BerlinRadioService() => _instance;
  BerlinRadioService._internal();
  static final BerlinRadioService _instance = BerlinRadioService._internal();

  final AudioPlayer _player = AudioPlayer();
  bool _isInitialized = false;
  bool _isPlaying = false;
  double _volume = 0.3; // Ambient level for video calls

  /// Berlin Beachhouse Radio stream URL
  static const String _radioStreamUrl = 'https://stream.beachhouse.radio/berlin';

  /// Alternative URLs for reliability
  static const List<String> _fallbackUrls = <String>[
    'https://radio.beachhouse.fm/berlin',
    'https://live.beachhouse.radio/stream',
  ];

  /// Initialize the radio service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _player.setVolume(_volume);
      await _player.setPlaybackRate(1.0);
      _isInitialized = true;
      debugPrint('🎵 Berlin Beachhouse Radio service initialized');
    } catch (e) {
      debugPrint('❌ Failed to initialize Berlin Radio: $e');
    }
  }

  /// Start playing Berlin Beachhouse Radio
  Future<void> startRadio() async {
    if (!_isInitialized) await initialize();
    if (_isPlaying) return;

    try {
      // Try primary stream first
      await _tryPlayStream(_radioStreamUrl);
    } catch (e) {
      debugPrint('🔄 Primary stream failed, trying fallbacks...');
      await _tryFallbackStreams();
    }
  }

  /// Stop the radio
  Future<void> stopRadio() async {
    if (!_isPlaying) return;

    await _player.stop();
    _isPlaying = false;
    debugPrint('⏹️ Berlin Beachhouse Radio stopped');
  }

  /// Set ambient volume for video calls
  Future<void> setAmbientVolume() async {
    _volume = 0.2; // Lower for calls
    await _player.setVolume(_volume);
  }

  /// Set normal volume
  Future<void> setNormalVolume() async {
    _volume = 0.4;
    await _player.setVolume(_volume);
  }

  /// Try to play a specific stream URL
  Future<void> _tryPlayStream(String url) async {
    await _player.play(UrlSource(url));
    _isPlaying = true;
    debugPrint('🎵 Berlin Beachhouse Radio playing: $url');
  }

  /// Try fallback stream URLs
  Future<void> _tryFallbackStreams() async {
    for (final String url in _fallbackUrls) {
      try {
        await _tryPlayStream(url);
        return; // Success
      } catch (e) {
        debugPrint('🔄 Fallback failed: $url');
        continue;
      }
    }

    // All streams failed, play local ambient track
    await _playLocalAmbient();
  }

  /// Play local ambient track as last resort
  Future<void> _playLocalAmbient() async {
    try {
      await _player.play(AssetSource('sounds/berlin_ambient.mp3'));
      _isPlaying = true;
      debugPrint('🎵 Playing local Berlin ambient track');
    } catch (e) {
      debugPrint('❌ Failed to play local ambient: $e');
    }
  }

  /// Auto-start when room is joined (disabled until stream confirmed)
  Future<void> onRoomJoined(String roomId) async {
    debugPrint('🎵 Berlin Radio available; awaiting explicit start for room: $roomId');
    // Intentionally do not auto-start to avoid failures in QA
  }

  /// Auto-stop when room is left
  Future<void> onRoomLeft(String roomId) async {
    debugPrint('⏹️ Stopping Berlin Radio for room: $roomId');
    await stopRadio();
  }

  /// Get current playing status
  bool get isPlaying => _isPlaying;
  bool get isInitialized => _isInitialized;
  double get volume => _volume;

  /// Dispose resources
  void dispose() {
    _player.dispose();
    _isInitialized = false;
    _isPlaying = false;
  }
}
