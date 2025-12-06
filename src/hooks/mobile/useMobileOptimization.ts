
import { useState, useEffect, useRef } from 'react';
import { usePlatformDetection } from './usePlatformDetection';
import { useMemoryOptimization } from './useMemoryOptimization';
import { useScrollOptimization } from './useScrollOptimization';
import { useVisibilityOptimization } from './useVisibilityOptimization';
import { usePerformanceMonitoring } from './usePerformanceMonitoring';
import { usePlatformStyles } from './usePlatformStyles';

/**
 * Main hook for mobile optimizations that combines all optimization strategies
 */
export function useMobileOptimization() {
  const [isPlatformOptimized, setIsPlatformOptimized] = useState(false);
  const { isRunningOnMobile, isIOSPlatform, isAndroidPlatform } = usePlatformDetection();
  const { optimizeMemoryUsage } = useMemoryOptimization();
  const { optimizeScrolling } = useScrollOptimization();
  const { handleVisibilityChange } = useVisibilityOptimization();
  const { startPerformanceMonitoring } = usePerformanceMonitoring();
  
  // Use a ref to track if optimization has been applied
  const optimizationApplied = useRef(false);
  
  // Apply platform styles
  usePlatformStyles();

  useEffect(() => {
    if (isRunningOnMobile && !optimizationApplied.current) {
      // Set up visibility change listener for background optimization
      document.addEventListener('visibilitychange', handleVisibilityChange);
      
      // Apply scroll optimization
      const cleanupScrolling = optimizeScrolling();
      
      // Start performance monitoring
      const cleanupPerformanceMonitoring = startPerformanceMonitoring();
      
      // Mark optimizations as applied
      optimizationApplied.current = true;
      setIsPlatformOptimized(true);
      
      // Cleanup function
      return () => {
        document.removeEventListener('visibilitychange', handleVisibilityChange);
        if (cleanupScrolling) cleanupScrolling();
        if (cleanupPerformanceMonitoring) cleanupPerformanceMonitoring();
      };
    }
    
    return undefined;
  }, [
    isRunningOnMobile, 
    handleVisibilityChange, 
    optimizeScrolling,
    startPerformanceMonitoring
  ]);

  // Public API
  return {
    isRunningOnMobile,
    isPlatformOptimized,
    isIOSPlatform,
    isAndroidPlatform,
    optimizeMemoryUsage  // Expose this for manual optimization calls
  };
}
