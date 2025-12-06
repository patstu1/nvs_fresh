
import React, { useState } from 'react';
import { useFormContext } from 'react-hook-form';
import { FormField, FormItem, FormLabel } from '@/components/ui/form';
import { Input } from '@/components/ui/input';
import { Camera, X, Upload, Image, Video, Lock, Unlock, Share2, User, Users } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { ScrollArea } from '@/components/ui/scroll-area';
import { toast } from '@/hooks/use-toast';
import { useNavigate } from 'react-router-dom';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription, DialogFooter } from '@/components/ui/dialog';

interface MediaItemProps {
  src: string;
  type: 'image' | 'video';
  onRemove: () => void;
  onShare?: () => void;
  isPrivate?: boolean;
}

const MediaItem: React.FC<MediaItemProps> = ({ src, type, onRemove, onShare, isPrivate }) => {
  return (
    <div className="relative group">
      {type === 'image' ? (
        <img 
          src={src} 
          alt="Media preview" 
          className="w-full h-24 object-cover rounded-md"
        />
      ) : (
        <video 
          src={src} 
          className="w-full h-24 object-cover rounded-md" 
          muted
        />
      )}
      <div className="absolute top-1 right-1 flex space-x-1 opacity-0 group-hover:opacity-100 transition-opacity">
        {isPrivate && onShare && (
          <button
            type="button"
            onClick={onShare}
            className="bg-black/70 rounded-full p-1"
          >
            <Share2 size={16} className="text-white" />
          </button>
        )}
        <button
          type="button"
          onClick={onRemove}
          className="bg-black/70 rounded-full p-1"
        >
          <X size={16} className="text-white" />
        </button>
      </div>
      {isPrivate && (
        <div className="absolute bottom-1 left-1 bg-black/70 rounded-full p-1">
          <Lock size={12} className="text-[#E6FFF4]" />
        </div>
      )}
    </div>
  );
};

