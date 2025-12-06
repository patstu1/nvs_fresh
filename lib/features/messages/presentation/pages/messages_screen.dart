import 'package:flutter/material.dart';
import '../../../../widgets/bottom_nav_bar.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'Messages Screen',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: 4),
    );
  }
}
