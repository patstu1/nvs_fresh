
import React, { createContext, useContext } from 'react';
import { useMediaManager } from '@/hooks/useMediaManager';
import { MediaVisibility, MediaType, SectionType, MediaItem } from '@/types/MediaTypes';

interface MediaContextType {
  profilePhotos: MediaItem[];
  publicAlbum: MediaItem[];
  privateAlbum: MediaItem[];
  anonymousAlbum: MediaItem[];
  profileVideo: MediaItem | null;
  isUploading: boolean;
  uploadMedia: (files: FileList, visibility: MediaVisibility, isNsfw: boolean, isProfilePic?: boolean) => Promise<void>;
  deleteMedia: (id: string, visibility: MediaVisibility) => void;
  updateMedia: (id: string, updates: Partial<MediaItem>) => boolean;
  shareMedia: (mediaId: string, userIds: string[]) => boolean;
  revokeAccess: (mediaId: string, userId: string) => void;
  changeVisibility: (mediaId: string, currentVisibility: MediaVisibility, newVisibility: MediaVisibility) => boolean;
  getMediaForSection: (section: SectionType) => MediaItem[];
  sectionRules: Record<SectionType, {
    allowNsfw: boolean;
    requireBlur: boolean;
    defaultVisibility: MediaVisibility;
  }>;
}

const MediaContext = createContext<MediaContextType | undefined>(undefined);

export const MediaProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const mediaManager = useMediaManager();
  
  return (
    <MediaContext.Provider value={mediaManager}>
      {children}
    </MediaContext.Provider>
  );
};

export const useMedia = () => {
  const context = useContext(MediaContext);
  if (!context) {
    throw new Error("useMedia must be used within a MediaProvider");
  }
  return context;
};
