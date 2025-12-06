import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      appBar: AppBar(
        title: const Text('Messages', style: TextStyle(color: NVSColors.neonMint)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          'Messages Screen - Your messages implementation goes here',
          style: TextStyle(color: NVSColors.neonMint, fontSize: 18),
        ),
      ),
    );
  }
}
