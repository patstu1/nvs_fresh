
import React from 'react';
import MessageFeed from './MessageFeed';
import { RoomMessage } from '@/hooks/useZoomRoom';

interface ChatTabContentProps {
  messages: RoomMessage[];
  onReact: (messageId: string, emoji: string) => void;
  onDelete: (messageId: string) => void;
}

const ChatTabContent: React.FC<ChatTabContentProps> = ({
  messages,
  onReact,
  onDelete
}) => {
  return (
    <MessageFeed 
      messages={messages}
      onReact={onReact}
      onDelete={onDelete}
    />
  );
};

export default ChatTabContent;
