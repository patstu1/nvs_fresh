
import React from 'react';
import ParticipantGallery from './ParticipantGallery';
import MediaControls from './MediaControls';
import { RoomUser } from '@/hooks/useZoomRoom';

interface GalleryTabContentProps {
  participants: RoomUser[];
  roomType: 'local' | 'city' | 'forum';
  isUserMuted: boolean;
  isUserCameraOff: boolean;
  toggleMute: () => void;
  toggleCamera: () => void;
}

const GalleryTabContent: React.FC<GalleryTabContentProps> = ({
  participants,
  roomType,
  isUserMuted,
  isUserCameraOff,
  toggleMute,
  toggleCamera
}) => {
  return (
    <div className="h-full flex flex-col">
      <ParticipantGallery 
        participants={participants}
        roomType={roomType}
        isCurrentUserMuted={isUserMuted}
        isCurrentUserCameraOff={isUserCameraOff}
      />
      
      <MediaControls 
        isUserMuted={isUserMuted}
        isUserCameraOff={isUserCameraOff}
        toggleMute={toggleMute}
        toggleCamera={toggleCamera}
      />
    </div>
  );
};

export default GalleryTabContent;
