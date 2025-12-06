import 'package:flutter/material.dart';
import '../../../../widgets/bottom_nav_bar.dart';

class ConnectScreen extends StatelessWidget {
  const ConnectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ConnectView(targetUserId: 'demo_user'),
      bottomNavigationBar: BottomNavBar(selectedIndex: 2),
    );
  }
}
