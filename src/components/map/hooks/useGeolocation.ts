
import { useCallback } from 'react';
import { toast } from '@/hooks/use-toast';

/**
 * Custom hook to handle geolocation functionality
 */
export const useGeolocation = () => {
  /**
   * Get the user's current position
   */
  const getCurrentPosition = useCallback(
    (
      onSuccess: (position: GeolocationPosition) => void,
      onError: (error: GeolocationPositionError) => void
    ) => {
      if (!navigator.geolocation) {
        onError({
          code: 0,
          message: "Geolocation is not supported by your browser",
          PERMISSION_DENIED: 1,
          POSITION_UNAVAILABLE: 2,
          TIMEOUT: 3
        });
        return;
      }

      navigator.geolocation.getCurrentPosition(
        onSuccess,
        onError,
        {
          enableHighAccuracy: true,
          timeout: 10000,
          maximumAge: 5000
        }
      );
    },
    []
  );

  /**
   * Handle geolocation errors
   */
  const handleGeolocationError = useCallback((error: GeolocationPositionError, setLocationError: (error: string | null) => void) => {
    console.error("Error getting location:", error);
    
    let errorMessage = "";
    switch (error.code) {
      case error.PERMISSION_DENIED:
        errorMessage = "Location permission denied";
        break;
      case error.POSITION_UNAVAILABLE:
        errorMessage = "Location information unavailable";
        break;
      case error.TIMEOUT:
        errorMessage = "Location request timed out";
        break;
      default:
        errorMessage = error.message;
    }
    
    setLocationError(errorMessage);
    
    toast({
      title: "Location Error",
      description: errorMessage,
      variant: "destructive"
    });
  }, []);

  return {
    getCurrentPosition,
    handleGeolocationError
  };
};

// Define the GeolocationPosition type
export interface GeolocationPosition {
  coords: {
    latitude: number;
    longitude: number;
    accuracy: number;
  };
}
