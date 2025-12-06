import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nvs/theme/nvs_colors.dart';
import 'package:nvs/widgets/nvs_header.dart';
import '../data/viewport_clusters.dart';
import 'cluster_bloom_layer.dart';

class NowMapView extends StatefulWidget {
  const NowMapView({super.key});
  @override
  State<NowMapView> createState() => _NowMapViewState();
}

class _NowMapViewState extends State<NowMapView> with TickerProviderStateMixin {
  GoogleMapController? _controller;
  String? _styleJson;
  final GlobalKey<ClusterBloomLayerState> _layerKey = GlobalKey<ClusterBloomLayerState>();
  Set<Marker> _markers = <Marker>{};
  late final AnimationController _fogCtl =
      AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat(reverse: true);

  @override
  void initState() {
    super.initState();
    rootBundle
        .loadString('assets/map_styles/nvs_neon_city.json')
        .then((String s) => mounted ? setState(() => _styleJson = s) : null);
  }

  @override
  void dispose() {
    _fogCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.98,
          child: GoogleMap(
            compassEnabled: false,
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: const CameraPosition(
              target: LatLng(34.0522, -118.2437),
              zoom: 14.5,
              tilt: 60,
              bearing: 28,
            ),
            onMapCreated: (GoogleMapController c) async {
              _controller = c;
              if (_styleJson != null) await c.setMapStyle(_styleJson);
            },
            markers: _markers,
            onCameraIdle: () async => _refreshClusters(),
          ),
        ),
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _fogCtl,
            builder: (_, __) => CustomPaint(
              painter: _BreathingGridFogPainter(_fogCtl.value),
              isComplex: true,
              willChange: true,
            ),
          ),
        ),
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: NvsHeader(sectionLabel: 'NOW', labelAlign: Alignment.topRight),
        ),
        // Invisible cluster layer overlay that fetches and paints bloom
        Positioned.fill(
          child: ClusterBloomLayer(
            key: _layerKey,
            controller: _controller,
            fetcher: (LatLngBounds bounds, double zoom) async {
              // TODO: replace with real viewport query
              return ViewportClusters(points: <ClusterPoint>[], clusters: <ClusterPoint>[]);
            },
          ),
        ),
      ],
    );
  }

  Future<void> _refreshClusters() async {
    await _layerKey.currentState?.refresh();
    setState(() => _markers = ClusterMarkers.of(context));
  }
}

class _BreathingGridFogPainter extends CustomPainter {
  _BreathingGridFogPainter(this.t);
  final double t; // 0..1

  @override
  void paint(Canvas canvas, Size size) {
    final Paint fog = Paint()
      ..shader = ui.Gradient.radial(
        Offset(size.width * 0.52, size.height * 0.58),
        size.shortestSide * (0.6 + 0.06 * (t - 0.5).abs() * 2),
        <Color>[nvsCyan.withOpacity(0.07), Colors.transparent],
      );
    canvas.drawRect(Offset.zero & size, fog);

    const double step = 42.0;
    final Paint glow = Paint()
      ..color = nvsMint.withOpacity(0.14 + 0.06 * (0.5 - (t - 0.5).abs()) * 2)
      ..strokeWidth = 1.2;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), glow);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), glow);
    }
  }

  @override
  bool shouldRepaint(covariant _BreathingGridFogPainter old) => old.t != t;
}
