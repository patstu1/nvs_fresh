
import React from 'react';

interface OneOnOneCallViewProps {
  user: {
    id: string;
    name: string;
    avatar?: string;
  };
  isCameraOff: boolean;
  isMuted: boolean;
}

const OneOnOneCallView: React.FC<OneOnOneCallViewProps> = ({
  user,
  isCameraOff,
  isMuted
}) => {
  return (
    <div className="grid grid-cols-2 gap-4 w-full">
      <div className="aspect-square">
        <div className="w-full h-full bg-[#2a2a2a] rounded-lg flex items-center justify-center">
          <img 
            src={user.avatar || "https://source.unsplash.com/random/100x100?face"}
            alt={user.name}
            className="w-full h-full object-cover rounded-lg"
          />
          <div className="absolute bottom-2 left-2 text-sm bg-black/50 px-2 py-1 rounded">
            {user.name}
          </div>
        </div>
      </div>
      
      <div className="aspect-square">
        <div className={`w-full h-full ${isCameraOff ? 'bg-[#1a1a1a]' : 'bg-[#2a2a2a]'} rounded-lg flex items-center justify-center`}>
          {isCameraOff ? (
            <div className="text-center">
              <div className="w-16 h-16 rounded-full bg-[#333] mx-auto mb-2 flex items-center justify-center">
                <span className="text-[#C2FFE6] text-xl">You</span>
              </div>
              <p className="text-sm text-[#C2FFE6]/70">Camera Off</p>
            </div>
          ) : (
            <video 
              className="w-full h-full object-cover rounded-lg"
              autoPlay
              muted
              playsInline
            />
          )}
          <div className="absolute bottom-2 left-2 text-sm bg-black/50 px-2 py-1 rounded">
            You {isMuted && '🔇'}
          </div>
        </div>
      </div>
    </div>
  );
};

export default OneOnOneCallView;
