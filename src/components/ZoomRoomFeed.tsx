
import React from 'react';
import ZoomRoomLayout from './zoom-room/ZoomRoomLayout';
import TabsContainer from './zoom-room/TabsContainer';
import { useZoomRoom } from '@/hooks/useZoomRoom';

interface ZoomRoomFeedProps {
  roomName: string;
  activeUsers: number;
  roomType?: 'local' | 'city' | 'forum';
  onBack: () => void;
}

const ZoomRoomFeed: React.FC<ZoomRoomFeedProps> = ({
  roomName,
  activeUsers,
  roomType = 'city',
  onBack
}) => {
  const {
    message,
    setMessage,
    messages,
    roomUsers,
    moderationWarning,
    setModerationWarning,
    activeTab,
    setActiveTab,
    isUserMuted,
    isUserCameraOff,
    handleSendMessage,
    handleReact,
    handleDeleteMessage,
    toggleMute,
    toggleCamera,
    getRoomSubtitle
  } = useZoomRoom({ roomName, activeUsers, roomType });

  return (
    <ZoomRoomLayout
      roomName={roomName}
      roomType={roomType}
      activeUsers={activeUsers}
      roomSubtitle={getRoomSubtitle()}
      moderationWarning={moderationWarning}
      roomUsers={roomUsers}
      onBack={onBack}
    >
      <TabsContainer
        activeTab={activeTab}
        setActiveTab={setActiveTab}
        messages={messages}
        roomUsers={roomUsers}
        roomType={roomType}
        isUserMuted={isUserMuted}
        isUserCameraOff={isUserCameraOff}
        message={message}
        setMessage={setMessage}
        handleSendMessage={handleSendMessage}
        handleReact={handleReact}
        handleDeleteMessage={handleDeleteMessage}
        toggleMute={toggleMute}
        toggleCamera={toggleCamera}
        activeUsers={activeUsers}
        clearModeratorWarning={() => setModerationWarning(null)}
      />
    </ZoomRoomLayout>
  );
};

export default ZoomRoomFeed;
