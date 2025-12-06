
import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, Upload, Lock, Eye, EyeOff, Share2, Users, Image, Video, X } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Avatar, AvatarImage, AvatarFallback } from '@/components/ui/avatar';
import { ScrollArea } from '@/components/ui/scroll-area';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { 
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
  DialogFooter,
} from '@/components/ui/dialog';
import { toast } from '@/hooks/use-toast';
import { Badge } from '@/components/ui/badge';

interface MediaItemProps {
  src: string;
  type: 'image' | 'video';
  isPrivate: boolean;
  isSelected?: boolean;
  onSelect?: () => void;
  onRemove: () => void;
  onShare?: () => void;
  onSetAsProfile?: () => void;
}

const MediaItem: React.FC<MediaItemProps> = ({ 
  src, 
  type, 
  isPrivate, 
  isSelected,
  onSelect, 
  onRemove, 
  onShare, 
  onSetAsProfile 
}) => {
  return (
    <div className={`relative group rounded-md overflow-hidden ${isSelected ? 'ring-2 ring-[#E6FFF4]' : ''}`}>
      <div className="relative aspect-square">
        {type === 'image' ? (
          <img 
            src={src} 
            alt="Media preview" 
            className="w-full h-full object-cover"
          />
        ) : (
          <video 
            src={src} 
            className="w-full h-full object-cover" 
            muted
          />
        )}
        
        {isPrivate && (
          <div className="absolute bottom-1 left-1 bg-black/70 rounded-full p-1">
            <Lock size={12} className="text-[#E6FFF4]" />
          </div>
        )}
        
        <div className="absolute inset-0 bg-black/0 group-hover:bg-black/30 transition-colors">
          {onSelect && (
            <button
              type="button"
              onClick={onSelect}
              className="absolute inset-0 w-full h-full"
            />
          )}
        </div>
      </div>
      
      <div className="absolute top-1 right-1 flex space-x-1 opacity-0 group-hover:opacity-100 transition-opacity">
        {onSetAsProfile && (
          <button
            type="button"
            onClick={onSetAsProfile}
            className="bg-black/70 rounded-full p-1"
            title="Set as profile photo"
          >
            <Users size={16} className="text-white" />
          </button>
        )}
        {onShare && (
          <button
            type="button"
            onClick={onShare}
            className="bg-black/70 rounded-full p-1"
            title="Share media"
          >
            <Share2 size={16} className="text-white" />
          </button>
        )}
        <button
          type="button"
          onClick={onRemove}
          className="bg-black/70 rounded-full p-1"
          title="Remove media"
        >
          <X size={16} className="text-white" />
        </button>
      </div>
    </div>
  );
};

