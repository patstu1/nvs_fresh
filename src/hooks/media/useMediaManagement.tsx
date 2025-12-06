
import { useCallback } from 'react';
import { MediaItem, MediaVisibility } from '@/types/MediaTypes';
import { toast } from '@/hooks/use-toast';

export const useMediaManagement = (
  publicAlbum: MediaItem[],
  privateAlbum: MediaItem[],
  anonymousAlbum: MediaItem[],
  profilePhotos: MediaItem[],
  profileVideo: MediaItem | null,
  setPublicAlbum: React.Dispatch<React.SetStateAction<MediaItem[]>>,
  setPrivateAlbum: React.Dispatch<React.SetStateAction<MediaItem[]>>,
  setAnonymousAlbum: React.Dispatch<React.SetStateAction<MediaItem[]>>,
  setProfilePhotos: React.Dispatch<React.SetStateAction<MediaItem[]>>,
  setProfileVideo: React.Dispatch<React.SetStateAction<MediaItem | null>>
) => {
  /**
   * Delete media item from the appropriate album
   */
  const deleteMedia = useCallback(
    (id: string, visibility: MediaVisibility) => {
      switch (visibility) {
        case 'public':
          setPublicAlbum(prev => prev.filter(item => item.id !== id));
          break;
        case 'private':
          setPrivateAlbum(prev => prev.filter(item => item.id !== id));
          break;
        case 'anonymous':
          setAnonymousAlbum(prev => prev.filter(item => item.id !== id));
          break;
      }
      
      // Also check if it's in profile photos
      setProfilePhotos(prev => prev.filter(item => item.id !== id));
      
      // Check if it's the profile video
      if (profileVideo?.id === id) {
        setProfileVideo(null);
      }
      
      toast({
        title: "Media deleted",
        description: "The selected media has been removed from your album"
      });
    },
    [profileVideo, setPublicAlbum, setPrivateAlbum, setAnonymousAlbum, setProfilePhotos, setProfileVideo]
  );

  /**
   * Update properties of a media item
   */
  const updateMedia = useCallback(
    (id: string, updates: Partial<MediaItem>) => {
      const updateInAlbum = (
        album: MediaItem[], 
        setAlbum: React.Dispatch<React.SetStateAction<MediaItem[]>>
      ) => {
        const itemIndex = album.findIndex(item => item.id === id);
        if (itemIndex !== -1) {
          const updatedAlbum = [...album];
          updatedAlbum[itemIndex] = { ...updatedAlbum[itemIndex], ...updates };
          setAlbum(updatedAlbum);
          return true;
        }
        return false;
      };
      
      // Try to update in each album
      let updated = updateInAlbum(publicAlbum, setPublicAlbum);
      if (!updated) updated = updateInAlbum(privateAlbum, setPrivateAlbum);
      if (!updated) updated = updateInAlbum(anonymousAlbum, setAnonymousAlbum);
      
      // Also check profile photos
      updateInAlbum(profilePhotos, setProfilePhotos);
      
      // Check if it's the profile video
      if (profileVideo?.id === id) {
        setProfileVideo(prev => prev ? { ...prev, ...updates } : null);
      }
      
      return updated;
    },
    [publicAlbum, privateAlbum, anonymousAlbum, profilePhotos, profileVideo, 
     setPublicAlbum, setPrivateAlbum, setAnonymousAlbum, setProfilePhotos, setProfileVideo]
  );

  /**
   * Change visibility of a media item (move between albums)
   */
  const changeVisibility = useCallback(
    (mediaId: string, currentVisibility: MediaVisibility, newVisibility: MediaVisibility) => {
      // Find the media in the current album
      let mediaItem: MediaItem | undefined;
      
      switch (currentVisibility) {
        case 'public':
          mediaItem = publicAlbum.find(item => item.id === mediaId);
          break;
        case 'private':
          mediaItem = privateAlbum.find(item => item.id === mediaId);
          break;
        case 'anonymous':
          mediaItem = anonymousAlbum.find(item => item.id === mediaId);
          break;
      }
      
      if (!mediaItem) {
        toast({
          title: "Error changing visibility",
          description: "Media item not found",
          variant: "destructive"
        });
        return false;
      }
      
      // Remove from current album
      deleteMedia(mediaId, currentVisibility);
      
      // Add to new album with updated visibility
      const updatedItem = { ...mediaItem, visibility: newVisibility };
      
      switch (newVisibility) {
        case 'public':
          setPublicAlbum(prev => [...prev, updatedItem]);
          break;
        case 'private':
          setPrivateAlbum(prev => [...prev, updatedItem]);
          break;
        case 'anonymous':
          setAnonymousAlbum(prev => [...prev, updatedItem]);
          break;
      }
      
      toast({
        title: "Visibility changed",
        description: `Media is now ${newVisibility}`
      });
      
      return true;
    },
    [publicAlbum, privateAlbum, anonymousAlbum, deleteMedia, 
     setPublicAlbum, setPrivateAlbum, setAnonymousAlbum]
  );

  return {
    deleteMedia,
    updateMedia,
    changeVisibility
  };
};
