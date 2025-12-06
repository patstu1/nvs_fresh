import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:nvs/meatup_core.dart';
import '../../../messenger/presentation/universal_messaging_sheet.dart';

/// NOW: Real-time user map + live interaction hub (UI shell per sketch)
/// Data wiring remains stubbed; replace clusters and chat when APIs are ready
class NowMapHubView extends StatefulWidget {
  const NowMapHubView({super.key, this.initialQuery, this.initialToast});

  final String? initialQuery;
  final String? initialToast;

  @override
  State<NowMapHubView> createState() => _NowMapHubViewState();
}

class _NowMapHubViewState extends State<NowMapHubView> {
  static const LatLng _defaultCenter = LatLng(34.0522, -118.2437);
  GoogleMapController? _mapController;
  final Set<Marker> _markers = <Marker>{};
  Timer? _pulseTimer;
  double _pulse = 0.0; // 0..1

  @override
  void initState() {
    super.initState();
    _seedClusters();
    _startPulse();
  }

  @override
  void dispose() {
    _pulseTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    // Apply cyberpunk dark style
    try {
      final String style =
          await DefaultAssetBundle.of(context).loadString('assets/map_styles/nvs_cyberpunk.json');
      await _mapController?.setMapStyle(style);
      // Tilt & bearing for 3D feel
      await _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          const CameraPosition(target: _defaultCenter, tilt: 55, bearing: 20, zoom: 14.5),
        ),
      );
      if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
        await _moveCameraToQuery(widget.initialQuery!);
      }
      if (widget.initialToast != null && widget.initialToast!.isNotEmpty) {
        _showToast(widget.initialToast!);
      }
    } catch (_) {}
  }

  Future<void> _moveCameraToQuery(String query) async {
    try {
      final List<geo.Location> results = await geo.locationFromAddress(query);
      if (results.isEmpty) return;
      final geo.Location loc = results.first;
      final LatLng target = LatLng(loc.latitude, loc.longitude);
      await _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: target, tilt: 55, bearing: 20, zoom: 14.5),
        ),
      );
      _showToast('centering on: ${query.toLowerCase()}');
    } catch (_) {}
  }

  void _showToast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontFamily: 'MagdaCleanMono',
            fontSize: 12,
            color: NVSColors.primaryLightMint,
          ),
        ),
        backgroundColor: Colors.black.withOpacity(0.7),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 80, left: 16, right: 16),
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _seedClusters() {
    // Stub: generate a few tight clusters around center
    final math.Random r = math.Random(7);
    final List<LatLng> points = <LatLng>[];
    for (int c = 0; c < 3; c++) {
      final double baseLat = _defaultCenter.latitude + (c - 1) * 0.0025;
      final double baseLng = _defaultCenter.longitude + (c - 1) * 0.0030;
      for (int i = 0; i < 6; i++) {
        points.add(
          LatLng(
            baseLat + (r.nextDouble() - 0.5) * 0.0012,
            baseLng + (r.nextDouble() - 0.5) * 0.0012,
          ),
        );
      }
    }
    setState(() {
      _markers.clear();
      for (int i = 0; i < points.length; i++) {
        _markers.add(
          Marker(
            markerId: MarkerId('u$i'),
            position: points[i],
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
            alpha: 0.85,
          ),
        );
      }
    });
  }

  void _startPulse() {
    const Duration step = Duration(milliseconds: 60);
    _pulseTimer = Timer.periodic(step, (_) {
      setState(() {
        _pulse += 0.04;
        if (_pulse > 1) _pulse = 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            // Map core layer
            Positioned.fill(
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: const CameraPosition(target: _defaultCenter, zoom: 13),
                markers: _markers,
                compassEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
              ),
            ),

            // Top bar (header)
            Positioned(
              top: 8,
              left: 12,
              right: 12,
              child: Row(
                children: <Widget>[
                  _FiltersButton(onTap: () {}),
                  const Spacer(),
                  const NvsLogo(letterSpacing: 10),
                  const Spacer(),
                  const _MapLabel(),
                ],
              ),
            ),

            // Right-side floating chat/messaging stack
            Positioned(
              right: 12,
              top: 120,
              child: Opacity(
                opacity: 0.85,
                child: Column(
                  children: <Widget>[
                    _FloatCircle(icon: Icons.add, onTap: () {}),
                    const SizedBox(height: 10),
                    _FloatCircle(icon: Icons.chat_bubble_outline, onTap: _openMessaging),
                    const SizedBox(height: 16),
                    // Last 3 chats (stub avatars)
                    for (int i = 0; i < 3; i++) ...<Widget>[
                      _AvatarDot(pulse: _pulse),
                      const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openMessaging() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.3,
        maxChildSize: 0.85,
        builder: (_, __) => const UniversalMessagingSheet(
          section: MessagingSection.now,
          targetUserId: 'unknown',
          displayName: 'user',
        ),
      ),
    );
  }
}

class _FiltersButton extends StatelessWidget {
  const _FiltersButton({required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: NVSColors.primaryLightMint.withOpacity(0.5)),
          boxShadow: const <BoxShadow>[
            BoxShadow(color: NVSColors.primaryLightMint, blurRadius: 6, spreadRadius: 0.5),
          ],
        ),
        child: const Text(
          'filters',
          style: TextStyle(
            fontFamily: 'MagdaCleanMono',
            fontSize: 12,
            color: NVSColors.primaryLightMint,
          ),
        ),
      ),
    );
  }
}

class _MapLabel extends StatelessWidget {
  const _MapLabel();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: NVSColors.primaryLightMint.withOpacity(0.5)),
      ),
      child: const Text(
        '3d map',
        style: TextStyle(
          fontFamily: 'MagdaCleanMono',
          fontSize: 12,
          color: NVSColors.primaryLightMint,
        ),
      ),
    );
  }
}

class _FloatCircle extends StatelessWidget {
  const _FloatCircle({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          shape: BoxShape.circle,
          border: Border.all(color: NVSColors.primaryLightMint.withOpacity(0.45)),
          boxShadow: const <BoxShadow>[
            BoxShadow(color: NVSColors.primaryLightMint, blurRadius: 8, spreadRadius: 0.6),
          ],
        ),
        child: Icon(icon, color: NVSColors.primaryLightMint, size: 18),
      ),
    );
  }
}

class _AvatarDot extends StatelessWidget {
  const _AvatarDot({required this.pulse});
  final double pulse;

  @override
  Widget build(BuildContext context) {
    final double scale = 0.9 + (pulse * 0.1);
    return Transform.scale(
      scale: scale,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.4),
          border: Border.all(color: NVSColors.turquoiseNeon.withOpacity(0.8)),
          boxShadow: const <BoxShadow>[
            BoxShadow(color: NVSColors.turquoiseNeon, blurRadius: 10, spreadRadius: 0.8),
          ],
        ),
        child: const Center(
          child: Text(
            'u',
            style: TextStyle(
              fontFamily: 'MagdaCleanMono',
              color: NVSColors.primaryLightMint,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
