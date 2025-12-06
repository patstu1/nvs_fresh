
import { useCallback } from "react";

type Location = { lat: number; lng: number; zoom?: number } | null;

export const useInitialCenterZoom = (
  userLocation: Location,
  selectedLocation: Location
) => {
  const getInitialCenter = useCallback((): [number, number] => {
    if (selectedLocation) {
      return [selectedLocation.lng, selectedLocation.lat];
    }
    if (userLocation) {
      return [userLocation.lng, userLocation.lat];
    }
    // Default: New York City
    return [-73.9857, 40.7484];
  }, [selectedLocation, userLocation]);

  const getInitialZoom = useCallback(() => {
    if (selectedLocation?.zoom) return selectedLocation.zoom;
    if (userLocation?.zoom) return userLocation.zoom;
    return 12;
  }, [selectedLocation, userLocation]);

  return { getInitialCenter, getInitialZoom };
};
