
import { useState, useEffect, useCallback, useRef } from 'react';
import { toast } from '@/hooks/use-toast';

interface Location {
  lat: number;
  lng: number;
  zoom?: number;
}

/**
 * Hook to handle map location functionality with improved performance
 */
export const useMapLocation = () => {
  const [userLocation, setUserLocation] = useState<Location | null>(null);
  const [selectedLocation, setSelectedLocation] = useState<Location | null>(null);
  const [locationError, setLocationError] = useState<string | null>(null);
  const [requestInProgress, setRequestInProgress] = useState(false);
  
  // Default location if GPS fails - San Francisco
  const defaultLocation: Location = { lat: 37.7749, lng: -122.4194, zoom: 12 };
  
  // Use refs to avoid duplicate location requests
  const timeoutIdRef = useRef<number | null>(null);
  const watchIdRef = useRef<number | null>(null);

  // Get user's location with improved error handling and caching
  const getUserLocation = useCallback(() => {
    // Don't make duplicate requests
    if (requestInProgress) return;
    
    if (!navigator.geolocation) {
      setLocationError("Geolocation is not supported by your browser");
      setSelectedLocation(defaultLocation);
      return;
    }
    
    setRequestInProgress(true);
    
    // Use cached location if available and recent
    const cachedLocation = localStorage.getItem('userLocationCache');
    const cachedTimestamp = localStorage.getItem('userLocationTimestamp');
    
    if (cachedLocation && cachedTimestamp) {
      const location = JSON.parse(cachedLocation);
      const timestamp = parseInt(cachedTimestamp, 10);
      const now = Date.now();
      
      // Use cached location if less than 5 minutes old
      if (now - timestamp < 5 * 60 * 1000) {
        setUserLocation(location);
        setSelectedLocation(location);
        setRequestInProgress(false);
        
        // Still get a fresh location in the background
        navigator.geolocation.getCurrentPosition(
          handlePositionSuccess,
          handlePositionError,
          { enableHighAccuracy: false, timeout: 10000, maximumAge: 60000 }
        );
        
        return;
      }
    }
    
    // Set timeout for geolocation request
    timeoutIdRef.current = window.setTimeout(() => {
      setLocationError("Location request timed out");
      setSelectedLocation(defaultLocation);
      setRequestInProgress(false);
    }, 10000); // 10 second timeout
    
    navigator.geolocation.getCurrentPosition(
      handlePositionSuccess,
      handlePositionError,
      {
        enableHighAccuracy: true,
        timeout: 10000,
        maximumAge: 60000 // Accept cached positions up to 1 minute old
      }
    );
  }, [requestInProgress]);
  
  // Extracted success handler for reuse
  const handlePositionSuccess = useCallback((position: GeolocationPosition) => {
    if (timeoutIdRef.current) clearTimeout(timeoutIdRef.current);
    
    const newLocation = {
      lat: position.coords.latitude,
      lng: position.coords.longitude,
      zoom: 14
    };
    
    // Cache the location
    localStorage.setItem('userLocationCache', JSON.stringify(newLocation));
    localStorage.setItem('userLocationTimestamp', Date.now().toString());
    
    setUserLocation(newLocation);
    setSelectedLocation(newLocation);
    setLocationError(null);
    setRequestInProgress(false);
  }, []);
  
  // Extracted error handler for reuse
  const handlePositionError = useCallback((error: GeolocationPositionError) => {
    if (timeoutIdRef.current) clearTimeout(timeoutIdRef.current);
    
    console.error("Error getting location:", error);
    setLocationError("Unable to retrieve your location");
    setSelectedLocation(defaultLocation); // Fall back to default location
    setRequestInProgress(false);
    
    // More user friendly error messages
    let errorMessage = "We couldn't access your location.";
    switch (error.code) {
      case 1:
        errorMessage += " Please enable location services in your settings.";
        break;
      case 2:
        errorMessage += " Your position is currently unavailable.";
        break;
      case 3:
        errorMessage += " The request timed out.";
        break;
    }
    
    toast({
      title: "Location Error",
      description: errorMessage,
      variant: "destructive"
    });
  }, [defaultLocation]);

  // Handle location updates with memoization to avoid unnecessary re-renders
  const onLocationUpdate = useCallback((location: Location) => {
    setUserLocation(location);
    setSelectedLocation(location);
  }, []);
  
  // Clean up any open timeouts or watchers on unmount
  useEffect(() => {
    return () => {
      if (timeoutIdRef.current) clearTimeout(timeoutIdRef.current);
      if (watchIdRef.current) navigator.geolocation.clearWatch(watchIdRef.current);
    };
  }, []);

  return {
    userLocation,
    selectedLocation,
    locationError,
    onLocationUpdate,
    getUserLocation
  };
};
