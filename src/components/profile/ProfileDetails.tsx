
import React from 'react';
import { MapPin, Calendar, Instagram } from 'lucide-react';
import { UserProfile } from '@/types/UserProfile';
import { TabType } from '@/types/TabTypes';

interface ProfileDetailsProps {
  profile: UserProfile;
  isBlocked: boolean;
  onToggleBlock: () => void;
  currentCity: { name: string; country: string };
  onCitySelect: (city: { name: string; country: string }) => void;
  activeSection?: TabType;
}

const ProfileDetails: React.FC<ProfileDetailsProps> = ({ 
  profile, 
  isBlocked,
  onToggleBlock,
  currentCity,
  onCitySelect,
  activeSection = 'grid'
}) => {
  // Get section-specific display rules
  const shouldShowDetails = () => {
    switch (activeSection) {
      case 'map': // NOW
        return !profile.isAnonymous;
      case 'rooms': // LIVE
        return profile.showBio !== false;
      default:
        return true;
    }
  };
  
  // Don't show details for anonymous NOW profiles or if bio is hidden in LIVE
  if (!shouldShowDetails()) return null;
  
  // Adjust bio content based on section
  const getBio = () => {
    // For Connect section, show more detailed bio if available
    if (activeSection === 'connect' && profile.showDetailedBio) {
      return `${profile.bio || ''}\n\nLooking for meaningful connections and shared experiences.`;
    }
    return profile.bio;
  };
  
  const bio = getBio();
  
  return (
    <div className="px-4 space-y-4">
      {/* Bio Section */}
      {bio && (
        <div className="space-y-2">
          <h2 className="text-lg font-semibold">About</h2>
          <p className="text-gray-300 whitespace-pre-line">{bio}</p>
        </div>
      )}
      
      {/* Location and Social Info - Only show for non-anonymous profiles */}
      {!profile.isAnonymous && (
        <>
          {profile.location && (
            <div className="flex items-center space-x-2">
              <MapPin className="w-5 h-5 text-[#E6FFF4]" />
              <span className="text-sm text-gray-300">{profile.location}</span>
            </div>
          )}
          
          {profile.lastActive && (
            <div className="flex items-center space-x-2">
              <Calendar className="w-5 h-5 text-[#E6FFF4]" />
              <span className="text-sm text-gray-300">
                {profile.isOnline ? 'Online now' : `Last active ${profile.lastActive}`}
              </span>
            </div>
          )}
          
          {/* Social Media - Only show in GRID and CONNECT */}
          {(['grid', 'connect'].includes(activeSection) && profile.social?.instagram) && (
            <div className="flex items-center space-x-2">
              <Instagram className="w-5 h-5 text-[#E6FFF4]" />
              <span className="text-sm text-gray-300">{profile.social.instagram}</span>
            </div>
          )}
        </>
      )}
    </div>
  );
};

export default ProfileDetails;
