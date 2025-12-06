
import React, { useState, useEffect, MutableRefObject } from 'react';
import MapboxCore from './MapboxCore';
import { toast } from '@/hooks/use-toast';
import { MapErrorOverlay } from './error/MapErrorOverlay';
import mapboxgl from 'mapbox-gl';
import { Location, User, Venue } from '../types/markerTypes';

interface MapboxMapContainerProps {
  mapContainerRef?: MutableRefObject<HTMLDivElement>;
  map?: mapboxgl.Map;
  mapLoaded?: boolean;
  filteredUsers?: User[];
  filteredVenues?: Venue[];
  clusterMarkers?: any[];
  onUserClick?: (user: User) => void;
  onVenueClick?: (venue: Venue) => void;
  blurUserImages?: boolean;
  showTokenPrompt?: boolean;
  showInit?: boolean;
  initializationError?: string | null;
  retryAttempts?: number;
  handleReload?: () => void;
  getErrorMessage?: () => string;
  loadDuration?: number;
  isDataLoaded?: boolean;
  MapboxTokenInput?: any;
  handleTokenSubmit?: (token: string) => void;
  handleSkip?: () => void;
  userLocation?: { lat: number; lng: number; zoom?: number } | null;
  selectedLocation?: { lat: number; lng: number; zoom?: number } | null;
  is3DMode?: boolean;
  filters?: any;
  onError?: (error: string) => void;
  token?: string;
}

const MapboxMapContainer: React.FC<MapboxMapContainerProps> = ({
  mapContainerRef,
  map,
  mapLoaded,
  filteredUsers,
  filteredVenues,
  clusterMarkers,
  onUserClick,
  onVenueClick,
  blurUserImages,
  showTokenPrompt,
  showInit,
  initializationError,
  retryAttempts,
  handleReload,
  getErrorMessage,
  loadDuration,
  isDataLoaded,
  MapboxTokenInput,
  handleTokenSubmit,
  handleSkip,
  userLocation,
  selectedLocation,
  is3DMode = false,
  filters,
  onError,
  token
}) => {
  const [error, setError] = useState<string | null>(null);
  const [retryCount, setRetryCount] = useState(0);
  
  // Handle map errors
  const handleMapError = (errorMessage: string) => {
    setError(errorMessage);
    
    if (onError) {
      onError(errorMessage);
    }
    
    // Show toast with error
    toast({
      title: "Map Error",
      description: "There was an error loading the map",
      variant: "destructive"
    });
  };
  
  // Function to retry loading the map
  const handleRetry = () => {
    setError(null);
    setRetryCount(prev => prev + 1);
    
    toast({
      title: "Retrying",
      description: "Attempting to reload the map...",
      variant: "default"
    });
  };
  
  // If location not available, try to get it
  useEffect(() => {
    if (!userLocation && !selectedLocation) {
      // If both locations are null, default to NYC
      console.log("No location data available, defaulting to New York City");
    }
  }, [userLocation, selectedLocation]);
  
  // If there's an error, show error overlay
  if (error) {
    return (
      <MapErrorOverlay 
        error={error}
        onRetry={handleRetry}
      />
    );
  }

  // Only pass token when it's valid (not undefined, null or empty string)
  const isValidToken = token && token.trim().length > 0;
  
  if (isValidToken) {
    return (
      <MapboxCore
        token={token}
        userLocation={userLocation}
        selectedLocation={selectedLocation}
        is3DMode={is3DMode}
        onError={handleMapError}
      />
    );
  }
  
  // If no token is available and we have a token input component, show it
  if (MapboxTokenInput && showTokenPrompt && handleTokenSubmit) {
    return (
      <MapboxTokenInput
        onSubmit={handleTokenSubmit}
        onSkip={handleSkip}
        open={true}
      />
    );
  }
  
  // Fallback error state when no token and no input component
  return (
    <MapErrorOverlay 
      error="No Mapbox token available. Please provide a valid token."
      onRetry={handleRetry}
    />
  );
};

export default MapboxMapContainer;
