
import React from 'react';
import { Globe, MapPin, Users, MessageCircle } from 'lucide-react';

interface RoomCity {
  id: string;
  name: string;
  country: string;
  userCount: number;
  capacity: number;
  isNearYou: boolean;
  distance?: number;  // Distance in kilometers (if applicable)
  type?: 'local' | 'city' | 'forum'; // Room type
  topic?: string; // For forum rooms
}

interface ZoomRoomGridProps {
  cities: RoomCity[];
  forumRooms: RoomCity[];
  isLocationMatchingEnabled: boolean;
  onOpenRoom: (roomId: string) => void;
}

const ZoomRoomGrid: React.FC<ZoomRoomGridProps> = ({
  cities,
  forumRooms,
  isLocationMatchingEnabled,
  onOpenRoom
}) => {
  // If location matching is enabled, only show nearby cities and forums
  const displayCities = isLocationMatchingEnabled 
    ? cities.filter(city => city.isNearYou).slice(0, 2)
    : cities;

  return (
    <>
      <div className="grid grid-cols-2 gap-4 mb-6">
        {displayCities.map(city => (
          <div 
            key={city.id} 
            className={`bg-[#2A2A2A] p-4 rounded-lg border ${
              city.isNearYou ? 'border-[#C2FFE6]' : 'border-[#C2FFE6]/30'
            }`}
          >
            <div className="flex justify-between items-center mb-3">
              <div className="flex items-center">
                {city.isNearYou ? (
                  <MapPin className="w-4 h-4 text-[#C2FFE6] mr-2" />
                ) : (
                  <Globe className="w-4 h-4 text-[#C2FFE6] mr-2" />
                )}
                <span className="text-[#C2FFE6] font-semibold">
                  {city.name}
                  {city.distance !== undefined && (
                    <span className="text-xs ml-2 text-[#C2FFE6]/70">
                      {city.distance.toFixed(1)}km
                    </span>
                  )}
                </span>
              </div>
              <div className="text-xs text-[#C2FFE6]/70">
                {city.userCount}/{city.capacity}
              </div>
            </div>
            <div className="flex justify-center">
              <button 
                onClick={() => onOpenRoom(city.id)}
                className="flex flex-col items-center"
              >
                <div className="w-12 h-12 rounded-full bg-[#2A2A2A] flex items-center justify-center mb-1 border border-[#C2FFE6]/50">
                  <MessageCircle className="w-6 h-6 text-[#C2FFE6]" />
                </div>
                <span className="text-xs text-gray-300">Zoom Room</span>
              </button>
            </div>
          </div>
        ))}
      </div>
      
      {/* Forum rooms section */}
      <h2 className="text-xl font-bold text-[#C2FFE6] mb-4">Forum Groups</h2>
      <div className="grid grid-cols-2 gap-4">
        {forumRooms.map(forum => (
          <div 
            key={forum.id} 
            className="bg-[#2A2A2A] p-4 rounded-lg border border-[#C2FFE6]/30"
          >
            <div className="flex justify-between items-center mb-3">
              <div className="flex items-center">
                <Users className="w-4 h-4 text-[#C2FFE6] mr-2" />
                <span className="text-[#C2FFE6] font-semibold">
                  {forum.topic || forum.name}
                </span>
              </div>
              <div className="text-xs text-[#C2FFE6]/70">
                {forum.userCount}/{forum.capacity}
              </div>
            </div>
            <div className="flex justify-center">
              <button 
                onClick={() => onOpenRoom(forum.id)}
                className="flex flex-col items-center"
              >
                <div className="w-12 h-12 rounded-full bg-[#2A2A2A] flex items-center justify-center mb-1 border border-[#C2FFE6]/50">
                  <MessageCircle className="w-6 h-6 text-[#C2FFE6]" />
                </div>
                <span className="text-xs text-gray-300">Forum Room</span>
              </button>
            </div>
          </div>
        ))}
      </div>
    </>
  );
};

export default ZoomRoomGrid;
