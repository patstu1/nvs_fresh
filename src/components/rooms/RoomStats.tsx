
import React from 'react';
import { Users } from 'lucide-react';

interface RoomStatsProps {
  activeUsers: number;
  isLocationMatchingEnabled: boolean;
  onOpenRoom: () => void;
  roomCapacity?: number;
  roomName?: string;
}

const RoomStats: React.FC<RoomStatsProps> = ({ 
  activeUsers, 
  isLocationMatchingEnabled,
  onOpenRoom,
  roomCapacity = 200,
  roomName = "Your Zoom"
}) => {
  return (
    <div className="bg-gradient-to-r from-[#333] to-[#222] p-3 rounded-lg mb-6 border border-[#444]">
      <div className="flex items-center justify-between">
        <div className="flex items-center">
          <Users className="h-5 w-5 text-[#C2FFE6] mr-2" />
          <span className="text-[#C2FFE6] font-medium">
            {isLocationMatchingEnabled ? activeUsers : '?'} Bros in {roomName} Room 
            <span className="text-xs ml-1 text-gray-400">
              (Cap: {roomCapacity})
            </span>
          </span>
        </div>
        <button 
          onClick={onOpenRoom} 
          className="bg-[#1A1A1A] border border-[#C2FFE6]/30 text-[#C2FFE6] text-xs px-3 py-1 rounded-full hover:bg-[#2A2A2A]"
        >
          Open Room
        </button>
      </div>
    </div>
  );
};

export default RoomStats;
