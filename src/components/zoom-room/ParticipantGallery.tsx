import React, { useState } from 'react';
import { Grid3X3, Users, Grid2X2 } from 'lucide-react';
import { Button } from '@/components/ui/button';

interface RoomParticipant {
  id: string;
  name: string;
  image?: string;
  isOnline: boolean;
  isSpeaking?: boolean;
  isMuted?: boolean;
  isCameraOff?: boolean;
  role?: string;
}

interface ParticipantGalleryProps {
  participants: RoomParticipant[];
  roomType?: 'local' | 'city' | 'forum';
  isCurrentUserMuted?: boolean;
  isCurrentUserCameraOff?: boolean;
}

const ParticipantGallery: React.FC<ParticipantGalleryProps> = ({
  participants,
  roomType = 'city',
  isCurrentUserMuted = false,
  isCurrentUserCameraOff = false
}) => {
  const [view, setView] = useState<'grid' | 'gallery'>('grid');
  
  // Determine number of columns based on view type
  const getGridCols = () => {
    return view === 'grid' ? 'grid-cols-3 sm:grid-cols-4' : 'grid-cols-2 sm:grid-cols-3';
  };

  return (
    <div className="flex flex-col h-full">
      {/* View toggle controls */}
      <div className="flex items-center justify-between mb-2 px-2">
        <span className="text-xs text-gray-400">{participants.length} participants</span>
        <div className="flex gap-1">
          <Button 
            variant={view === 'grid' ? 'secondary' : 'ghost'} 
            size="icon"
            className="w-7 h-7"
            onClick={() => setView('grid')}
          >
            <Grid3X3 className="h-4 w-4" />
          </Button>
          <Button 
            variant={view === 'gallery' ? 'secondary' : 'ghost'} 
            size="icon"
            className="w-7 h-7"
            onClick={() => setView('gallery')}
          >
            <Grid2X2 className="h-4 w-4" />
          </Button>
        </div>
      </div>
      
      {/* Gallery grid */}
      <div className={`grid ${getGridCols()} gap-2 overflow-y-auto p-2 flex-grow`}>
        {/* Current user tile */}
        <div className="relative aspect-square">
          <div className={`w-full h-full ${isCurrentUserCameraOff ? 'bg-[#1a1a1a]' : 'bg-[#2a2a2a]'} rounded-lg flex items-center justify-center`}>
            {isCurrentUserCameraOff ? (
              <div className="text-center">
                <div className="w-10 h-10 rounded-full bg-[#333] mx-auto mb-1 flex items-center justify-center">
                  <span className="text-[#C2FFE6]">You</span>
                </div>
                <p className="text-xs text-[#C2FFE6]/70">Camera Off</p>
              </div>
            ) : (
              <video 
                className="w-full h-full object-cover rounded-lg"
                autoPlay
                muted
                playsInline
              />
            )}
            <div className="absolute bottom-1 left-1 text-xs bg-black/50 px-1 rounded">
              You {isCurrentUserMuted && '🔇'}
            </div>
          </div>
        </div>
        
        {/* Other participants */}
        {participants.map((participant) => (
          <div key={participant.id} className="relative aspect-square">
            <div className={`w-full h-full bg-[#2a2a2a] rounded-lg flex items-center justify-center ${participant.isSpeaking ? 'border-2 border-[#C2FFE6]' : ''}`}>
              {!participant.isCameraOff ? (
                <img 
                  src={participant.image || `https://source.unsplash.com/random/100x100?face&${participant.id}`} 
                  alt={participant.name}
                  className="w-full h-full object-cover rounded-lg"
                />
              ) : (
                <div className="text-center">
                  <div className="w-10 h-10 rounded-full bg-[#333] mx-auto mb-1 flex items-center justify-center">
                    <span className="text-[#C2FFE6]">{participant.name.charAt(0)}</span>
                  </div>
                  <p className="text-xs text-[#C2FFE6]/70">Camera Off</p>
                </div>
              )}
              <div className="absolute bottom-1 left-1 text-xs bg-black/50 px-1 rounded">
                {participant.name.split(' ')[0]} {participant.isMuted && '🔇'}
              </div>
              {participant.role && (
                <div className="absolute top-1 right-1 text-[10px] bg-black/50 px-1 rounded text-[#C2FFE6]">
                  {participant.role}
                </div>
              )}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default ParticipantGallery;
