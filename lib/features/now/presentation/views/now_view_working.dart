// Quantum NOW view with breathing 3D map and bio-responsive effects
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nvs/core/models/app_types.dart';
import 'package:nvs/core/theme/quantum_design_tokens.dart';
import '../../../../core/providers/quantum_providers.dart';
import '../../../../core/services/location_optimizer_service.dart';
import '../widgets/neon_globe_intro.dart';
import '../../../../shared/widgets/section_label.dart';
import '../widgets/cyberpunk_map_overlay.dart';
import '../widgets/user_cluster_manager.dart';

enum NowViewMode { globeIntro, mapView }

class NowViewWorking extends ConsumerStatefulWidget {
  const NowViewWorking({super.key});

  @override
  ConsumerState<NowViewWorking> createState() => _NowViewWorkingState();
}

class _NowViewWorkingState extends ConsumerState<NowViewWorking> with TickerProviderStateMixin {
  NowViewMode _currentMode = NowViewMode.globeIntro;
  GoogleMapController? _mapController;
  Position? _userPosition;
  final Set<Marker> _markers = <Marker>{};

  // Breathing animation controllers for the living 3D map
  late AnimationController _breathingController;
  late AnimationController _pulseController;
  late Animation<double> _breathingAnimation;
  late Animation<double> _pulseAnimation;

  // UI state
  String? _selectedUserId;
  String? _selectedUserName;

  // Mock users data (like Sniffies)
  final List<NowUser> _nearbyUsers = <NowUser>[];

