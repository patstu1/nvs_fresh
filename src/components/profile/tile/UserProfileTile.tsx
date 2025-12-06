
import React from 'react';
import { Heart } from 'lucide-react';
import soundManager from '@/utils/soundManager';
import { toast } from '@/hooks/use-toast';
import { ProfileBadges } from './ProfileBadges';
import { ProfileContextMenu } from './ProfileContextMenu';
import { getCyberpunkStyles } from './ProfileThemeStyles';

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
  compatibilityScore?: number;
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
    
    const newView = { id, name, image, timestamp: currentTime };
    const filteredHistory = viewHistory.filter((view: any) => view.id !== id);
    const updatedHistory = [newView, ...filteredHistory].slice(0, 20);
    
    localStorage.setItem('profileViewHistory', JSON.stringify(updatedHistory));
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

  const displayName = isAnonymous ? "Anonymous" : name;
  
  return (
    <ProfileContextMenu
      name={displayName}
      onProfileClick={onProfileClick}
      onSendYo={handleSendYo}
      onRequestPrivateAlbum={handleRequestPrivateAlbum}
      id={id}
      hasPrivateAlbum={hasPrivateAlbum}
      privateAlbumCount={privateAlbumCount}
      compatibilityScore={compatibilityScore}
    >
      <div className={getCyberpunkStyles(theme)} onClick={handleProfileClick}>
        {theme === 'cyberpunk' && (
          <div key="cyberpunk-heart" className="absolute top-2 right-2 w-8 h-8 rounded-full border-2 border-[#AAFF50]/70 bg-black flex items-center justify-center"
               style={{ boxShadow: '0 0 3px rgba(170, 255, 80, 0.3), 0 0 3px rgba(194, 255, 230, 0.2), inset 0 0 2px rgba(170, 255, 80, 0.2)' }}>
            <Heart 
              className="w-4 h-4 text-[#AAFF50]" 
              fill="rgba(170, 255, 80, 0.3)" 
              strokeWidth={1.5} 
            />
          </div>
        )}
        
        <img 
          src={image} 
          alt={displayName}
          className="w-full h-full object-cover" 
        />
        
        <div className="absolute bottom-0 left-0 right-0 p-2 bg-gradient-to-t from-black to-transparent">
          <div className="flex justify-between items-end">
            <div>
              <div className="flex items-center text-[#C2FFE6]">
                <div className="flex items-center">
                  <span className="font-medium text-[14px]">{displayName}</span>
                  {age && !isAnonymous && <span className="font-medium text-[14px] ml-1">, {age}</span>}
                  
                  {lastActive === 'Online' && (
                    <div className="ml-1 w-1.5 h-1.5 rounded-full bg-green-500 animate-pulse" 
                         style={{ boxShadow: '0 0 4px #4ADE80' }} />
                  )}
                </div>
              </div>
            </div>
            
            <ProfileBadges
              isAnonymous={!!isAnonymous}
              privateAlbum={hasPrivateAlbum}
              privateAlbumCount={privateAlbumCount}
              explicitMainPhoto={explicitMainPhoto}
            />
          </div>
        </div>
      </div>
    </ProfileContextMenu>
  );
};

export default UserProfileTile;
