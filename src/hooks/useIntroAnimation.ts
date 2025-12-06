
import { useState, useEffect, useCallback, useRef } from 'react';
import soundManager from '@/utils/soundManager';

export interface AnimationSequenceState {
  showYo: boolean;
  showBro: boolean;
  showIcon: boolean;
  showFinal: boolean;
  iconScale: number;
}

export const useIntroAnimation = () => {
  const [showIntro, setShowIntro] = useState(true);
  const [showYo, setShowYo] = useState(false);
  const [showBro, setShowBro] = useState(false);
  const [showIcon, setShowIcon] = useState(false);
  const [showFinal, setShowFinal] = useState(false);
  const [iconScale, setIconScale] = useState(0.2);
  
  // Use refs to track and clear timeouts to prevent memory leaks
  const timersRef = useRef<{ [key: string]: number }>({});
  
  // Handle sound effects
  useEffect(() => {
    if (showIntro) {
      // Try to play the YO sound at the start
      try {
        console.log('info: Animation sequence started');
        soundManager.play('yo-sound', 0.7); // Fix: Pass volume as a number instead of an object
      } catch (error) {
        console.error('Failed to play sound:', error);
      }
    }
  }, [showIntro]);
  
  // Memoized function to skip animation
  const skipAnimation = useCallback(() => {
    console.log('info: Cleaning up timers');
    
    // Clean up all pending timers
    Object.values(timersRef.current).forEach(id => {
      window.clearTimeout(id);
      cancelAnimationFrame(id);
    });
    
    // Reset states
    setShowYo(false);
    setShowBro(false);
    setShowIcon(false);
    setShowFinal(false);
    setShowIntro(false);
  }, []);
  
  useEffect(() => {
    if (showIntro) {
      // Show YO first
      console.log('info: Showing YO');
      timersRef.current.yoTimer = window.setTimeout(() => {
        setShowYo(true);
        
        // Then transition to BRO
        timersRef.current.broTimer = window.setTimeout(() => {
          console.log('info: Showing BRO');
          setShowYo(false);
          setShowBro(true);
          
          // Transition to icon animation
          timersRef.current.iconTimer = window.setTimeout(() => {
            console.log('info: Showing logo');
            setShowBro(false);
            setShowIcon(true);
            
            // Scale up the icon with requestAnimationFrame for better performance
            let scale = 0.2;
            let lastTimestamp = 0;
            
            const animateScale = (timestamp: number) => {
              if (!lastTimestamp) lastTimestamp = timestamp;
              const delta = timestamp - lastTimestamp;
              
              // Adjust for consistent speed regardless of framerate
              if (delta > 16) { // targeting ~60fps
                scale += 0.008 * (delta / 16);
                setIconScale(scale);
                lastTimestamp = timestamp;
                
                // Stop scaling when large enough
                if (scale >= 2) {
                  // Show final branding screen after icon animation
                  timersRef.current.finalTimer = window.setTimeout(() => {
                    setShowIcon(false);
                    setShowFinal(true);
                    
                    // Auto-complete after holding final screen
                    timersRef.current.completeTimer = window.setTimeout(() => {
                      setShowFinal(false);
                      skipAnimation();
                    }, 3000); // Hold final screen for 3 seconds
                  }, 500);
                  return;
                }
              }
              
              // Continue animation
              timersRef.current.animationFrame = requestAnimationFrame(animateScale);
            };
            
            timersRef.current.animationFrame = requestAnimationFrame(animateScale);
          }, 2000);
        }, 1000);
      }, 500);
    }
    
    // Cleanup all timers and animation frames on unmount
    return () => {
      skipAnimation();
    };
  }, [showIntro, skipAnimation]);
  
  return {
    showIntro,
    setShowIntro,
    skipAnimation,
    showYo,
    showBro,
    showIcon,
    showFinal,
    iconScale
  };
};
