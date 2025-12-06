
import React, { ReactNode } from 'react';
import RoomHeader from './RoomHeader';
import UserAvatarBar from './UserAvatarBar';
import ContentModerationBanner from '../ContentModerationBanner';
import ModerationWarning from './ModerationWarning';
import { RoomUser } from '@/hooks/useZoomRoom';

interface ZoomRoomLayoutProps {
  roomName: string;
  roomType: 'local' | 'city' | 'forum';
  activeUsers: number;
  roomSubtitle: string;
  moderationWarning: string | null;
  roomUsers: RoomUser[];
  onBack: () => void;
  children: ReactNode;
}

const ZoomRoomLayout: React.FC<ZoomRoomLayoutProps> = ({
  roomName,
  roomType,
  activeUsers,
  roomSubtitle,
  moderationWarning,
  roomUsers,
  onBack,
  children
}) => {
  return (
    <div className="flex flex-col h-full pb-20">
      <RoomHeader 
        roomName={roomName}
        roomType={roomType}
        subtitle={roomSubtitle}
        activeUsers={activeUsers}
        onBack={onBack}
      />
      
      <ContentModerationBanner 
        message="This room is AI-moderated. Drug solicitation and inappropriate content are prohibited."
      />
      
      <ModerationWarning message={moderationWarning} />
      
      <UserAvatarBar users={roomUsers} />
      
      {children}
    </div>
  );
};

export default ZoomRoomLayout;
