
import { useEffect, useRef, useState, useCallback } from 'react';
import mapboxgl from 'mapbox-gl';
import { Location } from '../types/markerTypes';

interface UseUserLocationMarkerProps {
  map: mapboxgl.Map | null;
  userLocation: Location | null;
  hideUserLocation: boolean;
  mapLoaded: boolean;
}

export const useUserLocationMarker = ({
  map,
  userLocation,
  hideUserLocation,
  mapLoaded
}: UseUserLocationMarkerProps) => {
  const userMarkerRef = useRef<mapboxgl.Marker | null>(null);
  const markerElementRef = useRef<HTMLDivElement | null>(null);
  const [animationAdded, setAnimationAdded] = useState(false);
  
  // Memoize marker creation for better performance
  const createUserMarker = useCallback(() => {
    if (!map || !userLocation || !mapLoaded || hideUserLocation) return null;
    
    try {
      // Create user location marker with minimal DOM operations
      if (!markerElementRef.current) {
        const el = document.createElement('div');
        el.className = 'user-location-marker floating-marker';
        el.style.cssText = 'width:22px;height:22px;border-radius:50%;background:#C2FFE6;border:2px solid white;box-shadow:0 0 5px rgba(194, 255, 230, 0.3);';
        
        // Add pulse effect more efficiently
        const pulse = document.createElement('div');
        pulse.className = 'pulse-ring';
        pulse.style.cssText = 'position:absolute;top:-10px;left:-10px;width:38px;height:38px;border:2px solid rgba(194, 255, 230, 0.5);border-radius:50%;';
        el.appendChild(pulse);
        
        markerElementRef.current = el;
      }
      
      // Add animation styles only once
      if (!animationAdded) {
        if (!document.getElementById('pulse-animation')) {
          const style = document.createElement('style');
          style.id = 'pulse-animation';
          style.innerHTML = `
            @keyframes pulse {
              0% { transform: scale(0.5); opacity: 0.7; }
              100% { transform: scale(1.3); opacity: 0; }
            }
            
            @keyframes float {
              0% { transform: translateY(0px); }
              50% { transform: translateY(-5px); }
              100% { transform: translateY(0px); }
            }
            
            .floating-marker {
              animation: float 3s ease-in-out infinite;
            }
            
            .pulse-ring {
              animation: pulse 2.5s infinite;
            }
          `;
          document.head.appendChild(style);
        }
        setAnimationAdded(true);
      }
      
      // Create or reuse marker
      if (!userMarkerRef.current && markerElementRef.current) {
        userMarkerRef.current = new mapboxgl.Marker({
          element: markerElementRef.current,
          anchor: 'center'
        })
          .setLngLat([userLocation.lng, userLocation.lat])
          .addTo(map);
      } else if (userMarkerRef.current) {
        userMarkerRef.current.setLngLat([userLocation.lng, userLocation.lat]);
      }
      
      return userMarkerRef.current;
    } catch (error) {
      console.error("Error creating user location marker:", error);
      return null;
    }
  }, [map, userLocation, mapLoaded, hideUserLocation, animationAdded]);
  
  // Add user location marker with optimized rendering
  useEffect(() => {
    // Only proceed if we have all required elements and the map is loaded
    if (!map || !mapLoaded || !userLocation || hideUserLocation) {
      if (userMarkerRef.current) {
        userMarkerRef.current.remove();
        userMarkerRef.current = null;
      }
      return;
    }
    
    // Create marker if not already created
    createUserMarker();
    
    // Cleanup when component unmounts
    return () => {
      if (userMarkerRef.current) {
        userMarkerRef.current.remove();
        userMarkerRef.current = null;
      }
      markerElementRef.current = null;
    };
  }, [userLocation, mapLoaded, hideUserLocation, map, createUserMarker]);
  
  return userMarkerRef.current;
};
