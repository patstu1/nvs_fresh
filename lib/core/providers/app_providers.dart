import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nvs/meatup_core.dart';

// Firebase Auth Provider
// final Provider<FirebaseAuth> firebaseAuthProvider =
//     Provider<FirebaseAuth>((ProviderRef<FirebaseAuth> ref) => FirebaseAuth.instance);

// final StreamProvider<User?> authStateChangesProvider = StreamProvider<User?>(
//   (StreamProviderRef<User?> ref) => ref.watch(firebaseAuthProvider).authStateChanges(),
// );

// Auth Service Provider
final Provider<AuthService> authServiceProvider =
    Provider<AuthService>((ref) {
  return AuthService();
});

// User Service Provider
final Provider<UserService> userServiceProvider =
    Provider<UserService>((ref) {
  return UserService();
});

// Analytics Service Provider
final Provider<AnalyticsService> analyticsServiceProvider =
    Provider<AnalyticsService>((ref) {
  return AnalyticsService();
});

// Notification Service Provider
final Provider<NotificationService> notificationServiceProvider =
    Provider<NotificationService>((ref) {
  return NotificationService();
});

// Location Service Provider
final Provider<LocationService> locationServiceProvider =
    Provider<LocationService>((ref) {
  return LocationService();
});

// AI Service Provider
final Provider<AiService> aiServiceProvider =
    Provider<AiService>((ref) => AiService());

// Video Service Provider
final Provider<VideoService> videoServiceProvider =
    Provider<VideoService>((ref) {
  return VideoService();
});

// Current User Provider
// final Provider<User?> currentUserProvider = Provider<User?>((ProviderRef<User?> ref) {
//   return ref.watch(firebaseAuthProvider).currentUser;
// });

// User Profile Provider
final FutureProviderFamily<UserProfile?, String> userProfileProvider =
    FutureProvider.family<UserProfile?, String>((ref, String userId) async {
  final UserService userService = ref.read(userServiceProvider);
  return userService.getUserProfile(userId);
});

// Current User Profile Provider
// final FutureProvider<UserProfile?> currentUserProfileProvider =
//     FutureProvider<UserProfile?>((FutureProviderRef<UserProfile?> ref) async {
//   final User? user = ref.watch(currentUserProvider);
//   if (user == null) return null;

//   final UserService userService = ref.read(userServiceProvider);
//   return userService.getUserProfile(user.uid);
// });

// Theme Mode Provider
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.dark) {
    _loadThemePreference();
  }

  void toggleTheme() {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    _saveThemePreference();
  }

  void setTheme(ThemeMode themeMode) {
    state = themeMode;
    _saveThemePreference();
  }

  Future<void> _saveThemePreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', state.name);
  }

  Future<void> _loadThemePreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? themeName = prefs.getString('theme_mode');
    if (themeName != null) {
      state = ThemeMode.values.firstWhere(
        (ThemeMode e) => e.name == themeName,
        orElse: () => ThemeMode.dark,
      );
    }
  }
}

final StateNotifierProvider<ThemeModeNotifier, ThemeMode> themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

// App State Provider
class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(const AppState());

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  void clearError() {
    state = state.copyWith();
  }

  void setCurrentRoute(String route) {
    state = state.copyWith(currentRoute: route);
  }

  void setAppVersion(String version) {
    state = state.copyWith(appVersion: version);
  }

  void setBuildNumber(String buildNumber) {
    state = state.copyWith(buildNumber: buildNumber);
  }
}

final StateNotifierProvider<AppStateNotifier, AppState> appStateProvider =
    StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  return AppStateNotifier();
});

// User Preferences Provider
class UserPreferencesNotifier extends StateNotifier<UserPreferences> {
  UserPreferencesNotifier() : super(const UserPreferences()) {
    loadPreferences();
  }

