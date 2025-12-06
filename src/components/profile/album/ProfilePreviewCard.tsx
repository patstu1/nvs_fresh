
import React from 'react';
import { UserProfile } from '@/types/UserProfile';

interface ProfilePreviewCardProps {
  profile: UserProfile;
}

const ProfilePreviewCard: React.FC<ProfilePreviewCardProps> = ({ profile }) => {
  return (
    <div className="flex items-center space-x-3">
      <img src={profile.image} alt={profile.name} className="w-16 h-16 rounded-full object-cover" />
      <div>
        <h4 className="font-medium text-white">{profile.name}, {profile.age}</h4>
        <p className="text-sm text-white/70">{profile.distance.toFixed(1)}km away</p>
      </div>
    </div>
  );
};

export default ProfilePreviewCard;
