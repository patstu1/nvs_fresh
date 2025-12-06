
import { UserProfile } from './UserProfile';

export type ProfilePosition = 'top' | 'bottom' | 'vers' | 'side';

export type ProfileStatus = 'single' | 'dating' | 'partnered' | 'open' | 'married';

export type ProfileMetrics = {
  height?: number;
  weight?: number;
  age?: number;
  position?: ProfilePosition;
  bodyType?: string;
  ethnicity?: string;
};

export type ProfilePreferences = {
  lookingFor: string[];
  tribes: string[];
  acceptsNsfw: boolean;
  meetingPreference?: 'now' | 'dates' | 'friends' | 'networking' | 'chat';
  maxDistance?: number;
  ageRange?: {
    min: number;
    max: number;
  };
};

// Section-specific visibility preferences
export type SectionVisibilityPreferences = {
  lineup: {
    showFace: boolean;
    showBio: boolean;
    showTags: boolean;
    showMetrics: boolean;
  };
  now: {
    showFace: boolean;
    showBio: boolean;
    anonymousMode: boolean;
    allowNsfw: boolean;
    useAlternateAvatar: boolean;
  };
  connect: {
    curatedPhotosOnly: boolean;
    emphasizeCompatibility: boolean;
    showDetailedBio: boolean;
  };
  live: {
    showBio: boolean;
    showTags: boolean;
    useCasualPhotos: boolean;
    anonymousMode: boolean;
  };
};

export interface DetailedUserProfile extends UserProfile {
  status?: ProfileStatus;
  metrics?: ProfileMetrics;
  preferences?: ProfilePreferences;
  social?: {
    instagram?: string;
    twitter?: string;
  };
  lastActive?: string;
  isOnline?: boolean;
  verifiedPhotos?: boolean;
  sectionPreferences?: SectionVisibilityPreferences;
  
  // NSFW content for NOW section
  nowContent?: {
    nsfwAvatar?: string;
    nsfwAlbum?: string[];
    nsfwBio?: string;
  };
}
