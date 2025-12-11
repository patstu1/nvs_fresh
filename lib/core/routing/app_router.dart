import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../navigation/main_navigation_page.dart';
import 'package:nvs/presentation/views/grid_view.dart' show GridViewWidget;
import '../../features/now/presentation/pages/now_map_hub.dart' show NowMapHubView;
import '../../features/connect/presentation/views/connect_view.dart' show ConnectViewWidget;
import '../../features/connect/presentation/pages/connect_dashboard.dart' show ConnectDashboard;
import '../../features/connect/presentation/pages/nvs_connect_onboarding.dart'
    show NvsConnectOnboardingPage;
import '../../features/onboarding/presentation/pages/onboarding_entry_page.dart'
    show OnboardingEntryPage;
import '../../features/ai_characters/presentation/pages/dombot_matchmaking_page.dart'
    show DomBotMatchmakingPage;
import '../../features/auth/presentation/pages/auth_page.dart' show AuthPage;
import '../../features/connect/presentation/pages/connect_vibe_analysis_page.dart'
    show ConnectVibeAnalysisPage;
import '../../features/connect/presentation/pages/connect_heatmap_page.dart'
    show ConnectHeatmapPage;
import '../../features/connect/presentation/pages/connect_verdict_page.dart'
    show ConnectVerdictPage;
import '../../features/connect/presentation/pages/connect_match_detail.dart'
    show ConnectMatchDetail;
import '../../features/connect/presentation/pages/match_canvas.dart' show MatchCanvas;
import '../../features/connect/presentation/screens/nvs_chosen_mates_vault_screen.dart'
    show NvsChosenMatesVaultScreen;
import '../../features/chat/presentation/pages/chat_page.dart' show ChatPage;
import '../../features/live/presentation/views/live_view.dart';
import '../../features/messenger/presentation/universal_messenger_view.dart'
    show UniversalMessengerView;
import '../../features/search/presentation/views/search_view.dart';
import '../../features/profile/presentation/views/profile_view.dart' show ProfileView;
import '../../features/profile/presentation/pages/profile_page.dart' show ProfilePage;
import '../../features/profile/presentation/pages/profile_setup_flow.dart' show ProfileSetupFlow;
import '../../features/messaging/presentation/pages/message_hub.dart' show MessageHub;

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        // Temporarily bypass AppShell to debug
        return child;
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            final String? tab = state.uri.queryParameters['tab'];
            return EntryGate(tab: tab);
          },
        ),
        GoRoute(
          path: '/onboarding',
          builder: (BuildContext context, GoRouterState state) => const OnboardingEntryPage(),
        ),
        GoRoute(
          path: '/auth',
          builder: (BuildContext context, GoRouterState state) => const AuthPage(),
        ),
        GoRoute(
          path: '/grid',
          builder: (BuildContext context, GoRouterState state) => const GridViewWidget(),
        ),
        GoRoute(
          path: '/now',
          builder: (BuildContext context, GoRouterState state) => const NowMapHubView(),
        ),
        GoRoute(
          path: '/connect',
          builder: (BuildContext context, GoRouterState state) => const _ConnectEntry(),
          routes: <RouteBase>[
            GoRoute(
              path: 'dashboard',
              builder: (BuildContext context, GoRouterState state) => const ConnectDashboard(),
            ),
            GoRoute(
              path: 'onboarding',
              builder: (BuildContext context, GoRouterState state) =>
                  const NvsConnectOnboardingPage(),
            ),
            GoRoute(
              path: 'cards',
              builder: (BuildContext context, GoRouterState state) => const ConnectViewWidget(),
            ),
            GoRoute(
              path: 'ai',
              builder: (BuildContext context, GoRouterState state) => const DomBotMatchmakingPage(),
            ),
            GoRoute(
              path: 'vibe',
              builder: (BuildContext context, GoRouterState state) =>
                  const ConnectVibeAnalysisPage(),
            ),
            GoRoute(
              path: 'heatmap',
              builder: (BuildContext context, GoRouterState state) => const ConnectHeatmapPage(),
            ),
            GoRoute(
              path: 'verdict',
              builder: (BuildContext context, GoRouterState state) => const ConnectVerdictPage(),
            ),
            GoRoute(
              path: 'matches',
              builder: (BuildContext context, GoRouterState state) => const MatchCanvas(),
            ),
            GoRoute(
              path: 'match/:id',
              builder: (BuildContext context, GoRouterState state) =>
                  ConnectMatchDetail(userId: state.pathParameters['id']),
            ),
            GoRoute(
              path: 'vault',
              builder: (BuildContext context, GoRouterState state) =>
                  const NvsChosenMatesVaultScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/live',
          builder: (BuildContext context, GoRouterState state) => const LiveViewWidget(),
        ),
        GoRoute(
          path: '/messages',
          builder: (BuildContext context, GoRouterState state) => const UniversalMessengerView(),
        ),
        GoRoute(
          path: '/search',
          builder: (BuildContext context, GoRouterState state) => const SearchViewWidget(),
        ),
        GoRoute(
          path: '/chat/:chatId',
          builder: (BuildContext context, GoRouterState state) => ChatPage(
            chatId: state.pathParameters['chatId'] ?? 'default',
          ),
        ),
        GoRoute(
          path: '/profile',
          builder: (BuildContext context, GoRouterState state) => const ProfileView(),
        ),
        GoRoute(
          path: '/profile/:id',
          builder: (BuildContext context, GoRouterState state) => const ProfilePage(),
        ),
        GoRoute(
          path: '/profile-setup',
          builder: (BuildContext context, GoRouterState state) => const ProfileSetupFlow(),
        ),
        GoRoute(
          path: '/message-hub',
          builder: (BuildContext context, GoRouterState state) {
            final String? section = state.uri.queryParameters['section'];
            int initialSection = 0;
            switch (section) {
              case 'meatmarket':
                initialSection = 0;
                break;
              case 'tradeblock':
                initialSection = 1;
                break;
              case 'lookout':
                initialSection = 2;
                break;
              case 'connect':
                initialSection = 3;
                break;
            }
            return MessageHub(initialSection: initialSection);
          },
        ),
      ],
    ),
  ],
);

