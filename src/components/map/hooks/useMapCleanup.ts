
import { useCallback } from "react";
import mapboxgl from "mapbox-gl";

export const useMapCleanup = () => {
  return useCallback((map: mapboxgl.Map | null) => {
    if (!map) return;
    
    try {
      // Remove any custom controls
      const controls = map.getContainer().querySelectorAll('.mapboxgl-ctrl');
      controls.forEach(control => {
        try {
          if (control && control.parentNode) {
            control.parentNode.removeChild(control);
          }
        } catch (e) {
          console.error("Error removing control:", e);
        }
      });
      
      // Safely remove specific event listeners
      const eventTypes = ['error', 'load', 'style.load', 'sourcedata'];
      eventTypes.forEach(eventType => {
        try {
          // Use proper event handler removal with null for the listener
          // This removes all listeners of a specific type
          map.off(eventType as keyof mapboxgl.MapEvent, null);
        } catch (e) {
          console.error(`Error removing ${eventType} listener:`, e);
        }
      });
      
      // Safely remove map
      try {
        map.remove();
      } catch (e) {
        console.error("Error cleaning up map:", e);
      }
    } catch (error) {
      console.error("Error during map cleanup:", error);
    }
  }, []);
};
