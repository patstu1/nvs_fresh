
import { App } from '@capacitor/app';
import { CapacitorException } from '@capacitor/core';

// Check if the app is running as a mobile app
export const isMobileApp = (): boolean => {
  return (
    window.location.href.includes('capacitor://') || 
    window.location.href.includes('yobro://') ||
    // Check if running in Capacitor
    !!window.Capacitor
  );
};

// Check if the platform is iOS
export const isIOS = (): boolean => {
  return (
    isMobileApp() && 
    (navigator.userAgent.includes('iPhone') || 
     navigator.userAgent.includes('iPad') || 
     navigator.userAgent.includes('iPod') ||
     (navigator.platform === 'MacIntel' && navigator.maxTouchPoints > 1))
  );
};

// Check if the platform is Android
export const isAndroid = (): boolean => {
  return isMobileApp() && /android/i.test(navigator.userAgent);
};

// Set up app state listeners (resume/pause)
export const setupAppStateListeners = async (
  onResumeCallback?: () => void,
  onPauseCallback?: () => void
): Promise<void> => {
  if (!isMobileApp()) return;
  
  try {
    App.addListener('appStateChange', ({ isActive }) => {
      if (isActive) {
        console.log('App has come to the foreground');
        onResumeCallback?.();
      } else {
        console.log('App has gone to the background');
        onPauseCallback?.();
      }
    });
  } catch (error) {
    const capacitorError = error as CapacitorException;
    console.error('Error setting up app state listeners:', capacitorError.message);
  }
};

// Get app version
export const getAppVersion = async (): Promise<string> => {
  if (!isMobileApp()) return 'web';
  
  try {
    const info = await App.getInfo();
    return `${info.version} (${info.build})`;
  } catch (error) {
    console.error('Error getting app version:', error);
    return 'unknown';
  }
};
