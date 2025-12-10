import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/nvs_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/routing/app_router.dart';
import 'firebase_options.dart';

class NVSApp extends ConsumerStatefulWidget {
  const NVSApp({super.key});

  @override
  ConsumerState<NVSApp> createState() => _NVSAppState();
}

class _NVSAppState extends ConsumerState<NVSApp> {
  late final Future<bool> _hasOnboardedFuture = _loadOnboardingFlag();
  late final Future<void> _firebaseInitFuture = _initializeFirebase();
  bool _initialRouteHandled = false;

  Future<void> _initializeFirebase() async {
    try {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      debugPrint('Firebase initialized successfully');
    } catch (e, stackTrace) {
      debugPrint('Firebase initialization failed: $e');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<bool> _loadOnboardingFlag() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getBool('hasOnboarded') ?? false;
    } catch (e) {
      debugPrint('SharedPreferences failed: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _firebaseInitFuture,
      builder: (BuildContext context, AsyncSnapshot<void> firebaseSnap) {
        if (firebaseSnap.connectionState != ConnectionState.done) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        return FutureBuilder<bool>(
          future: _hasOnboardedFuture,
          builder: (BuildContext context, AsyncSnapshot<bool> snap) {
            // Skip initial route handling for now to avoid crashes
            // The app will start at '/' which shows the main navigation
            return MaterialApp.router(
              title: 'Neural Vector Social',
              debugShowCheckedModeBanner: false,
              theme: NvsTheme.theme,
              routerConfig: appRouter,
            );
          },
        );
      },
    );
  }
}
