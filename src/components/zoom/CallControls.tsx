
import React from 'react';
import { Button } from '@/components/ui/button';
import { Mic, MicOff, Camera, CameraOff, Phone } from 'lucide-react';

interface CallControlsProps {
  isMuted: boolean;
  isCameraOff: boolean;
  onToggleMute: () => void;
  onToggleCamera: () => void;
  onEndCall: () => void;
}

const CallControls: React.FC<CallControlsProps> = ({
  isMuted,
  isCameraOff,
  onToggleMute,
  onToggleCamera,
  onEndCall
}) => {
  return (
    <div className="p-4 border-t border-[#333] flex justify-center space-x-4">
      <Button 
        variant="outline" 
        size="icon" 
        className={`rounded-full ${isMuted ? 'bg-red-500/20 border-red-500' : 'border-[#C2FFE6]'}`}
        onClick={onToggleMute}
      >
        {isMuted ? (
          <MicOff className="h-5 w-5 text-red-500" />
        ) : (
          <Mic className="h-5 w-5 text-[#C2FFE6]" />
        )}
      </Button>
      
      <Button 
        variant="outline" 
        size="icon" 
        className={`rounded-full ${isCameraOff ? 'bg-red-500/20 border-red-500' : 'border-[#C2FFE6]'}`}
        onClick={onToggleCamera}
      >
        {isCameraOff ? (
          <CameraOff className="h-5 w-5 text-red-500" />
        ) : (
          <Camera className="h-5 w-5 text-[#C2FFE6]" />
        )}
      </Button>
      
      <Button 
        size="icon" 
        className="rounded-full bg-red-500 hover:bg-red-600"
        onClick={onEndCall}
      >
        <Phone className="h-5 w-5 text-white" />
      </Button>
    </div>
  );
};

export default CallControls;
