
import React from 'react';
import { Button } from '@/components/ui/button';
import { ChevronLeft, Users, Globe, MapPin, MessageCircle } from 'lucide-react';

interface RoomHeaderProps {
  roomName: string;
  activeUsers: number;
  subtitle?: string;
  roomType?: 'local' | 'city' | 'forum';
  onBack: () => void;
}

const RoomHeader: React.FC<RoomHeaderProps> = ({ 
  roomName, 
  activeUsers, 
  subtitle,
  roomType = 'city',
  onBack 
}) => {
  // Get the appropriate icon based on room type
  const getRoomIcon = () => {
    switch (roomType) {
      case 'local':
        return <MapPin className="h-4 w-4 text-[#C2FFE6] mr-1" />;
      case 'forum':
        return <MessageCircle className="h-4 w-4 text-[#C2FFE6] mr-1" />;
      default:
        return <Globe className="h-4 w-4 text-[#C2FFE6] mr-1" />;
    }
  };

  return (
    <div className="flex items-center justify-between p-4 border-b border-[#333]">
      <div className="flex items-center">
        <Button 
          variant="ghost" 
          size="icon" 
          onClick={onBack}
          className="mr-2"
        >
          <ChevronLeft className="h-5 w-5 text-[#C2FFE6]" />
        </Button>
        <div>
          <h2 className="text-lg font-semibold text-[#C2FFE6] flex items-center">
            {getRoomIcon()}
            {roomName}
          </h2>
          <div className="flex items-center text-xs text-gray-400">
            <Users className="h-3 w-3 mr-1" />
            <span>{activeUsers} bros active</span>
            {subtitle && (
              <span className="ml-2 px-1.5 py-0.5 bg-[#2A2A2A] rounded-full text-[10px]">
                {subtitle}
              </span>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default RoomHeader;
