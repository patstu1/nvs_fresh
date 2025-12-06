import React, { useState } from 'react';
import { Button } from '@/components/ui/button';
import { Dialog, DialogContent } from '@/components/ui/dialog';
import { Badge } from '@/components/ui/badge';
import { Lock, X, MessageCircle, Video, TrendingUp, Heart, Images, UserX, Flag, EyeOff } from 'lucide-react';
import { toast } from '@/hooks/use-toast';
import soundManager from '@/utils/soundManager';
import { useNavigate } from 'react-router-dom';
import BlurrableImage from './BlurrableImage';
import { TabType } from '@/types/TabTypes';

interface User {
  id: string;
  name: string;
  age: number;
  height: string;
  weight: string;
  image: string;
  distance: string;
  lastActive: string;
  privateAlbum: boolean;
  compatibilityScore?: number;
  emojis: string[];
  privateAlbumCount?: number;
  explicitMainPhoto?: boolean;
  isBlocked?: boolean;
}

interface UserProfileDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  user: User | null;
  onViewProfile: (userId: string) => void;
  onStartChat: (userId: string) => void;
  onRequestPrivateAlbum?: (userId: string) => void;
  onReportProfile?: (userId: string) => void;
  blurImages?: boolean;
  activeSection?: TabType;
}

