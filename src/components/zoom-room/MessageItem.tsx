
import React from 'react';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { Trash2 } from 'lucide-react';

interface MessageReaction {
  emoji: string;
  count: number;
  reacted: boolean;
}

interface MessageItemProps {
  message: {
    id: string;
    userId: string;
    userName: string;
    userImage?: string;
    userRole?: string;
    content: string;
    isImage: boolean;
    timestamp: Date;
    reactions: MessageReaction[];
    isFlagged?: boolean;
  };
  onReact: (messageId: string, emoji: string) => void;
  onDelete: (messageId: string) => void;
  formatTimestamp: (date: Date) => string;
}

const MessageItem: React.FC<MessageItemProps> = ({ message, onReact, onDelete, formatTimestamp }) => {
  const isCurrentUser = message.userId === 'current-user';
  
  return (
    <div 
      className={`flex ${isCurrentUser ? 'justify-end' : 'justify-start'}`}
    >
      <div 
        className={`max-w-[80%] p-3 rounded-lg ${
          isCurrentUser 
            ? 'bg-[#1E413C] text-white' 
            : 'bg-[#2A2A2A] text-gray-200'
        } ${message.isFlagged ? 'border border-red-500' : ''}`}
      >
        {/* Message header */}
        <div className="flex items-center mb-1">
          {!isCurrentUser && (
            <Avatar className="w-6 h-6 mr-2">
              <AvatarImage src={message.userImage} />
              <AvatarFallback className="bg-[#333] text-[#C2FFE6] text-xs">
                {message.userName.charAt(0)}
              </AvatarFallback>
            </Avatar>
          )}
          <div className="flex items-center">
            <span className="font-medium text-sm mr-1">{message.userName}</span>
            {message.userRole && (
              <span className="bg-[#333] text-[#C2FFE6] text-xs px-1 rounded">{message.userRole}</span>
            )}
          </div>
          <span className="text-xs text-gray-400 ml-auto">{formatTimestamp(message.timestamp)}</span>
        </div>
        
        {/* Message content */}
        {message.isImage ? (
          <div className="my-1 rounded-md overflow-hidden">
            <img 
              src={message.content} 
              alt="Shared" 
              className="w-full h-auto max-h-60 object-cover"
            />
          </div>
        ) : (
          <p className="text-sm mb-1">{message.content}</p>
        )}
        
        {/* Reactions */}
        <div className="flex items-center justify-between mt-2">
          <div className="flex space-x-2">
            {message.reactions.map((reaction, idx) => (
              <button 
                key={`${message.id}-${idx}`}
                onClick={() => onReact(message.id, reaction.emoji)}
                className={`flex items-center text-xs px-1.5 py-0.5 rounded-full ${
                  reaction.reacted 
                    ? 'bg-[#C2FFE6]/20 text-[#C2FFE6]' 
                    : 'bg-[#333] text-gray-300'
                } ${reaction.count === 0 && !reaction.reacted ? 'hidden' : ''}`}
              >
                <span className="mr-1">{reaction.emoji}</span>
                <span>{reaction.count}</span>
              </button>
            ))}
          </div>
          
          {isCurrentUser && (
            <button 
              onClick={() => onDelete(message.id)}
              className="text-gray-400 hover:text-red-400"
            >
              <Trash2 className="h-3.5 w-3.5" />
            </button>
          )}
        </div>
      </div>
    </div>
  );
};

export default MessageItem;
