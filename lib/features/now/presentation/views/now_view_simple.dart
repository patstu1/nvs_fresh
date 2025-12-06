import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nvs/meatup_core.dart';
import '../widgets/neon_globe_intro.dart';

enum NowViewMode { globeIntro, mapView }

class NowViewSimple extends StatefulWidget {
  const NowViewSimple({super.key});

  @override
  State<NowViewSimple> createState() => _NowViewSimpleState();
}

class _NowViewSimpleState extends State<NowViewSimple> {
  NowViewMode _currentMode = NowViewMode.globeIntro;
  GoogleMapController? _mapController;
  Position? _userPosition;
  final Set<Marker> _markers = <Marker>{};

  @override
  void initState() {
    super.initState();
    _getUserLocation();

    // Start with globe intro, then transition to map
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _currentMode = NowViewMode.mapView;
        });
      }
    });
  }

  Future<void> _getUserLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        if (mounted) {
          setState(() {
            _userPosition = position;
          });
          _generateMockUsers();
        }
      }
    } catch (e) {
      // Fallback to LA coordinates
      if (mounted) {
        setState(() {
          _userPosition = Position(
            latitude: 34.0522,
            longitude: -118.2437,
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
        _generateMockUsers();
      }
    }
  }

  void _generateMockUsers() {
    if (_userPosition == null || !mounted) return;

    final math.Random random = math.Random();
    _markers.clear();

    // Generate users within 5km radius
    for (int i = 0; i < 15; i++) {
      final double distance = random.nextDouble() * 5000; // 5km in meters
      final double bearing = random.nextDouble() * 2 * math.pi;

      final double lat = _userPosition!.latitude + (distance * math.cos(bearing)) / 111320;
      final double lng = _userPosition!.longitude +
          (distance * math.sin(bearing)) / (111320 * math.cos(_userPosition!.latitude));

      _markers.add(
        Marker(
          markerId: MarkerId('user_$i'),
          position: LatLng(lat, lng),
          onTap: () => _showUserProfile('User $i'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            random.nextBool() ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueOrange,
          ),
        ),
      );
    }

    // Add user's own position
    if (_userPosition != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('user'),
          position: LatLng(_userPosition!.latitude, _userPosition!.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: 'You'),
        ),
      );
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _showUserProfile(String userName) {
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: NVSColors.pureBlack,
      builder: (BuildContext context) => Container(
        height: 200,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: NVSColors.primaryNeonMint, width: 2),
                color: NVSColors.primaryNeonMint.withOpacity(0.1),
              ),
              child: const Icon(
                Icons.person,
                color: NVSColors.primaryNeonMint,
                size: 30,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              userName,
              style: const TextStyle(
                fontFamily: 'BellGothic',
                color: NVSColors.primaryNeonMint,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: NVSColors.primaryNeonMint,
                foregroundColor: Colors.black,
              ),
              child: const Text(
                'Close',
                style: TextStyle(
                  fontFamily: 'BellGothic',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      body: Stack(
        children: <Widget>[
          // Main content
          if (_currentMode == NowViewMode.globeIntro)
            NeonGlobeIntro(
              onComplete: () {
                if (mounted) {
                  setState(() {
                    _currentMode = NowViewMode.mapView;
                  });
                }
              },
            )
          else
            _buildMapView(),

          // NOW header when in map mode
          if (_currentMode == NowViewMode.mapView)
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: NVSColors.pureBlack.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: NVSColors.primaryNeonMint),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: NVSColors.primaryNeonMint.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Text(
                      'NOW',
                      style: TextStyle(
                        fontFamily: 'BellGothic',
                        color: NVSColors.primaryNeonMint,
                        fontSize: 16,
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMapView() {
    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
        _applyCyberpunkMapStyle();
        if (_userPosition != null) {
          _mapController!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(_userPosition!.latitude, _userPosition!.longitude),
                zoom: 16.5,
                tilt: 60.0, // 3D cyberpunk angle
                bearing: 30.0,
              ),
            ),
          );
        }
      },
      initialCameraPosition: CameraPosition(
        target: LatLng(
          _userPosition?.latitude ?? 34.0522,
          _userPosition?.longitude ?? -118.2437,
        ),
        zoom: 16.5,
        tilt: 60.0,
        bearing: 30.0,
      ),
      markers: _markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: false,
    );
  }

  Future<void> _applyCyberpunkMapStyle() async {
    const String mapStyle = '''
    [
      {
        "elementType": "geometry",
        "stylers": [{"color": "#0a0f1a"}]
      },
      {
        "elementType": "labels.text.fill",
        "stylers": [{"color": "#4BEFE0"}, {"lightness": 20}]
      },
      {
        "elementType": "labels.text.stroke",
        "stylers": [{"color": "#001122"}, {"weight": 2}]
      },
      {
        "featureType": "road.highway",
        "elementType": "geometry.fill",
        "stylers": [{"color": "#00F7FF"}, {"lightness": -40}]
      },
      {
        "featureType": "road.highway",
        "elementType": "geometry.stroke",
        "stylers": [{"color": "#4BEFE0"}, {"lightness": -20}, {"weight": 2}]
      },
      {
        "featureType": "road.arterial",
        "elementType": "geometry.fill",
        "stylers": [{"color": "#1a4a5c"}]
      },
      {
        "featureType": "water",
        "elementType": "geometry",
        "stylers": [{"color": "#4BEFE0"}, {"lightness": -60}]
      },
      {
        "featureType": "poi",
        "stylers": [{"visibility": "off"}]
      },
      {
        "featureType": "transit",
        "stylers": [{"visibility": "off"}]
      }
    ]
    ''';

    await _mapController?.setMapStyle(mapStyle);
  }
}
