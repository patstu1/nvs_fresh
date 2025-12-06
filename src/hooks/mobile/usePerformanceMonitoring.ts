
import { useCallback, useRef } from 'react';
import { usePlatformDetection } from './usePlatformDetection';

/**
 * Hook that provides performance monitoring functionality
 */
export function usePerformanceMonitoring() {
  const { isRunningOnMobile } = usePlatformDetection();
  const performanceTracker = useRef<{startTime: number, frames: number}>({startTime: 0, frames: 0});
  
  // Reset performance tracking
  const resetPerformanceTracking = useCallback(() => {
    performanceTracker.current = {
      startTime: performance.now(),
      frames: 0
    };
  }, []);
  
  // Monitor frame rate to detect performance issues
  const startPerformanceMonitoring = useCallback(() => {
    if (!isRunningOnMobile) return () => {};
    
    resetPerformanceTracking();
    
    const countFrame = () => {
      performanceTracker.current.frames++;
      
      // Check every 2 seconds
      const elapsed = performance.now() - performanceTracker.current.startTime;
      if (elapsed >= 2000) {
        const fps = (performanceTracker.current.frames / elapsed) * 1000;
        
        // If performance is poor, apply more aggressive optimizations
        if (fps < 30) {
          document.body.classList.add('low-performance');
          // Disable non-essential animations
          const style = document.createElement('style');
          style.innerHTML = `
            .low-performance .optional-animation {
              animation: none !important;
              transition: none !important;
            }
          `;
          document.head.appendChild(style);
        } else {
          document.body.classList.remove('low-performance');
        }
        
        // Reset counters
        resetPerformanceTracking();
      }
      
      requestAnimationFrame(countFrame);
    };
    
    const frameId = requestAnimationFrame(countFrame);
    return () => cancelAnimationFrame(frameId);
  }, [isRunningOnMobile, resetPerformanceTracking]);
  
  return {
    performanceTracker,
    resetPerformanceTracking,
    startPerformanceMonitoring
  };
}
