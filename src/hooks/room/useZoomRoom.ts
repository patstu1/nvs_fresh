
import { useState } from 'react';
import { useMessageHandling } from './useMessageHandling';
import { useRoomUsers } from './useRoomUsers';
import { useMockMessages } from './useMockMessages';
import { useMediaControls } from './useMediaControls';
import { useRoomMetadata } from './useRoomMetadata';
import { UseZoomRoomOptions } from './types';

export function useZoomRoom({ roomName, activeUsers, roomType = 'city' }: UseZoomRoomOptions) {
  const [activeTab, setActiveTab] = useState<string>('chat');
  
  const {
    message,
    setMessage,
    messages,
    setMessages,
    moderationWarning,
    setModerationWarning,
    handleSendMessage,
    handleReact,
    handleDeleteMessage
  } = useMessageHandling();

  const { roomUsers } = useRoomUsers(activeUsers, roomType, roomName);
  
  // Generate mock messages
  useMockMessages(roomUsers, roomType, roomName, setMessages);
  
  const {
    isUserMuted,
    isUserCameraOff,
    toggleMute,
    toggleCamera
  } = useMediaControls();
  
  const { getRoomSubtitle } = useRoomMetadata(roomType);

  return {
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
  };
}
