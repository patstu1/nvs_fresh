import 'package:flutter/material.dart';
import '../core/theme/nvs_colors.dart';
import '../features/grid/presentation/views/grid_view.dart';
import '../features/now/presentation/views/now_view.dart';
import '../features/connect/presentation/views/connect_view.dart';
import '../features/live/presentation/views/live_view.dart';
import '../features/messages/presentation/views/messages_view.dart';
import '../features/search/presentation/views/search_view.dart';
import '../features/profile/presentation/pages/profile_view.dart';

/// Emergency minimal navigation for Y Combinator demo
class MinimalNavigation extends StatefulWidget {
  const MinimalNavigation({super.key});

  @override
  State<MinimalNavigation> createState() => _MinimalNavigationState();
}

class _MinimalNavigationState extends State<MinimalNavigation> {
  int _currentIndex = 0;

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _screens = const <Widget>[
    GridViewWidget(),
    NowViewWidget(),
    ConnectViewWidget(),
    LiveViewWidget(),
    MessagesViewWidget(),
    SearchViewWidget(),
    ProfileViewWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: NVSColors.pureBlack,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: NVSColors.ultraLightMint.withValues(alpha: 0.1),
              blurRadius: 20,
              spreadRadius: 1,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          selectedItemColor: NVSColors.ultraLightMint,
          unselectedItemColor: Colors.white24,
          currentIndex: _currentIndex,
          onTap: _onNavTap,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: const TextStyle(
            fontFamily: NVSFonts.primary,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(fontFamily: NVSFonts.secondary),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Text('🩲', style: TextStyle(fontSize: 20)),
              label: 'Grid',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.circle_outlined), label: 'Now'),
            BottomNavigationBarItem(icon: Icon(Icons.all_inclusive), label: 'Connect'),
            BottomNavigationBarItem(icon: Icon(Icons.videocam), label: 'Live'),
            BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: 'Messages'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
