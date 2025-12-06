
import React from 'react';
import { Badge } from '@/components/ui/badge';
import { Lock, Heart } from 'lucide-react';

interface ProfileBadgesProps {
  isAnonymous: boolean;
  privateAlbum?: boolean;
  privateAlbumCount?: number;
  explicitMainPhoto?: boolean;
}

export const ProfileBadges: React.FC<ProfileBadgesProps> = ({
  isAnonymous,
  privateAlbum,
  privateAlbumCount,
  explicitMainPhoto
}) => {
  if (!isAnonymous && !privateAlbum && !explicitMainPhoto) return null;
  
  return (
    <div className="flex flex-col gap-1 items-end">
      {isAnonymous && (
        <Badge className="bg-[#FF3366] text-white">
          Anonymous
        </Badge>
      )}
      
      {privateAlbum && (
        <Badge className="bg-[#E6FFF4] text-black">
          <Lock className="w-3 h-3 mr-1" />
          XXX Album ({privateAlbumCount || "5"})
        </Badge>
      )}
      
      {explicitMainPhoto && (
        <Badge className="bg-[#FF3366] text-white">
          <Heart className="w-3 h-3 mr-1" />
          XXX
        </Badge>
      )}
    </div>
  );
};
