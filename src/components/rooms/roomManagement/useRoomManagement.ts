
import { useEffect } from 'react';
import { useRoomLocation } from './useRoomLocation';
import { useRoomData } from './useRoomData';
import { useRoomNavigation } from './useRoomNavigation';
import { Room } from '../RoomTypes';

export const useRoomManagement = () => {
  const {
    userLocation,
    userLocalRoomId,
    isLocationMatchingEnabled,
    currentCity,
    getUserLocation,
    handleLocationMatchingToggle,
    handleCitySelect
  } = useRoomLocation();

  const {
    popularConnects,
    citiesWithRooms,
    forumRooms,
    updateLocalRoomUsers,
    updateLocalRoomName,
    setCitiesWithRooms
  } = useRoomData();

  const {
    activeView,
    selectedRoom,
    activeRoomUsers,
    setActiveRoomUsers,
    handleOpenZoomRoom,
    handleBackToRooms,
    getSelectedRoomDetails
  } = useRoomNavigation([...citiesWithRooms, ...forumRooms]);

  // Update local room users after location is set
  useEffect(() => {
    if (userLocation) {
      const userCount = updateLocalRoomUsers();
      // If locationMatchingEnabled, set the active room users to local room count
      if (isLocationMatchingEnabled) {
        setActiveRoomUsers(userCount);
      }
    }
  }, [userLocation, isLocationMatchingEnabled]);

  // Set your current zoom room based on location
  useEffect(() => {
    if (isLocationMatchingEnabled) {
      // When location matching is enabled, always use the local room
      const localRoom = citiesWithRooms.find(city => city.id === 'local-1');
      if (localRoom) {
        setActiveRoomUsers(localRoom.userCount);
      }
    }
  }, [isLocationMatchingEnabled, citiesWithRooms]);

  const handleCitySelectAndUpdateRoom = (city: { name: string; country: string }) => {
    handleCitySelect(city);
    
    // Find the selected city room or default to first city
    const cityRoom = citiesWithRooms.find(c => c.name === city.name) || citiesWithRooms[1];
    setActiveRoomUsers(cityRoom.userCount);
  };

  const handleOpenZoomRoomWrapper = (roomId: string) => {
    handleOpenZoomRoom(roomId, [...citiesWithRooms, ...forumRooms]);
  };

  return {
    isLocationMatchingEnabled,
    currentCity,
    activeView,
    selectedRoom,
    activeRoomUsers,
    userLocalRoomId,
    popularConnects,
    citiesWithRooms,
    forumRooms,
    handleCitySelect: handleCitySelectAndUpdateRoom,
    handleLocationMatchingToggle,
    handleOpenZoomRoom: handleOpenZoomRoomWrapper,
    handleBackToRooms,
    getSelectedRoomDetails: () => getSelectedRoomDetails(citiesWithRooms, forumRooms)
  };
};
