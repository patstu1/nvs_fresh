
import React, { memo } from 'react';
import ZoomRoomFeed from './ZoomRoomFeed';
import RoomsList from './rooms/RoomsList';
import { useRoomManagement } from './rooms/roomManagement/useRoomManagement';
import { useMobileOptimization } from '@/hooks/useMobileOptimization';

const TopBanner = () => (
  <div className="relative w-full flex justify-center items-center my-6">
    <div className="w-full text-center py-8 z-[100] relative">
      <h1 className="neon-text-giant">LIVE</h1>
    </div>
  </div>
);

const RoomsView: React.FC = memo(() => {
  const {
    isLocationMatchingEnabled,
    currentCity,
    activeView,
    selectedRoom,
    activeRoomUsers,
    userLocalRoomId,
    popularConnects,
    citiesWithRooms,
    forumRooms,
    handleCitySelect,
    handleLocationMatchingToggle,
    handleOpenZoomRoom,
    handleBackToRooms,
    getSelectedRoomDetails
  } = useRoomManagement();
  
  useMobileOptimization();

  if (activeView === 'feed' && selectedRoom) {
    const roomDetails = getSelectedRoomDetails();
    return (
      <>
        <TopBanner />
        <ZoomRoomFeed 
          roomName={roomDetails.name}
          roomType={roomDetails.type}
          activeUsers={activeRoomUsers}
          onBack={handleBackToRooms}
        />
      </>
    );
  }

  return (
    <div className="flex flex-col">
      <TopBanner />
      <RoomsList
        isLocationMatchingEnabled={isLocationMatchingEnabled}
        currentCity={currentCity}
        activeRoomUsers={activeRoomUsers}
        userLocalRoomId={userLocalRoomId}
        popularConnects={popularConnects}
        citiesWithRooms={citiesWithRooms}
        forumRooms={forumRooms}
        onLocationToggle={handleLocationMatchingToggle}
        onCitySelect={handleCitySelect}
        onOpenRoom={handleOpenZoomRoom}
      />
    </div>
  );
});

RoomsView.displayName = 'RoomsView';

export default RoomsView;
