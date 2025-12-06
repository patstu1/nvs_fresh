
import React, { useState } from 'react';
import { Users } from 'lucide-react';
import ZoomCallDialog from './ZoomCallDialog';
import { toast } from '@/hooks/use-toast';

interface ZoomRoomButtonProps {
  cityName: string;
  userCount: number;
  capacity?: number;
}

const ZoomRoomButton: React.FC<ZoomRoomButtonProps> = ({ 
  cityName, 
  userCount,
  capacity = 200
}) => {
  const [isZoomRoomOpen, setIsZoomRoomOpen] = useState(false);
  
  const handleOpenZoomRoom = () => {
    setIsZoomRoomOpen(true);
    toast({
      title: "Opening Zoom Room",
      description: `Connecting to ${cityName} with ${userCount} active users`,
    });
  };

  return (
    <>
      <button 
        onClick={handleOpenZoomRoom}
        className="flex flex-col items-center zoom-room-button"
      >
        <div className="w-12 h-12 rounded-full bg-[#2A2A2A] flex items-center justify-center mb-1 border border-[#C2FFE6]/50">
          <Users className="w-6 h-6 text-[#C2FFE6]" />
        </div>
        <span className="text-xs text-gray-300">Room</span>
      </button>
      
      <ZoomCallDialog 
        isOpen={isZoomRoomOpen} 
        onClose={() => setIsZoomRoomOpen(false)} 
        user={{
          id: "room",
          name: cityName
        }}
        isGroupCall={true}
        capacity={capacity}
        cityName={cityName}
      />
    </>
  );
};

export default ZoomRoomButton;
