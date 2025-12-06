
import { useEffect } from "react";
import mapboxgl from "mapbox-gl";
import { setupHolographicEffects } from "../utils/holographic/mapEffects";
import { toast } from "@/hooks/use-toast";
import { useMapStore } from "../stores/useMapStore";

interface Props {
  token: string | null;
  mapContainerRef: React.RefObject<HTMLDivElement>;
  getInitialCenter: () => [number, number];
  getInitialZoom: () => number;
  is3DMode: boolean;
  mapStyle: string;
  onMapInitialized?: (map: mapboxgl.Map) => void;
  resetMap: () => void;
  setMap: (m: mapboxgl.Map | null) => void;
  setMapLoaded: (b: boolean) => void;
  setInitializationError: (msg: string | null) => void;
  initializationTimeoutRef: React.MutableRefObject<number | null>;
  previousTokenRef: React.MutableRefObject<string | null>;
}

export const useMapboxEffect = ({
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
}: Props) => {
  const { setError } = useMapStore();
  
  useEffect(() => {
    if (!token || !mapContainerRef.current) return;
    
    // Skip re-initialization if the token hasn't changed
    if (previousTokenRef.current === token) return;

    // Store the new token for future comparison
    previousTokenRef.current = token;
    
    // Clean up any existing map
    resetMap();

    try {
      console.log("Initializing map with token:", token.substring(0, 8) + "...");
      
      // Check if token is a secret token and warn
      if (token.startsWith('sk.')) {
        const errMsg = "Secret tokens (sk.*) cannot be used in browser applications. Please use a public token that starts with 'pk.'";
        console.error(errMsg);
        setInitializationError(errMsg);
        setError(errMsg);
        return;
      }
      
      // Configure mapbox with the token
      mapboxgl.accessToken = token;

      const initialCenter = getInitialCenter();
      const initialZoom = getInitialZoom();

      // Create new map instance with optimized settings
      const newMap = new mapboxgl.Map({
        container: mapContainerRef.current,
        style: mapStyle,
        center: initialCenter,
        zoom: initialZoom,
        pitch: is3DMode ? 45 : 0,
        bearing: 0,
        projection: "globe",
        antialias: true,
        attributionControl: false,
        preserveDrawingBuffer: true,
        failIfMajorPerformanceCaveat: false, // Be more forgiving with performance
        maxZoom: 20,
        minZoom: 1
      });

      // Set timeout to detect style loading issues
      initializationTimeoutRef.current = window.setTimeout(() => {
        const errorMsg = "Map load timeout - style not loaded";
        setInitializationError(errorMsg);
        setError(errorMsg);
        console.error(errorMsg);
      }, 20000);

      // Handle successful map load
      newMap.on("load", () => {
        if (initializationTimeoutRef.current) {
          window.clearTimeout(initializationTimeoutRef.current);
          initializationTimeoutRef.current = null;
        }
        
        console.log("Map loaded successfully");
        setMapLoaded(true);
        setInitializationError(null);
        setError(null);
        
        try {
          if (is3DMode) setupHolographicEffects(newMap);
        } catch (e) {
          console.warn("Could not apply holographic effects:", e);
        }
        
        // Add navigation controls
        try {
          newMap.addControl(
            new mapboxgl.NavigationControl({ visualizePitch: true }),
            "bottom-right"
          );
        } catch (e) {
          console.warn("Could not add navigation controls:", e);
        }
        
        // Notify parent component
        if (onMapInitialized) onMapInitialized(newMap);
      });

      // Handle map errors
      newMap.on("error", (e) => {
        console.error("Mapbox error:", e);
        const errorMessage = e.error?.message || "Map initialization failed";
        setInitializationError(errorMessage);
        setError(errorMessage);
        
        toast({
          title: "Map Error",
          description: errorMessage,
          variant: "destructive",
        });
      });

      // Set the map in state
      setMap(newMap);
      
    } catch (error: any) {
      console.error("Map initialization error:", error);
      const errorMessage = error.message || "Failed to initialize map";
      setInitializationError(errorMessage);
      setError(errorMessage);
      
      toast({
        title: "Map Error",
        description: errorMessage,
        variant: "destructive",
      });
    }

    // Cleanup function
    return () => {
      if (initializationTimeoutRef.current) {
        window.clearTimeout(initializationTimeoutRef.current);
      }
    };
  }, [
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
    setError,
  ]);
};
