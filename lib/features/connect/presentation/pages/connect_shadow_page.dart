// connect_shadow_page.dart

import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

class ConnectShadowPage extends StatelessWidget {
  const ConnectShadowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: NVSColors.pureBlack,
      body: Center(
        child: Text('Connect Shadow Page', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
