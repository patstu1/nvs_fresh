
import React from 'react';
import { cn } from '@/lib/utils';
import { Heart, Users, TrendingUp, Lock, Eye } from 'lucide-react';
import {
  ContextMenu,
  ContextMenuContent,
  ContextMenuItem,
  ContextMenuTrigger,
} from "@/components/ui/context-menu";
import { toast } from '@/hooks/use-toast';
import { UserProfile } from '@/types/UserProfile';
import soundManager from '@/utils/soundManager';

interface UserProfileTileProps {
  id: string;
  image: string;
  name: string;
  age?: number;
  emojis: string[];
  distance: number;
  lastActive?: string;
  onProfileClick: (id: string) => void;
  theme?: 'default' | 'cyberpunk';
  compatibilityScore?: number; // Score between 0-100
  hasPrivateAlbum?: boolean;
  isAnonymous?: boolean;
  explicitMainPhoto?: boolean;
  privateAlbumCount?: number;
  onRequestPrivateAlbum?: (id: string) => void;
}

const UserProfileTile: React.FC<UserProfileTileProps> = ({
  id,
  image,
  name,
  age,
  emojis,
  distance,
  lastActive,
  onProfileClick,
  theme = 'default',
  compatibilityScore,
  hasPrivateAlbum,
  isAnonymous,
  explicitMainPhoto,
  privateAlbumCount,
  onRequestPrivateAlbum
}) => {
  const handleProfileClick = () => {
    const viewHistory = JSON.parse(localStorage.getItem('profileViewHistory') || '[]');
    const currentTime = new Date().toISOString();
    
    const newView = {
      id,
      name,
      image,
      timestamp: currentTime
    };
    
    const filteredHistory = viewHistory.filter((view: any) => view.id !== id);
    
    const updatedHistory = [newView, ...filteredHistory];
    
    const trimmedHistory = updatedHistory.slice(0, 20);
    
    localStorage.setItem('profileViewHistory', JSON.stringify(trimmedHistory));
    
    onProfileClick(id);
  };

  const handleSendYo = () => {
    try {
      soundManager.play('yo');
      
      toast({
        title: "YO!",
        description: `You sent a YO to ${name}!`,
      });
    } catch (error) {
      console.error('Error playing YO sound:', error);
      toast({
        title: "YO!",
        description: `You sent a YO to ${name}! (sound unavailable)`,
      });
    }
  };
  
  const handleRequestPrivateAlbum = () => {
    if (onRequestPrivateAlbum) {
      onRequestPrivateAlbum(id);
    } else {
      toast({
        title: "Private Album",
        description: `Requesting access to ${name}'s private album`
      });
    }
  };

  const getCyberpunkStyles = () => {
    const baseStyles = "relative aspect-square overflow-hidden rounded-lg cursor-pointer border-2 transition-all duration-300 hover:scale-105";
    
    const themeStyles = {
      cyberpunk: cn(
        baseStyles,
        "border-[#C2FFE6] shadow-[0_0_3px_rgba(194,255,230,0.3),0_0_3px_rgba(170,255,80,0.2),inset_0_0_2px_rgba(194,255,230,0.2)]",
        "bg-gradient-to-b from-black via-black to-black"
      ),
      default: baseStyles
    };

    return themeStyles[theme];
  };

  const getProfileIndicators = () => {
    const indicators = [];
    
    // Heart icon for cyberpunk theme
    if (theme === 'cyberpunk') {
      indicators.push(
        <div key="cyberpunk-heart" className="absolute top-2 right-2 w-8 h-8 rounded-full border-2 border-[#AAFF50]/70 bg-black flex items-center justify-center"
             style={{ boxShadow: '0 0 3px rgba(170, 255, 80, 0.3), 0 0 3px rgba(194, 255, 230, 0.2), inset 0 0 2px rgba(170, 255, 80, 0.2)' }}>
          <Heart 
            className="w-4 h-4 text-[#AAFF50]" 
            fill="rgba(170, 255, 80, 0.3)" 
            strokeWidth={1.5} 
          />
        </div>
      );
    }
    
    // Anonymous icon
    if (isAnonymous) {
      indicators.push(
        <div key="anonymous" className="absolute top-2 left-2 bg-black/70 backdrop-blur-sm px-2 py-1 rounded-full">
          <Eye className="w-3.5 h-3.5 text-[#E6FFF4]" />
        </div>
      );
    }
    
    // Compatibility score
    if (compatibilityScore !== undefined) {
      indicators.push(
        <div key="compatibility" className="absolute top-2 left-2 bg-black/50 backdrop-blur-sm px-2 py-1 rounded-full">
          <span className="text-xs font-medium text-[#C2FFE6]">{compatibilityScore}%</span>
        </div>
      );
    }
    
    // Private album indicator
    if (hasPrivateAlbum) {
      indicators.push(
        <div key="private-album" className={`absolute ${isAnonymous ? 'top-9' : 'top-2'} ${compatibilityScore !== undefined ? 'left-12' : 'left-2'} bg-[#E6FFF4] rounded-full w-5 h-5 flex items-center justify-center`}>
          <Lock className="w-3 h-3 text-black" />
        </div>
      );
    }
    
    // Explicit main photo indicator
    if (explicitMainPhoto) {
      indicators.push(
        <div key="explicit-photo" className="absolute top-2 right-2 bg-[#FF3366] rounded-full px-1.5 py-0.5 flex items-center">
          <span className="text-[10px] font-bold text-white">XXX</span>
        </div>
      );
    }
    
    return indicators;
  };

  return (
    <ContextMenu>
      <ContextMenuTrigger>
        <div 
          className={getCyberpunkStyles()}
          onClick={handleProfileClick}
        >
          {getProfileIndicators()}
          
          <img 
            src={image} 
            alt={name}
            className="w-full h-full object-cover" 
          />
          
          <div className="absolute bottom-0 left-0 right-0 p-2 bg-gradient-to-t from-black to-transparent">
            <div className="flex flex-col items-start justify-center">
              <div className="flex items-center text-[#C2FFE6]">
                <div className="flex items-center">
                  <span className="font-medium text-[14px]">{isAnonymous ? "Anonymous" : name}</span>
                  {age && !isAnonymous && <span className="font-medium text-[14px] ml-1">, {age}</span>}
                  
                  {lastActive === 'Online' && (
                    <div className="ml-1 w-1.5 h-1.5 rounded-full bg-green-500 animate-pulse" 
                         style={{ boxShadow: '0 0 4px #4ADE80' }} />
                  )}
                </div>
              </div>
            </div>
          </div>
        </div>
      </ContextMenuTrigger>
      
      <ContextMenuContent className="bg-black border border-[#C2FFE6]/30 text-[#C2FFE6] shadow-[0_0_5px_rgba(194,255,230,0.2)]">
        <ContextMenuItem 
          onClick={() => onProfileClick(id)}
          className="cursor-pointer hover:bg-[#C2FFE6]/10"
        >
          View Profile
        </ContextMenuItem>
        
        <ContextMenuItem 
          className="cursor-pointer hover:bg-[#C2FFE6]/10"
          onClick={handleSendYo}
        >
          <TrendingUp className="w-4 h-4 mr-2 text-[#FDE1D3]" />
          <span>Send YO!</span>
        </ContextMenuItem>
        
        {hasPrivateAlbum && (
          <ContextMenuItem 
            className="cursor-pointer hover:bg-[#C2FFE6]/10"
            onClick={handleRequestPrivateAlbum}
          >
            <Lock className="w-4 h-4 mr-2 text-[#E6FFF4]" />
            <span>Request XXX Album ({privateAlbumCount || 5})</span>
          </ContextMenuItem>
        )}
        
        {compatibilityScore !== undefined && (
          <ContextMenuItem 
            className="cursor-pointer hover:bg-[#C2FFE6]/10"
            onClick={() => toast({
              title: "AI Connect",
              description: `You have a ${compatibilityScore}% compatibility with ${name}`
            })}
          >
            <Heart className="w-4 h-4 mr-2 text-[#C2FFE6]" />
            <span>AI Connect: {compatibilityScore}%</span>
          </ContextMenuItem>
        )}
        
        <ContextMenuItem 
          className="cursor-pointer hover:bg-[#C2FFE6]/10"
          onClick={() => toast({
            title: "YoBro Pro",
            description: "Upgrade to YoBro Pro to access premium features"
          })}
        >
          <Users className="w-4 h-4 mr-2 text-[#AAFF50]" />
          <span>YoBro Pro</span>
        </ContextMenuItem>
      </ContextMenuContent>
    </ContextMenu>
  );
};

export default UserProfileTile;
