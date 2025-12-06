
import { useEffect } from "react";
import mapboxgl from "mapbox-gl";

type Location = { lat: number; lng: number; zoom?: number } | null;

export const useMapCenterUpdater = (
  map: mapboxgl.Map | null,
  mapLoaded: boolean,
  selectedLocation: Location,
  userLocation: Location
) => {
  useEffect(() => {
    if (!map || !mapLoaded) return;
    if (selectedLocation) {
      map.flyTo({
        center: [selectedLocation.lng, selectedLocation.lat] as [number, number],
        zoom: selectedLocation.zoom || map.getZoom(),
        duration: 1000,
        essential: true,
      });
    } else if (userLocation) {
      map.flyTo({
        center: [userLocation.lng, userLocation.lat] as [number, number],
        zoom: userLocation.zoom || map.getZoom(),
        duration: 1000,
        essential: true,
      });
    }
  }, [map, mapLoaded, selectedLocation, userLocation]);
};
