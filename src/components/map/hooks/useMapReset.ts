
import { useCallback } from "react";
import mapboxgl from "mapbox-gl";

/**
 * Creates the resetMap callback for cleaning up mapbox instances.
 */
export const useMapReset = (
  map: mapboxgl.Map | null,
  setMap: (map: mapboxgl.Map | null) => void,
  setMapLoaded: (loaded: boolean) => void,
  setInitializationError: (error: string | null) => void,
  initializationTimeoutRef: React.MutableRefObject<number | null>
) => {
  return useCallback(() => {
    if (map) {
      map.off("error", undefined as any);
      map.off("load", undefined as any);
      map.off("style.load", undefined as any);
      map.off("sourcedata", undefined as any);
      map.remove();
    }
    setMap(null);
    setMapLoaded(false);
    setInitializationError(null);
    if (initializationTimeoutRef.current) {
      window.clearTimeout(initializationTimeoutRef.current);
      initializationTimeoutRef.current = null;
    }
  }, [map, setMap, setMapLoaded, setInitializationError, initializationTimeoutRef]);
};
