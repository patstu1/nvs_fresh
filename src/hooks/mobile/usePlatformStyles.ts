
import { useEffect } from 'react';
import { usePlatformDetection } from './usePlatformDetection';

/**
 * Hook that applies platform-specific style optimizations
 */
export function usePlatformStyles() {
  const { isRunningOnMobile, isIOSPlatform, isAndroidPlatform } = usePlatformDetection();

  useEffect(() => {
    if (!isRunningOnMobile) return;

    // Apply platform-specific optimizations
    if (isIOSPlatform) {
      // iOS-specific optimizations
      document.body.classList.add('ios-optimized');
      
      // Disable iOS-specific behaviors that cause performance issues
      document.addEventListener('touchmove', (e) => {
        if (e.target instanceof HTMLElement && 
            !e.target.closest('.scroll-enabled')) {
          e.preventDefault();
        }
      }, { passive: false });
      
      // Add iOS momentum scrolling optimization
      const style = document.createElement('style');
      style.innerHTML = `
        .ios-optimized * {
          -webkit-overflow-scrolling: touch;
        }
        .ios-optimized .optimize-rendering {
          transform: translateZ(0);
          will-change: transform;
        }
        .app-background * {
          animation-play-state: paused !important;
        }
        .scrolling .heavy-animation {
          animation-play-state: paused !important;
        }
      `;
      document.head.appendChild(style);
    }
    
    if (isAndroidPlatform) {
      // Android-specific optimizations
      document.body.classList.add('android-optimized');
      
      // Improve tap response time on Android
      const androidStyle = document.createElement('style');
      androidStyle.innerHTML = `
        .android-optimized button, 
        .android-optimized a,
        .android-optimized [role="button"] {
          touch-action: manipulation;
        }
        .android-optimized .optimize-rendering {
          will-change: transform;
          backface-visibility: hidden;
        }
        .android-optimized img, 
        .android-optimized video {
          view-transition-name: media;
        }
      `;
      document.head.appendChild(androidStyle);
    }
    
    // Reduce animations when on low-power mode or low-end devices
    if ('connection' in navigator) {
      const connection = navigator.connection as any;
      if (connection && (connection.effectiveType === '2g' || connection.saveData)) {
        document.body.classList.add('reduce-animations');
        
        // Add low-end device style optimizations
        const lowEndStyle = document.createElement('style');
        lowEndStyle.innerHTML = `
          .reduce-animations * {
            transition-duration: 0.1s !important;
            animation-duration: 0.1s !important;
          }
          .reduce-animations img {
            image-rendering: auto;
          }
        `;
        document.head.appendChild(lowEndStyle);
      }
    }

    // Cleanup function
    return () => {
      document.body.classList.remove('ios-optimized', 'android-optimized', 'reduce-animations');
    };
  }, [isRunningOnMobile, isIOSPlatform, isAndroidPlatform]);
}
