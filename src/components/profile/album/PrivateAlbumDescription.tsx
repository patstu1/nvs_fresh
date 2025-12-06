
import React from 'react';
import { UserProfile } from '@/types/UserProfile';

interface PrivateAlbumDescriptionProps {
  profile: UserProfile;
}

const PrivateAlbumDescription: React.FC<PrivateAlbumDescriptionProps> = ({ profile }) => {
  return (
    <div className="bg-[#1A1A1A] p-3 rounded-md border border-[#E6FFF4]/10">
      <p className="text-sm text-white/80">
        Your request will be sent to {profile.name}. If approved, you'll be notified and gain access to their private content.
      </p>
    </div>
  );
};

export default PrivateAlbumDescription;
