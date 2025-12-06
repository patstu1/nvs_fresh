import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CyberpunkMapScreen extends StatefulWidget {
  const CyberpunkMapScreen({super.key});

  @override
  State<CyberpunkMapScreen> createState() => _CyberpunkMapScreenState();
}

class _CyberpunkMapScreenState extends State<CyberpunkMapScreen> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(34.0522, -118.2437); // Los Angeles

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _setCyberpunkStyle();
  }

  Future<void> _setCyberpunkStyle() async {
    final String style =
        await DefaultAssetBundle.of(context).loadString('assets/map_styles/nvs_cyberpunk.json');
    mapController.setMapStyle(style);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 14,
        ),
        zoomControlsEnabled: false,
        myLocationEnabled: true,
        compassEnabled: false,
      ),
    );
  }
}








