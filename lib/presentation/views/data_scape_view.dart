// packages/now/lib/presentation/views/data_scape_view.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:nvs/meatup_core.dart';
import 'package:nvs/presentation/widgets/now_hud.dart';
import 'package:nvs/presentation/widgets/presence_marker.dart';

class DataScapeView extends ConsumerStatefulWidget {
  const DataScapeView({super.key});
  @override
  ConsumerState<DataScapeView> createState() => _DataScapeViewState();
}

class _DataScapeViewState extends ConsumerState<DataScapeView> {
  MapboxMap? _mapboxMap;
  bool _isBroadcasting = true;
  final Point _initialCenter = Point(
    coordinates: Position(-118.2437, 34.0522),
  ); // LA

  final Map<SignalQuality, String> _imageNames = {
    SignalQuality.perfect: 'perfect_signal',
    SignalQuality.weak: 'weak_signal',
    SignalQuality.echo: 'echo_signal',
  };

  @override
  void initState() {
    super.initState();
  }

  void _onMapCreated(MapboxMap mapboxMap) async {
    _mapboxMap = mapboxMap;
    await _addMarkerImagesToMap();
    _populateMapWithSignals();
  }

  Future<void> _addMarkerImagesToMap() async {
    try {
      for (final quality in SignalQuality.values) {
        final bytes = await WidgetToImageConverter.capture(
          PresenceMarker(quality: quality, size: 48),
          context,
        );

        // Add the custom marker image to the map style
        await _mapboxMap?.style.addStyleImage(
          _imageNames[quality]!,
          1.0, // scale
          MbxImage(width: 48, height: 48, data: bytes),
          true, // sdf
          [], // stretchX
          [], // stretchY
          null, // content
        );
      }
    } catch (e) {
      print('Error adding marker images: $e');
    }
  }

  void _populateMapWithSignals() {
    // In a real app, this would come from a provider.
    final List<Map<String, dynamic>> signals = [
      {'lat': 34.0522, 'lng': -118.2437, 'quality': SignalQuality.perfect},
      {'lat': 34.0580, 'lng': -118.2530, 'quality': SignalQuality.perfect},
      {'lat': 34.0750, 'lng': -118.2380, 'quality': SignalQuality.weak},
      {'lat': 34.1010, 'lng': -118.2995, 'quality': SignalQuality.echo},
    ];

    // Create annotations for the new API
    _mapboxMap?.annotations.createPointAnnotationManager().then((
      annotationManager,
    ) {
      for (final signal in signals) {
        final annotation = PointAnnotationOptions(
          geometry: Point(coordinates: Position(signal['lng'], signal['lat'])),
          iconImage: _imageNames[signal['quality']],
          iconSize: 1.0,
        );
        annotationManager.create(annotation);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          MapWidget(
            key: const ValueKey("mapWidget"),
            cameraOptions: CameraOptions(center: _initialCenter, zoom: 12.0),
            styleUri:
                'mapbox://styles/yobroapp/clmd9z17y012g01pfhb3l9b4d', // NVS Nocturne
            onMapCreated: _onMapCreated,
          ),
          NowHud(
            onRecenter: () => _mapboxMap?.flyTo(
              CameraOptions(center: _initialCenter, zoom: 12.0),
              MapAnimationOptions(duration: 1000),
            ),
            isBroadcasting: _isBroadcasting,
            onToggleBroadcast: (v) => setState(() => _isBroadcasting = v),
            onOpenNexus: () {
              /* TODO: Navigate to Nexus */
            },
          ),
        ],
      ),
    );
  }
}
