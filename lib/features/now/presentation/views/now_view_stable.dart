import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nvs/meatup_core.dart';
import '../widgets/neon_globe_intro.dart';

enum NowViewMode { globeIntro, mapView }

class NowViewStable extends StatefulWidget {
  const NowViewStable({super.key});

  @override
  State<NowViewStable> createState() => _NowViewStableState();
}

class _NowViewStableState extends State<NowViewStable> with TickerProviderStateMixin {
  NowViewMode _currentMode = NowViewMode.globeIntro;
  GoogleMapController? _mapController;
  Position? _userPosition;
  Set<Marker> _markers = <Marker>{};

  // Animation controllers for breathing effects
  late AnimationController _atmosphereController;
  late AnimationController _particleController;
  late Animation<double> _atmosphereAnimation;
  late Animation<double> _particleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeLocation();

    // Globe intro duration
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _currentMode = NowViewMode.mapView;
        });
      }
    });
  }

  void _initializeAnimations() {
    _atmosphereController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _particleController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat();

    _atmosphereAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _atmosphereController,
        curve: Curves.easeInOut,
      ),
    );

    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_particleController);
  }

  Future<void> _initializeLocation() async {
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
          await _generateUsers();
        }
      }
    } catch (e) {
      // Fallback coordinates
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
        await _generateUsers();
      }
    }
  }

  Future<void> _generateUsers() async {
    if (_userPosition == null || !mounted) return;

    final math.Random random = math.Random();
    final Set<Marker> newMarkers = <Marker>{};

    // Generate 25 nearby users
    for (int i = 0; i < 25; i++) {
      final double distance = random.nextDouble() * 5000; // 5km radius
      final double bearing = random.nextDouble() * 2 * math.pi;

      final double lat = _userPosition!.latitude + (distance * math.cos(bearing)) / 111320;
      final double lng = _userPosition!.longitude +
          (distance * math.sin(bearing)) / (111320 * math.cos(_userPosition!.latitude));

      // Determine marker color based on distance (Signal Integrity Protocol)
      BitmapDescriptor markerIcon;
      if (distance < 1000) {
        markerIcon =
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen); // Perfect signal
      } else if (distance < 3000) {
        markerIcon =
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange); // Weak signal
      } else {
        markerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed); // Echo signal
      }

      newMarkers.add(
        Marker(
          markerId: MarkerId('user_$i'),
          position: LatLng(lat, lng),
          onTap: () => _showUserProfile('User $i', distance),
          icon: markerIcon,
        ),
      );
    }

    // Add user's location
    if (_userPosition != null) {
      newMarkers.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position: LatLng(_userPosition!.latitude, _userPosition!.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: 'You'),
        ),
      );
    }

    if (mounted) {
      setState(() {
        _markers = newMarkers;
      });
    }
  }

  void _showUserProfile(String userName, double distance) {
    if (!mounted) return;

    final String distanceText = distance < 1000
        ? '${distance.round()}m away'
        : '${(distance / 1000).toStringAsFixed(1)}km away';

    showModalBottomSheet(
      context: context,
      backgroundColor: NVSColors.pureBlack,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) => Container(
        height: 350,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: <Widget>[
            // Profile avatar with neon effect
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: <Color>[
                    NVSColors.primaryNeonMint,
                    NVSColors.turquoiseNeon,
                    NVSColors.primaryNeonMint.withOpacity(0.3),
                  ],
                ),
                border: Border.all(color: NVSColors.primaryNeonMint, width: 3),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: NVSColors.primaryNeonMint.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.person,
                color: NVSColors.pureBlack,
                size: 50,
              ),
            ),

            const SizedBox(height: 24),

            // Username
            Text(
              userName,
              style: const TextStyle(
                fontFamily: 'BellGothic',
                color: NVSColors.primaryNeonMint,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 8),

            // Distance and status
            Text(
              distanceText,
              style: const TextStyle(
                fontFamily: 'MagdaCleanMono',
                color: NVSColors.ultraLightMint,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Online now',
              style: TextStyle(
                fontFamily: 'MagdaCleanMono',
                color: NVSColors.primaryNeonMint,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 32),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildActionButton('MESSAGE', Icons.chat, () {
                  Navigator.pop(context);
                  // Message functionality would go here
                }),
                _buildActionButton('PROFILE', Icons.person, () {
                  Navigator.pop(context);
                  // Profile view functionality would go here
                }),
              ],
            ),

            const SizedBox(height: 16),

            // Close button
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'CLOSE',
                style: TextStyle(
                  fontFamily: 'BellGothic',
                  color: NVSColors.ultraLightMint,
                  fontSize: 14,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(
        label,
        style: const TextStyle(
          fontFamily: 'BellGothic',
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: NVSColors.primaryNeonMint,
        foregroundColor: NVSColors.pureBlack,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
            Stack(
              children: <Widget>[
                _buildCyberpunkMap(),
                _buildAtmosphericOverlay(),
              ],
            ),

          // NOW header when in map mode
          if (_currentMode == NowViewMode.mapView) _buildHeader(),
        ],
      ),
    );
  }

  Widget _buildCyberpunkMap() {
    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
        _applyCyberpunkStyle();

        if (_userPosition != null) {
          controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(_userPosition!.latitude, _userPosition!.longitude),
                zoom: 16.5,
                tilt: 60.0, // Dramatic 3D angle
                bearing: 30.0, // Slight rotation
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

  Widget _buildAtmosphericOverlay() {
    return AnimatedBuilder(
      animation: Listenable.merge(<Listenable?>[_atmosphereController, _particleController]),
      builder: (BuildContext context, Widget? child) {
        return IgnorePointer(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                radius: 1.5,
                colors: <Color>[
                  Colors.transparent,
                  NVSColors.primaryNeonMint.withOpacity(0.05 * _atmosphereAnimation.value),
                  NVSColors.turquoiseNeon.withOpacity(0.03 * _atmosphereAnimation.value),
                  Colors.transparent,
                ],
              ),
            ),
            child: CustomPaint(
              painter: AtmosphericEffectsPainter(
                progress: _particleAnimation.value,
                intensity: _atmosphereAnimation.value,
                color: NVSColors.primaryNeonMint,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: NVSColors.pureBlack.withOpacity(0.8),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: NVSColors.primaryNeonMint, width: 2),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: NVSColors.primaryNeonMint.withOpacity(0.4),
                  blurRadius: 15,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: const Text(
              'NOW',
              style: TextStyle(
                fontFamily: 'BellGothic',
                color: NVSColors.primaryNeonMint,
                fontSize: 18,
                letterSpacing: 3,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _applyCyberpunkStyle() async {
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
        "featureType": "road.arterial",
        "elementType": "geometry.stroke",
        "stylers": [{"color": "#4BEFE0"}, {"lightness": -40}, {"weight": 1}]
      },
      {
        "featureType": "road.local",
        "elementType": "geometry",
        "stylers": [{"color": "#0f2a3a"}]
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

    try {
      await _mapController?.setMapStyle(mapStyle);
    } catch (e) {
      // Silently handle any map styling errors
    }
  }

  @override
  void dispose() {
    _atmosphereController.dispose();
    _particleController.dispose();
    super.dispose();
  }
}

class AtmosphericEffectsPainter extends CustomPainter {
  AtmosphericEffectsPainter({
    required this.progress,
    required this.intensity,
    required this.color,
  });
  final double progress;
  final double intensity;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color.withOpacity(0.1 * intensity)
      ..style = PaintingStyle.fill;

    // Draw floating particles
    final math.Random random = math.Random(42);
    for (int i = 0; i < 8; i++) {
      final double x =
          (random.nextDouble() * size.width) + (math.sin(progress * 2 * math.pi + i) * 20);
      final double y =
          (random.nextDouble() * size.height) + (math.cos(progress * 2 * math.pi + i * 0.7) * 15);

      canvas.drawCircle(
        Offset(x, y),
        1 + (math.sin(progress * 4 * math.pi + i) * 0.5),
        paint,
      );
    }

    // Draw scanning lines
    final Paint linePaint = Paint()
      ..color = color.withOpacity(0.05 * intensity)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 3; i++) {
      final double y = (size.height / 3) * i + (progress * size.height * 0.1);
      if (y < size.height) {
        canvas.drawLine(
          Offset(0, y),
          Offset(size.width, y),
          linePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(AtmosphericEffectsPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.intensity != intensity;
  }
}
