import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> initialize() async {
    try {
      await _analytics.setAnalyticsCollectionEnabled(true);
      // Set up custom event parameters
      await _analytics.setUserProperty(name: 'user_type', value: 'premium');
    } catch (e) {
      print('Analytics service initialization error: $e');
      rethrow;
    }
  }

  // Track your app events
  Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }

  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    await _analytics.logEvent(name: name, parameters: parameters);
  }
}
