// Simple flutter bootstrap script to prevent splash screen errors
(function() {
  // Remove any existing splash screen
  try {
    if (typeof removeSplashFromWeb === 'function') {
      removeSplashFromWeb();
    }
  } catch (e) {
    // Ignore errors
  }
  
  // Initialize Flutter
  if (typeof flutterInAppWebViewPlatform !== 'undefined') {
    flutterInAppWebViewPlatform.callHandler('removeSplashFromWeb');
  }
})(); 