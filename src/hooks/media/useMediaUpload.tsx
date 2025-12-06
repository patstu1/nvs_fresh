
import { useState, useCallback } from 'react';
import { MediaVisibility, MediaItem } from '@/types/MediaTypes';
import { toast } from '@/hooks/use-toast';
import { useMediaUtils } from './useMediaUtils';

export const useMediaUpload = (
  setPublicAlbum: React.Dispatch<React.SetStateAction<MediaItem[]>>,
  setPrivateAlbum: React.Dispatch<React.SetStateAction<MediaItem[]>>,
  setAnonymousAlbum: React.Dispatch<React.SetStateAction<MediaItem[]>>,
  setProfilePhotos: React.Dispatch<React.SetStateAction<MediaItem[]>>,
  setProfileVideo: React.Dispatch<React.SetStateAction<MediaItem | null>>
) => {
  const [isUploading, setIsUploading] = useState(false);
  const { createMediaItem } = useMediaUtils();

  /**
   * Upload media files to the appropriate albums
   */
  const uploadMedia = useCallback(
    async (
      files: FileList, 
      visibility: MediaVisibility, 
      isNsfw: boolean,
      isProfilePic: boolean = false
    ) => {
      if (!files.length) return;
      
      setIsUploading(true);
      
      try {
        // In a real app, this would upload to a storage service
        const uploadedMedia: MediaItem[] = Array.from(files).map(file => {
          const isVideo = file.type.startsWith('video/');
          return createMediaItem(
            file,
            isVideo ? 'video' : 'image',
            visibility,
            isNsfw,
            isProfilePic
          );
        });
        
        // Add to appropriate album based on visibility
        switch (visibility) {
          case 'public':
            setPublicAlbum(prev => [...prev, ...uploadedMedia]);
            break;
          case 'private':
            setPrivateAlbum(prev => [...prev, ...uploadedMedia]);
            break;
          case 'anonymous':
            setAnonymousAlbum(prev => [...prev, ...uploadedMedia]);
            break;
        }
        
        // If marked as profile pic, add to profile photos
        if (isProfilePic) {
          // Only add images (not videos) to profile photos
          const profileImages = uploadedMedia.filter(item => item.type === 'image');
          setProfilePhotos(prev => [...prev, ...profileImages]);
        }
        
        // If it's a video and there's only one and user wants it as profile video
        if (files.length === 1 && files[0].type.startsWith('video/') && isProfilePic) {
          setProfileVideo(uploadedMedia[0]);
        }
        
        toast({
          title: "Media uploaded successfully",
          description: `${uploadedMedia.length} item(s) added to your ${visibility} album`
        });
      } catch (error) {
        console.error("Upload error:", error);
        toast({
          title: "Upload failed",
          description: "There was an error uploading your media",
          variant: "destructive"
        });
      } finally {
        setIsUploading(false);
      }
    },
    [createMediaItem, setPublicAlbum, setPrivateAlbum, setAnonymousAlbum, setProfilePhotos, setProfileVideo]
  );

  return { 
    isUploading, 
    uploadMedia 
  };
};
