
import React, { useState } from 'react';
import { Grid3X3, Grid2X2 } from 'lucide-react';
import { Button } from '@/components/ui/button';

interface Participant {
  id: string;
  name: string;
  avatar?: string;
}

interface ParticipantsGridProps {
  participants: Participant[];
  isCameraOff: boolean;
  isMuted: boolean;
}

const ParticipantsGrid: React.FC<ParticipantsGridProps> = ({
  participants,
  isCameraOff,
  isMuted
}) => {
  const [viewMode, setViewMode] = useState<'compact' | 'gallery'>('compact');

  return (
    <div className="w-full flex flex-col">
      <div className="flex justify-between items-center mb-2 px-1">
        <span className="text-xs text-gray-400">{participants.length + 1} participants</span>
        <div className="flex gap-1">
          <Button 
            variant={viewMode === 'compact' ? 'secondary' : 'ghost'} 
            size="icon"
            className="w-7 h-7"
            onClick={() => setViewMode('compact')}
          >
            <Grid3X3 className="h-4 w-4" />
          </Button>
          <Button 
            variant={viewMode === 'gallery' ? 'secondary' : 'ghost'} 
            size="icon"
            className="w-7 h-7"
            onClick={() => setViewMode('gallery')}
          >
            <Grid2X2 className="h-4 w-4" />
          </Button>
        </div>
      </div>
      
      <div className={`grid ${viewMode === 'compact' ? 'grid-cols-3 sm:grid-cols-4' : 'grid-cols-2 sm:grid-cols-3'} gap-2 overflow-y-auto max-h-[400px]`}>
        <div className="relative aspect-square">
          <div className={`w-full h-full ${isCameraOff ? 'bg-[#1a1a1a]' : 'bg-[#2a2a2a]'} rounded-lg flex items-center justify-center`}>
            {isCameraOff ? (
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
              You {isMuted && '🔇'}
            </div>
          </div>
        </div>
        
        {participants.map((participant) => (
          <div key={participant.id} className="relative aspect-square">
            <div className="w-full h-full bg-[#2a2a2a] rounded-lg flex items-center justify-center">
              {Math.random() > 0.3 ? (
                <img 
                  src={participant.avatar || `https://source.unsplash.com/random/100x100?face&${participant.id}`} 
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
                {participant.name.split(' ')[0]} {Math.random() > 0.7 && '🔇'}
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default ParticipantsGrid;
