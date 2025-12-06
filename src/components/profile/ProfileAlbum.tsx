
import React from 'react';
import { Lock } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { UserProfile } from '@/types/UserProfile';
import AlbumGrid from './album/AlbumGrid';

interface ProfileAlbumProps {
  profile: UserProfile;
  onRequestPrivateAlbum: () => void;
  isNsfw?: boolean;
}

const ProfileAlbum: React.FC<ProfileAlbumProps> = ({ profile, onRequestPrivateAlbum, isNsfw = false }) => {
  // If the profile has a privateAlbum that is shared, or if it's NSFW content for Cruise section
  const hasSharedAlbum = profile.privateAlbum?.isShared || isNsfw;
  const albumImages = profile.privateAlbum?.images || [];
  
  if (!profile.hasPrivateAlbum && !hasSharedAlbum && !isNsfw) return null;
  
  // For mock data - in a real app this would come from the profile data
  const mockPrivateAlbumImages = [
    '/placeholder.svg',
    '/placeholder.svg',
    '/placeholder.svg'
  ];

  const images = hasSharedAlbum ? albumImages : mockPrivateAlbumImages;
  
  return (
    <div className="mx-4 my-3 bg-[#1A1A1A] p-4 rounded-lg border border-[#E6FFF4]/20">
      <div className="flex items-start justify-between mb-3">
        <div className="flex items-center">
          {!hasSharedAlbum && <Lock className="w-5 h-5 text-[#E6FFF4] mr-2" />}
          <h3 className="text-lg font-medium text-[#E6FFF4]">
            {isNsfw ? "NSFW Album" : "Private Album"}
          </h3>
        </div>
      </div>
      
      <AlbumGrid 
        images={images}
        isPrivate={!hasSharedAlbum}
        onImageClick={() => !hasSharedAlbum && onRequestPrivateAlbum()}
        onLockClick={!hasSharedAlbum ? onRequestPrivateAlbum : undefined}
      />
      
      {!hasSharedAlbum && (
        <div className="mt-3">
          <Button 
            onClick={onRequestPrivateAlbum} 
            className="w-full bg-[#E6FFF4] text-black hover:bg-[#E6FFF4]/90"
          >
            Request Access
          </Button>
        </div>
      )}
    </div>
  );
};

export default ProfileAlbum;
