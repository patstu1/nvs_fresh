
import React, { useState, useEffect } from 'react';
import { Dialog, DialogContent } from '@/components/ui/dialog';
import { toast } from '@/hooks/use-toast';
import ContentModerationBanner from './ContentModerationBanner';
import ZoomHeader from './zoom/ZoomHeader';
import ConnectingState from './zoom/ConnectingState';
import ReadyToConnectState from './zoom/ReadyToConnectState';
import ParticipantsGrid from './zoom/ParticipantsGrid';
import OneOnOneCallView from './zoom/OneOnOneCallView';
import CallControls from './zoom/CallControls';

interface ZoomCallDialogProps {
  isOpen: boolean;
  onClose: () => void;
  user: {
    id: string;
    name: string;
    avatar?: string;
  };
  isGroupCall?: boolean;
  capacity?: number;
  cityName?: string;
}

const ZoomCallDialog: React.FC<ZoomCallDialogProps> = ({
  isOpen,
  onClose,
  user,
  isGroupCall = false,
  capacity = 200,
  cityName
}) => {
  const [isCallConnected, setIsCallConnected] = useState(false);
  const [isMuted, setIsMuted] = useState(false);
  const [isCameraOff, setIsCameraOff] = useState(false);
  const [participants, setParticipants] = useState<Array<{id: string, name: string, avatar?: string}>>([]);
  const [zoomLoaded, setZoomLoaded] = useState(false);
  
  useEffect(() => {
    if (isOpen) {
      const timer = setTimeout(() => {
        setZoomLoaded(true);
        
        if (isGroupCall) {
          const initialParticipants = Array.from({ length: Math.floor(Math.random() * 15) + 5 }, (_, i) => ({
            id: `user-${i}`,
            name: `User ${i}`,
            avatar: `https://source.unsplash.com/random/100x100?face&${i}`
          }));
          setParticipants(initialParticipants);
          
          const participantInterval = setInterval(() => {
            if (Math.random() > 0.7) {
              const newParticipant = {
                id: `user-${participants.length + 1}`,
                name: `User ${participants.length + 1}`,
                avatar: `https://source.unsplash.com/random/100x100?face&${participants.length + 1}`
              };
              setParticipants(prev => [...prev, newParticipant]);
              
              toast({
                title: "New participant joined",
                description: `${newParticipant.name} has joined the room`
              });
            }
          }, 5000);
          
          return () => clearInterval(participantInterval);
        } else {
          setParticipants([{
            id: user.id,
            name: user.name,
            avatar: user.avatar
          }]);
        }
      }, 2000);
      
      return () => clearTimeout(timer);
    } else {
      setIsCallConnected(false);
      setZoomLoaded(false);
    }
  }, [isOpen, isGroupCall, user, participants.length]);

  const handleConnect = () => {
    setIsCallConnected(true);
    toast({
      title: isGroupCall ? "Joined Zoom Room" : "Call Connected",
      description: isGroupCall 
        ? `You've joined the ${cityName} room with ${participants.length} others` 
        : `You are now connected with ${user.name}`
    });
  };
  
  const handleDisconnect = () => {
    toast({
      title: isGroupCall ? "Left Room" : "Call Ended",
      description: isGroupCall 
        ? "You've left the Zoom room" 
        : `Call with ${user.name} ended`
    });
    onClose();
  };
  
  const toggleMute = () => {
    setIsMuted(!isMuted);
    toast({
      title: isMuted ? "Microphone Unmuted" : "Microphone Muted",
      description: isMuted ? "Others can now hear you" : "Others can no longer hear you"
    });
  };
  
  const toggleCamera = () => {
    setIsCameraOff(!isCameraOff);
    toast({
      title: isCameraOff ? "Camera Turned On" : "Camera Turned Off",
      description: isCameraOff ? "Others can now see you" : "Others can no longer see you"
    });
  };

  const getDialogTitle = () => {
    return isGroupCall 
      ? `${cityName} Zoom Room` 
      : `Call with ${user.name}`;
  };

  return (
    <Dialog open={isOpen} onOpenChange={(open) => !open && onClose()}>
      <DialogContent className="sm:max-w-md bg-black border border-[#333] p-0 overflow-hidden max-h-[90vh]">
        <div className="relative w-full h-full flex flex-col">
          <ZoomHeader 
            title={getDialogTitle()}
            participantCount={isGroupCall ? participants.length : undefined}
            capacity={isGroupCall ? capacity : undefined}
            onClose={onClose}
          />
          
          <ContentModerationBanner message={
            isGroupCall 
              ? "Drug use and solicitation are strictly prohibited in YoBro Zoom rooms. Violations will result in immediate removal." 
              : "Drug use and solicitation are strictly prohibited during video calls."
          } />
          
          <div className="flex-grow p-4 flex flex-col items-center justify-center bg-[#121212] min-h-[300px]">
            {!zoomLoaded ? (
              <ConnectingState />
            ) : !isCallConnected ? (
              <ReadyToConnectState
                title={isGroupCall ? `${cityName} Zoom Room` : user.name}
                subtitle="Ready to connect"
                avatar={user.avatar}
                isGroupCall={isGroupCall}
                participantCount={participants.length}
                onConnect={handleConnect}
              />
            ) : (
              <>
                {isGroupCall ? (
                  <ParticipantsGrid 
                    participants={participants}
                    isCameraOff={isCameraOff}
                    isMuted={isMuted}
                  />
                ) : (
                  <OneOnOneCallView 
                    user={user}
                    isCameraOff={isCameraOff}
                    isMuted={isMuted}
                  />
                )}
              </>
            )}
          </div>
          
          {isCallConnected && (
            <CallControls 
              isMuted={isMuted}
              isCameraOff={isCameraOff}
              onToggleMute={toggleMute}
              onToggleCamera={toggleCamera}
              onEndCall={handleDisconnect}
            />
          )}
        </div>
      </DialogContent>
    </Dialog>
  );
};

export default ZoomCallDialog;
