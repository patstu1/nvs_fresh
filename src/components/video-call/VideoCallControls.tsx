
import React from 'react';
import { Button } from '@/components/ui/button';
import { Video, VideoOff, Mic, MicOff, PhoneOff } from 'lucide-react';

interface VideoCallControlsProps {
  isCameraOn: boolean;
  isMicOn: boolean;
  toggleCamera: () => void;
  toggleMic: () => void;
  handleEndCall: () => void;
}

const VideoCallControls: React.FC<VideoCallControlsProps> = ({
  isCameraOn,
  isMicOn,
  toggleCamera,
  toggleMic,
  handleEndCall
}) => {
  return (
    <div className="absolute bottom-0 left-0 right-0 h-20 bg-[#1A1A1A] flex items-center justify-center space-x-4 p-2">
      <Button
        onClick={toggleMic}
        variant="outline"
        className={`rounded-full w-12 h-12 flex items-center justify-center ${!isMicOn ? 'bg-red-500 border-red-500' : 'bg-[#333] border-[#444]'}`}
      >
        {isMicOn ? <Mic className="h-5 w-5" /> : <MicOff className="h-5 w-5" />}
      </Button>
      
      <Button
        onClick={toggleCamera}
        variant="outline"
        className={`rounded-full w-12 h-12 flex items-center justify-center ${!isCameraOn ? 'bg-red-500 border-red-500' : 'bg-[#333] border-[#444]'}`}
      >
        {isCameraOn ? <Video className="h-5 w-5" /> : <VideoOff className="h-5 w-5" />}
      </Button>
      
      <Button
        onClick={handleEndCall}
        className="bg-red-500 hover:bg-red-600 rounded-full w-14 h-14 flex items-center justify-center"
      >
        <PhoneOff className="h-6 w-6" />
      </Button>
    </div>
  );
};

export default VideoCallControls;
