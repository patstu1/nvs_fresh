
import React from 'react';
import { Lock } from 'lucide-react';
import { DialogHeader, DialogTitle, DialogDescription } from '@/components/ui/dialog';
import { UserProfile } from '@/types/UserProfile';

interface PrivateAlbumRequestHeaderProps {
  profile: UserProfile;
}

const PrivateAlbumRequestHeader: React.FC<PrivateAlbumRequestHeaderProps> = ({ profile }) => {
  return (
    <DialogHeader>
      <DialogTitle className="text-[#E6FFF4] flex items-center">
        <Lock className="w-5 h-5 mr-2" />
        Request Private Album Access
      </DialogTitle>
      <DialogDescription className="text-white/70">
        Send a request to view {profile.name}'s private album content
      </DialogDescription>
    </DialogHeader>
  );
};

export default PrivateAlbumRequestHeader;
