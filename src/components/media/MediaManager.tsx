
import React, { useState } from 'react';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Camera, Unlock, Lock, UserCircle } from 'lucide-react';
import { useMediaManager } from '@/hooks/useMediaManager';
import { MediaItem, MediaVisibility } from '@/types/MediaTypes';
import MediaShareDialog from './MediaShareDialog';
import MediaManagerHeader from './MediaManagerHeader';
import ProfileTab from './tabs/ProfileTab';
import PublicTab from './tabs/PublicTab';
import PrivateTab from './tabs/PrivateTab';

const MediaManager: React.FC = () => {
  const {
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
    changeVisibility
  } = useMediaManager();

  const [activeTab, setActiveTab] = useState<string>('profile');
  const [showShareDialog, setShowShareDialog] = useState<boolean>(false);
  const [selectedMedia, setSelectedMedia] = useState<MediaItem | null>(null);
  const [isNsfw, setIsNsfw] = useState<boolean>(false);

  // Handle file upload
  const handleFileUpload = (
    event: React.ChangeEvent<HTMLInputElement>,
    visibility: MediaVisibility,
    isProfileMedia: boolean = false
  ) => {
    const files = event.target.files;
    if (!files || files.length === 0) return;
    
    uploadMedia(files, visibility, isNsfw, isProfileMedia);
    
    // Reset the input
    event.target.value = '';
  };

  // Handle share dialog
  const handleShareClick = (media: MediaItem) => {
    setSelectedMedia(media);
    setShowShareDialog(true);
  };

  // Handle share submit
  const handleShareSubmit = (userIds: string[]) => {
    if (selectedMedia) {
      shareMedia(selectedMedia.id, userIds);
    }
    setShowShareDialog(false);
  };

  // Handle visibility change
  const handleVisibilityChange = (media: MediaItem, newVisibility: MediaVisibility) => {
    changeVisibility(media.id, media.visibility, newVisibility);
  };

  // Handle delete
  const handleDelete = (media: MediaItem) => {
    deleteMedia(media.id, media.visibility);
  };

  // Handle toggle NSFW
  const handleToggleNsfw = (media: MediaItem) => {
    updateMedia(media.id, { isNsfw: !media.isNsfw });
  };

  return (
    <div className="bg-black text-white p-4">
      <MediaManagerHeader title="Media Manager" />

      <Tabs value={activeTab} onValueChange={setActiveTab} className="w-full">
        <TabsList className="grid w-full grid-cols-3 bg-black">
          <TabsTrigger 
            value="profile" 
            className="data-[state=active]:bg-[#E6FFF4] data-[state=active]:text-black"
          >
            <UserCircle className="mr-2 h-4 w-4" />
            Profile
          </TabsTrigger>
          <TabsTrigger 
            value="public" 
            className="data-[state=active]:bg-[#E6FFF4] data-[state=active]:text-black"
          >
            <Unlock className="mr-2 h-4 w-4" />
            Public
          </TabsTrigger>
          <TabsTrigger 
            value="private" 
            className="data-[state=active]:bg-[#E6FFF4] data-[state=active]:text-black"
          >
            <Lock className="mr-2 h-4 w-4" />
            Private
          </TabsTrigger>
        </TabsList>
        
        <TabsContent value="profile">
          <ProfileTab
            profilePhotos={profilePhotos}
            profileVideo={profileVideo}
            isNsfw={isNsfw}
            setIsNsfw={setIsNsfw}
            handleFileUpload={handleFileUpload}
            handleDelete={handleDelete}
            handleToggleNsfw={handleToggleNsfw}
            handleShareClick={handleShareClick}
            handleVisibilityChange={handleVisibilityChange}
          />
        </TabsContent>
        
        <TabsContent value="public">
          <PublicTab
            publicAlbum={publicAlbum}
            isNsfw={isNsfw}
            setIsNsfw={setIsNsfw}
            handleFileUpload={handleFileUpload}
            handleDelete={handleDelete}
            handleToggleNsfw={handleToggleNsfw}
            handleVisibilityChange={handleVisibilityChange}
          />
        </TabsContent>
        
        <TabsContent value="private">
          <PrivateTab
            privateAlbum={privateAlbum}
            anonymousAlbum={anonymousAlbum}
            isNsfw={isNsfw}
            setIsNsfw={setIsNsfw}
            handleFileUpload={handleFileUpload}
            handleDelete={handleDelete}
            handleToggleNsfw={handleToggleNsfw}
            handleShareClick={handleShareClick}
            handleVisibilityChange={handleVisibilityChange}
          />
        </TabsContent>
      </Tabs>
      
      <MediaShareDialog 
        open={showShareDialog} 
        onOpenChange={setShowShareDialog}
        onConfirm={handleShareSubmit}
        media={selectedMedia}
      />
    </div>
  );
};

export default MediaManager;