const PrivateAlbumView: React.FC = () => {
  const navigate = useNavigate();
  const [activeTab, setActiveTab] = useState<'all' | 'public' | 'private'>('all');
  const [shareDialogOpen, setShareDialogOpen] = useState(false);
  const [privacyDialogOpen, setPrivacyDialogOpen] = useState(false);
  const [selectedMedia, setSelectedMedia] = useState<string | null>(null);
  const [shareWith, setShareWith] = useState<string[]>([]);
  const [selectedMediaForMap, setSelectedMediaForMap] = useState<string[]>([]);
  
  // Mock media data - in a real app, this would come from a database
  const [publicAlbum, setPublicAlbum] = useState([
    '/placeholder.svg',
    '/placeholder.svg',
    '/placeholder.svg',
  ]);
  
  const [privateAlbum, setPrivateAlbum] = useState([
    '/placeholder.svg',
    '/placeholder.svg',
    '/placeholder.svg',
    '/placeholder.svg',
  ]);
  
  const [profileMedia, setProfileMedia] = useState({
    main: '/placeholder.svg',
    secondary: ['/placeholder.svg', '/placeholder.svg']
  });

  // Mock contacts
  const contacts = [
    { id: '1', name: 'Alex', image: 'https://images.unsplash.com/photo-1504257432389-52343af06ae3?w=500&h=500&fit=crop', distance: '0.5 mi' },
    { id: '2', name: 'Brandon', image: 'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=500&h=500&fit=crop', distance: '1.2 mi' },
    { id: '3', name: 'Carlos', image: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=500&h=500&fit=crop', distance: '2.7 mi' },
  ];

  const handleBack = () => {
    navigate(-1);
  };
  
  const handleFileUpload = (
    event: React.ChangeEvent<HTMLInputElement>,
    isPrivate: boolean
  ) => {
    const files = event.target.files;
    if (!files || files.length === 0) return;

    // For demonstration purposes, we'll create object URLs
    const fileUrls = Array.from(files).map(file => {
      return URL.createObjectURL(file);
    });

    if (isPrivate) {
      setPrivateAlbum(prev => [...prev, ...fileUrls]);
    } else {
      setPublicAlbum(prev => [...prev, ...fileUrls]);
    }
    
    toast({
      title: `${fileUrls.length} files uploaded`,
      description: `Added to your ${isPrivate ? 'private' : 'public'} album`,
    });
  };

  const handleRemoveMedia = (index: number, isPrivate: boolean) => {
    if (isPrivate) {
      setPrivateAlbum(prev => prev.filter((_, i) => i !== index));
    } else {
      setPublicAlbum(prev => prev.filter((_, i) => i !== index));
    }
    
    toast({
      title: "Media removed",
      description: "The selected item has been removed from your album",
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
  
  const toggleMediaForMap = (media: string) => {
    setSelectedMediaForMap(prev => 
      prev.includes(media)
        ? prev.filter(m => m !== media)
        : [...prev, media].slice(0, 3) // Limit to 3 selections
    );
  };
  
  const handleSetAsProfile = (media: string) => {
    setProfileMedia(prev => ({
      ...prev,
      main: media,
    }));
    
    toast({
      title: "Profile photo updated",
      description: "Your main profile photo has been updated",
    });
  };

  const saveMapSelections = () => {
    if (selectedMediaForMap.length === 0) {
      toast({
        title: "No photos selected",
        description: "Please select at least one photo for your map profile",
        variant: "destructive",
      });
      return;
    }
    
    setPrivacyDialogOpen(false);
    
    if (selectedMediaForMap.length > 0) {
      setProfileMedia({
        main: selectedMediaForMap[0],
        secondary: selectedMediaForMap.slice(1, 3)
      });
    }
    
    toast({
      title: "Map profile updated",
      description: `${selectedMediaForMap.length} photos selected for your map profile`,
    });
    
    // In a real app, you'd save this to the user's profile
  };

  return (
    <div className="flex flex-col min-h-screen bg-black text-white pb-20">
      {/* Header */}
      <div className="fixed top-0 left-0 right-0 bg-black z-10 border-b border-[#333333]">
        <div className="flex items-center px-4 py-3">
          <button onClick={handleBack} className="mr-2">
            <ArrowLeft className="w-6 h-6 text-white" />
          </button>
          <h2 className="text-xl font-medium text-white">My Media</h2>
          
          <div className="ml-auto">
            <Button
              variant="outline"
              onClick={() => setPrivacyDialogOpen(true)}
              size="sm"
              className="bg-[#E6FFF4] text-black hover:bg-[#E6FFF4]/90 mr-2"
            >
              <Users className="mr-1 h-4 w-4" />
              Map Profile
            </Button>
          </div>
        </div>
      </div>
      
      {/* Album tabs */}
      <div className="pt-14 px-4">
        <Tabs value={activeTab} onValueChange={(value) => setActiveTab(value as any)} className="w-full">
          <TabsList className="grid w-full grid-cols-3 bg-[#1A1A1A]">
            <TabsTrigger 
              value="all" 
              className={`data-[state=active]:bg-[#E6FFF4] data-[state=active]:text-black`}
            >
              All
            </TabsTrigger>
            <TabsTrigger 
              value="public" 
              className={`data-[state=active]:bg-[#E6FFF4] data-[state=active]:text-black`}
            >
              <Eye className="mr-2 h-4 w-4" />
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
          
          {/* All Media Tab */}
          <TabsContent value="all" className="mt-4">
            <div className="flex justify-between mb-4">
              <h3 className="text-lg font-medium text-[#E6FFF4]">Public Album</h3>
              <div className="relative">
                <Button 
                  type="button" 
                  variant="outline"
                  size="sm"
                  className="bg-[#E6FFF4] text-black border-0 hover:bg-[#E6FFF4]/90"
                >
                  <Upload className="mr-2 h-4 w-4" />
                  Add
                </Button>
                <Input
                  type="file"
                  accept="image/*,video/*"
                  multiple
                  className="absolute inset-0 opacity-0 cursor-pointer"
                  onChange={(e) => handleFileUpload(e, false)}
                />
              </div>
            </div>
            <div className="grid grid-cols-3 gap-2 mb-6">
              {publicAlbum.map((media, index) => (
                <MediaItem 
                  key={`public-${index}`} 
                  src={media} 
                  type={media.includes('video') ? 'video' : 'image'} 
                  isPrivate={false}
                  onRemove={() => handleRemoveMedia(index, false)} 
                  onSetAsProfile={() => handleSetAsProfile(media)}
                />
              ))}
            </div>
            
            <div className="flex justify-between mb-4">
              <h3 className="text-lg font-medium text-[#E6FFF4]">Private Album</h3>
              <div className="relative">
                <Button 
                  type="button" 
                  variant="outline"
                  size="sm"
                  className="bg-[#E6FFF4] text-black border-0 hover:bg-[#E6FFF4]/90"
                >
                  <Upload className="mr-2 h-4 w-4" />
                  Add
                </Button>
                <Input
                  type="file"
                  accept="image/*,video/*"
                  multiple
                  className="absolute inset-0 opacity-0 cursor-pointer"
                  onChange={(e) => handleFileUpload(e, true)}
                />
              </div>
            </div>
            <div className="grid grid-cols-3 gap-2">
              {privateAlbum.map((media, index) => (
                <MediaItem 
                  key={`private-${index}`} 
                  src={media} 
                  type={media.includes('video') ? 'video' : 'image'} 
                  isPrivate={true}
                  onRemove={() => handleRemoveMedia(index, true)} 
                  onShare={() => handleShareMedia(media)}
                  onSetAsProfile={() => handleSetAsProfile(media)}
                />
              ))}
            </div>
          </TabsContent>
          
          {/* Public Album Tab */}
          <TabsContent value="public" className="mt-4">
            <div className="flex justify-between mb-4">
              <h3 className="text-lg font-medium text-[#E6FFF4]">Public Album</h3>
              <div className="relative">
                <Button 
                  type="button" 
                  variant="outline"
                  size="sm"
                  className="bg-[#E6FFF4] text-black border-0 hover:bg-[#E6FFF4]/90"
                >
                  <Upload className="mr-2 h-4 w-4" />
                  Add
                </Button>
                <Input
                  type="file"
                  accept="image/*,video/*"
                  multiple
                  className="absolute inset-0 opacity-0 cursor-pointer"
                  onChange={(e) => handleFileUpload(e, false)}
                />
              </div>
            </div>
            {publicAlbum.length > 0 ? (
              <div className="grid grid-cols-3 gap-2">
                {publicAlbum.map((media, index) => (
                  <MediaItem 
                    key={`public-tab-${index}`} 
                    src={media} 
                    type={media.includes('video') ? 'video' : 'image'} 
                    isPrivate={false}
                    onRemove={() => handleRemoveMedia(index, false)} 
                    onSetAsProfile={() => handleSetAsProfile(media)}
                  />
                ))}
              </div>
            ) : (
              <div className="flex flex-col items-center justify-center h-40 border border-dashed border-[#333333] rounded-md">
                <Image className="h-10 w-10 text-[#333333] mb-2" />
                <p className="text-[#666666]">No public media</p>
              </div>
            )}
          </TabsContent>
          
          {/* Private Album Tab */}
          <TabsContent value="private" className="mt-4">
            <div className="flex justify-between mb-4">
              <h3 className="text-lg font-medium text-[#E6FFF4]">Private Album</h3>
              <div className="relative">
                <Button 
                  type="button" 
                  variant="outline"
                  size="sm"
                  className="bg-[#E6FFF4] text-black border-0 hover:bg-[#E6FFF4]/90"
                >
                  <Upload className="mr-2 h-4 w-4" />
                  Add
                </Button>
                <Input
                  type="file"
                  accept="image/*,video/*"
                  multiple
                  className="absolute inset-0 opacity-0 cursor-pointer"
                  onChange={(e) => handleFileUpload(e, true)}
                />
              </div>
            </div>
            {privateAlbum.length > 0 ? (
              <div className="grid grid-cols-3 gap-2">
                {privateAlbum.map((media, index) => (
                  <MediaItem 
                    key={`private-tab-${index}`} 
                    src={media} 
                    type={media.includes('video') ? 'video' : 'image'} 
                    isPrivate={true}
                    onRemove={() => handleRemoveMedia(index, true)} 
                    onShare={() => handleShareMedia(media)}
                    onSetAsProfile={() => handleSetAsProfile(media)}
                  />
                ))}
              </div>
            ) : (
              <div className="flex flex-col items-center justify-center h-40 border border-dashed border-[#333333] rounded-md">
                <Lock className="h-10 w-10 text-[#333333] mb-2" />
                <p className="text-[#666666]">No private media</p>
              </div>
            )}
            
            <div className="bg-[#1A1A1A] p-4 rounded-md border border-[#E6FFF4]/10 mt-6">
              <h4 className="text-[#E6FFF4] font-medium mb-1">Private Album Privacy</h4>
              <p className="text-sm text-[#E6FFF4]/70">
                Your private album is only visible to users you explicitly share it with. 
                You'll be able to grant or revoke access to specific users at any time.
              </p>
            </div>
          </TabsContent>
        </Tabs>
      </div>
      
      {/* Share dialog */}
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
                  <p className="text-xs text-[#E6FFF4]/70">{contact.distance}</p>
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
      
      {/* Map Profile Selection Dialog */}
      <Dialog open={privacyDialogOpen} onOpenChange={setPrivacyDialogOpen}>
        <DialogContent className="bg-[#1A1A1A] border border-[#E6FFF4]/30">
          <DialogHeader>
            <DialogTitle className="text-[#E6FFF4]">Map Profile Photos</DialogTitle>
            <DialogDescription className="text-[#E6FFF4]/70">
              Select up to 3 photos to use on the map. The first selection will be your main profile photo.
            </DialogDescription>
          </DialogHeader>
          
          <div className="space-y-4">
            {/* Current selections */}
            <div className="bg-black/50 p-3 rounded-md">
              <h4 className="text-sm font-medium text-[#E6FFF4] mb-2">Current Map Profile</h4>
              <div className="flex space-x-2">
                <div className="w-16 h-16 rounded-full overflow-hidden border-2 border-[#E6FFF4]">
                  <img src={profileMedia.main} alt="Main profile" className="w-full h-full object-cover" />
                </div>
                {profileMedia.secondary.map((img, i) => (
                  <div key={i} className="w-12 h-12 rounded-full overflow-hidden border border-[#E6FFF4]/50">
                    <img src={img} alt={`Secondary profile ${i+1}`} className="w-full h-full object-cover" />
                  </div>
                ))}
              </div>
            </div>
            
            {/* Selection grid */}
            <div>
              <h4 className="text-sm font-medium text-[#E6FFF4] mb-2">Select from your media</h4>
              <ScrollArea className="h-60 w-full">
                <div className="grid grid-cols-3 gap-2 p-1">
                  {[...privateAlbum, ...publicAlbum].map((media, index) => (
                    <MediaItem 
                      key={`selection-${index}`}
                      src={media} 
                      type={media.includes('video') ? 'video' : 'image'} 
                      isPrivate={privateAlbum.includes(media)}
                      isSelected={selectedMediaForMap.includes(media)}
                      onSelect={() => toggleMediaForMap(media)}
                      onRemove={() => {}} // Not used in selection mode
                    />
                  ))}
                </div>
              </ScrollArea>
              
              <div className="flex items-center justify-between mt-2">
                <p className="text-xs text-[#E6FFF4]/70">
                  {selectedMediaForMap.length}/3 selected
                </p>
                {selectedMediaForMap.length > 0 && (
                  <Button
                    size="sm"
                    variant="outline"
                    onClick={() => setSelectedMediaForMap([])}
                    className="text-xs border-[#E6FFF4]/30 text-[#E6FFF4]/70"
                  >
                    Clear selection
                  </Button>
                )}
              </div>
            </div>
          </div>
          
          <DialogFooter>
            <Button
              type="button"
              variant="ghost"
              onClick={() => setPrivacyDialogOpen(false)}
              className="text-[#E6FFF4]/70 hover:text-[#E6FFF4] hover:bg-transparent"
            >
              Cancel
            </Button>
            <Button
              type="button"
              onClick={saveMapSelections}
              className="bg-[#E6FFF4] text-black hover:bg-[#E6FFF4]/90"
            >
              Save Map Profile
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
};

export default PrivateAlbumView;
