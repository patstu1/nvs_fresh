// connect_verdict_page.dart

import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

class ConnectVerdictPage extends StatelessWidget {
  const ConnectVerdictPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Text('Connect Verdict Page', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