const MediaUploadSection: React.FC = () => {
  const navigate = useNavigate();
  const { control, setValue, watch } = useFormContext();
  const [activeTab, setActiveTab] = useState<'profile' | 'public' | 'private'>('profile');
  const [shareDialogOpen, setShareDialogOpen] = useState(false);
  const [selectedMedia, setSelectedMedia] = useState<string | null>(null);
  const [shareWith, setShareWith] = useState<string[]>([]);

  const profilePictures = watch('media.profilePictures', []);
  const profileVideo = watch('media.profileVideo', '');
  const publicAlbum = watch('media.publicAlbum', []);
  const privateAlbum = watch('media.privateAlbum', []);

  const contacts = [
    { id: '1', name: 'Alex', image: 'https://images.unsplash.com/photo-1504257432389-52343af06ae3?w=500&h=500&fit=crop' },
    { id: '2', name: 'Brandon', image: 'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=500&h=500&fit=crop' },
    { id: '3', name: 'Carlos', image: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=500&h=500&fit=crop' },
  ];

  const handleFileUpload = (
    event: React.ChangeEvent<HTMLInputElement>,
    type: 'profilePictures' | 'profileVideo' | 'publicAlbum' | 'privateAlbum'
  ) => {
    const files = event.target.files;
    if (!files || files.length === 0) return;

    const fileUrls = Array.from(files).map(file => {
      const isVideo = file.type.startsWith('video/');
      
      if (type === 'profileVideo' && !isVideo) {
        toast({
          title: "Invalid file type",
          description: "Please upload a video file for your profile video",
          variant: "destructive",
        });
        return null;
      }
      
      if (isVideo && type !== 'profileVideo' && type !== 'publicAlbum' && type !== 'privateAlbum') {
        toast({
          title: "Invalid file type",
          description: "Videos can only be uploaded for profile video or albums",
          variant: "destructive",
        });
        return null;
      }
      
      return URL.createObjectURL(file);
    }).filter(Boolean) as string[];

    if (fileUrls.length === 0) return;

    if (type === 'profileVideo') {
      setValue('media.profileVideo', fileUrls[0]);
      toast({
        title: "Profile video uploaded",
        description: "Your profile video has been updated",
      });
    } else {
      const currentFiles = watch(`media.${type}`, []);
      setValue(`media.${type}`, [...currentFiles, ...fileUrls]);
      toast({
        title: "Media uploaded",
        description: `${fileUrls.length} files have been added to your ${type.replace('Album', ' album')}`,
      });
    }
  };

  const removeFile = (
    index: number,
    type: 'profilePictures' | 'profileVideo' | 'publicAlbum' | 'privateAlbum'
  ) => {
    if (type === 'profileVideo') {
      setValue('media.profileVideo', '');
    } else {
      const currentFiles = [...watch(`media.${type}`, [])];
      currentFiles.splice(index, 1);
      setValue(`media.${type}`, currentFiles);
    }
    
    toast({
      title: "Media removed",
      description: "The selected item has been removed",
    });
  };

  const handleShareMedia = (media: string) => {
    setSelectedMedia(media);
    setShareWith([]);
    setShareDialogOpen(true);
  };

  const toggleShareWithUser = (userId: string) => {
    setShareWith(prev => 
      prev.includes(userId) 
        ? prev.filter(id => id !== userId) 
        : [...prev, userId]
    );
  };

  const completeShare = () => {
    if (shareWith.length > 0) {
      toast({
        title: "Private media shared",
        description: `Shared with ${shareWith.length} contact${shareWith.length > 1 ? 's' : ''}`,
      });
    }
    setShareDialogOpen(false);
  };

  const handleManagePrivateAlbum = () => {
    navigate('/private-album');
  };

  return (
    <div className="space-y-6">
      <Tabs value={activeTab} onValueChange={(value) => setActiveTab(value as any)} className="w-full">
        <TabsList className="grid w-full grid-cols-3 bg-black">
          <TabsTrigger 
            value="profile" 
            className={`data-[state=active]:bg-[#E6FFF4] data-[state=active]:text-black`}
          >
            <Camera className="mr-2 h-4 w-4" />
            Profile
          </TabsTrigger>
          <TabsTrigger 
            value="public" 
            className={`data-[state=active]:bg-[#E6FFF4] data-[state=active]:text-black`}
          >
            <Unlock className="mr-2 h-4 w-4" />
            Public
          </TabsTrigger>
          <TabsTrigger 
            value="private" 
            className={`data-[state=active]:bg-[#E6FFF4] data-[state=active]:text-black`}
          >
            <Lock className="mr-2 h-4 w-4" />
            Private
          </TabsTrigger>
        </TabsList>
        
        <TabsContent value="profile" className="space-y-4">
          <FormItem>
            <FormLabel className="text-[#E6FFF4]">Profile Pictures</FormLabel>
            <div className="mb-2">
              <ScrollArea className="h-32 w-full border border-[#E6FFF4]/20 rounded-md p-2">
                <div className="grid grid-cols-3 gap-2">
                  {profilePictures.map((pic, index) => (
                    <MediaItem 
                      key={index} 
                      src={pic} 
                      type="image" 
                      onRemove={() => removeFile(index, 'profilePictures')} 
                    />
                  ))}
                </div>
              </ScrollArea>
            </div>
            <div className="flex justify-between">
              <p className="text-sm text-[#E6FFF4]/70">Upload up to 6 profile pictures</p>
              <div className="relative">
                <Button 
                  type="button" 
                  variant="outline"
                  size="sm"
                  className="bg-[#E6FFF4] text-black border-0 hover:bg-[#E6FFF4]/90"
                  disabled={profilePictures.length >= 6}
                >
                  <Image className="mr-2 h-4 w-4" />
                  Add Photos
                </Button>
                <Input
                  type="file"
                  accept="image/*"
                  multiple
                  className="absolute inset-0 opacity-0 cursor-pointer"
                  onChange={(e) => handleFileUpload(e, 'profilePictures')}
                  disabled={profilePictures.length >= 6}
                />
              </div>
            </div>
          </FormItem>
          
          <FormItem>
            <FormLabel className="text-[#E6FFF4]">Profile Video (10 seconds max)</FormLabel>
            {profileVideo ? (
              <div className="relative group">
                <video 
                  src={profileVideo} 
                  controls 
                  className="w-full h-40 object-cover rounded-md" 
                />
                <button
                  type="button"
                  onClick={() => removeFile(0, 'profileVideo')}
                  className="absolute top-2 right-2 bg-black/70 rounded-full p-1 opacity-0 group-hover:opacity-100 transition-opacity"
                >
                  <X size={16} className="text-white" />
                </button>
              </div>
            ) : (
              <div className="flex items-center justify-center h-40 border border-dashed border-[#E6FFF4]/20 rounded-md">
                <div className="text-center">
                  <Video className="mx-auto h-8 w-8 text-[#E6FFF4]/50 mb-2" />
                  <p className="text-[#E6FFF4]/70 text-sm mb-2">Upload a short video introduction</p>
                  <div className="relative inline-block">
                    <Button 
                      type="button" 
                      variant="outline"
                      size="sm"
                      className="bg-[#E6FFF4] text-black border-0 hover:bg-[#E6FFF4]/90"
                    >
                      <Upload className="mr-2 h-4 w-4" />
                      Upload Video
                    </Button>
                    <Input
                      type="file"
                      accept="video/*"
                      className="absolute inset-0 opacity-0 cursor-pointer"
                      onChange={(e) => handleFileUpload(e, 'profileVideo')}
                    />
                  </div>
                </div>
              </div>
            )}
            <p className="text-sm text-[#E6FFF4]/70 mt-1">
              Create a short video to introduce yourself (10 seconds max)
            </p>
          </FormItem>
        </TabsContent>
        
        <TabsContent value="public" className="space-y-4">
          <FormItem>
            <FormLabel className="text-[#E6FFF4]">Public Album</FormLabel>
            <p className="text-sm text-[#E6FFF4]/70 mb-2">
              These photos and videos will be visible to everyone who views your profile
            </p>
            <div className="mb-2">
              <ScrollArea className="h-60 w-full border border-[#E6FFF4]/20 rounded-md p-2">
                <div className="grid grid-cols-3 gap-2">
                  {publicAlbum.map((media, index) => (
                    <MediaItem 
                      key={index} 
                      src={media} 
                      type={media.includes('video') ? 'video' : 'image'}
                      onRemove={() => removeFile(index, 'publicAlbum')} 
                    />
                  ))}
                </div>
              </ScrollArea>
            </div>
            <div className="flex justify-between">
              <p className="text-sm text-[#E6FFF4]/70">Upload photos and videos to your public album</p>
              <div className="relative">
                <Button 
                  type="button" 
                  variant="outline"
                  size="sm"
                  className="bg-[#E6FFF4] text-black border-0 hover:bg-[#E6FFF4]/90"
                >
                  <Upload className="mr-2 h-4 w-4" />
                  Add Media
                </Button>
                <Input
                  type="file"
                  accept="image/*,video/*"
                  multiple
                  className="absolute inset-0 opacity-0 cursor-pointer"
                  onChange={(e) => handleFileUpload(e, 'publicAlbum')}
                />
              </div>
            </div>
          </FormItem>
        </TabsContent>
        
        <TabsContent value="private" className="space-y-4">
          <FormItem>
            <FormLabel className="text-[#E6FFF4]">Private Album</FormLabel>
            <p className="text-sm text-[#E6FFF4]/70 mb-2">
              These photos and videos will only be visible to people you give access to
            </p>
            <div className="mb-2">
              <ScrollArea className="h-60 w-full border border-[#E6FFF4]/20 rounded-md p-2">
                <div className="grid grid-cols-3 gap-2">
                  {privateAlbum.map((media, index) => (
                    <MediaItem 
                      key={index} 
                      src={media} 
                      type={media.includes('video') ? 'video' : 'image'}
                      onRemove={() => removeFile(index, 'privateAlbum')}
                      onShare={() => handleShareMedia(media)}
                      isPrivate
                    />
                  ))}
                </div>
              </ScrollArea>
            </div>
            <div className="flex flex-wrap gap-2">
              <div className="relative">
                <Button 
                  type="button" 
                  variant="outline"
                  size="sm"
                  className="bg-[#E6FFF4] text-black border-0 hover:bg-[#E6FFF4]/90"
                >
                  <Upload className="mr-2 h-4 w-4" />
                  Add Media
                </Button>
                <Input
                  type="file"
                  accept="image/*,video/*"
                  multiple
                  className="absolute inset-0 opacity-0 cursor-pointer"
                  onChange={(e) => handleFileUpload(e, 'privateAlbum')}
                />
              </div>
              
              <Button
                type="button"
                variant="outline"
                size="sm"
                className="border border-[#E6FFF4]/30 text-[#E6FFF4] hover:bg-[#E6FFF4]/10 flex-1 md:flex-none"
                onClick={handleManagePrivateAlbum}
              >
                <Lock className="mr-2 h-4 w-4" />
                Manage XXX Album
              </Button>
            </div>
          </FormItem>
          <div className="bg-[#1A1A1A] p-4 rounded-md border border-[#E6FFF4]/10">
            <h4 className="text-[#E6FFF4] font-medium mb-1">Private Album Privacy</h4>
            <p className="text-sm text-[#E6FFF4]/70">
              Your private album is only visible to users you explicitly share it with. 
              You'll be able to grant or revoke access to specific users at any time.
            </p>
          </div>
          
          <div className="bg-[#1A1A1A] p-4 rounded-md border border-[#E6FFF4]/10">
            <div className="flex items-center justify-between mb-2">
              <h4 className="text-[#E6FFF4] font-medium">Share Management</h4>
              <Button 
                type="button" 
                variant="outline"
                size="sm"
                className="bg-transparent text-[#E6FFF4] border border-[#E6FFF4]/30 hover:bg-[#E6FFF4]/10"
                onClick={() => {
                  toast({
                    title: "Access Management",
                    description: "Open the access management screen to manage who can see your private media",
                  });
                }}
              >
                <Users className="mr-2 h-4 w-4" />
                Manage Access
              </Button>
            </div>
            <p className="text-sm text-[#E6FFF4]/70">
              Control access to your private album and see who has viewed your shared content.
            </p>
          </div>
        </TabsContent>
      </Tabs>
      
      <Dialog open={shareDialogOpen} onOpenChange={setShareDialogOpen}>
        <DialogContent className="bg-[#1A1A1A] border border-[#E6FFF4]/30">
          <DialogHeader>
            <DialogTitle className="text-[#E6FFF4]">Share Private Content</DialogTitle>
            <DialogDescription className="text-[#E6FFF4]/70">
              Select people to share this private content with. They will receive a notification.
            </DialogDescription>
          </DialogHeader>
          
          {selectedMedia && (
            <div className="w-full max-h-40 flex justify-center overflow-hidden rounded-md">
              {selectedMedia.includes('video') ? (
                <video src={selectedMedia} className="h-40 object-cover" muted />
              ) : (
                <img src={selectedMedia} alt="Share preview" className="h-40 object-cover" />
              )}
            </div>
          )}
          
          <div className="space-y-2 max-h-60 overflow-y-auto">
            {contacts.map(contact => (
              <div 
                key={contact.id}
                className={`flex items-center p-2 rounded-md cursor-pointer ${
                  shareWith.includes(contact.id) ? 'bg-[#E6FFF4]/10 border border-[#E6FFF4]/30' : ''
                }`}
                onClick={() => toggleShareWithUser(contact.id)}
              >
                <img 
                  src={contact.image} 
                  alt={contact.name} 
                  className="w-10 h-10 rounded-full object-cover mr-3" 
                />
                <div className="flex-1">
                  <h4 className="text-[#E6FFF4] font-medium">{contact.name}</h4>
                </div>
                <div className={`w-6 h-6 rounded-full flex items-center justify-center ${
                  shareWith.includes(contact.id) 
                    ? 'bg-[#E6FFF4] text-black' 
                    : 'border border-[#E6FFF4]/30'
                }`}>
                  {shareWith.includes(contact.id) && <X size={14} />}
                </div>
              </div>
            ))}
          </div>
          
          <DialogFooter>
            <Button
              type="button"
              variant="ghost"
              onClick={() => setShareDialogOpen(false)}
              className="text-[#E6FFF4]/70 hover:text-[#E6FFF4] hover:bg-transparent"
            >
              Cancel
            </Button>
            <Button
              type="button"
              onClick={completeShare}
              className="bg-[#E6FFF4] text-black hover:bg-[#E6FFF4]/90"
              disabled={shareWith.length === 0}
            >
              Share with {shareWith.length > 0 ? shareWith.length : ''} {shareWith.length === 1 ? 'person' : 'people'}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
};

export default MediaUploadSection;
