
import { isMobileApp, isIOS, isAndroid } from '@/utils/mobileConfig';

/**
 * Hook that provides platform detection functionality
 */
export function usePlatformDetection() {
  const isRunningOnMobile = isMobileApp();
  const isIOSPlatform = isIOS();
  const isAndroidPlatform = isAndroid();
  
  return {
    isRunningOnMobile,
    isIOSPlatform, 
    isAndroidPlatform
  };
}
