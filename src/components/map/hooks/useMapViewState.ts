
import { useState, useEffect, useCallback } from 'react';
import { useMapLocation } from '@/hooks/useMapLocation';
import { useMapState } from './useMapState';
import { useMapboxToken } from './useMapboxToken';
import { toast } from '@/hooks/use-toast';

export const useMapViewState = () => {
  const {
    userLocation,
    selectedLocation,
    locationError,
    onLocationUpdate,
    getUserLocation
  } = useMapLocation();
  
  const mapState = useMapState();
  const { token, isTokenValid, handleTokenSubmit, handleSkip } = useMapboxToken();
  
  const [locationAccuracy, setLocationAccuracy] = useState<number | null>(null);
  const [isLocating, setIsLocating] = useState(false);
  const [showTokenInput, setShowTokenInput] = useState(false);
  const [showAgeVerification, setShowAgeVerification] = useState(false);
  const [hasMapError, setHasMapError] = useState(false);
  const [mapLoaded, setMapLoaded] = useState(false);
  
  // Check age verification
  useEffect(() => {
    const ageVerified = localStorage.getItem('ageVerified');
    if (!ageVerified) {
      setShowAgeVerification(true);
    } else {
      setShowAgeVerification(false);
      
      console.log("Age verified, attempting to get user location...");
      try {
        getUserLocation();
      } catch (error) {
        console.error("Error getting location:", error);
        toast({
          title: "Location Notice",
          description: "Using default location instead."
        });
      }
    }
  }, [getUserLocation]);
  
  useEffect(() => {
    if (locationError) {
      console.log("Location error:", locationError);
      toast({
        title: "Location Notice",
        description: locationError,
      });
    }
  }, [locationError]);
  
  const handleAgeVerified = useCallback(() => {
    localStorage.setItem('ageVerified', 'true');
    setShowAgeVerification(false);
    getUserLocation();
  }, [getUserLocation]);
  
  const handleAgeVerificationCancelled = useCallback(() => {
    window.history.back();
  }, []);
  
  const handleMapError = useCallback(() => {
    console.log("Map error occurred");
    setHasMapError(true);
    toast({
      title: "Map Error",
      description: "There was an error loading the map. Please try reloading the page.",
      variant: "destructive",
    });
  }, []);
  
  const handleMapInitialized = useCallback((map: mapboxgl.Map) => {
    console.log("Map initialized successfully");
    setHasMapError(false);
    setMapLoaded(true);
    
    toast({
      title: "Map Loaded",
      description: "Map has been successfully loaded",
      variant: "default",
    });
  }, []);

  return {
    // Map state
    userLocation,
    selectedLocation,
    locationError,
    locationAccuracy,
    setLocationAccuracy,
    isLocating,
    setIsLocating,
    mapState,
    
    // Dialog state
    showTokenInput,
    setShowTokenInput,
    showAgeVerification,
    
    // Map status
    hasMapError,
    mapLoaded,
    
    // Handlers
    handleAgeVerified,
    handleAgeVerificationCancelled,
    handleMapError,
    handleMapInitialized,
    handleTokenSubmit,
    handleSkip
  };
};
