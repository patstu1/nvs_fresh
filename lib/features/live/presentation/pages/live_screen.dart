import 'package:flutter/material.dart';
import 'package:nvs/widgets/bottom_nav_bar.dart';
import 'live_view.dart';

class LiveScreen extends StatelessWidget {
  const LiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Live', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
      ),
      body: const LiveViewWidget(),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 3),
    );
  }
}
