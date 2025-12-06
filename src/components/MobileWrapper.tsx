
import React, { useEffect } from 'react';
import { useScrollOptimization } from '@/hooks/mobile/useScrollOptimization';
import { useMemoryOptimization } from '@/hooks/mobile/useMemoryOptimization';
import { usePlatformDetection } from '@/hooks/mobile/usePlatformDetection';

interface MobileWrapperProps {
  children: React.ReactNode;
}

const MobileWrapper: React.FC<MobileWrapperProps> = ({ children }) => {
  const { optimizeScrolling } = useScrollOptimization();
  const { optimizeMemoryUsage } = useMemoryOptimization();
  const { isRunningOnMobile, isIOSPlatform, isAndroidPlatform } = usePlatformDetection();

  useEffect(() => {
    // Apply memory optimizations when component mounts
    optimizeMemoryUsage();

    // Apply viewport meta tag adjustments for iOS and Android
    const meta = document.querySelector('meta[name="viewport"]');
    if (meta) {
      if (isIOSPlatform) {
        meta.setAttribute('content', 'width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, viewport-fit=cover');
      } else if (isAndroidPlatform) {
        meta.setAttribute('content', 'width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no');
      }
    }

    // Prevent elastic overscroll on iOS
    document.body.classList.add('no-bounce');
    
    // Add platform-specific classes to body
    if (isIOSPlatform) {
      document.body.classList.add('ios-platform');
    } else if (isAndroidPlatform) {
      document.body.classList.add('android-platform');
    }

    return () => {
      document.body.classList.remove('no-bounce', 'ios-platform', 'android-platform');
    };
  }, [optimizeMemoryUsage, isIOSPlatform, isAndroidPlatform]);

  return (
    <div className={`min-h-screen bg-black text-[#C2FFE6] hardware-accelerated ${isRunningOnMobile ? 'mobile-optimized' : ''}`}>
      <div className="min-h-screen flex flex-col content-stretch">
        {children}
      </div>
    </div>
  );
};

export default MobileWrapper;
