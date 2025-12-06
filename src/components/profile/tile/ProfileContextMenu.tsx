
import React from 'react';
import {
  ContextMenu,
  ContextMenuContent,
  ContextMenuItem,
  ContextMenuTrigger,
} from "@/components/ui/context-menu";
import { Heart, Lock, TrendingUp, Users } from 'lucide-react';
import { toast } from '@/hooks/use-toast';

interface ProfileContextMenuProps {
  children: React.ReactNode;
  name: string;
  onProfileClick: (id: string) => void;
  onSendYo: () => void;
  onRequestPrivateAlbum?: () => void;
  id: string;
  hasPrivateAlbum?: boolean;
  privateAlbumCount?: number;
  compatibilityScore?: number;
}

export const ProfileContextMenu: React.FC<ProfileContextMenuProps> = ({
  children,
  name,
  onProfileClick,
  onSendYo,
  onRequestPrivateAlbum,
  id,
  hasPrivateAlbum,
  privateAlbumCount,
  compatibilityScore
}) => {
  return (
    <ContextMenu>
      <ContextMenuTrigger>{children}</ContextMenuTrigger>
      
      <ContextMenuContent className="bg-black border border-[#C2FFE6]/30 text-[#C2FFE6] shadow-[0_0_5px_rgba(194,255,230,0.2)]">
        <ContextMenuItem 
          onClick={() => onProfileClick(id)}
          className="cursor-pointer hover:bg-[#C2FFE6]/10"
        >
          View Profile
        </ContextMenuItem>
        
        <ContextMenuItem 
          className="cursor-pointer hover:bg-[#C2FFE6]/10"
          onClick={onSendYo}
        >
          <TrendingUp className="w-4 h-4 mr-2 text-[#FDE1D3]" />
          <span>Send YO!</span>
        </ContextMenuItem>
        
        {hasPrivateAlbum && (
          <ContextMenuItem 
            className="cursor-pointer hover:bg-[#C2FFE6]/10"
            onClick={onRequestPrivateAlbum}
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
