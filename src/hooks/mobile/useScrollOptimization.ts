
import { useCallback, useEffect, useRef } from 'react';
import { usePlatformDetection } from './usePlatformDetection';

/**
 * Hook that provides enhanced scroll optimization functionality
 */
export function useScrollOptimization() {
  const { isRunningOnMobile, isIOSPlatform } = usePlatformDetection();
  const lastScrollTop = useRef(0);
  const scrollDirectionRef = useRef<'up' | 'down'>('up');
  const ticking = useRef(false);
  const scrollTimeout = useRef<number | null>(null);
  
  // Improved scroll optimization with passive listeners and throttling
  const optimizeScrolling = useCallback(() => {
    if (!isRunningOnMobile) return undefined;
    
    // Apply iOS-specific body fixes if on iOS
    if (isIOSPlatform) {
      document.body.classList.add('ios-scroll-fix');
      document.documentElement.style.height = '100%';
      document.body.style.height = '100%';
      document.body.style.position = 'fixed';
      document.body.style.width = '100%';
      document.body.style.overflowY = 'scroll';
    }

    const handleScroll = () => {
      const scrollTop = window.scrollY;
      
      // Detect scroll direction
      if (scrollTop > lastScrollTop.current) {
        if (scrollDirectionRef.current !== 'down') {
          scrollDirectionRef.current = 'down';
          document.body.classList.add('scrolling-down');
          document.body.classList.remove('scrolling-up');
        }
      } else if (scrollTop < lastScrollTop.current) {
        if (scrollDirectionRef.current !== 'up') {
          scrollDirectionRef.current = 'up';
          document.body.classList.add('scrolling-up');
          document.body.classList.remove('scrolling-down');
        }
      }
      
      // Only process scroll events if we've moved significantly
      if (Math.abs(lastScrollTop.current - scrollTop) < 10) return;
      
      lastScrollTop.current = scrollTop;
      
      if (!ticking.current) {
        // Use requestAnimationFrame for more efficient visual updates
        window.requestAnimationFrame(() => {
          // During scroll, disable heavy animations
          document.body.classList.add('scrolling');
          
          // Clear the previous timeout
          if (scrollTimeout.current !== null) {
            window.clearTimeout(scrollTimeout.current);
          }
          
          // Re-enable animations after scrolling stops
          scrollTimeout.current = window.setTimeout(() => {
            document.body.classList.remove('scrolling');
          }, 100) as unknown as number;
          
          ticking.current = false;
        });
        
        ticking.current = true;
      }
    };
    
    // Apply passive listener for better performance
    window.addEventListener('scroll', handleScroll, { passive: true });
    
    return () => {
      window.removeEventListener('scroll', handleScroll);
      
      // Clean up iOS specific styles
      if (isIOSPlatform) {
        document.body.classList.remove('ios-scroll-fix');
        document.documentElement.style.removeProperty('height');
        document.body.style.removeProperty('height');
        document.body.style.removeProperty('position');
        document.body.style.removeProperty('width');
        document.body.style.removeProperty('overflowY');
      }
    };
  }, [isRunningOnMobile, isIOSPlatform]);

  // Immediately apply optimization on mount
  useEffect(() => {
    const cleanup = optimizeScrolling();
    return cleanup;
  }, [optimizeScrolling]);
  
  return {
    optimizeScrolling,
    scrollDirection: scrollDirectionRef.current
  };
}
