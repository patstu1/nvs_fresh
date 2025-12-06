
import React from 'react';
import { VideoOff } from 'lucide-react';

interface ConnectedCallViewProps {
  user: {
    id: string;
    name: string;
    avatar?: string;
  };
  remoteVideoRef: React.RefObject<HTMLVideoElement>;
  localVideoRef: React.RefObject<HTMLVideoElement>;
  isCameraOn: boolean;
}

const ConnectedCallView: React.FC<ConnectedCallViewProps> = ({
  user,
  remoteVideoRef,
  localVideoRef,
  isCameraOn
}) => {
  return (
    <>
      <video 
        ref={remoteVideoRef}
        autoPlay 
        playsInline
        className="w-full h-full object-cover"
        poster={user.avatar}
      />
      {!isCameraOn && (
        <div className="absolute inset-0 flex items-center justify-center bg-[#121212]/50">
          <div className="w-32 h-32 rounded-full overflow-hidden">
            {user.avatar ? (
              <img src={user.avatar} alt={user.name} className="w-full h-full object-cover" />
            ) : (
              <div className="w-full h-full bg-yobro-blue flex items-center justify-center text-4xl">
                {user.name.charAt(0)}
              </div>
            )}
          </div>
        </div>
      )}
      
      <div className="absolute bottom-24 right-4 w-1/4 max-w-[180px] aspect-video rounded-lg overflow-hidden border-2 border-[#90EE90] shadow-[0_0_10px_rgba(144,238,144,0.5)]">
        <video 
          ref={localVideoRef}
          autoPlay 
          playsInline 
          muted 
          className={`w-full h-full object-cover ${!isCameraOn ? 'hidden' : ''}`}
        />
        {!isCameraOn && (
          <div className="w-full h-full bg-[#222] flex items-center justify-center">
            <VideoOff className="h-6 w-6 text-gray-400" />
          </div>
        )}
      </div>
    </>
  );
};

export default ConnectedCallView;
