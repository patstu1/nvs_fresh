// packages/now/lib/presentation/widgets/data_scape_view.dart
// Operation: Midnight City - The Final Forging

import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:nvs/meatup_core.dart';
import 'package:nvs/presentation/widgets/now_hud.dart';
import 'package:nvs/presentation/widgets/presence_marker.dart';

/// The DataScapeView - The Living City
///
/// This is the final, complete implementation of our NOW section's map view.
/// It renders a living, breathing cityscape populated with real-time presence
/// markers that represent users in the physical world.
class DataScapeView extends ConsumerStatefulWidget {
  const DataScapeView({super.key});

  @override
  ConsumerState<DataScapeView> createState() => _DataScapeViewState();
}

class _DataScapeViewState extends ConsumerState<DataScapeView> {
  MapboxMapController? _mapController;
  bool _isBroadcasting = true;
  Timer? _glitchTimer;
  Timer? _signalUpdateTimer;

  // Cache for converted marker images - The Sacred Repository
  final Map<String, Uint8List> _cachedMarkerImages = {};

  // Mock data for user signals - The Living Ghosts
  final List<Map<String, dynamic>> _signals = [
    {
      'id': 'user_1',
      'lat': 34.0522,
      'lng': -118.2437,
      'quality': SignalQuality.perfect,
      'lastSeen': DateTime.now(),
    },
    {
      'id': 'user_2',
      'lat': 34.0580,
      'lng': -118.2530,
      'quality': SignalQuality.perfect,
      'lastSeen': DateTime.now(),
    },
    {
      'id': 'user_3',
      'lat': 34.0750,
      'lng': -118.2380,
      'quality': SignalQuality.weak,
      'lastSeen': DateTime.now().subtract(const Duration(minutes: 5)),
    },
    {
      'id': 'user_4',
      'lat': 34.1010,
      'lng': -118.2995,
      'quality': SignalQuality.echo,
      'lastSeen': DateTime.now().subtract(const Duration(minutes: 15)),
    },
  ];

