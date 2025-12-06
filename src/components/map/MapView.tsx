
import React, { useState, useEffect } from 'react';
import { Skeleton } from '@/components/ui/skeleton';
import ErrorBoundary from '@/components/ErrorBoundary';
import { MapErrorOverlay } from './components/error/MapErrorOverlay';
import { useMapboxToken } from './hooks/useMapboxToken';
import { Button } from '@/components/ui/button';
import MapboxMapContainer from './components/MapboxMapContainer';
import { useMapLocation } from '@/hooks/useMapLocation';
import { useMapState } from './hooks/useMapState';
import { toast } from '@/hooks/use-toast';
import MapTokenInput from './components/MapTokenInput';
import { Compass } from 'lucide-react';

// Modern MapView component with improved initialization and error handling
const MapView = () => {
  const [isLoading, setIsLoading] = useState(true);
  const [mapError, setMapError] = useState<string | null>(null);
  const [mapInitialized, setMapInitialized] = useState(false);
  const { token, setToken, isTokenValid, handleTokenSubmit } = useMapboxToken();
  const { userLocation, selectedLocation, getUserLocation } = useMapLocation();
  const mapState = useMapState();
  const [showTokenInput, setShowTokenInput] = useState(false);
  const [tokenRetryCount, setTokenRetryCount] = useState(0);
  
  // Initialize map when component mounts
  useEffect(() => {
    const initMap = async () => {
      try {
        // Check for stored token first
        const storedToken = localStorage.getItem('mapbox_token');
        if (storedToken) {
          console.log("Found stored Mapbox token, initializing map");
          setToken(storedToken);
          setMapInitialized(true);
        } else {
          // Show token input if no token found
          console.log("No Mapbox token found, showing token input");
          setShowTokenInput(true);
        }
      } catch (error) {
        console.error("Map initialization error:", error);
        setMapError("Failed to initialize map. Please try again.");
      } finally {
        setIsLoading(false);
      }
    };
    
    initMap();
    getUserLocation();
  }, [setToken, getUserLocation]);
  
  // Handle token submission
  const handleTokenInputSubmit = (inputToken: string) => {
    try {
      // Basic validation
      if (!inputToken.trim()) {
        toast({
          title: "Invalid Token",
          description: "Please provide a valid Mapbox token",
          variant: "destructive"
        });
        return;
      }
      
      // Save token
      localStorage.setItem('mapbox_token', inputToken);
      setToken(inputToken);
      setShowTokenInput(false);
      setMapInitialized(true);
      
      console.log("Map token saved:", inputToken.substring(0, 5) + "...");
      
      toast({
        title: "Success",
        description: "Map token saved successfully",
        variant: "default"
      });
    } catch (error) {
      console.error("Error saving token:", error);
      setMapError("Failed to save map token. Please try again.");
    }
  };
  
  // Handle skipping token input
  const handleSkipTokenInput = () => {
    setShowTokenInput(false);
    setMapInitialized(true);
    toast({
      title: "Map Limited",
      description: "Using map without a token. Some features may be limited.",
      variant: "default"
    });
  };
  
  // Handle map errors
  const handleMapError = (error: string) => {
    console.error("Map error received:", error);
    
    // Check if it's a token error
    if (error.toLowerCase().includes('token') || error.toLowerCase().includes('unauthorized') || error.toLowerCase().includes('access')) {
      setTokenRetryCount(prev => prev + 1);
      
      // After a few retries with the same token, show token input again
      if (tokenRetryCount >= 2) {
        setMapInitialized(false);
        setShowTokenInput(true);
        localStorage.removeItem('mapbox_token'); // Clear invalid token
        
        toast({
          title: "Token Error",
          description: "Your Mapbox token appears to be invalid. Please provide a valid token.",
          variant: "destructive"
        });
      }
    }
    
    setMapError(error);
  };
  
  // If still loading, show skeleton
  if (isLoading) {
    return (
      <div className="w-full h-screen bg-black flex items-center justify-center">
        <div className="space-y-4 w-full max-w-md p-4">
          <Compass className="w-16 h-16 text-[#00FFC4] mx-auto animate-pulse" />
          <Skeleton className="h-[300px] w-full bg-gray-800" />
          <div className="text-center">
            <p className="text-[#00FFC4] text-lg">Initializing map...</p>
          </div>
        </div>
      </div>
    );
  }

  // If there's an error and token input is not shown
  if (mapError && !showTokenInput) {
    return (
      <MapErrorOverlay 
        error={mapError}
        onRetry={() => setShowTokenInput(true)}
      />
    );
  }

  return (
    <ErrorBoundary
      fallback={
        <div className="w-full h-screen bg-black flex items-center justify-center">
          <div className="bg-black/90 border border-red-500/50 rounded-lg p-6 max-w-md text-center">
            <div className="text-red-500 text-5xl mb-4">⚠️</div>
            <h3 className="text-red-500 text-xl font-semibold mb-2">Map Error</h3>
            <p className="text-white/80 mb-4">An unexpected error occurred while loading the map</p>
            <Button 
              onClick={() => window.location.reload()}
              variant="destructive"
            >
              Reload Page
            </Button>
          </div>
        </div>
      }
    >
      <div className="relative w-full h-screen bg-black">
        {/* Show token input dialog if needed */}
        <MapTokenInput
          open={showTokenInput}
          onSubmit={handleTokenInputSubmit}
          onSkip={handleSkipTokenInput}
          initialToken={token || ''}
        />
        
        {/* Main map container */}
        {mapInitialized && (
          <MapboxMapContainer
            token={token}
            userLocation={userLocation}
            selectedLocation={selectedLocation}
            is3DMode={mapState.is3DMode}
            filters={mapState.profileFilters}
            onError={handleMapError}
          />
        )}
      </div>
    </ErrorBoundary>
  );
};

export default MapView;
