
import React from 'react';
import { MessageCircle, Heart, Lock, X } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { UserProfile } from '@/types/UserProfile';
import { TabType } from '@/types/TabTypes';

interface ProfileActionsProps {
  profile: UserProfile;
  isFavorite: boolean;
  setIsFavorite: (value: boolean) => void;
  onRequestPrivateAlbum: () => void;
  activeSection?: TabType;
}

const ProfileActions: React.FC<ProfileActionsProps> = ({ 
  profile, 
  isFavorite, 
  setIsFavorite,
  onRequestPrivateAlbum,
  activeSection = 'grid'
}) => {
  // Get the section-specific label
  const getSectionLabel = () => {
    switch (activeSection) {
      case 'grid': return 'GRID';
      case 'map': return 'NOW';
      case 'connect': return 'CONNECT';
      case 'rooms': return 'LIVE';
      default: return '';
    }
  };
  
  // Check if we should show the private album request button based on section
  const showPrivateRequest = profile.hasPrivateAlbum && 
    (activeSection !== 'map' || !profile.privateAlbum?.isShared);

  return (
    <div className="px-4 py-2 flex items-center justify-between">
      <div className="flex space-x-2">
        <Button 
          variant="secondary" 
          className="bg-[#1A1A1A] border border-[#E6FFF4]/30 text-white flex items-center"
          onClick={() => {}}
        >
          <MessageCircle className="w-5 h-5 mr-2 text-[#E6FFF4]" />
          <span>Message</span>
          {getSectionLabel() && (
            <span className="ml-1 text-xs opacity-70">({getSectionLabel()})</span>
          )}
        </Button>
        
        <Button 
          variant={isFavorite ? "default" : "secondary"}
          className={`${isFavorite ? 'bg-[#E6FFF4] text-black' : 'bg-[#1A1A1A] border border-[#E6FFF4]/30 text-white'}`}
          onClick={() => setIsFavorite(!isFavorite)}
        >
          <Heart className={`w-5 h-5 ${isFavorite ? 'fill-black' : ''}`} />
        </Button>
      </div>
      
      <div>
        {showPrivateRequest ? (
          <Button 
            variant="secondary" 
            className="bg-[#1A1A1A] border border-[#E6FFF4]/30 text-white"
            onClick={onRequestPrivateAlbum}
          >
            <Lock className="w-5 h-5 mr-2 text-[#E6FFF4]" />
            {activeSection === 'map' ? 'NSFW Album' : 'Private Album'}
          </Button>
        ) : (
          <Button 
            variant="secondary" 
            className="bg-[#1A1A1A] border border-[#E6FFF4]/30 text-white"
            onClick={() => {}}
          >
            <X className="w-5 h-5 mr-2 text-[#E6FFF4]" />
            Block
          </Button>
        )}
      </div>
    </div>
  );
};

export default ProfileActions;
