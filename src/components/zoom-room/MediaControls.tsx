
import React from 'react';

interface MediaControlsProps {
  isUserMuted: boolean;
  isUserCameraOff: boolean;
  toggleMute: () => void;
  toggleCamera: () => void;
}

const MediaControls: React.FC<MediaControlsProps> = ({ 
  isUserMuted, 
  isUserCameraOff, 
  toggleMute, 
  toggleCamera 
}) => {
  return (
    <div className="flex justify-center gap-4 p-2 bg-[#1a1a1a] border-t border-[#333]">
      <button 
        onClick={toggleMute} 
        className={`p-2 rounded-full ${isUserMuted ? 'bg-red-500' : 'bg-[#333]'}`}
      >
        {isUserMuted ? '🔇' : '🎤'}
      </button>
      <button 
        onClick={toggleCamera} 
        className={`p-2 rounded-full ${isUserCameraOff ? 'bg-red-500' : 'bg-[#333]'}`}
      >
        {isUserCameraOff ? '📵' : '📹'}
      </button>
    </div>
  );
};

export default MediaControls;