  // Location clustering
  final LocationOptimizerService _locationService = LocationOptimizerService();
  final List<UserCluster> _userClusters = <UserCluster>[];
  final bool _showClusters = true;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _getUserLocation();
    _initializeLocationClustering();

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
        setState(() {
          _userPosition = position;
        });
        _generateMockUsers();
      }
    } catch (e) {
      // Fallback to LA coordinates
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

  void _generateMockUsers() {
    if (_userPosition == null) return;

    final math.Random random = math.Random();
    _markers.clear();
    _nearbyUsers.clear();

    // Generate users within 5km radius like Sniffies
    for (int i = 0; i < 30; i++) {
      final double distance = random.nextDouble() * 5000; // 5km in meters
      final double bearing = random.nextDouble() * 2 * math.pi;

      final double lat = _userPosition!.latitude + (distance * math.cos(bearing)) / 111320;
      final double lng = _userPosition!.longitude +
          (distance * math.sin(bearing)) / (111320 * math.cos(_userPosition!.latitude));

      _nearbyUsers.add(
        NowUser(
          id: 'user_$i',
          name: random.nextBool() ? null : 'User $i', // Some anonymous
          imageUrl: 'https://picsum.photos/100/100?random=$i',
          lat: lat,
          lng: lng,
          isOnline: random.nextBool(),
          isHosting: random.nextDouble() > 0.8,
          isAnonymous: random.nextBool(),
          lastSeen: DateTime.now().subtract(
            Duration(minutes: random.nextInt(120)),
          ),
        ),
      );

      // Also add markers for map view
      _markers.add(
        Marker(
          markerId: MarkerId('user_$i'),
          position: LatLng(lat, lng),
          onTap: () => _onUserTapped('user_$i', 'User $i'),
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

    // Refresh UI with new users after build is complete
    Future.delayed(Duration.zero, () {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _onUserTapped(String userId, String userName) {
    setState(() {
      _selectedUserId = userId;
      _selectedUserName = userName;
    });
  }

  void _handleUserClusterTap(NowUser user) {
    // Use post-frame callback to avoid provider modification during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _selectedUserId = user.id;
          _selectedUserName = user.name ?? 'Anonymous User';
        });

        // Show user profile modal
        showModalBottomSheet(
          context: context,
          backgroundColor: QuantumDesignTokens.pureBlack,
          builder: (BuildContext context) => _buildUserProfileModal(user),
        );
      }
    });
  }

  Widget _buildUserProfileModal(NowUser user) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          // User avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: QuantumDesignTokens.primaryNeonMint,
                width: 2,
              ),
              color: QuantumDesignTokens.primaryNeonMint.withOpacity(0.1),
            ),
            child: user.imageUrl != null
                ? ClipOval(
                    child: Image.network(
                      user.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (
                        BuildContext context,
                        Object error,
                        StackTrace? stackTrace,
                      ) =>
                          const Icon(
                        Icons.person,
                        color: QuantumDesignTokens.primaryNeonMint,
                        size: 40,
                      ),
                    ),
                  )
                : const Icon(
                    Icons.person,
                    color: QuantumDesignTokens.primaryNeonMint,
                    size: 40,
                  ),
          ),
          const SizedBox(height: 20),

          // User name
          Text(
            user.name ?? 'Anonymous User',
            style: const TextStyle(
              fontFamily: 'BellGothic',
              color: QuantumDesignTokens.primaryNeonMint,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          // Status
          Text(
            user.isOnline ? 'Online now' : 'Last seen ${_formatLastSeen(user.lastSeen)}',
            style: const TextStyle(
              fontFamily: 'MagdaCleanMono',
              color: QuantumDesignTokens.ultraLightMint,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: QuantumDesignTokens.primaryNeonMint,
                  foregroundColor: Colors.black,
                ),
                child: const Text(
                  'Message',
                  style: TextStyle(
                    fontFamily: 'BellGothic',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: QuantumDesignTokens.primaryNeonMint,
                  ),
                ),
                child: const Text(
                  'View Profile',
                  style: TextStyle(
                    fontFamily: 'BellGothic',
                    color: QuantumDesignTokens.primaryNeonMint,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatLastSeen(DateTime lastSeen) {
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(lastSeen);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<dynamic> performanceMetrics = ref.watch(performanceMetricsProvider);
    final bool shouldEnableGlow = ref.watch(shouldEnableGlowEffectsProvider);
    final BioResponsiveThemeData? bioThemeData = ref.watch(bioResponsiveThemeProvider);

    return Scaffold(
      backgroundColor: QuantumDesignTokens.pureBlack,
      body: Stack(
        children: <Widget>[
          // Main content
          if (_currentMode == NowViewMode.globeIntro)
            NeonGlobeIntro(
              onComplete: () {
                setState(() {
                  _currentMode = NowViewMode.mapView;
                });
              },
            )
          else
            AnimatedBuilder(
              animation: Listenable.merge(<Listenable?>[_breathingAnimation, _pulseAnimation]),
              builder: (BuildContext context, Widget? child) {
                final double breathingScale = _breathingAnimation.value;
                final double pulseScale = _pulseAnimation.value;
                final double combinedScale = breathingScale * pulseScale;

                return Transform.scale(
                  scale: combinedScale,
                  child: QuantumGlowContainer(
                    enableGlow: shouldEnableGlow,
                    child: Stack(
                      children: <Widget>[
                        _buildMapView(),
                        // Cyberpunk atmospheric overlay
                        const CyberpunkMapOverlay(),
                        // User cluster overlay with breathing bubbles
                        if (_userPosition != null && _nearbyUsers.isNotEmpty)
                          UserClusterManager(
                            users: _nearbyUsers,
                            userLat: _userPosition!.latitude,
                            userLng: _userPosition!.longitude,
                            onUserTapped: _handleUserClusterTap,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),

          // NVS Logo Video when in map mode
          if (_currentMode == NowViewMode.mapView)
            const SafeArea(
              child: Padding(
                padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                child: Center(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: QuantumDesignTokens.cardBackground,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'QUANTUM NOW',
                        style: TextStyle(
                          color: QuantumDesignTokens.neonMint,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // NOW header when in map mode
          if (_currentMode == NowViewMode.mapView)
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 80.0,
                  left: 16.0,
                  right: 16.0,
                  bottom: 16.0,
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: QuantumDesignTokens.pureBlack.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: QuantumDesignTokens.primaryNeonMint,
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: QuantumDesignTokens.primaryNeonMint.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Text(
                      'NOW',
                      style: TextStyle(
                        fontFamily: 'BellGothic',
                        color: QuantumDesignTokens.primaryNeonMint,
                        fontSize: 16,
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Section Label
          const SectionLabel(
            sectionName: 'NOW',
            glowColor: QuantumDesignTokens.turquoiseNeon,
            alignment: Alignment.bottomLeft,
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
                zoom: 16.5, // Closer zoom for more detail
                tilt: 60.0, // More dramatic 3D angle like cyberpunk cityscape
                bearing: 30.0, // Slight rotation for dynamic view
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
        zoom: 16.5, // Closer zoom for more detail
        tilt: 60.0, // More dramatic 3D angle like cyberpunk cityscape
        bearing: 30.0, // Slight rotation for dynamic view
      ),
      markers: _markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: false,
    );
  }

  Future<void> _applyCyberpunkMapStyle() async {
    // Ultra-detailed cyberpunk style like the reference image
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
        "featureType": "all",
        "elementType": "labels.icon",
        "stylers": [{"visibility": "off"}]
      },
      {
        "featureType": "administrative",
        "elementType": "geometry",
        "stylers": [{"color": "#002233"}]
      },
      {
        "featureType": "landscape",
        "elementType": "geometry",
        "stylers": [{"color": "#0d1426"}]
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
        "stylers": [{"color": "#003d5c"}, {"lightness": 10}]
      },
      {
        "featureType": "water",
        "elementType": "geometry.fill",
        "stylers": [{"color": "#4BEFE0"}, {"lightness": -60}]
      },
      {
        "featureType": "poi",
        "stylers": [{"visibility": "off"}]
      },
      {
        "featureType": "transit",
        "stylers": [{"visibility": "off"}]
      },
      {
        "featureType": "administrative.locality",
        "elementType": "labels.text.fill",
        "stylers": [{"color": "#4BEFE0"}, {"lightness": 40}]
      },
      {
        "featureType": "administrative.neighborhood",
        "elementType": "labels.text.fill",
        "stylers": [{"color": "#00F7FF"}, {"lightness": 20}]
      }
    ]
    ''';

    await _mapController?.setMapStyle(mapStyle);
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _pulseController.dispose();
    _mapController?.dispose();
    _locationService.dispose();
    super.dispose();
  }

  /// Initialize breathing animations for the living 3D map
  void _initializeAnimations() {
    // Breathing animation - slow, organic rhythm
    _breathingController = AnimationController(
      duration: const Duration(milliseconds: 4000), // 4 second breathing cycle
      vsync: this,
    );
    _breathingAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(
      CurvedAnimation(
        parent: _breathingController,
        curve: Curves.easeInOut,
      ),
    );

    // Pulse animation - heart beat sync
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200), // ~50 BPM resting heart rate
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    // Start the living breathing effect
    _breathingController.repeat(reverse: true);
    _pulseController.repeat(reverse: true);
  }
}
