
import React from 'react';
import { ArrowLeft, MoreVertical, Video, User, Trash2, UserX, Clock } from 'lucide-react';
import { cn } from '@/lib/utils';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Avatar, AvatarImage, AvatarFallback } from "@/components/ui/avatar";
import { ChatOriginSection } from '@/services/chat/types';

interface ChatHeaderProps {
  otherUser: {
    id?: string;
    name: string;
    avatar?: string;
    isOnline?: boolean;
    lastActive?: string;
  } | null;
  onBack: () => void;
  isBlocked: boolean;
  onStartVideoCall: () => void;
  onToggleOptions: (show: boolean) => void;
  showOptions: boolean;
  onBlockUser: () => void;
  onNavigateToProfile: (userId: string) => void;
  sectionOrigin?: ChatOriginSection;
}

const ChatHeader: React.FC<ChatHeaderProps> = ({
  otherUser,
  onBack,
  isBlocked,
  onStartVideoCall,
  onToggleOptions,
  showOptions,
  onBlockUser,
  onNavigateToProfile,
  sectionOrigin = 'unknown'
}) => {
  const getSectionStyling = () => {
    switch (sectionOrigin) {
      case 'grid':
        return {
          bg: 'bg-[#0066FF]',
          border: 'border-[#0066FF]/50',
          text: 'text-white',
          glow: 'shadow-[0_0_10px_rgba(0,102,255,0.5)]'
        };
      case 'now':
        return {
          bg: 'bg-[#FF3366]',
          border: 'border-[#FF3366]/50',
          text: 'text-white',
          glow: 'shadow-[0_0_10px_rgba(255,51,102,0.5)]'
        };
      case 'connect':
        return {
          bg: 'bg-[#33FF99]',
          border: 'border-[#33FF99]/50',
          text: 'text-black',
          glow: 'shadow-[0_0_10px_rgba(51,255,153,0.5)]'
        };
      case 'live':
        return {
          bg: 'bg-[#9933FF]',
          border: 'border-[#9933FF]/50',
          text: 'text-white',
          glow: 'shadow-[0_0_10px_rgba(153,51,255,0.5)]'
        };
      default:
        return {
          bg: 'bg-black',
          border: 'border-[#9DE134]/50',
          text: 'text-white',
          glow: ''
        };
    }
  };

  const styles = getSectionStyling();

  return (
    <div 
      className={`fixed top-0 left-0 right-0 ${styles.bg} ${styles.text} backdrop-blur-lg z-40 border-b ${styles.border} ${styles.glow}`}
      style={{ 
        WebkitBackdropFilter: 'blur(12px)',
        paddingTop: 'env(safe-area-inset-top)'
      }}
    >
      <div className="flex items-center justify-between h-16 px-4">
        <div className="flex items-center">
          <button onClick={onBack} className="mr-2 p-1">
            <ArrowLeft className="w-6 h-6" />
          </button>
          
          {otherUser ? (
            <div className="flex items-center" onClick={() => otherUser.id && onNavigateToProfile(otherUser.id)}>
              <Avatar className="h-9 w-9 border border-white/30 mr-3">
                <AvatarImage src={otherUser.avatar} />
                <AvatarFallback className="bg-yobro-dark text-gray-300">
                  {otherUser.name.charAt(0).toUpperCase()}
                </AvatarFallback>
              </Avatar>
              
              <div>
                <div className="font-medium">{otherUser.name}</div>
                <div className="text-xs flex items-center">
                  {otherUser.isOnline ? (
                    <>
                      <div className="w-2 h-2 bg-green-400 rounded-full mr-1"></div>
                      Online
                    </>
                  ) : (
                    <>
                      <Clock className="w-3 h-3 mr-1" />
                      {otherUser.lastActive || 'Recently'}
                    </>
                  )}
                </div>
              </div>
            </div>
          ) : (
            <div className="flex items-center">
              <div className="w-9 h-9 bg-yobro-dark rounded-full mr-3 flex items-center justify-center">
                <User className="w-5 h-5 text-gray-400" />
              </div>
              <div className="font-medium">Loading...</div>
            </div>
          )}
        </div>
        
        <div className="flex items-center space-x-2">
          <button 
            onClick={onStartVideoCall}
            className={`p-2 rounded-full ${isBlocked ? 'opacity-50' : ''}`}
            disabled={isBlocked}
          >
            <Video className="w-5 h-5" />
          </button>
          
          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <button 
                onClick={() => onToggleOptions(!showOptions)}
                className="p-2 rounded-full"
              >
                <MoreVertical className="w-5 h-5" />
              </button>
            </DropdownMenuTrigger>
            <DropdownMenuContent 
              align="end" 
              className="bg-[#1A1A1A] border border-gray-800 text-white"
            >
              <DropdownMenuItem 
                onClick={() => otherUser && otherUser.id && onNavigateToProfile(otherUser.id)}
                className="cursor-pointer hover:bg-[#2A2A2A]"
              >
                <User className="w-4 h-4 mr-2" />
                View Profile
              </DropdownMenuItem>
              <DropdownMenuItem 
                onClick={onBlockUser}
                className="cursor-pointer hover:bg-[#2A2A2A]"
              >
                <UserX className="w-4 h-4 mr-2" />
                {isBlocked ? 'Unblock User' : 'Block User'}
              </DropdownMenuItem>
              <DropdownMenuItem 
                className="cursor-pointer hover:bg-[#2A2A2A] text-red-400"
              >
                <Trash2 className="w-4 h-4 mr-2" />
                Delete Conversation
              </DropdownMenuItem>
            </DropdownMenuContent>
          </DropdownMenu>
        </div>
      </div>
    </div>
  );
};

export default ChatHeader;
