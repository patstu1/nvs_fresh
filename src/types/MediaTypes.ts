
export type MediaVisibility = 'public' | 'private' | 'anonymous';
export type MediaType = 'image' | 'video';
export type SectionType = 'grid' | 'now' | 'connect' | 'live';

export interface MediaItem {
  id: string;
  url: string;
  type: MediaType;
  visibility: MediaVisibility;
  isNsfw: boolean;
  isProfilePic?: boolean;
  caption?: string;
  uploadedAt: string;
  sharedWith?: string[]; // Array of user IDs who have access
}

export interface AlbumSection {
  id: string;
  name: string;
  media: MediaItem[];
}

export interface MediaManagerSettings {
  defaultVisibility: MediaVisibility;
  allowNsfw: boolean;
  autoBlurNsfw: boolean;
  sectionVisibilityRules: Record<SectionType, {
    allowNsfw: boolean;
    requireBlur: boolean;
    defaultVisibility: MediaVisibility;
  }>;
}
