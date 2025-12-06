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
          'MESSAGES\nComing Soon',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFA7FFE0),
            fontSize: 24,
            fontFamily: 'MagdaCleanMono',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: 4),
    );
  }
}
