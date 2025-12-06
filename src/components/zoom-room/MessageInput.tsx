
import React from 'react';
import { Input } from '@/components/ui/input';
import { Button } from '@/components/ui/button';
import { Send, Image, Users } from 'lucide-react';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';

interface MessageInputProps {
  message: string;
  onMessageChange: (message: string) => void;
  onSend: () => void;
  activeUsers: number;
  clearModeratorWarning?: () => void;
}

const MessageInput: React.FC<MessageInputProps> = ({ 
  message, 
  onMessageChange, 
  onSend, 
  activeUsers,
  clearModeratorWarning
}) => {
  return (
    <div className="p-3 border-t border-[#333] bg-[#1A1A1A] absolute bottom-0 left-0 right-0">
      <div className="flex items-center">
        <Avatar className="w-8 h-8 mr-2">
          <AvatarImage src="/placeholder.svg" />
          <AvatarFallback className="bg-[#333] text-[#C2FFE6]">Y</AvatarFallback>
        </Avatar>
        
        <div className="flex-1 relative flex items-center bg-[#2A2A2A] rounded-full pr-2">
          <Input 
            type="text"
            value={message}
            onChange={(e) => {
              onMessageChange(e.target.value);
              if (clearModeratorWarning) {
                clearModeratorWarning();
              }
            }}
            placeholder="Type a message..."
            className="flex-1 border-none bg-transparent focus-visible:ring-0 focus-visible:ring-offset-0"
            onKeyDown={(e) => {
              if (e.key === 'Enter') onSend();
            }}
          />
          
          <div className="flex items-center">
            <Button 
              variant="ghost" 
              size="icon" 
              className="h-8 w-8 text-gray-400 hover:text-[#C2FFE6]"
            >
              <Image className="h-4 w-4" />
            </Button>
            
            <Button
              variant="ghost" 
              size="icon"
              className="h-8 w-8 text-gray-400 hover:text-[#C2FFE6]"
              onClick={onSend}
              disabled={!message.trim()}
            >
              <Send className="h-4 w-4" />
            </Button>
          </div>
        </div>
      </div>
      
      <div className="flex justify-center mt-2">
        <div className="flex items-center text-xs text-gray-400 bg-[#2A2A2A] rounded-full px-2 py-0.5">
          <Users className="h-3 w-3 mr-1" />
          <span>In a room with {activeUsers} bros</span>
        </div>
      </div>
    </div>
  );
};

export default MessageInput;