  Future<void> loadPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    state = UserPreferences(
      notificationsEnabled: prefs.getBool('notifications_enabled') ?? true,
      locationEnabled: prefs.getBool('location_enabled') ?? true,
      darkModeEnabled: prefs.getBool('dark_mode_enabled') ?? true,
      autoPlayVideos: prefs.getBool('auto_play_videos') ?? false,
      showOnlineStatus: prefs.getBool('show_online_status') ?? true,
      allowMessagesFrom: prefs.getString('allow_messages_from') ?? 'all',
      privacyLevel: prefs.getString('privacy_level') ?? 'standard',
      language: prefs.getString('language') ?? 'en',
      measurementUnit: prefs.getString('measurement_unit') ?? 'metric',
    );
  }

  Future<void> updateNotificationSettings(bool enabled) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', enabled);
    state = state.copyWith(notificationsEnabled: enabled);
  }

  Future<void> updateLocationSettings(bool enabled) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('location_enabled', enabled);
    state = state.copyWith(locationEnabled: enabled);
  }

  Future<void> updateDarkModeSettings(bool enabled) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode_enabled', enabled);
    state = state.copyWith(darkModeEnabled: enabled);
  }

  Future<void> updateAutoPlaySettings(bool enabled) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auto_play_videos', enabled);
    state = state.copyWith(autoPlayVideos: enabled);
  }

  Future<void> updateOnlineStatusSettings(bool enabled) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_online_status', enabled);
    state = state.copyWith(showOnlineStatus: enabled);
  }

  Future<void> updateMessageSettings(String allowFrom) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('allow_messages_from', allowFrom);
    state = state.copyWith(allowMessagesFrom: allowFrom);
  }

  Future<void> updatePrivacyLevel(String level) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('privacy_level', level);
    state = state.copyWith(privacyLevel: level);
  }

  Future<void> updateLanguage(String language) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
    state = state.copyWith(language: language);
  }

  Future<void> updateMeasurementUnit(String unit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('measurement_unit', unit);
    state = state.copyWith(measurementUnit: unit);
  }
}

final StateNotifierProvider<UserPreferencesNotifier, UserPreferences> userPreferencesProvider =
    StateNotifierProvider<UserPreferencesNotifier, UserPreferences>((ref) {
  return UserPreferencesNotifier();
});

// App State Model
class AppState {
  const AppState({
    this.isLoading = false,
    this.error,
    this.currentRoute = '/',
    this.appVersion = '1.0.0',
    this.buildNumber = '1',
  });
  final bool isLoading;
  final String? error;
  final String currentRoute;
  final String appVersion;
  final String buildNumber;

  AppState copyWith({
    bool? isLoading,
    String? error,
    String? currentRoute,
    String? appVersion,
    String? buildNumber,
  }) {
    return AppState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      currentRoute: currentRoute ?? this.currentRoute,
      appVersion: appVersion ?? this.appVersion,
      buildNumber: buildNumber ?? this.buildNumber,
    );
  }
}

// User Preferences Model
class UserPreferences {
  const UserPreferences({
    this.notificationsEnabled = true,
    this.locationEnabled = true,
    this.darkModeEnabled = true,
    this.autoPlayVideos = false,
    this.showOnlineStatus = true,
    this.allowMessagesFrom = 'all',
    this.privacyLevel = 'standard',
    this.language = 'en',
    this.measurementUnit = 'metric',
  });
  final bool notificationsEnabled;
  final bool locationEnabled;
  final bool darkModeEnabled;
  final bool autoPlayVideos;
  final bool showOnlineStatus;
  final String allowMessagesFrom;
  final String privacyLevel;
  final String language;
  final String measurementUnit;

  UserPreferences copyWith({
    bool? notificationsEnabled,
    bool? locationEnabled,
    bool? darkModeEnabled,
    bool? autoPlayVideos,
    bool? showOnlineStatus,
    String? allowMessagesFrom,
    String? privacyLevel,
    String? language,
    String? measurementUnit,
  }) {
    return UserPreferences(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      locationEnabled: locationEnabled ?? this.locationEnabled,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      autoPlayVideos: autoPlayVideos ?? this.autoPlayVideos,
      showOnlineStatus: showOnlineStatus ?? this.showOnlineStatus,
      allowMessagesFrom: allowMessagesFrom ?? this.allowMessagesFrom,
      privacyLevel: privacyLevel ?? this.privacyLevel,
      language: language ?? this.language,
      measurementUnit: measurementUnit ?? this.measurementUnit,
    );
  }
}
