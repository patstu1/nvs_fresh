import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../widgets/cyberpunk_3d_globe.dart';
import 'dart:async';

class NowTransitionPage extends StatefulWidget {
  const NowTransitionPage({super.key});

  @override
  State<NowTransitionPage> createState() => _NowTransitionPageState();
}

class _NowTransitionPageState extends State<NowTransitionPage>
    with TickerProviderStateMixin {
  late AnimationController _globeScaleController;
  bool _showMap = false;
  Position? _userPosition;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _globeScaleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _globeScaleController.forward();
    _getUserLocation();
    // After animation, show map
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _showMap = true;
      });
    });
  }

  Future<void> _getUserLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _userPosition = position;
      });
    } catch (e) {
      // fallback: San Francisco
      setState(() {
        _userPosition = Position(
          latitude: 37.7749,
          longitude: -122.4194,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );
      });
    }
  }

  @override
  void dispose() {
    _globeScaleController.dispose();
    super.dispose();
  }

  CameraPosition get _initialCameraPosition => CameraPosition(
        target: _userPosition != null
            ? LatLng(_userPosition!.latitude, _userPosition!.longitude)
            : const LatLng(37.7749, -122.4194),
        zoom: 14.0,
        tilt: 60.0,
        bearing: 0.0,
      );

  @override
  Widget build(BuildContext context) {
    const mint = Color(0xFF4BEFE0);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Google Maps 3D view
          if (_showMap && _userPosition != null)
            Positioned.fill(
              child: GoogleMap(
                initialCameraPosition: _initialCameraPosition,
                mapType: MapType.normal,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                compassEnabled: false,
                onMapCreated: (controller) {
                  _mapController = controller;
                  _applyCyberpunkMapStyle();
                  // Animate camera for cinematic zoom
                  controller.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: LatLng(
                            _userPosition!.latitude, _userPosition!.longitude),
                        zoom: 18.5,
                        tilt: 70.0,
                        bearing: 20.0,
                      ),
                    ),
                  );
                },
              ),
            ),
          // Animated globe
          if (!_showMap)
            Center(
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.3, end: 1.0).animate(
                  CurvedAnimation(
                      parent: _globeScaleController,
                      curve: Curves.easeInOutCubic),
                ),
                child: Cyberpunk3DGlobe(
                  size: 220,
                  onLocationFound: () {},
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _applyCyberpunkMapStyle() async {
    const style = '''
    [
      {"elementType": "geometry", "stylers": [{"color": "#0a0a0a"}]},
      {"elementType": "labels.text.fill", "stylers": [{"color": "#4BEFE0"}]},
      {"elementType": "labels.text.stroke", "stylers": [{"color": "#000000"}]},
      {"featureType": "road", "elementType": "geometry", "stylers": [{"color": "#1a1a1a"}]},
      {"featureType": "water", "elementType": "geometry", "stylers": [{"color": "#4BEFE0"}]},
      {"featureType": "poi", "stylers": [{"visibility": "off"}]},
      {"featureType": "transit", "stylers": [{"visibility": "off"}]},
      {"featureType": "administrative", "stylers": [{"visibility": "off"}]}
    ]
    ''';
    await _mapController?.setMapStyle(style);
  }
}
