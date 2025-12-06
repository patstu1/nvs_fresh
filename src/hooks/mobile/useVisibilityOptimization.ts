
import { useCallback } from 'react';
import { usePlatformDetection } from './usePlatformDetection';
import { useMemoryOptimization } from './useMemoryOptimization';

/**
 * Hook that optimizes app behavior when visibility changes (background/foreground)
 */
export function useVisibilityOptimization() {
  const { isRunningOnMobile } = usePlatformDetection();
  const { optimizeMemoryUsage } = useMemoryOptimization();
  
  // Handle visibility change to optimize background behavior
  const handleVisibilityChange = useCallback(() => {
    if (document.hidden && isRunningOnMobile) {
      console.log("App has gone to the background");
      // App went to background - optimize memory
      optimizeMemoryUsage();
      
      // Pause all media and animations when app goes to background
      document.querySelectorAll('video, audio').forEach((media: any) => {
        if (!media.paused) media.pause();
      });
      
      // Disable heavy animations
      document.body.classList.add('app-background');
    } else if (isRunningOnMobile) {
      // App came to foreground
      console.log("App has come to the foreground");
      document.body.classList.remove('app-background');
    }
  }, [isRunningOnMobile, optimizeMemoryUsage]);
  
  return {
    handleVisibilityChange
  };
}
