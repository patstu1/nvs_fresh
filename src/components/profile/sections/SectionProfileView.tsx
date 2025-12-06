
import React from 'react';
import { DetailedUserProfile } from '@/types/ProfileTypes';
import { TabType } from '@/types/TabTypes';

interface SectionProfileViewProps {
  profile: DetailedUserProfile;
  activeSection: TabType;
}

export const SectionProfileView = ({ profile, activeSection }: SectionProfileViewProps) => {
  const getProfileForSection = () => {
    switch (activeSection) {
      case 'map':
        return {
          ...profile,
          image: profile.sectionPreferences?.now.useAlternateAvatar && profile.nowContent?.nsfwAvatar ? 
                 profile.nowContent.nsfwAvatar : profile.image,
          name: profile.sectionPreferences?.now.anonymousMode ? 
                'Anonymous' : profile.name,
          showFace: profile.sectionPreferences?.now.showFace,
          bio: profile.nowContent?.nsfwBio || profile.bio,
          showMetrics: !profile.sectionPreferences?.now.anonymousMode,
        };
      case 'connect':
        return {
          ...profile,
          name: profile.name,
          showFace: true,
          showDetailedBio: profile.sectionPreferences?.connect.showDetailedBio,
          emphasizeCompatibility: true,
        };
      case 'rooms':
        return {
          ...profile,
          name: profile.sectionPreferences?.live.anonymousMode ? 
                'Anonymous' : profile.name,
          bio: profile.sectionPreferences?.live.showBio ? profile.bio : undefined,
          useCasualPhotos: profile.sectionPreferences?.live.useCasualPhotos,
        };
      default:
        return {
          ...profile,
          name: profile.name,
          showFace: profile.sectionPreferences?.lineup.showFace,
          bio: profile.sectionPreferences?.lineup.showBio ? profile.bio : undefined,
          showMetrics: profile.sectionPreferences?.lineup.showMetrics,
        };
    }
  };

  return getProfileForSection();
};

export default SectionProfileView;
