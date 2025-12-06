// connect_heatmap_page.dart

import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

class ConnectHeatmapPage extends StatelessWidget {
  const ConnectHeatmapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Text('Connect Heatmap Page', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
