
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

  const validateToken = (token: string): boolean => {
    // Basic validation for Mapbox tokens
    if (!token || typeof token !== 'string') return false;
    if (token.trim() === '') return false;
    
    // Mapbox tokens should start with 'pk.' for public tokens
    if (!token.startsWith('pk.')) {
      console.warn('Warning: Token may be invalid - Mapbox public tokens typically start with "pk."');
    }
    
    return true;
  };

  const initializeMap = useCallback((currentToken: string, container: HTMLDivElement) => {
    try {
      // Validate token before proceeding
      if (!validateToken(currentToken)) {
        const errorMsg = "Invalid Mapbox token format";
        console.error(errorMsg, currentToken);
        setMapError(errorMsg);
        if (onMapError) onMapError(errorMsg);
        
        toast({
          title: "Token Error",
          description: "The provided Mapbox token appears to be invalid",
          variant: "destructive"
        });
        return null;
      }
      
      console.log(`Initializing map with token: ${currentToken.substring(0, 5)}...`);
      
      // Set token globally
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
      
      // Create the map with provided options
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
      
      // Handle successful map load
      map.once('load', () => {
        console.log('Map loaded successfully');
        setMapLoaded(true);
        setMapError(null);
        
        if (onMapInitialized) {
          onMapInitialized(map);
        }
        
        // Adjust sizing after a slight delay
        setTimeout(() => {
          try {
            map.resize();
          } catch (e) {
            console.warn('Error during resize:', e);
          }
        }, 500);
      });
      
      // Add error handler to map for runtime errors
      map.on('error', (e) => {
        const errorMessage = e.error?.message || 'Unknown map error';
        console.error('Mapbox error:', errorMessage);
        setMapError(errorMessage);
        
        if (onMapError) {
          onMapError(errorMessage);
        }
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
