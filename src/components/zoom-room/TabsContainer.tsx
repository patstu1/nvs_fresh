
import React from 'react';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import ChatTabContent from './ChatTabContent';
import GalleryTabContent from './GalleryTabContent';
import MessageInput from './MessageInput';
import { RoomMessage, RoomUser } from '@/hooks/useZoomRoom';

interface TabsContainerProps {
  activeTab: string;
  setActiveTab: (tab: string) => void;
  messages: RoomMessage[];
  roomUsers: RoomUser[];
  roomType: 'local' | 'city' | 'forum';
  isUserMuted: boolean;
  isUserCameraOff: boolean;
  message: string;
  setMessage: (message: string) => void;
  handleSendMessage: () => void;
  handleReact: (messageId: string, emoji: string) => void;
  handleDeleteMessage: (messageId: string) => void;
  toggleMute: () => void;
  toggleCamera: () => void;
  activeUsers: number;
  clearModeratorWarning: () => void;
}

const TabsContainer: React.FC<TabsContainerProps> = ({
  activeTab,
  setActiveTab,
  messages,
  roomUsers,
  roomType,
  isUserMuted,
  isUserCameraOff,
  message,
  setMessage,
  handleSendMessage,
  handleReact,
  handleDeleteMessage,
  toggleMute,
  toggleCamera,
  activeUsers,
  clearModeratorWarning
}) => {
  return (
    <>
      <Tabs value={activeTab} onValueChange={setActiveTab} className="w-full flex-grow flex flex-col">
        <TabsList className="grid grid-cols-2 mx-4">
          <TabsTrigger value="chat">Chat</TabsTrigger>
          <TabsTrigger value="gallery">Gallery View</TabsTrigger>
        </TabsList>
        
        <TabsContent value="chat" className="flex-grow flex flex-col">
          <ChatTabContent 
            messages={messages}
            onReact={handleReact}
            onDelete={handleDeleteMessage}
          />
        </TabsContent>
        
        <TabsContent value="gallery" className="flex-grow">
          <GalleryTabContent 
            participants={roomUsers}
            roomType={roomType}
            isUserMuted={isUserMuted}
            isUserCameraOff={isUserCameraOff}
            toggleMute={toggleMute}
            toggleCamera={toggleCamera}
          />
        </TabsContent>
      </Tabs>
      
      {activeTab === 'chat' && (
        <MessageInput 
          message={message}
          onMessageChange={setMessage}
          onSend={handleSendMessage}
          activeUsers={activeUsers}
          clearModeratorWarning={clearModeratorWarning}
        />
      )}
    </>
  );
};

export default TabsContainer;
