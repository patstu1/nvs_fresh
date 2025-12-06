
import { useState } from 'react';
import { toast } from '@/hooks/use-toast';

export function useMediaControls() {
  const [isUserMuted, setIsUserMuted] = useState(false);
  const [isUserCameraOff, setIsUserCameraOff] = useState(true);
  
  // Toggle user audio/video
  const toggleMute = () => {
    setIsUserMuted(!isUserMuted);
    toast({
      title: isUserMuted ? "Microphone Unmuted" : "Microphone Muted",
      description: isUserMuted ? "Others can now hear you" : "Others can no longer hear you"
    });
  };
  
  const toggleCamera = () => {
    setIsUserCameraOff(!isUserCameraOff);
    toast({
      title: isUserCameraOff ? "Camera Turned On" : "Camera Turned Off",
      description: isUserCameraOff ? "Others can now see you" : "Others can no longer see you"
    });
  };

  return {
    isUserMuted,
    isUserCameraOff,
    toggleMute,
    toggleCamera
  };
}
