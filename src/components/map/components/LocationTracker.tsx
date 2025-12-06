
import React from 'react';
import { toast } from '@/hooks/use-toast';
import mapboxgl from 'mapbox-gl';
import { useGeolocation } from '../hooks/useGeolocation';
import LocationTrackerButton from './location/LocationTrackerButton';
import { createUserLocationMarkerElement } from './location/UserLocationMarker';

interface LocationTrackerProps {
  map: mapboxgl.Map | null;
  userLocation: [number, number] | null;
  setUserLocation: (location: [number, number]) => void;
  setLocationAccuracy: (accuracy: number) => void;
  setMapCenter: (center: [number, number]) => void;
  locationAccuracy: number | null;
  isLocating: boolean;
  setIsLocating: (isLocating: boolean) => void;
  setLocationError: (error: string | null) => void;
}

const LocationTracker: React.FC<LocationTrackerProps> = ({
  map,
  userLocation,
  setUserLocation,
  setLocationAccuracy,
  locationAccuracy,
  isLocating,
  setIsLocating,
  setLocationError
}) => {
  const userLocationMarkerRef = React.useRef<mapboxgl.Marker | null>(null);
  const { getCurrentPosition, handleGeolocationError } = useGeolocation();

  // Handle cleanup when component unmounts
  React.useEffect(() => {
    return () => {
      if (userLocationMarkerRef.current) {
        userLocationMarkerRef.current.remove();
        userLocationMarkerRef.current = null;
      }
    };
  }, []);

  // Update marker when userLocation or map changes - with proper loading checks
  React.useEffect(() => {
    // Skip if any required elements are missing
    if (!map || !userLocation) {
      return;
    }
    
    // Ensure map is fully loaded before adding markers
    if (!map.loaded()) {
      const handleMapLoad = () => {
        addMarkerToMap();
        map.off('load', handleMapLoad);
      };
      
      map.on('load', handleMapLoad);
      return;
    }
    
    addMarkerToMap();
    
    function addMarkerToMap() {
      try {
        // Clear existing marker if it exists
        if (userLocationMarkerRef.current) {
          userLocationMarkerRef.current.remove();
        }
        
        // Create enhanced location marker
        const el = createUserLocationMarkerElement(locationAccuracy);
        
        // Add marker to map
        userLocationMarkerRef.current = new mapboxgl.Marker(el)
          .setLngLat(userLocation)
          .addTo(map);
          
        // Add entrance animation
        el.animate(
          [
            { opacity: 0, transform: 'scale(0.5)' },
            { opacity: 1, transform: 'scale(1)' }
          ],
          {
            duration: 500,
            easing: 'cubic-bezier(0.34, 1.56, 0.64, 1)',
            fill: 'forwards'
          }
        );
      } catch (error) {
        console.error("Error creating location marker:", error);
      }
    }
  }, [userLocation, map, locationAccuracy]);

  const centerOnUserLocation = () => {
    if (!userLocation) {
      setIsLocating(true);
      getCurrentPosition(
        (position) => {
          const { longitude, latitude, accuracy } = position.coords;
          const newLocation: [number, number] = [longitude, latitude];
          setUserLocation(newLocation);
          setLocationAccuracy(accuracy);
          
          if (map && map.loaded()) {
            map.flyTo({
              center: newLocation,
              zoom: 16,
              speed: 1.5
            });
          }
          setIsLocating(false);
        },
        (error) => {
          handleGeolocationError(error, setLocationError);
          setIsLocating(false);
        }
      );
    } else if (map && map.loaded()) {
      map.flyTo({
        center: userLocation,
        zoom: 16,
        speed: 1.5
      });
      
      toast({
        title: "Centered on Your Location",
        description: locationAccuracy 
          ? `Location accuracy: ${Math.round(locationAccuracy)}m` 
          : "Using your current location"
      });
    }
  };

  return (
    <LocationTrackerButton
      isLocating={isLocating}
      onClick={centerOnUserLocation}
    />
  );
};

export default LocationTracker;