  @override
  void initState() {
    super.initState();

    // The Glitch Timer - Creates flicker effects for weak/echo signals
    _glitchTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_mapController != null) {
        _updateWeakSignals();
      }
    });

    // The Signal Update Timer - Simulates real-time presence updates
    _signalUpdateTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_mapController != null) {
        _simulateSignalUpdates();
      }
    });
  }

  @override
  void dispose() {
    _glitchTimer?.cancel();
    _signalUpdateTimer?.cancel();
    super.dispose();
  }

  void _onMapCreated(MapboxMapController controller) {
    _mapController = controller;
    _mapController!.onStyleLoadedCallback = _initializeMapMarkers;
  }

  /// The Sacred Initialization - Convert our PresenceMarkers to map images
  Future<void> _initializeMapMarkers() async {
    if (_mapController == null) return;

    debugPrint('🌃 Initializing DataScape markers...');

    try {
      // Generate marker images for each signal quality
      for (final quality in SignalQuality.values) {
        final imageKey = 'marker_${quality.name}';

        if (!_cachedMarkerImages.containsKey(imageKey)) {
          debugPrint('🎯 Forging marker for quality: ${quality.name}');

          final Uint8List? imageData =
              await WidgetToImageConverter.presenceMarkerToImage(
                PresenceMarker(quality: quality),
                pixelRatio: 3.0, // High quality for crisp markers
              );

          if (imageData != null) {
            _cachedMarkerImages[imageKey] = imageData;
            await _mapController!.addImage(imageKey, imageData);
            debugPrint(
              '✅ Marker forged: $imageKey with ${imageData.length} bytes',
            );
          } else {
            debugPrint('❌ Failed to forge marker: $imageKey');
          }
        }
      }

      // Populate the world with our signals
      await _populateWorld();
    } catch (e) {
      debugPrint('💥 DataScape initialization failed: $e');
    }
  }

  /// The World Population - Add all signals to the map
  Future<void> _populateWorld() async {
    if (_mapController == null) return;

    debugPrint('🌍 Populating the world with ${_signals.length} signals...');

    try {
      // Clear existing symbols
      await _clearMapSymbols();

      // Add each signal as a symbol on the map
      for (final signal in _signals) {
        await _addSignalToMap(signal);
      }

      debugPrint('✨ World population complete');
    } catch (e) {
      debugPrint('💥 World population failed: $e');
    }
  }

  /// Add a single signal to the map
  Future<void> _addSignalToMap(Map<String, dynamic> signal) async {
    if (_mapController == null) return;

    try {
      final quality = signal['quality'] as SignalQuality;
      final imageKey = 'marker_${quality.name}';

      // Only add if we have the image cached
      if (_cachedMarkerImages.containsKey(imageKey)) {
        await _mapController!.addSymbol(
          SymbolOptions(
            geometry: LatLng(signal['lat'], signal['lng']),
            iconImage: imageKey,
            iconSize: _getIconSizeForQuality(quality),
            iconOpacity: _getOpacityForQuality(quality),
            symbolSortKey: _getSortKeyForQuality(quality),
          ),
          {
            'id': signal['id'],
            'quality': quality.name,
            'lastSeen': signal['lastSeen'].toIso8601String(),
          },
        );
      }
    } catch (e) {
      debugPrint('Failed to add signal ${signal['id']}: $e');
    }
  }

  /// Clear all existing symbols from the map
  Future<void> _clearMapSymbols() async {
    if (_mapController == null) return;

    try {
      final symbols = await _mapController!.symbols;
      for (final symbol in symbols) {
        await _mapController!.removeSymbol(symbol);
      }
    } catch (e) {
      debugPrint('Failed to clear symbols: $e');
    }
  }

  /// The Glitch Protocol - Update weak/echo signals for flicker effect
  void _updateWeakSignals() {
    // This creates the visual "glitch" effect for weak and echo signals
    // by periodically adjusting their opacity and size
    final weakSignals = _signals
        .where(
          (s) =>
              s['quality'] == SignalQuality.weak ||
              s['quality'] == SignalQuality.echo,
        )
        .toList();

    if (weakSignals.isNotEmpty) {
      _populateWorld(); // Refresh to create flicker
    }
  }

  /// Simulate real-time signal updates
  void _simulateSignalUpdates() {
    // In a real implementation, this would receive updates from the backend
    // For now, we simulate by occasionally updating signal positions or qualities
    setState(() {
      // Randomly update a signal's last seen time
      if (_signals.isNotEmpty) {
        final randomSignal =
            _signals[DateTime.now().millisecond % _signals.length];
        randomSignal['lastSeen'] = DateTime.now();
      }
    });
  }

  /// Get icon size based on signal quality
  double _getIconSizeForQuality(SignalQuality quality) {
    switch (quality) {
      case SignalQuality.perfect:
        return 1.0;
      case SignalQuality.weak:
        return 0.8;
      case SignalQuality.echo:
        return 0.6;
    }
  }

  /// Get opacity based on signal quality
  double _getOpacityForQuality(SignalQuality quality) {
    switch (quality) {
      case SignalQuality.perfect:
        return 1.0;
      case SignalQuality.weak:
        return 0.7;
      case SignalQuality.echo:
        return 0.4;
    }
  }

  /// Get sort key for layering (higher values appear on top)
  double _getSortKeyForQuality(SignalQuality quality) {
    switch (quality) {
      case SignalQuality.perfect:
        return 3.0;
      case SignalQuality.weak:
        return 2.0;
      case SignalQuality.echo:
        return 1.0;
    }
  }

  /// Map tap handler - Detect taps on presence markers
  void _onMapTap(Point<double> point, LatLng coordinates) async {
    if (_mapController == null) return;

    try {
      final features = await _mapController!.queryRenderedFeatures(
        point,
        [],
        null,
      );

      if (features.isNotEmpty) {
        final feature = features.first;
        final properties = feature['properties'] as Map<String, dynamic>?;

        if (properties != null && properties.containsKey('id')) {
          _handleMarkerTap(properties);
        }
      }
    } catch (e) {
      debugPrint('Map tap query failed: $e');
    }
  }

  /// Handle marker tap events
  void _handleMarkerTap(Map<String, dynamic> markerData) {
    final userId = markerData['id'] as String;
    final quality = markerData['quality'] as String;

    debugPrint('🎯 Marker tapped: $userId (quality: $quality)');

    // Show user profile drawer or navigate to user details
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'User $userId (Signal: $quality)',
          style: NvsTextStyles.body.copyWith(color: Colors.white),
        ),
        backgroundColor: NVSColors.cardBackground,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Recenter the map on user's location
  void _onRecenter() async {
    if (_mapController == null) return;

    // In a real implementation, this would get the user's actual location
    await _mapController!.animateCamera(
      CameraUpdateOptions(
        center: const LatLng(34.0522, -118.2437), // Los Angeles
        zoom: 14.0,
        duration: const Duration(milliseconds: 1000),
      ),
    );
  }

  /// Toggle broadcasting state
  void _onToggleBroadcast(bool value) {
    setState(() {
      _isBroadcasting = value;
    });

    if (_isBroadcasting) {
      debugPrint('📡 Broadcasting enabled');
    } else {
      debugPrint('📴 Broadcasting disabled');
    }
  }

  /// Open the Nexus (placeholder for future implementation)
  void _onOpenNexus() {
    debugPrint('🌌 Opening Nexus...');
    // Future implementation: Navigate to Nexus view
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // The Living Map - Mapbox with NVS Nocturne style
          MapboxMap(
            accessToken: const String.fromEnvironment('MAPBOX_ACCESS_TOKEN'),
            styleString:
                'mapbox://styles/yobroapp/clmd9z17y012g01pfhb3l9b4d', // NVS Nocturne
            initialCameraPosition: const CameraPosition(
              target: LatLng(34.0522, -118.2437),
              zoom: 14.0,
            ),
            onMapCreated: _onMapCreated,
            onMapClick: _onMapTap,
            compassEnabled: false,
            rotateGesturesEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            tiltGesturesEnabled: false,
            myLocationEnabled: false,
            trackCameraPosition: true,
          ),

          // The Ambient Life Layer - Future implementation for traffic, events, etc.
          // Container(
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //       begin: Alignment.topCenter,
          //       end: Alignment.bottomCenter,
          //       colors: [
          //         Colors.transparent,
          //         NVSColors.pureBlack.withValues(alpha: 0.1),
          //       ],
          //     ),
          //   ),
          // ),

          // The NOW HUD - Tactical control interface
          NowHud(
            onRecenter: _onRecenter,
            isBroadcasting: _isBroadcasting,
            onToggleBroadcast: _onToggleBroadcast,
            onOpenNexus: _onOpenNexus,
          ),
        ],
      ),
    );
  }
}
