import React, { useEffect, useState, useRef } from 'react';
import MapboxMapContainer from './MapboxMapContainer';
import { MapboxTokenInput } from './index';
import { useMapboxToken } from '../hooks/useMapboxToken';
import { useMapboxInstance } from '../hooks/useMapboxInstance';
import { useTokenPrompt } from '../hooks/useTokenPrompt';
import { useMapRetry } from '../hooks/useMapRetry';
import { useMapStore } from '../stores/useMapStore';
import { toast } from '@/hooks/use-toast';
import { Venue } from '../types/markerTypes';

interface Props {
  userLocation: { lat: number; lng: number; zoom?: number } | null;
  selectedLocation: { lat: number; lng: number; zoom?: number } | null;
  onUserClick?: (user: any) => void;
  onVenueClick?: (venue: any) => void;
  showHeatMap?: boolean;
  hideUserLocation?: boolean;
  is3DMode?: boolean;
  filters?: any;
  blurUserImages?: boolean;
  onMapInitialized?: (map: mapboxgl.Map) => void;
}

const MapboxMap: React.FC<Props> = ({
  userLocation,
  selectedLocation,
  onUserClick = () => {},
  onVenueClick = () => {},
  showHeatMap = false,
  hideUserLocation = false,
  is3DMode = false,
  filters = {},
  blurUserImages = false,
  onMapInitialized
}) => {
  const [isDataLoaded, setIsDataLoaded] = useState(false);
  const [showInit, setShowInit] = useState(true);
  const [mapFullyReady, setMapFullyReady] = useState(false);
  const startTimeRef = useRef(Date.now());
  const [loadDuration, setLoadDuration] = useState(0);
  const { setStatus } = useMapStore();
  const readyCheckIntervalRef = useRef<number | null>(null);

  const { token, handleTokenSubmit: updateToken, resetToDefaultToken } = useMapboxToken();
  const { hasInitialized, setHasInitialized, showTokenPrompt, setShowTokenPrompt } = useTokenPrompt(token);
  
  console.log("Current token:", token ? `${token.substring(0, 10)}...` : "No token available");
  
  const {
    mapContainerRef,
    map,
    mapLoaded,
    initializationError,
    resetMap
  } = useMapboxInstance({
    token,
    userLocation,
    selectedLocation,
    is3DMode,
    onMapInitialized,
    forceRedraw: 0
  });

  const {
    retryAttempts,
    forceRedraw,
    handleReload,
    initTimeoutRef
  } = useMapRetry({
    resetMap, 
    resetToDefaultToken,
    setHasInitialized,
    setShowTokenPrompt
  });

  useEffect(() => {
    if (initializationError) {
      setStatus('error');
    } else if (!mapLoaded) {
      setStatus('loading');
    } else {
      setStatus('loaded');
    }
  }, [mapLoaded, initializationError, setStatus]);

  useEffect(() => {
    if (mapLoaded && map) {
      if (readyCheckIntervalRef.current) {
        window.clearInterval(readyCheckIntervalRef.current);
      }
      
      const checkMapReady = () => {
        try {
          if (map && map.loaded() && map.getCanvas() && map.getCanvasContainer()) {
            console.log('Map is fully ready for markers');
            setMapFullyReady(true);
            
            if (readyCheckIntervalRef.current) {
              window.clearInterval(readyCheckIntervalRef.current);
              readyCheckIntervalRef.current = null;
            }
            return true;
          }
        } catch (e) {
          console.warn('Map not fully ready yet:', e);
        }
        return false;
      };
      
      if (!checkMapReady()) {
        readyCheckIntervalRef.current = window.setInterval(checkMapReady, 300);
        
        setTimeout(() => {
          if (readyCheckIntervalRef.current) {
            window.clearInterval(readyCheckIntervalRef.current);
            readyCheckIntervalRef.current = null;
            
            if (!mapFullyReady) {
              console.log('Map ready timeout - forcing update');
              setMapFullyReady(true);
            }
          }
        }, 8000);
      }
      
      return () => {
        if (readyCheckIntervalRef.current) {
          window.clearInterval(readyCheckIntervalRef.current);
          readyCheckIntervalRef.current = null;
        }
      };
    }
  }, [mapLoaded, map, mapFullyReady]);

  useEffect(() => {
    if (mapLoaded && mapFullyReady && map) {
      const dataLoadTimeout = setTimeout(() => {
        setIsDataLoaded(true);
        setShowInit(false);
        setStatus('loaded');
        
        console.log('Map and data fully loaded and ready');
        
        if (map) {
          setTimeout(() => {
            try {
              map.resize();
            } catch (e) {
              console.warn('Error resizing map:', e);
            }
          }, 100);
        }
      }, 1500);
      
      return () => clearTimeout(dataLoadTimeout);
    }
  }, [mapLoaded, mapFullyReady, map, setStatus]);
  
  useEffect(() => {
    if (!mapLoaded || showInit) {
      const interval = setInterval(() => {
        setLoadDuration(Math.floor((Date.now() - startTimeRef.current) / 1000));
      }, 1000);
      
      return () => clearInterval(interval);
    }
  }, [mapLoaded, showInit]);
  
  const handleSkip = () => {
    setHasInitialized(true);
    resetToDefaultToken();
    toast({
      title: "Using Default Token",
      description: "Attempting to use the built-in Mapbox token"
    });
  };
  
  const getErrorMessage = () => {
    if (!initializationError) return "Unknown error";
    
    if (initializationError.includes("token") || initializationError.includes("access")) {
      return "Invalid Mapbox token or access denied. Please provide a valid token.";
    }
    
    if (initializationError.includes("style")) {
      return "Map style could not be loaded. Please check your network connection.";
    }
    
    return initializationError;
  };
  
  const filteredUsers = Array(5).fill(null).map((_, i) => ({
    id: `user-${i}`,
    name: `User ${i}`,
    position: {
      lat: userLocation ? userLocation.lat + (Math.random() - 0.5) * 0.01 : 40.7128,
      lng: userLocation ? userLocation.lng + (Math.random() - 0.5) * 0.01 : -74.006
    },
    online: Math.random() > 0.5,
    isNew: Math.random() > 0.8,
    image: "/placeholder.svg"
  }));
  
  const filteredVenues: Venue[] = Array(3).fill(null).map((_, i) => ({
    id: `venue-${i}`,
    name: `Venue ${i}`,
    position: {
      lat: userLocation ? userLocation.lat + (Math.random() - 0.5) * 0.01 : 40.7128,
      lng: userLocation ? userLocation.lng + (Math.random() - 0.5) * 0.01 : -74.006
    },
    type: (['bar', 'club', 'cruise', 'gym', 'other'][i % 5]) as 'bar' | 'club' | 'cruise' | 'gym' | 'other',
    userCount: Math.floor(Math.random() * 20) + 5
  }));
  
  const clusterMarkers = Array(2).fill(null).map((_, i) => ({
    id: `cluster-${i}`,
    count: Math.floor(Math.random() * 10) + 5,
    position: {
      lat: userLocation ? userLocation.lat + (Math.random() - 0.5) * 0.02 : 40.7128,
      lng: userLocation ? userLocation.lng + (Math.random() - 0.5) * 0.02 : -74.006
    },
    points: Array(Math.floor(Math.random() * 10) + 5).fill(null)
  }));

  return (
    <MapboxMapContainer
      token={token}
      mapContainerRef={mapContainerRef}
      map={map}
      mapLoaded={mapLoaded && mapFullyReady}
      filteredUsers={filteredUsers}
      filteredVenues={filteredVenues}
      clusterMarkers={clusterMarkers}
      onUserClick={onUserClick}
      onVenueClick={onVenueClick}
      blurUserImages={blurUserImages}
      showTokenPrompt={showTokenPrompt}
      showInit={showInit}
      initializationError={initializationError}
      retryAttempts={retryAttempts}
      handleReload={handleReload}
      getErrorMessage={getErrorMessage}
      loadDuration={loadDuration}
      isDataLoaded={isDataLoaded}
      MapboxTokenInput={MapboxTokenInput}
      handleTokenSubmit={updateToken}
      handleSkip={handleSkip}
      userLocation={userLocation}
      selectedLocation={selectedLocation}
      is3DMode={is3DMode}
      filters={filters}
    />
  );
};

export default MapboxMap;
