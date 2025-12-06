// connect_chart_sync_page.dart

import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

class ConnectChartSyncPage extends StatelessWidget {
  const ConnectChartSyncPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: NVSColors.pureBlack,
      body: Center(
        child: Text(
          'Connect Chart Sync Page',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
