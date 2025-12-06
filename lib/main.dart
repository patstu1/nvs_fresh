import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'nvs_app.dart';
import 'firebase_options.dart';

Future<void> _initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      try {
        await _initializeFirebase();
      } catch (error, stackTrace) {
        debugPrint('Firebase initialization error: $error');
        debugPrintStack(stackTrace: stackTrace);
      }

      runApp(const ProviderScope(child: NVSApp()));
    },
    (Object error, StackTrace stackTrace) {
      debugPrint('Uncaught zone error: $error');
      debugPrintStack(stackTrace: stackTrace);
    },
  );
}
