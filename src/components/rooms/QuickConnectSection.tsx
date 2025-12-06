
import React from 'react';
import VideoCallButton from '../VideoCallButton';

interface QuickConnectProfile {
  id: string;
  name: string;
  image: string;
  distance: number;
}

interface QuickConnectSectionProps {
  profiles: QuickConnectProfile[];
}

const QuickConnectSection: React.FC<QuickConnectSectionProps> = ({ profiles }) => {
  return (
    <>
      <h2 className="text-xl font-bold text-[#C2FFE6] mb-4">Quick Connect</h2>
      <div className="grid grid-cols-3 gap-4 mb-8">
        {profiles.map(user => (
          <div key={user.id} className="flex flex-col items-center">
            <div className="relative mb-2">
              <div className="w-16 h-16 rounded-full overflow-hidden border-2 border-[#C2FFE6]">
                <img src={user.image} alt={user.name} className="w-full h-full object-cover" />
              </div>
              <div className="absolute -bottom-1 -right-1 bg-[#2A2A2A] text-[#C2FFE6] text-xs px-1 rounded-full border border-[#C2FFE6]">
                {user.distance.toFixed(1)}km
              </div>
            </div>
            <span className="text-sm text-[#C2FFE6] mb-1">{user.name}</span>
            <VideoCallButton 
              userId={user.id} 
              userName={user.name} 
              userImage={user.image} 
              distance={user.distance} 
            />
          </div>
        ))}
      </div>
    </>
  );
};

export default QuickConnectSection;
