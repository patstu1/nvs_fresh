/// Shared application constants
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // App metadata
  static const String appName = 'Meatup';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Next Generation Social Platform';

  // API endpoints (when backend is ready)
  static const String baseUrl = 'https://api.nvs.app';
  static const String apiVersion = '/v1';

  // Storage keys
  static const String userTokenKey = 'user_token';
  static const String userProfileKey = 'user_profile';
  static const String onboardingCompleteKey = 'onboarding_complete';
  static const String themeKey = 'app_theme';

  // Animation durations
  static const Duration animationDurationFast = Duration(milliseconds: 200);
  static const Duration animationDurationNormal = Duration(milliseconds: 300);
  static const Duration animationDurationSlow = Duration(milliseconds: 500);

  // Timeouts
  static const Duration networkTimeout = Duration(seconds: 30);
  static const Duration cacheTimeout = Duration(hours: 24);

  // Limits
  static const int maxImageSize = 10 * 1024 * 1024; // 10MB
  static const int maxVideoSize = 100 * 1024 * 1024; // 100MB
  static const int maxMessageLength = 1000;
  static const int maxUsernameLength = 30;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // UI sizing
  static const double iconSizeLarge = 48.0;
  static const double borderWidthThick = 4.0;
  static const double spacingM = 12.0;

  // Validation
  static const String emailRegex = r'^[^@]+@[^@]+\.[^@]+$';
  static const String usernameRegex = r'^[a-zA-Z0-9_]{3,30}$';
  static const String passwordRegex = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{8,}$';

  // Error messages
  static const String networkErrorMessage = 'Network error. Please check your connection.';
  static const String serverErrorMessage = 'Server error. Please try again later.';
  static const String unknownErrorMessage = 'An unknown error occurred.';
  static const String invalidInputMessage = 'Please check your input and try again.';

  // Success messages
  static const String profileUpdatedMessage = 'Profile updated successfully.';
  static const String messageSentMessage = 'Message sent successfully.';
  static const String settingsSavedMessage = 'Settings saved successfully.';

  // Feature flags
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  static const bool enablePushNotifications = true;
  static const bool enableLocationServices = true;
}
