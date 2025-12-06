import { useEffect } from 'react';
import soundManager from '@/utils/soundManager';

export const useSoundEffect = (isActive: boolean) => {
  useEffect(() => {
    if (isActive) {
      try {
        // This is now handled in the main useIntroAnimation hook
        // Just keeping this hook for compatibility
      } catch (error) {
        console.error('Error playing sound:', error);
      }
    }
    
    return () => {
      // Cleanup function if needed
    };
  }, [isActive]);
};
