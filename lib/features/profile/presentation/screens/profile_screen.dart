import 'package:flutter/material.dart';
import '../../../../widgets/bottom_nav_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'PROFILE\nComing Soon',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFA7FFE0),
            fontSize: 24,
            fontFamily: 'MagdaClean',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: 6),
    );
  }
}
