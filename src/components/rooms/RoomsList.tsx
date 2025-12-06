
import React from 'react';
import LocationControls from './LocationControls';
import RoomStats from './RoomStats';
import QuickConnectSection from './QuickConnectSection';
import ZoomRoomGrid from './ZoomRoomGrid';
import { Room, ConnectProfile } from './RoomTypes';

interface RoomsListProps {
  isLocationMatchingEnabled: boolean;
  currentCity: { name: string; country: string };
  activeRoomUsers: number;
  userLocalRoomId: string;
  popularConnects: ConnectProfile[];
  citiesWithRooms: Room[];
  forumRooms: Room[];
  onLocationToggle: (enabled: boolean) => void;
  onCitySelect: (city: { name: string; country: string }) => void;
  onOpenRoom: (roomId: string) => void;
}

const RoomsList: React.FC<RoomsListProps> = ({
  isLocationMatchingEnabled,
  currentCity,
  activeRoomUsers,
  userLocalRoomId,
  popularConnects,
  citiesWithRooms,
  forumRooms,
  onLocationToggle,
  onCitySelect,
  onOpenRoom
}) => {
  return (
    <div className="flex flex-col p-4 pb-24">
      <LocationControls
        isLocationMatchingEnabled={isLocationMatchingEnabled}
        currentCity={currentCity}
        onLocationToggle={onLocationToggle}
        onCitySelect={onCitySelect}
      />

      <RoomStats 
        activeUsers={activeRoomUsers}
        isLocationMatchingEnabled={isLocationMatchingEnabled}
        onOpenRoom={() => onOpenRoom(userLocalRoomId)}
        roomName={isLocationMatchingEnabled ? "Local" : "Global"}
      />

      <QuickConnectSection profiles={popularConnects} />

      <h2 className="text-xl font-bold text-[#C2FFE6] mb-4">Global Rooms</h2>
      <ZoomRoomGrid 
        cities={citiesWithRooms}
        forumRooms={forumRooms}
        isLocationMatchingEnabled={isLocationMatchingEnabled}
        onOpenRoom={onOpenRoom}
      />
    </div>
  );
};

export default RoomsList;
