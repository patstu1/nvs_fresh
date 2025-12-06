
import React, { useRef, useEffect } from 'react';
import mapboxgl from 'mapbox-gl';
import 'mapbox-gl/dist/mapbox-gl.css';
import { useMapboxTokenInitializer } from '../hooks/useMapboxTokenInitializer';
import { useMapboxInitialization } from '../hooks/useMapboxInitialization';
import MapboxTokenInput from './MapboxTokenInput';
import { MapLoadingOverlay } from './loading/MapLoadingOverlay';
import { MapErrorOverlay } from './error/MapErrorOverlay';

interface MapboxMapCoreProps {
  initialCenter?: [number, number];
  initialZoom?: number;
  is3DMode?: boolean;
  style?: string;
  children?: React.ReactNode;
  onMapInitialized?: (map: mapboxgl.Map) => void;
  onMapError?: (error: string) => void;
}

const MapboxMapCore: React.FC<MapboxMapCoreProps> = ({
  initialCenter,
  initialZoom,
  is3DMode = false,
  style = 'mapbox://styles/mapbox/dark-v11',
  children,
  onMapInitialized,
  onMapError
}) => {
  const mapContainerRef = useRef<HTMLDivElement>(null);
  const mapRef = useRef<mapboxgl.Map | null>(null);
  
  const { 
    token, 
    isShowingTokenInput, 
    handleUserProvidedToken, 
    handleTokenError,
    hideTokenInput
  } = useMapboxTokenInitializer({
    onTokenReady: (token) => {
      if (!mapRef.current && mapContainerRef.current) {
        console.log(`Attempting to initialize map with token starting with: ${token.substring(0, 10)}...`);
        const map = initializeMap(token, mapContainerRef.current);
        if (map) mapRef.current = map;
      }
    }
  });

  const {
    initializeMap,
    mapLoaded,
    mapError
  } = useMapboxInitialization({
    onMapInitialized,
    onMapError,
    initialCenter,
    initialZoom,
    is3DMode,
    style
  });

  // Update 3D mode
  useEffect(() => {
    if (mapRef.current && mapLoaded) {
      mapRef.current.easeTo({
        pitch: is3DMode ? 45 : 0,
        bearing: is3DMode ? 10 : 0,
        duration: 1000
      });
    }
  }, [is3DMode, mapLoaded]);

  // Cleanup on unmount
  useEffect(() => {
    return () => {
      if (mapRef.current) {
        try {
          mapRef.current.remove();
        } catch (err) {
          console.error("Error removing map:", err);
        }
      }
    };
  }, []);

  // Handle skipping token input
  const handleSkip = () => {
    hideTokenInput();
    const backupToken = 'pk.eyJ1IjoiZXhhbXBsZXMiLCJhIjoiY2p0MG01OGF0MDBvdTQzanRzNmlmZTJtaiJ9.SEZOFObuwz-L0IziU4DIvg';
    console.log("Using backup token for Mapbox");
    if (mapContainerRef.current) {
      const map = initializeMap(backupToken, mapContainerRef.current);
      if (map) mapRef.current = map;
    }
  };

  return (
    <div className="relative w-full h-full bg-black">
      <div ref={mapContainerRef} className="absolute inset-0" />
      
      {mapError && (
        <MapErrorOverlay 
          error={mapError} 
          onRetry={() => {
            if (token && mapContainerRef.current) {
              console.log("Retrying map initialization...");
              const map = initializeMap(token, mapContainerRef.current);
              if (map) mapRef.current = map;
            }
          }}
        />
      )}
      
      {!mapLoaded && !mapError && <MapLoadingOverlay />}
      
      {isShowingTokenInput && (
        <MapboxTokenInput 
          onSubmit={handleUserProvidedToken}
          onSkip={handleSkip}
          open={isShowingTokenInput}
        />
      )}
      
      {mapLoaded && mapRef.current && React.Children.map(children, child => {
        if (React.isValidElement(child)) {
          return React.createElement(child.type, {
            ...child.props,
            map: mapRef.current
          });
        }
        return child;
      })}
    </div>
  );
};

export default MapboxMapCore;
