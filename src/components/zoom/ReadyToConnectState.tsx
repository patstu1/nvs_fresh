
import React from 'react';
import { Button } from '@/components/ui/button';

interface ReadyToConnectStateProps {
  title: string;
  subtitle: string;
  avatar?: string;
  isGroupCall?: boolean;
  participantCount?: number;
  onConnect: () => void;
}

const ReadyToConnectState: React.FC<ReadyToConnectStateProps> = ({
  title,
  subtitle,
  avatar,
  isGroupCall = false,
  participantCount = 0,
  onConnect
}) => {
  return (
    <div className="text-center">
      <div className="w-24 h-24 rounded-full overflow-hidden mx-auto mb-4 border-2 border-[#C2FFE6]">
        <img 
          src={avatar || "https://source.unsplash.com/random/100x100?face"} 
          alt={title}
          className="w-full h-full object-cover"
        />
      </div>
      <h3 className="text-[#C2FFE6] text-xl mb-2">{title}</h3>
      <p className="text-[#C2FFE6]/70 mb-6">
        {isGroupCall 
          ? `${participantCount} people in this room` 
          : subtitle}
      </p>
      <Button 
        className="bg-[#C2FFE6] text-black hover:bg-[#C2FFE6]/80"
        onClick={onConnect}
      >
        {isGroupCall ? "Join Room" : "Start Call"}
      </Button>
    </div>
  );
};

export default ReadyToConnectState;