const UserProfileDialog: React.FC<UserProfileDialogProps> = ({ 
  open, 
  onOpenChange, 
  user, 
  onViewProfile,
  onStartChat,
  onRequestPrivateAlbum,
  onReportProfile,
  blurImages = false,
  activeSection = 'grid'
}) => {
  const [privateAlbumRequested, setPrivateAlbumRequested] = useState(false);
  const navigate = useNavigate();
  
  const formatTime = (timeStr: string) => {
    if (!timeStr) return '';
    if (timeStr === 'now') return 'just now';
    return `${timeStr} ago`;
  };

  const handleSendYo = () => {
    if (!user) return;
    
    try {
      soundManager.play('yo');
      toast({
        title: "YO!",
        description: `You sent a YO to ${user.name}!`,
      });
    } catch (error) {
      console.error('Error playing YO sound:', error);
      toast({
        title: "YO!",
        description: `You sent a YO to ${user.name}! (sound unavailable)`,
      });
    }
  };
  
  const handleRequestPrivateAlbum = () => {
    if (!user || !onRequestPrivateAlbum) return;
    
    setPrivateAlbumRequested(true);
    onRequestPrivateAlbum(user.id);
    
    toast({
      title: "Request Sent",
      description: `Your request for ${user.name}'s XXX album was sent`
    });
  };

  const handleStartChat = () => {
    if (!user) return;
    onStartChat(user.id);
    navigate(`/messages/${user.id}?origin_section=map`);
  };

  const handleBlockUser = () => {
    if (!user) return;
    
    toast({
      title: "User Blocked",
      description: `${user.name} has been blocked`,
      variant: "destructive",
    });
    
    onOpenChange(false);
  };
  
  const handleReportProfile = () => {
    if (!user) return;
    
    if (onReportProfile) {
      onReportProfile(user.id);
    } else {
      toast({
        title: "Profile Reported",
        description: "Thank you for your report. Our team will review this profile.",
        variant: "destructive",
      });
    }
  };

  const getSectionLabel = () => {
    switch (activeSection) {
      case 'grid': return 'GRID';
      case 'map': return 'NOW';
      case 'connect': return 'CONNECT';
      case 'rooms': return 'LIVE';
      default: return '';
    }
  };

  if (!user) return null;
  
  const displayName = user.name === 'Anonymous' ? 'Anonymous' : user.name;

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="bg-black border border-[#E6FFF4]/30 text-white max-w-md p-0 overflow-hidden">
        <div className="relative w-full h-72">
          {blurImages ? (
            <BlurrableImage
              src={user.image}
              alt={displayName}
              className="w-full h-full"
              onReportProfile={() => handleReportProfile()}
            />
          ) : (
            <img src={user.image} alt={displayName} className="w-full h-full object-cover" />
          )}
          
          <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-transparent" />
          
          <div className="absolute bottom-4 left-4 right-4">
            <div className="flex justify-between items-end">
              <div>
                <h2 className="text-2xl font-bold text-white">
                  {displayName}
                  {user.age && displayName !== 'Anonymous' && <span>, {user.age}</span>}
                </h2>
                <div className="flex items-center">
                  <p className="text-sm text-white/80">{user.distance}km away</p>
                  <div className="w-1 h-1 rounded-full bg-white/30 mx-2"></div>
                  <p className="text-sm text-white/80">Active {formatTime(user.lastActive)}</p>
                </div>
              </div>
              
              <div className="flex flex-col gap-1 items-end">
                <Badge className="bg-[#FF3366] text-white">
                  Anonymous
                </Badge>
                
                {user.privateAlbum && (
                  <Badge className="bg-[#E6FFF4] text-black">
                    <Lock className="w-3 h-3 mr-1" />
                    XXX Album ({user.privateAlbumCount || "5"})
                  </Badge>
                )}
                
                {user.explicitMainPhoto && (
                  <Badge className="bg-[#FF3366] text-white">
                    <Heart className="w-3 h-3 mr-1" />
                    XXX
                  </Badge>
                )}
              </div>
            </div>
          </div>
          
          <Button
            variant="ghost"
            size="icon"
            className="absolute top-2 right-2 text-white bg-black/50 rounded-full"
            onClick={() => onOpenChange(false)}
          >
            <X className="w-5 h-5" />
          </Button>
        </div>
        
        <div className="p-4">
          <div className="flex justify-between items-center mb-4">
            <div>
              <h3 className="font-medium">Stats</h3>
              <p className="text-sm text-white/70">{user.height} • {user.weight}</p>
              <div className="flex gap-1 mt-1">
                {user.emojis.map((emoji, idx) => (
                  <span key={idx} className="text-lg">{emoji}</span>
                ))}
              </div>
            </div>
            
            <div className="flex space-x-2">
              <Button
                size="sm"
                variant="outline"
                className="border-[#FDE1D3]/30 text-[#FDE1D3]"
                onClick={handleSendYo}
              >
                <TrendingUp className="w-4 h-4 mr-1" />
                YO!
              </Button>

              <Button 
                size="sm" 
                variant="outline" 
                className="border-[#E6FFF4]/30 text-[#E6FFF4]"
                onClick={handleStartChat}
              >
                <MessageCircle className="w-4 h-4 mr-1" />
                Chat
              </Button>
            </div>
          </div>
          
          {user.privateAlbum && (
            <div className="bg-[#1A1A1A] p-3 mb-4 rounded-md border border-[#E6FFF4]/10">
              <div className="flex justify-between items-center">
                <div>
                  <p className="text-sm text-[#E6FFF4] font-medium">XXX Album Available</p>
                  <p className="text-xs text-[#E6FFF4]/70 mt-1">
                    This user has a private album with explicit content ({user.privateAlbumCount || 5} photos)
                  </p>
                </div>
                <Button 
                  size="sm" 
                  className={`${privateAlbumRequested ? 'bg-[#1A1A1A] border border-[#E6FFF4]/30 text-[#E6FFF4]/50' : 'bg-[#E6FFF4] text-black hover:bg-[#E6FFF4]/90'}`}
                  onClick={handleRequestPrivateAlbum}
                  disabled={privateAlbumRequested}
                >
                  {privateAlbumRequested ? (
                    <>Requested</>
                  ) : (
                    <>
                      <Images className="w-3.5 h-3.5 mr-1" />
                      Request
                    </>
                  )}
                </Button>
              </div>
            </div>
          )}
          
          <div className="flex justify-between mt-4">
            <Button
              onClick={() => onViewProfile(user.id)}
              variant="ghost"
              className="text-white/70 hover:text-white"
            >
              View Full Profile
            </Button>
            
            <div className="flex space-x-2">
              <Button
                onClick={handleReportProfile}
                variant="outline"
                className="text-red-400 border-red-400/30 hover:bg-red-400/10"
              >
                <Flag className="w-4 h-4 mr-1" />
                Report
              </Button>
              
              <Button
                onClick={handleBlockUser}
                variant="outline"
                className="text-red-500 border-red-500/30 hover:bg-red-500/10"
              >
                <UserX className="w-4 h-4 mr-1" />
                Block
              </Button>
            </div>
          </div>
        </div>
      </DialogContent>
    </Dialog>
  );
};

export default UserProfileDialog;
