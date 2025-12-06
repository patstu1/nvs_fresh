import 'package:flutter/material.dart';
import '../pages/grid_main_view.dart';
import '../../../../widgets/bottom_nav_bar.dart';

class GridScreen extends StatelessWidget {
  const GridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: NVSGridView(),
      bottomNavigationBar: BottomNavBar(selectedIndex: 0),
    );
  }
}




