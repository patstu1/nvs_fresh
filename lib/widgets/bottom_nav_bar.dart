import 'package:flutter/material.dart';
import 'package:nvs/core/widgets/nvs_bottom_navigation.dart';

/// Legacy compatibility wrapper for the updated `NvsBottomNavigation`.
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key, this.selectedIndex});

  final int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    // `selectedIndex` is ignored intentionally because navigation is
    // derived from the current GoRouter location inside NvsBottomNavigation.
    return const NvsBottomNavigation();
  }
}






