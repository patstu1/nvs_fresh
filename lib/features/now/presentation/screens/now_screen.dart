import 'package:flutter/material.dart';
import '../views/now_view_minimal_working.dart';
import '../../../../widgets/bottom_nav_bar.dart';

class NowScreen extends StatelessWidget {
  const NowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: NowViewMinimalWorking(),
      bottomNavigationBar: BottomNavBar(selectedIndex: 1),
    );
  }
}




