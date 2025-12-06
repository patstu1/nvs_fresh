// lib/core/navigation/app_navigation_config.dart

// This enum is now the SINGLE SOURCE OF TRUTH for our main navigation.
// There are 7 items. The index will always be from 0 to 6. The RangeError is now impossible.
enum MainNavigationTab { grid, now, connect, live, messages, search, profile }

class AppNavigationConfig {
  static const List<MainNavigationTab> tabs = <MainNavigationTab>[
    MainNavigationTab.grid,
    MainNavigationTab.now,
    MainNavigationTab.connect,
    MainNavigationTab.live,
    MainNavigationTab.messages,
    MainNavigationTab.search,
    MainNavigationTab.profile,
  ];
}
