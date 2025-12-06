import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../data/viewport_clusters.dart';
import 'neon_markers.dart';

typedef ClusterFetch = Future<ViewportClusters> Function(LatLngBounds bounds, double zoom);

class ClusterBloomLayer extends StatefulWidget {
  const ClusterBloomLayer({required this.controller, required this.fetcher, super.key});

  final GoogleMapController? controller;
  final ClusterFetch fetcher;

  @override
  State<ClusterBloomLayer> createState() => ClusterBloomLayerState();
}

class ClusterBloomLayerState extends State<ClusterBloomLayer> with TickerProviderStateMixin {
  Set<Marker> _markers = <Marker>{};
  late final AnimationController _bloom =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 420));
  double _lastZoom = 0;

  @override
  void dispose() {
    _bloom.dispose();
    super.dispose();
  }

  Future<void> refresh() async {
    if (widget.controller == null) return;
    final LatLngBounds b = await widget.controller!.getVisibleRegion();
    final double z = await widget.controller!.getZoomLevel();
    final ViewportClusters result = await widget.fetcher(b, z);

    final Set<Marker> next = <Marker>{};
    for (final ClusterPoint p in result.points) {
      next.add(
        Marker(
          markerId: MarkerId(p.id),
          position: p.position,
          icon: NeonMarkerFactory.single(),
          anchor: const Offset(.5, .5),
          zIndex: 2,
        ),
      );
    }
    for (final ClusterPoint c in result.clusters) {
      next.add(
        Marker(
          markerId: MarkerId(c.id),
          position: c.position,
          icon: NeonMarkerFactory.cluster(c.count),
          anchor: const Offset(.5, .5),
          zIndex: 3,
        ),
      );
    }

    final bool zoomChanged = (_lastZoom - z).abs() >= 0.25;
    final bool setChanged = next.length != _markers.length;
    _lastZoom = z;

    setState(() => _markers = next);
    if (zoomChanged || setChanged) {
      _bloom.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClusterMarkers(markers: _markers, child: const SizedBox.shrink()),
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _bloom,
            builder: (_, __) => IgnorePointer(
              child: CustomPaint(
                painter: _BloomPulsePainter(markers: _markers, progress: _bloom.value),
                isComplex: true,
                willChange: true,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ClusterMarkers extends InheritedWidget {
  const ClusterMarkers({required this.markers, required super.child, super.key});
  final Set<Marker> markers;
  static Set<Marker> of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ClusterMarkers>()?.markers ?? <Marker>{};
  @override
  bool updateShouldNotify(ClusterMarkers oldWidget) => oldWidget.markers != markers;
}

class _BloomPulsePainter extends CustomPainter {
  _BloomPulsePainter({required this.markers, required this.progress});
  final Set<Marker> markers;
  final double progress; // 0..1

  @override
  void paint(Canvas canvas, Size size) {
    // Simple bloom pulse from marker centers. In production, map LatLng to screen points.
    final Paint p = Paint()
      ..color = Colors.white.withOpacity((1 - progress) * 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    // Without a Projection API here, draw subtle global pulse.
    final double radius = size.shortestSide * (0.1 + 0.15 * progress);
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, p);
  }

  @override
  bool shouldRepaint(covariant _BloomPulsePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.markers != markers;
}
