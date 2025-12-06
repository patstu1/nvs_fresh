
import { useState, useEffect } from 'react';
import { toast } from '@/hooks/use-toast';
import { Room } from '../RoomTypes';

export function useRoomLocation() {
  const [userLocation, setUserLocation] = useState<{lat: number, lng: number} | null>(null);
  const [userLocalRoomId] = useState<string>('local-1');
  const [isLocationMatchingEnabled, setIsLocationMatchingEnabled] = useState(true);
  const [currentCity, setCurrentCity] = useState({ name: 'Your Location', country: '' });

  // Get user location on component mount
  useEffect(() => {
    getUserLocation();
  }, []);
  
  // Get user location and update local room
  const getUserLocation = () => {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          const userPos = {
            lat: position.coords.latitude,
            lng: position.coords.longitude
          };
          setUserLocation(userPos);
          
          // Create a personalized local room name based on approximate location
          reverseGeocode(userPos.lat, userPos.lng);
        },
        (error) => {
          console.error("Error getting location:", error);
          toast({
            title: "Location Error",
            description: "Unable to determine your location. Some features may be limited.",
            variant: "destructive"
          });
        }
      );
    }
  };
  
  // Simple reverse geocoding to get approximate location name
  const reverseGeocode = async (lat: number, lng: number) => {
    try {
      // In a real app, you would use a geocoding API here
      // For this demo, we'll just simulate with a delay
      setTimeout(() => {
        // This would be the result from the geocoding API
        const nearestCity = "Your Area";
        
        // Local room name update will be handled by the main hook that consumes this
        // Just return the data needed
        return nearestCity;
      }, 1000);
    } catch (error) {
      console.error("Geocoding error:", error);
    }
  };

  const handleLocationMatchingToggle = (enabled: boolean) => {
    setIsLocationMatchingEnabled(enabled);
    if (enabled && currentCity.name !== 'Your Location') {
      setCurrentCity({ name: 'Your Location', country: '' });
      // When enabled, re-fetch user location to ensure it's current
      getUserLocation();
    }
  };

  const handleCitySelect = (city: { name: string; country: string }) => {
    setCurrentCity(city);
    setIsLocationMatchingEnabled(false);
  };

  return {
    userLocation,
    userLocalRoomId,
    isLocationMatchingEnabled,
    currentCity,
    getUserLocation,
    handleLocationMatchingToggle,
    handleCitySelect
  };
}
