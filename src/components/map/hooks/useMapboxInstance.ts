
import { useState, useEffect } from "react";
import mapboxgl from "mapbox-gl";
import { useMapboxContainer } from "./useMapboxContainer";
import { useMapboxRefsAndError } from "./useMapboxRefsAndError";
import { useMapReset } from "./useMapReset";
import { useInitialCenterZoom } from "./useInitialCenterZoom";
import { useMapboxEffect } from "./useMapboxEffect";
import { useMapCenterUpdater } from "./useMapCenterUpdater";
import { useMapCleanup } from "./useMapCleanup";
import { useMapCleanupEffect } from "./useMapCleanupEffect";

interface UseMapboxInstanceProps {
  token: string | null;
  userLocation: { lat: number; lng: number; zoom?: number } | null;
  selectedLocation: { lat: number; lng: number; zoom?: number } | null;
  is3DMode?: boolean;
  onMapInitialized?: (map: mapboxgl.Map) => void;
  mapStyle?: string;
  forceRedraw?: number; // Add this parameter
}

export const useMapboxInstance = ({
  token,
  userLocation,
  selectedLocation,
  is3DMode = false,
  onMapInitialized,
  mapStyle = "mapbox://styles/mapbox/dark-v11",
  forceRedraw = 0, // Default to 0
}: UseMapboxInstanceProps) => {
  const mapContainerRef = useMapboxContainer();
  const [map, setMap] = useState<mapboxgl.Map | null>(null);
  const [mapLoaded, setMapLoaded] = useState(false);

  // Custom refs/error state hook
  const {
    previousTokenRef,
    initializationTimeoutRef,
    initializationError,
    setInitializationError,
  } = useMapboxRefsAndError();

  // Force reset map when forceRedraw changes
  useEffect(() => {
    if (forceRedraw > 0) {
      resetMap();
    }
  }, [forceRedraw]); // eslint-disable-line react-hooks/exhaustive-deps

  // Composable map reset
  const resetMap = useMapReset(
    map,
    setMap,
    setMapLoaded,
    setInitializationError,
    initializationTimeoutRef
  );

  // Calculate center/zoom
  const { getInitialCenter, getInitialZoom } = useInitialCenterZoom(
    userLocation,
    selectedLocation
  );

  // Mapbox map effect (init, error, controls, style, etc)
  useMapboxEffect({
    token,
    mapContainerRef,
    getInitialCenter,
    getInitialZoom,
    is3DMode,
    mapStyle,
    onMapInitialized,
    resetMap,
    setMap,
    setMapLoaded,
    setInitializationError,
    initializationTimeoutRef,
    previousTokenRef,
  });

  // Update map center when userLocation or selectedLocation changes
  useMapCenterUpdater(map, mapLoaded, selectedLocation, userLocation);

  // Cleanup on unmount
  const cleanupMap = useMapCleanup();
  useMapCleanupEffect(map, cleanupMap);

  return {
    mapContainerRef,
    map,
    mapLoaded,
    initializationError,
    resetMap,
  };
};
