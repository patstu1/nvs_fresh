
export interface UserProfile {
  id: string;
  image: string;
  name: string;
  age?: number;
  emojis: string[];
  distance: number;
  lastActive?: string;
  bio?: string;
  height?: number;
  weight?: number;
  bodyType?: 'slim' | 'average' | 'muscular' | 'toned' | 'stocky' | 'athletic';
  ethnicity?: string;
  lookingFor?: string[];
  tribe?: string;
  compatibilityScore?: number;
  hasPrivateAlbum?: boolean;
  privateAlbum?: {
    isShared?: boolean;
    images: string[];
    isExplicit?: boolean;
  };
  location?: string;
  tags?: string[];
  isAnonymous?: boolean;
  explicitMainPhoto?: boolean;
  privateAlbumCount?: number;
  isBlocked?: boolean;
  position?: 'top' | 'bottom' | 'vers' | 'side';
  // Add chat-related fields
  unreadMessages?: number;
  lastMessage?: {
    text: string;
    timestamp: string;
  };
  isOnline?: boolean;
  canMessage?: boolean;
  
  // New fields for section-specific display options
  showFace?: boolean;
  showBio?: boolean;
  showMetrics?: boolean;
  showDetailedBio?: boolean;
  emphasizeCompatibility?: boolean;
  useCasualPhotos?: boolean;
  verifiedPhotos?: boolean;
  
  // Add social media links
  social?: {
    instagram?: string;
    twitter?: string;
    facebook?: string;
    spotify?: string;
  };
  
  // User profile specific fields
  username?: string;
  avatar_url?: string;
}