class _ConnectEntry extends StatefulWidget {
  const _ConnectEntry();
  @override
  State<_ConnectEntry> createState() => _ConnectEntryState();
}

class _ConnectEntryState extends State<_ConnectEntry> {
  @override
  void initState() {
    super.initState();
    _route();
  }

  Future<void> _route() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool hasCompleted = prefs.getBool('hasCompletedConnectOnboarding') ?? false;
      if (!mounted) return;
      if (hasCompleted) {
        context.go('/connect/dashboard');
      } else {
        context.go('/connect/onboarding');
      }
    } catch (e) {
      print('SharedPreferences failed in _ConnectEntry: $e');
      // Default to onboarding if SharedPreferences fails
      if (!mounted) return;
      context.go('/connect/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class EntryGate extends StatefulWidget {
  const EntryGate({super.key, this.tab});
  final String? tab;

  @override
  State<EntryGate> createState() => _EntryGateState();
}

class _EntryGateState extends State<EntryGate> {
  @override
  void initState() {
    super.initState();
    _maybeRedirectToOnboarding();
  }

  Future<void> _maybeRedirectToOnboarding() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      // ignore: unused_local_variable
      final bool hasOnboarded = prefs.getBool('hasOnboarded') ?? false;
      if (!mounted) return;

      // For debugging, let's force the main app to show instead of onboarding
      // Comment out the onboarding redirect for now
      // if (!hasOnboarded) {
      //   WidgetsBinding.instance.addPostFrameCallback((_) {
      //     if (mounted) context.go('/onboarding');
      //   });
      // }
    } catch (e) {
      debugPrint('SharedPreferences failed in EntryGate: $e');
    }
  }

  int _mapTabToIndex(String? t) {
    switch (t) {
      case 'grid':
        return 0;
      case 'now':
        return 1;
      case 'connect':
        return 2;
      case 'live':
        return 3;
      case 'messages':
        return 4;
      case 'search':
        return 5;
      case 'profile':
        return 6;
      default:
        return 0; // default to MEAT MARKET grid section
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainNavigationPage(initialIndex: _mapTabToIndex(widget.tab));
  }
}
