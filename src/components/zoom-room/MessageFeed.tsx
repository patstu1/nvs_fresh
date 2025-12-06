
import React, { useRef, useEffect } from 'react';
import { ScrollArea } from '@/components/ui/scroll-area';
import MessageItem from './MessageItem';

interface RoomMessage {
  id: string;
  userId: string;
  userName: string;
  userImage?: string;
  userRole?: string;
  content: string;
  isImage: boolean;
  timestamp: Date;
  reactions: {
    emoji: string;
    count: number;
    reacted: boolean;
  }[];
  isFlagged?: boolean;
}

interface MessageFeedProps {
  messages: RoomMessage[];
  onReact: (messageId: string, emoji: string) => void;
  onDelete: (messageId: string) => void;
}

const MessageFeed: React.FC<MessageFeedProps> = ({ messages, onReact, onDelete }) => {
  const scrollAreaRef = useRef<HTMLDivElement>(null);
  
  // Format timestamps
  const formatTimestamp = (date: Date) => {
    const now = new Date();
    const diffMs = now.getTime() - date.getTime();
    const diffMins = Math.floor(diffMs / 60000);
    
    if (diffMins < 1) return 'just now';
    if (diffMins < 60) return `${diffMins}m ago`;
    
    const diffHrs = Math.floor(diffMins / 60);
    if (diffHrs < 24) return `${diffHrs}h ago`;
    
    return date.toLocaleDateString();
  };

  // Scroll to bottom when messages change
  useEffect(() => {
    if (scrollAreaRef.current) {
      const scrollContainer = scrollAreaRef.current.querySelector('[data-radix-scroll-area-viewport]');
      if (scrollContainer) {
        scrollContainer.scrollTop = scrollContainer.scrollHeight;
      }
    }
  }, [messages]);

  return (
    <ScrollArea className="flex-1" ref={scrollAreaRef}>
      <div className="p-4 space-y-4">
        {messages.map(msg => (
          <MessageItem 
            key={msg.id}
            message={msg}
            onReact={onReact}
            onDelete={onDelete}
            formatTimestamp={formatTimestamp}
          />
        ))}
      </div>
    </ScrollArea>
  );
};

export default MessageFeed;
