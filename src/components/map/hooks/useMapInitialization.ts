
import { useState, useCallback } from 'react';
import mapboxgl from 'mapbox-gl';
import { toast } from '@/hooks/use-toast';

interface UseMapboxInitializationProps {
  onMapInitialized?: (map: mapboxgl.Map) => void;
  onMapError?: (error: string) => void;
  initialCenter?: [number, number];
  initialZoom?: number;
  is3DMode?: boolean;
  style?: string;
}

export const useMapboxInitialization = ({
  onMapInitialized,
  onMapError,
  initialCenter = [-73.9857, 40.7484],
  initialZoom = 12,
  is3DMode = false,
  style = 'mapbox://styles/mapbox/dark-v11'
}: UseMapboxInitializationProps) => {
  const [mapLoaded, setMapLoaded] = useState(false);
  const [mapError, setMapError] = useState<string | null>(null);

  const initializeMap = useCallback((currentToken: string, container: HTMLDivElement) => {
    try {
      console.log(`Initializing map with token: ${currentToken.substring(0, 10)}...`);
      
      mapboxgl.accessToken = currentToken;
      
      if (!mapboxgl.supported()) {
        const errorMsg = "Your browser doesn't support Mapbox GL";
        setMapError(errorMsg);
        if (onMapError) onMapError(errorMsg);
        
        toast({
          title: "Browser Compatibility Error",
          description: errorMsg,
          variant: "destructive"
        });
        return null;
      }
      
      const map = new mapboxgl.Map({
        container,
        style,
        center: initialCenter,
        zoom: initialZoom,
        pitch: is3DMode ? 45 : 0,
        bearing: is3DMode ? 0 : 0,
        antialias: true,
        attributionControl: false,
        preserveDrawingBuffer: true,
        failIfMajorPerformanceCaveat: false,
        maxZoom: 20,
        minZoom: 1
      });
      
      map.once('load', () => {
        console.log('Map loaded successfully');
        setMapLoaded(true);
        setMapError(null);
        
        if (onMapInitialized) {
          onMapInitialized(map);
        }
        
        setTimeout(() => {
          try {
            map.resize();
          } catch (e) {
            console.warn('Error during resize:', e);
          }
        }, 500);
      });
      
      return map;
    } catch (error) {
      console.error('Error initializing map:', error);
      const errorMessage = error instanceof Error ? error.message : 'Unknown error initializing map';
      setMapError(errorMessage);
      
      if (onMapError) {
        onMapError(errorMessage);
      }
      
      toast({
        title: "Map Initialization Error",
        description: errorMessage,
        variant: "destructive"
      });
      
      return null;
    }
  }, [initialCenter, initialZoom, is3DMode, style, onMapInitialized, onMapError]);

  return {
    initializeMap,
    mapLoaded,
    mapError
  };
};
