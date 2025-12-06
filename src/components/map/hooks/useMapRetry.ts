
import { useState, useRef, useCallback } from 'react';
import { toast } from '@/hooks/use-toast';
import { useMapStore } from '../stores/useMapStore';

export function useMapRetry({ resetMap, resetToDefaultToken, setHasInitialized, setShowTokenPrompt }: any) {
  const [retryAttempts, setRetryAttempts] = useState(0);
  const [forceRedraw, setForceRedraw] = useState(0);
  const initTimeoutRef = useRef<number | null>(null);
  const { resetRetry } = useMapStore();

  const handleReload = useCallback(() => {
    setRetryAttempts((prev: number) => {
      const newCount = prev + 1;
      
      if (newCount === 1) {
        resetMap();
        setForceRedraw((prev: number) => prev + 1);
        toast({
          title: "Reloading Map",
          description: "Attempting to reload the map..."
        });
      }
      else if (newCount === 2) {
        resetToDefaultToken();
        resetMap();
        setForceRedraw((prev: number) => prev + 1);
        toast({
          title: "Trying Different Token",
          description: "Attempting to use an alternate Mapbox token..."
        });
      }
      else {
        toast({
          title: "Refreshing Map Data",
          description: "Clearing cached data and reinitializing map..."
        });

        localStorage.removeItem('mapbox-cache');
        resetToDefaultToken();
        resetMap();
        setHasInitialized(false);
        setForceRedraw((prev: number) => prev + 1);
        resetRetry();

        setTimeout(() => {
          window.dispatchEvent(new Event('resize'));
          setShowTokenPrompt(true);
        }, 1000);
        
        // Reset retry counter after full reset
        return 0;
      }
      
      return newCount;
    });
  }, [resetMap, resetToDefaultToken, setHasInitialized, setForceRedraw, setShowTokenPrompt, resetRetry]);

  return {
    retryAttempts,
    setRetryAttempts,
    forceRedraw,
    setForceRedraw,
    handleReload,
    initTimeoutRef
  }
}
