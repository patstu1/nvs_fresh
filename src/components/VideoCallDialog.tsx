
import React, { useEffect, useRef, useState } from 'react';
import { Dialog, DialogContent } from '@/components/ui/dialog';
import { toast } from '@/hooks/use-toast';
import ContentModerationBanner from './ContentModerationBanner';
import IncomingCallView from './video-call/IncomingCallView';
import VideoCallControls from './video-call/VideoCallControls';
import ConnectedCallView from './video-call/ConnectedCallView';

interface VideoCallDialogProps {
  isOpen: boolean;
  onClose: () => void;
  user: {
    id: string;
    name: string;
    avatar?: string;
  };
  isIncoming?: boolean;
  onAccept?: () => void;
  onReject?: () => void;
}

const VideoCallDialog: React.FC<VideoCallDialogProps> = ({
  isOpen,
  onClose,
  user,
  isIncoming = false,
  onAccept,
  onReject,
}) => {
  const [isCameraOn, setIsCameraOn] = useState(true);
  const [isMicOn, setIsMicOn] = useState(true);
  const [isCallConnected, setIsCallConnected] = useState(!isIncoming);
  const localVideoRef = useRef<HTMLVideoElement>(null);
  const remoteVideoRef = useRef<HTMLVideoElement>(null);

  useEffect(() => {
    if (isOpen && !isIncoming) {
      setTimeout(() => {
        setIsCallConnected(true);
      }, 1000);
    }

    if (isOpen && isCameraOn) {
      navigator.mediaDevices.getUserMedia({ video: true, audio: isMicOn })
        .then(stream => {
          if (localVideoRef.current) {
            localVideoRef.current.srcObject = stream;
          }
        })
        .catch(err => {
          console.error('Error accessing camera: ', err);
          setIsCameraOn(false);
          toast({
            title: "Camera Error",
            description: "Could not access your camera. Please check permissions.",
          });
        });
    }

    return () => {
      if (localVideoRef.current?.srcObject) {
        const stream = localVideoRef.current.srcObject as MediaStream;
        stream.getTracks().forEach(track => track.stop());
      }
    };
  }, [isOpen, isCameraOn, isMicOn, isIncoming]);

  const handleAccept = () => {
    setIsCallConnected(true);
    if (onAccept) onAccept();
  };

  const handleEndCall = () => {
    if (localVideoRef.current?.srcObject) {
      const stream = localVideoRef.current.srcObject as MediaStream;
      stream.getTracks().forEach(track => track.stop());
    }
    
    onClose();
    
    toast({
      title: "Call Ended",
      description: `Call with ${user.name} has ended`,
    });
  };

  const toggleCamera = () => {
    setIsCameraOn(!isCameraOn);
    
    if (localVideoRef.current?.srcObject) {
      const stream = localVideoRef.current.srcObject as MediaStream;
      stream.getVideoTracks().forEach(track => {
        track.enabled = !isCameraOn;
      });
    }
  };

  const toggleMic = () => {
    setIsMicOn(!isMicOn);
    
    if (localVideoRef.current?.srcObject) {
      const stream = localVideoRef.current.srcObject as MediaStream;
      stream.getAudioTracks().forEach(track => {
        track.enabled = !isMicOn;
      });
    }
  };

  return (
    <Dialog open={isOpen} onOpenChange={(open) => !open && onClose()}>
      <DialogContent className="sm:max-w-[90vw] md:max-w-[80vw] lg:max-w-[800px] p-0 bg-[#121212] text-white">
        <div className="relative h-[70vh] flex flex-col">
          <ContentModerationBanner />
          
          <div className="absolute inset-0 top-[40px] bg-black flex items-center justify-center">
            {isCallConnected ? (
              <ConnectedCallView
                user={user}
                remoteVideoRef={remoteVideoRef}
                localVideoRef={localVideoRef}
                isCameraOn={isCameraOn}
              />
            ) : (
              <IncomingCallView 
                user={user}
                onReject={onReject || handleEndCall}
                onAccept={handleAccept}
              />
            )}
          </div>
          
          {isCallConnected && (
            <VideoCallControls
              isCameraOn={isCameraOn}
              isMicOn={isMicOn}
              toggleCamera={toggleCamera}
              toggleMic={toggleMic}
              handleEndCall={handleEndCall}
            />
          )}
        </div>
      </DialogContent>
    </Dialog>
  );
};

export default VideoCallDialog;
