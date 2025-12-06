// connect_decision_page.dart

import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

class ConnectDecisionPage extends StatelessWidget {
  const ConnectDecisionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: NVSColors.pureBlack,
      body: Center(
        child: Text('Connect Decision Page', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
