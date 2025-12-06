
import { v4 as uuidv4 } from 'uuid';
import { MediaItem, MediaType, MediaVisibility } from '@/types/MediaTypes';

export const useMediaUtils = () => {
  /**
   * Creates a new media item object
   */
  const createMediaItem = (
    file: File | string, 
    type: MediaType, 
    visibility: MediaVisibility, 
    isNsfw: boolean,
    isProfilePic: boolean = false
  ): MediaItem => {
    const url = typeof file === 'string' ? file : URL.createObjectURL(file);
    
    return {
      id: uuidv4(),
      url,
      type,
      visibility,
      isNsfw,
      isProfilePic,
      uploadedAt: new Date().toISOString(),
      sharedWith: []
    };
  };

  return {
    createMediaItem
  };
};
