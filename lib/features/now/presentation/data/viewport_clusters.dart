import 'package:google_maps_flutter/google_maps_flutter.dart';

class ViewportClusters {
  // aggregated groups
  ViewportClusters({required this.points, required this.clusters});
  final List<ClusterPoint> points; // single users
  final List<ClusterPoint> clusters;
}

class ClusterPoint {
  // 1 for single; >1 for cluster
  ClusterPoint({required this.id, required this.position, required this.count});
  final String id; // stable id
  final LatLng position;
  final int count;
}
