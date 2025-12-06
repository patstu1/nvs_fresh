import 'package:flutter/material.dart';
import 'package:nvs/widgets/bottom_nav_bar.dart';
import 'profile_view.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
      ),
      body: const ProfileViewWidget(),
      bottomNavigationBar: const BottomNavBar(
        selectedIndex: 6,
      ), // Note: Profile is index 6, but we only have 6 items (0-5)
    );
  }
}
