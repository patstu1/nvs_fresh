
import React, { useEffect, useRef } from 'react';
import mapboxgl from 'mapbox-gl';
import { Location } from '../types/markerTypes';
import { applyHolographicStyles } from '../utils/holographic';
import { useMapboxToken } from '../hooks/useMapboxToken';
import { toast } from '@/hooks/use-toast';

interface MapInitializerProps {
  containerRef: React.RefObject<HTMLDivElement>;
  holographicOverlayRef: React.RefObject<HTMLDivElement>;
  initialLocation: Location | null;
  showHeatMap: boolean;
  is3DMode: boolean;
  onMapLoaded: (map: mapboxgl.Map) => void;
  onMapError?: (error: string) => void;
}

const MapInitializer: React.FC<MapInitializerProps> = ({
  containerRef,
  holographicOverlayRef,
  initialLocation,
  showHeatMap,
  is3DMode,
  onMapLoaded,
  onMapError
}) => {
  // Use token from hook
  const { token, resetToDefaultToken } = useMapboxToken();
  const mapRef = useRef<mapboxgl.Map | null>(null);
  const initAttempted = useRef(false);
  
  // Initialize map when token and container are available
  useEffect(() => {
    if (!token || !containerRef.current || initAttempted.current) return;
    
    try {
      initAttempted.current = true;
      console.log("Initializing map with token starting with:", token.substring(0, 10) + "...");
      
      // Set the access token
      mapboxgl.accessToken = token;
      
      // Create map instance with optimized settings
      const map = new mapboxgl.Map({
        container: containerRef.current,
        style: 'mapbox://styles/mapbox/dark-v11',
        center: [initialLocation?.lng || -73.9857, initialLocation?.lat || 40.7484],
        zoom: initialLocation?.zoom || 12,
        pitch: is3DMode ? 60 : 0,
        bearing: is3DMode ? 15 : 0,
        projection: 'globe',
        antialias: true,
        attributionControl: false,
        maxZoom: 19,
        minZoom: 2,
        failIfMajorPerformanceCaveat: false,
      });
      
      mapRef.current = map;
      
      // Setup event handlers
      map.on('load', () => {
        console.log("Map loaded successfully");
        onMapLoaded(map);
        
        // Apply 3D effects if enabled
        if (is3DMode && holographicOverlayRef.current) {
          applyHolographicStyles(holographicOverlayRef.current);
          holographicOverlayRef.current.style.opacity = '1';
        }
      });
      
      // Handle errors
      map.on('error', (e) => {
        console.error("Map error:", e);
        
        // Try fallback token on authorization errors
        if (e.error && 
            (e.error.message?.includes('access token') || 
             e.error.message?.includes('token') || 
             e.error.message?.includes('unauthorized'))) {
          resetToDefaultToken();
          
          if (onMapError) {
            onMapError(e.error.message);
          }
          
          toast({
            title: "Map Token Error",
            description: "Trying to use a different token...",
            variant: "destructive",
          });
        }
      });
      
      // Add controls
      map.addControl(new mapboxgl.NavigationControl(), 'bottom-right');
      
      // Handle timeout for loading issues
      const timeout = setTimeout(() => {
        if (map && !map.loaded()) {
          console.log("Map load timeout, checking style loading status");
          if (map.isStyleLoaded()) {
            console.log("Style is loaded despite missing load event, proceeding");
            onMapLoaded(map);
          }
        }
      }, 8000);
      
      return () => {
        clearTimeout(timeout);
        if (mapRef.current) {
          mapRef.current.remove();
        }
      };
      
    } catch (error) {
      console.error("Error initializing map:", error);
      if (onMapError) {
        onMapError(error instanceof Error ? error.message : "Unknown error initializing map");
      }
      
      toast({
        title: "Map Initialization Error",
        description: error instanceof Error ? error.message : "Failed to initialize map",
        variant: "destructive",
      });
    }
  }, [token, containerRef, initialLocation, is3DMode, onMapLoaded, onMapError, resetToDefaultToken, holographicOverlayRef]);
  
  // Handle 3D mode changes
  useEffect(() => {
    if (mapRef.current) {
      const map = mapRef.current;
      
      if (is3DMode) {
        map.easeTo({
          pitch: 60,
          bearing: 15,
          duration: 1000
        });
        
        if (holographicOverlayRef.current) {
          holographicOverlayRef.current.style.opacity = '1';
          applyHolographicStyles(holographicOverlayRef.current);
        }
      } else {
        map.easeTo({
          pitch: 0,
          bearing: 0,
          duration: 1000
        });
        
        if (holographicOverlayRef.current) {
          holographicOverlayRef.current.style.opacity = '0';
        }
      }
    }
  }, [is3DMode, holographicOverlayRef]);
  
  return null;
};

export default MapInitializer;
