import 'package:flutter/material.dart';

import '../core/v4_dependencies.dart';
import '../features/connect/connect_home_page_v4.dart';
import '../features/lookout/lookout_home_page.dart';
import '../features/meat_market/meat_market_home_page.dart';
import '../features/messaging/messaging_home_page.dart';
import '../features/profile/profile_home_page_v4.dart';
import '../features/tradeblock/tradeblock_home_page.dart';
import '../features/vaultline/vaultline_home_page.dart';

class V4RootShell extends StatefulWidget {
  const V4RootShell({super.key});

  @override
  State<V4RootShell> createState() => _V4RootShellState();
}

class _V4RootShellState extends State<V4RootShell> {
  int _currentIndex = 0;

  late final List<_V4TabItem> _tabs = <_V4TabItem>[
    const _V4TabItem('Meat Market', Icons.grid_view_rounded),
    const _V4TabItem('Tradeblock', Icons.public),
    const _V4TabItem('Connect', Icons.hub_rounded),
    const _V4TabItem('Lookout', Icons.live_tv_rounded),
    const _V4TabItem('Vaultline', Icons.lock_clock_rounded),
    const _V4TabItem('Messages', Icons.chat_bubble_rounded),
    const _V4TabItem('Profile', Icons.person_outline_rounded),
  ];

  late final List<Widget> _pages = const <Widget>[
    MeatMarketHomePage(),
    TradeblockHomePage(),
    ConnectHomePageV4(),
    LookoutHomePage(),
    VaultlineHomePage(),
    MessagingHomePage(),
    ProfileHomePageV4(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSPalette.surfaceDark,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: IndexedStack(
            key: ValueKey<int>(_currentIndex),
            index: _currentIndex,
            children: _pages,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: NVSPalette.surfaceDark,
          border: Border(
            top: BorderSide(color: NVSPalette.mediumGray.withValues(alpha: 0.6)),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: NVSPalette.surfaceDark,
          selectedItemColor: NVSPalette.mint,
          unselectedItemColor: NVSPalette.lightGray,
          type: BottomNavigationBarType.fixed,
          items: _tabs
              .map(
                ( _V4TabItem tab) => BottomNavigationBarItem(
                  icon: Icon(tab.icon),
                  label: tab.label,
                ),
              )
              .toList(growable: false),
          onTap: (int index) {
            if (index == _currentIndex) return;
            setState(() => _currentIndex = index);
          },
        ),
      ),
    );
  }
}

class _V4TabItem {
  const _V4TabItem(this.label, this.icon);

  final String label;
  final IconData icon;
}
