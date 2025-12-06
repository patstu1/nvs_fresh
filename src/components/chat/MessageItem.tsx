
import React from 'react';
import { format } from 'date-fns';
import { MapPin, Volume2 } from 'lucide-react';
import { cn } from '@/lib/utils';

interface MessageItemProps {
  message: {
    id: string;
    content: string;
    sent_at: string;
    read_at: string | null;
    message_type: 'text' | 'image' | 'location' | 'emoji' | 'yo' | 'voice' | 'video';
    media_url?: string;
    location_data?: {
      latitude: number;
      longitude: number;
      address?: string;
    };
  };
  isOwnMessage: boolean;
  sectionOrigin?: 'grid' | 'now' | 'connect' | 'live' | 'unknown';
}

const MessageItem = ({ message, isOwnMessage, sectionOrigin = 'unknown' }: MessageItemProps) => {
  const formatMessageTime = (timestamp: string) => {
    return format(new Date(timestamp), 'p');
  };

  const getStatusIcon = (message: MessageItemProps['message']) => {
    if (!message) return '✓';
    if (message.read_at) return '✓✓';
    return '✓';
  };

  // Define section-specific styling
  const getSectionStyling = () => {
    switch (sectionOrigin) {
      case 'grid':
        return {
          own: 'bg-[#0066FF] text-white rounded-br-none', // Neon Blue
          other: 'bg-[#2A2A2A] text-white rounded-bl-none'
        };
      case 'now':
        return {
          own: 'bg-[#FF3366] text-white rounded-br-none', // Neon Red
          other: 'bg-[#2A2A2A] text-white rounded-bl-none'
        };
      case 'connect':
        return {
          own: 'bg-[#33FF99] text-black rounded-br-none', // Neon Green
          other: 'bg-[#2A2A2A] text-white rounded-bl-none'
        };
      case 'live':
        return {
          own: 'bg-[#9933FF] text-white rounded-br-none', // Neon Purple
          other: 'bg-[#2A2A2A] text-white rounded-bl-none'
        };
      default:
        return {
          own: 'bg-yobro-blue text-white rounded-br-none',
          other: 'bg-[#2A2A2A] text-white rounded-bl-none'
        };
    }
  };
  
  const styles = getSectionStyling();

  return (
    <div className={`mb-4 flex ${isOwnMessage ? 'justify-end' : 'justify-start'}`}>
      <div
        className={`max-w-[70%] rounded-lg p-3 ${
          isOwnMessage ? styles.own : styles.other
        }`}
      >
        {message.message_type === 'image' && (
          <img 
            src={message.content || message.media_url} 
            alt="Shared image" 
            className="rounded-md w-full h-auto mb-1"
          />
        )}
        
        {message.message_type === 'location' && (
          <div className="flex items-center mb-2">
            <MapPin className="w-4 h-4 mr-1" />
            <span className="text-sm">Location shared</span>
          </div>
        )}
        
        {message.message_type === 'yo' && (
          <div className="flex items-center justify-center bg-black/20 rounded p-2 mb-1">
            <span className="text-lg font-bold">YO!</span>
          </div>
        )}
        
        {message.message_type === 'voice' && (
          <div className="flex items-center mb-1">
            <Volume2 className="w-4 h-4 mr-1" />
            <span className="text-sm">Voice message</span>
          </div>
        )}
        
        {message.message_type === 'text' && (
          <p className="text-sm">{message.content}</p>
        )}
        
        {message.message_type === 'emoji' && (
          <p className="text-2xl">{message.content}</p>
        )}
        
        <div className="flex justify-end items-center mt-1">
          <span className="text-xs opacity-70">
            {formatMessageTime(message.sent_at)}
          </span>
          {isOwnMessage && (
            <span className="text-xs ml-1">
              {getStatusIcon(message)}
            </span>
          )}
        </div>
      </div>
    </div>
  );
};

export default MessageItem;
