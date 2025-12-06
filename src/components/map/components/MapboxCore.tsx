
import React, { useRef, useState } from 'react';
import 'mapbox-gl/dist/mapbox-gl.css';
import { useMapboxInitialization } from '../hooks/useMapboxInitialization';
import { MapControls } from './controls/MapControls';

interface MapboxCoreProps {
  token: string;
  userLocation: { lat: number; lng: number; zoom?: number } | null;
  selectedLocation: { lat: number; lng: number; zoom?: number } | null;
  is3DMode?: boolean;
  onError?: (error: string) => void;
}

const MapboxCore: React.FC<MapboxCoreProps> = ({
  token,
  userLocation,
  selectedLocation,
  is3DMode = false,
  onError
}) => {
  // UI state
  const [showSettings, setShowSettings] = useState(false);
  const [blurImages, setBlurImages] = useState(true);
  
  // Map container ref
  const mapContainer = useRef<HTMLDivElement>(null);
  const map = useRef<mapboxgl.Map | null>(null);
  
  // Initialize map using our custom hook
  const { mapLoaded, mapError } = useMapboxInitialization({
    onMapInitialized: (newMap) => {
      map.current = newMap;
    },
    onMapError: onError, // Pass the onError prop to the initialization hook
    initialCenter: [
      selectedLocation?.lng || userLocation?.lng || -73.9857,
      selectedLocation?.lat || userLocation?.lat || 40.7484
    ],
    initialZoom: selectedLocation?.zoom || userLocation?.zoom || 12,
    is3DMode
  });

  // Initialize map when component mounts
  React.useEffect(() => {
    if (!mapContainer.current || !token) {
      console.log("Cannot initialize map: missing container or token");
      return;
    }
    
    if (map.current) {
      console.log("Map already initialized, skipping");
      return;
    }

    const initMap = () => {
      if (!mapContainer.current) return;
      const initResult = useMapboxInitialization({
        onMapInitialized: (newMap) => {
          map.current = newMap;
        },
        onMapError: onError, // Pass the onError prop to the initialization hook
      }).initializeMap(token, mapContainer.current);
      
      map.current = initResult;
    };

    initMap();
    
    return () => {
      if (map.current) {
        map.current.remove();
        map.current = null;
      }
    };
  }, [token, onError]);

  return (
    <div className="relative h-screen w-full bg-black">
      <div ref={mapContainer} className="absolute inset-0" />
      
      {/* Loading state */}
      {!mapLoaded && !mapError && (
        <div className="absolute inset-0 flex items-center justify-center bg-black/80 z-10">
          <div className="text-center">
            <div className="w-16 h-16 border-4 border-t-transparent border-[#00FFC4] rounded-full animate-spin mx-auto mb-4"></div>
            <p className="text-[#00FFC4] font-medium">Initializing map...</p>
          </div>
        </div>
      )}
      
      {/* Error state */}
      {mapError && (
        <div className="absolute inset-0 flex items-center justify-center bg-black/80 z-10 p-4">
          <div className="max-w-md bg-black/90 border border-red-500/30 rounded-lg p-6 text-center">
            <div className="text-red-500 text-5xl mb-4">⚠️</div>
            <h3 className="text-red-500 text-xl font-semibold mb-2">Map Error</h3>
            <p className="text-white/80 mb-4">{mapError}</p>
          </div>
        </div>
      )}
      
      {/* Map controls */}
      {mapLoaded && (
        <MapControls
          showSettings={showSettings}
          blurImages={blurImages}
          onSettingsClick={() => setShowSettings(true)}
          onBlurToggle={() => setBlurImages(!blurImages)}
        />
      )}
    </div>
  );
};

export default MapboxCore;
