
import { useState } from 'react';
import { MediaItem } from '@/types/MediaTypes';
import { useAuth } from '@/hooks/useAuth';
import { useMediaUtils } from './media/useMediaUtils';
import { useMediaUpload } from './media/useMediaUpload';
import { useMediaManagement } from './media/useMediaManagement';
import { useMediaSharing } from './media/useMediaSharing';
import { useMediaSections, DEFAULT_SECTION_RULES } from './media/useMediaSections';

export function useMediaManager() {
  const { user } = useAuth();
  const [profilePhotos, setProfilePhotos] = useState<MediaItem[]>([]);
  const [publicAlbum, setPublicAlbum] = useState<MediaItem[]>([]);
  const [privateAlbum, setPrivateAlbum] = useState<MediaItem[]>([]);
  const [anonymousAlbum, setAnonymousAlbum] = useState<MediaItem[]>([]);
  const [profileVideo, setProfileVideo] = useState<MediaItem | null>(null);
  
  // Initialize all the sub-hooks
  const { createMediaItem } = useMediaUtils();
  
  const { isUploading, uploadMedia } = useMediaUpload(
    setPublicAlbum,
    setPrivateAlbum,
    setAnonymousAlbum,
    setProfilePhotos,
    setProfileVideo
  );
  
  const { deleteMedia, updateMedia, changeVisibility } = useMediaManagement(
    publicAlbum,
    privateAlbum,
    anonymousAlbum,
    profilePhotos,
    profileVideo,
    setPublicAlbum,
    setPrivateAlbum,
    setAnonymousAlbum,
    setProfilePhotos,
    setProfileVideo
  );
  
  const { shareMedia, revokeAccess } = useMediaSharing(
    privateAlbum,
    setPrivateAlbum
  );
  
  const { getMediaForSection, sectionRules } = useMediaSections(
    publicAlbum,
    privateAlbum,
    anonymousAlbum
  );

  // Return all the functionality
  return {
    profilePhotos,
    publicAlbum,
    privateAlbum,
    anonymousAlbum,
    profileVideo,
    isUploading,
    uploadMedia,
    deleteMedia,
    updateMedia,
    shareMedia,
    revokeAccess,
    changeVisibility,
    getMediaForSection,
    sectionRules
  };
}
