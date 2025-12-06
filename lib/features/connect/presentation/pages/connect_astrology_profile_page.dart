// connect_astrology_profile_page.dart

import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

class ConnectAstrologyProfilePage extends StatelessWidget {
  const ConnectAstrologyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: NVSColors.pureBlack,
      body: Center(
        child: Text(
          'Connect Astrology Profile Page',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
