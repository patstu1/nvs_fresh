
import { useEffect } from "react";
import mapboxgl from "mapbox-gl";

export const useMapCleanupEffect = (
  map: mapboxgl.Map | null,
  cleanupMap: (map: mapboxgl.Map | null) => void
) => {
  useEffect(() => {
    return () => {
      try {
        if (map) {
          // First try to remove all event listeners to prevent callbacks after unmount
          try {
            // Remove specific event listeners
            const eventTypes = ['error', 'load', 'style.load', 'sourcedata'];
            eventTypes.forEach(eventType => {
              try {
                // Use proper event handler removal with null for the listener
                // This removes all listeners of a specific type
                map.off(eventType as keyof mapboxgl.MapEvent, null);
              } catch (e) {
                console.warn(`Could not remove ${eventType} map event listener:`, e);
              }
            });
          } catch (e) {
            console.warn("Could not remove map event listeners:", e);
          }
          
          // Then clean up the map
          cleanupMap(map);
        }
      } catch (error) {
        console.error("Error cleaning up map:", error);
      }
    };
  }, [map, cleanupMap]);
};
