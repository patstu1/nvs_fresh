// lib/platform/auth_platform.dart
// Platform-specific authentication to solve iOS dependency conflicts

import 'dart:io';

abstract class AuthPlatform {
  static bool get supportsGoogleSignIn {
    // Enable Google Sign In on all platforms with updated dependency resolution
    return true;
  }

  static bool get supportsAppleSignIn {
    return Platform.isIOS || Platform.isMacOS;
  }

  static String get primaryAuthMethod {
    if (Platform.isIOS) {
      return 'Apple Sign In'; // Primary on iOS
    } else {
      return 'Google Sign In'; // Primary on Android/other platforms
    }
  }

  static String get secondaryAuthMethod {
    if (Platform.isIOS) {
      return 'Google Sign In'; // Secondary option on iOS
    } else {
      return 'Apple Sign In'; // Secondary option on Android (if available)
    }
  }
}
