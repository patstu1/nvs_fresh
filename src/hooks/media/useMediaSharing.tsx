
import { useCallback } from 'react';
import { MediaItem } from '@/types/MediaTypes';
import { toast } from '@/hooks/use-toast';

export const useMediaSharing = (
  privateAlbum: MediaItem[],
  setPrivateAlbum: React.Dispatch<React.SetStateAction<MediaItem[]>>
) => {
  /**
   * Share media with specific users
   */
  const shareMedia = useCallback(
    (mediaId: string, userIds: string[]) => {
      // Find the media item in all albums
      let found = false;
      
      // Only private media can be shared
      const updateAlbum = privateAlbum.map(item => {
        if (item.id === mediaId) {
          found = true;
          const currentSharedWith = item.sharedWith || [];
          const newSharedWith = [...new Set([...currentSharedWith, ...userIds])];
          return { ...item, sharedWith: newSharedWith };
        }
        return item;
      });
      
      if (found) {
        setPrivateAlbum(updateAlbum);
        toast({
          title: "Media shared",
          description: `Shared with ${userIds.length} user(s)`
        });
        return true;
      }
      
      toast({
        title: "Sharing failed",
        description: "Could not find the media item to share",
        variant: "destructive"
      });
      return false;
    },
    [privateAlbum, setPrivateAlbum]
  );

  /**
   * Revoke access to shared media
   */
  const revokeAccess = useCallback(
    (mediaId: string, userId: string) => {
      // Find the media item in private album
      const updateAlbum = privateAlbum.map(item => {
        if (item.id === mediaId) {
          const currentSharedWith = item.sharedWith || [];
          return { 
            ...item, 
            sharedWith: currentSharedWith.filter(id => id !== userId) 
          };
        }
        return item;
      });
      
      setPrivateAlbum(updateAlbum);
      toast({
        title: "Access revoked",
        description: "User access has been removed"
      });
    },
    [privateAlbum, setPrivateAlbum]
  );

  return {
    shareMedia,
    revokeAccess
  };
};
