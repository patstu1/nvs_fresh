
import React, { useState } from 'react';
import { Image, Lock, Plus, Trash2, Video, Upload, Unlock, Share2, Eye, UserPlus } from 'lucide-react';
import { cn } from '@/lib/utils';
import { toast } from '@/hooks/use-toast';
import { Input } from './ui/input';
import { Button } from './ui/button';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { 
  Dialog, 
  DialogContent, 
  DialogHeader, 
  DialogTitle, 
  DialogDescription, 
  DialogFooter 
} from '@/components/ui/dialog';
import { ScrollArea } from '@/components/ui/scroll-area';

interface Media {
  id: string;
  url: string;
  isPrivate: boolean;
  type: 'image' | 'video';
}

interface Contact {
  id: string;
  name: string;
  image: string;
  hasAccess?: boolean;
}

const PhotoAlbumView: React.FC = () => {
  const [publicMedia, setPublicMedia] = useState<Media[]>([
    { id: '1', url: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=500&h=500&fit=crop', isPrivate: false, type: 'image' },
    { id: '2', url: 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=500&h=500&fit=crop', isPrivate: false, type: 'image' },
    { id: '3', url: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500&h=500&fit=crop', isPrivate: false, type: 'image' },
  ]);
  
  const [privateMedia, setPrivateMedia] = useState<Media[]>([
    { id: '4', url: 'https://images.unsplash.com/photo-1488161628813-04466f872be2?w=500&h=500&fit=crop', isPrivate: true, type: 'image' },
    { id: '5', url: 'https://images.unsplash.com/photo-1492681290082-e932832941e6?w=500&h=500&fit=crop', isPrivate: true, type: 'image' },
  ]);
  
  const [profileVideo, setProfileVideo] = useState<string | null>(null);
  const [showPrivate, setShowPrivate] = useState(false);
  const [activeTab, setActiveTab] = useState<'public' | 'private' | 'profile'>('public');
  
  // New states for enhanced functionality
  const [shareDialogOpen, setShareDialogOpen] = useState(false);
  const [albumAccessDialogOpen, setAlbumAccessDialogOpen] = useState(false);
  const [selectedMediaId, setSelectedMediaId] = useState<string | null>(null);
  const [selectedContacts, setSelectedContacts] = useState<string[]>([]);

  // Mock contacts data - in a real app, this would come from an API
  const [contacts, setContacts] = useState<Contact[]>([
    { id: '1', name: 'Alex', image: 'https://images.unsplash.com/photo-1504257432389-52343af06ae3?w=500&h=500&fit=crop', hasAccess: false },
    { id: '2', name: 'Brandon', image: 'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=500&h=500&fit=crop', hasAccess: true },
    { id: '3', name: 'Carlos', image: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=500&h=500&fit=crop', hasAccess: false },
  ]);

  const handleTogglePrivate = () => {
    setShowPrivate(!showPrivate);
    if (!showPrivate) {
      toast({
        title: "Private Album",
        description: "Viewing private photos",
      });
    }
  };
  
  const handleUploadMedia = (e: React.ChangeEvent<HTMLInputElement>, albumType: 'public' | 'private' | 'profile') => {
    const files = e.target.files;
    if (!files || files.length === 0) return;
    
    // For demonstration - in real app you would upload to server
    const fileArray = Array.from(files);
    
    if (albumType === 'profile') {
      // Handle profile video upload (only first file)
      const file = fileArray[0];
      if (file.type.startsWith('video/')) {
        const videoUrl = URL.createObjectURL(file);
        setProfileVideo(videoUrl);
        toast({
          title: "Profile Video Uploaded",
          description: "Your profile video has been updated",
        });
      } else {
        toast({
          title: "Invalid File Type",
          description: "Please upload a video file for your profile video",
          variant: "destructive"
        });
      }
      return;
    }
    
    const newMedia = fileArray.map((file, index) => {
      const isVideo = file.type.startsWith('video/');
      const url = URL.createObjectURL(file);
      return {
        id: Date.now().toString() + index,
        url,
        isPrivate: albumType === 'private',
        type: isVideo ? 'video' as const : 'image' as const
      };
    });
    
    if (albumType === 'public') {
      setPublicMedia(prev => [...prev, ...newMedia]);
    } else {
      setPrivateMedia(prev => [...prev, ...newMedia]);
    }
    
    toast({
      title: `${albumType === 'public' ? 'Public' : 'Private'} Media Added`,
      description: `Added ${newMedia.length} items to your ${albumType} album`,
    });
  };
  
  const handleDeleteMedia = (id: string, isPrivate: boolean) => {
    if (isPrivate) {
      setPrivateMedia(privateMedia.filter(item => item.id !== id));
    } else {
      setPublicMedia(publicMedia.filter(item => item.id !== id));
    }
    
    toast({
      title: "Media Deleted",
      description: "Item has been removed from your album",
    });
  };
  
  const handleToggleMediaPrivacy = (id: string, currentlyPrivate: boolean) => {
    if (currentlyPrivate) {
      const media = privateMedia.find(item => item.id === id);
      if (media) {
        setPrivateMedia(privateMedia.filter(item => item.id !== id));
        setPublicMedia([...publicMedia, { ...media, isPrivate: false }]);
      }
    } else {
      const media = publicMedia.find(item => item.id === id);
      if (media) {
        setPublicMedia(publicMedia.filter(item => item.id !== id));
        setPrivateMedia([...privateMedia, { ...media, isPrivate: true }]);
      }
    }
    
    toast({
      title: currentlyPrivate ? "Media Made Public" : "Media Made Private",
      description: currentlyPrivate ? "Item moved to public album" : "Item moved to private album",
    });
  };
  
  const handleDeleteProfileVideo = () => {
    setProfileVideo(null);
    toast({
      title: "Profile Video Removed",
      description: "Your profile video has been removed",
    });
  };

  // New handlers for enhanced functionality
  const openShareDialog = (id: string) => {
    setSelectedMediaId(id);
    setSelectedContacts([]);
    setShareDialogOpen(true);
  };

  const toggleContactSelection = (contactId: string) => {
    setSelectedContacts(prev => 
      prev.includes(contactId)
        ? prev.filter(id => id !== contactId)
        : [...prev, contactId]
    );
  };

  const handleShareMedia = () => {
    if (selectedContacts.length === 0) {
      toast({
        title: "No Contacts Selected",
        description: "Please select at least one contact to share with",
        variant: "destructive"
      });
      return;
    }

    // In a real app, you would make an API call here to share with selected contacts
    toast({
      title: "Media Shared",
      description: `Shared with ${selectedContacts.length} ${selectedContacts.length === 1 ? 'person' : 'people'}`,
    });

    setShareDialogOpen(false);
  };

  const openAlbumAccessDialog = () => {
    setAlbumAccessDialogOpen(true);
  };

  const toggleContactAccess = (contactId: string) => {
    setContacts(contacts.map(contact => 
      contact.id === contactId 
        ? { ...contact, hasAccess: !contact.hasAccess }
        : contact
    ));
  };

  const saveAlbumAccessChanges = () => {
    // In a real app, you would make an API call here to update access permissions
    toast({
      title: "Access Permissions Updated",
      description: `Updated access for ${contacts.filter(c => c.hasAccess).length} contacts`,
    });

    setAlbumAccessDialogOpen(false);
  };

  return (
    <div className="w-full h-full pt-16 pb-20 px-4">
      <div className="mb-4">
        <Tabs value={activeTab} onValueChange={(val) => setActiveTab(val as any)} className="w-full">
          <TabsList className="grid w-full grid-cols-3 bg-black">
            <TabsTrigger 
              value="public" 
              className={`data-[state=active]:bg-[#86db7d] data-[state=active]:text-black`}
            >
              <Image className="mr-2 h-4 w-4" />
              Public
            </TabsTrigger>
            <TabsTrigger 
              value="private" 
              className={`data-[state=active]:bg-[#86db7d] data-[state=active]:text-black`}
            >
              <Lock className="mr-2 h-4 w-4" />
              Private
            </TabsTrigger>
            <TabsTrigger 
              value="profile" 
              className={`data-[state=active]:bg-[#86db7d] data-[state=active]:text-black`}
            >
              <Video className="mr-2 h-4 w-4" />
              Profile Vid
            </TabsTrigger>
          </TabsList>
          
          {/* Public Album Tab */}
          <TabsContent value="public" className="mt-4">
            <div className="flex justify-between items-center mb-4">
              <h2 className="text-xl font-bold text-[#E6FFF4]">Public Album</h2>
              <div className="relative">
                <Button 
                  className="w-10 h-10 rounded-full bg-[#86db7d] flex items-center justify-center"
                >
                  <Plus className="w-6 h-6 text-black" />
                </Button>
                <Input
                  type="file"
                  accept="image/*,video/*"
                  multiple
                  className="absolute inset-0 opacity-0 cursor-pointer"
                  onChange={(e) => handleUploadMedia(e, 'public')}
                />
              </div>
            </div>
            
            <div className="grid grid-cols-3 gap-2">
              {publicMedia.map((media) => (
                <div key={media.id} className="relative aspect-square">
                  {media.type === 'image' ? (
                    <img 
                      src={media.url} 
                      alt="Album media" 
                      className="w-full h-full object-cover rounded-lg"
                    />
                  ) : (
                    <video
                      src={media.url}
                      className="w-full h-full object-cover rounded-lg"
                      controls
                    />
                  )}
                  <div className="absolute inset-0 flex items-center justify-center opacity-0 hover:opacity-100 bg-black/50 rounded-lg transition-opacity">
                    <button 
                      onClick={() => handleToggleMediaPrivacy(media.id, media.isPrivate)}
                      className="w-8 h-8 rounded-full bg-white/20 flex items-center justify-center mr-2"
                    >
                      <Lock className="w-4 h-4 text-white" />
                    </button>
                    <button 
                      onClick={() => handleDeleteMedia(media.id, media.isPrivate)}
                      className="w-8 h-8 rounded-full bg-white/20 flex items-center justify-center"
                    >
                      <Trash2 className="w-4 h-4 text-white" />
                    </button>
                  </div>
                </div>
              ))}
              {publicMedia.length === 0 && (
                <div className="col-span-3 text-center py-8">
                  <div className="w-12 h-12 rounded-full bg-[#2A2A2A] flex items-center justify-center mx-auto mb-4">
                    <Image className="w-6 h-6 text-gray-400" />
                  </div>
                  <p className="text-gray-400">No public media yet</p>
                  <div className="relative mt-4 inline-block">
                    <Button 
                      className="bg-[#86db7d] text-black hover:bg-[#86db7d]/90"
                    >
                      <Upload className="mr-2 h-4 w-4" />
                      Add media
                    </Button>
                    <Input
                      type="file"
                      accept="image/*,video/*"
                      multiple
                      className="absolute inset-0 opacity-0 cursor-pointer"
                      onChange={(e) => handleUploadMedia(e, 'public')}
                    />
                  </div>
                </div>
              )}
            </div>
          </TabsContent>
          
          {/* Private Album Tab */}
          <TabsContent value="private" className="mt-4">
            <div className="flex justify-between items-center mb-4">
              <h2 className="text-xl font-bold text-[#E6FFF4]">Private Album</h2>
              <div className="flex items-center">
                <button 
                  onClick={handleTogglePrivate}
                  className={cn(
                    "px-3 py-1 rounded-full text-sm mr-2",
                    showPrivate 
                      ? "bg-[#86db7d] text-black" 
                      : "bg-[#2A2A2A] text-white"
                  )}
                >
                  {showPrivate ? "Hide" : "Show"}
                </button>
                <div className="relative">
                  <Button 
                    className="w-10 h-10 rounded-full bg-[#86db7d] flex items-center justify-center"
                  >
                    <Plus className="w-6 h-6 text-black" />
                  </Button>
                  <Input
                    type="file"
                    accept="image/*,video/*"
                    multiple
                    className="absolute inset-0 opacity-0 cursor-pointer"
                    onChange={(e) => handleUploadMedia(e, 'private')}
                  />
                </div>
              </div>
            </div>
            
            {showPrivate ? (
              <>
                <div className="grid grid-cols-3 gap-2">
                  {privateMedia.map((media) => (
                    <div key={media.id} className="relative aspect-square">
                      {media.type === 'image' ? (
                        <img 
                          src={media.url} 
                          alt="Private media" 
                          className="w-full h-full object-cover rounded-lg"
                        />
                      ) : (
                        <video
                          src={media.url}
                          className="w-full h-full object-cover rounded-lg"
                          controls
                        />
                      )}
                      <div className="absolute inset-0 flex items-center justify-center opacity-0 hover:opacity-100 bg-black/50 rounded-lg transition-opacity">
                        <button 
                          onClick={() => openShareDialog(media.id)}
                          className="w-8 h-8 rounded-full bg-white/20 flex items-center justify-center mr-2"
                        >
                          <Share2 className="w-4 h-4 text-white" />
                        </button>
                        <button 
                          onClick={() => handleToggleMediaPrivacy(media.id, media.isPrivate)}
                          className="w-8 h-8 rounded-full bg-white/20 flex items-center justify-center mr-2"
                        >
                          <Unlock className="w-4 h-4 text-white" />
                        </button>
                        <button 
                          onClick={() => handleDeleteMedia(media.id, media.isPrivate)}
                          className="w-8 h-8 rounded-full bg-white/20 flex items-center justify-center"
                        >
                          <Trash2 className="w-4 h-4 text-white" />
                        </button>
                      </div>
                    </div>
                  ))}
                  {privateMedia.length === 0 && (
                    <div className="col-span-3 text-center py-8">
                      <div className="w-12 h-12 rounded-full bg-[#2A2A2A] flex items-center justify-center mx-auto mb-4">
                        <Lock className="w-6 h-6 text-gray-400" />
                      </div>
                      <p className="text-gray-400">No private media yet</p>
                      <div className="relative mt-4 inline-block">
                        <Button 
                          className="bg-[#86db7d] text-black hover:bg-[#86db7d]/90"
                        >
                          <Upload className="mr-2 h-4 w-4" />
                          Add media
                        </Button>
                        <Input
                          type="file"
                          accept="image/*,video/*"
                          multiple
                          className="absolute inset-0 opacity-0 cursor-pointer"
                          onChange={(e) => handleUploadMedia(e, 'private')}
                        />
                      </div>
                    </div>
                  )}
                </div>
                
                {privateMedia.length > 0 && (
                  <div className="mt-4 space-y-4">
                    <div className="bg-[#1A1A1A] p-4 rounded-lg">
                      <h3 className="text-[#E6FFF4] font-medium mb-2">Album Access Controls</h3>
                      <p className="text-[#E6FFF4]/70 text-sm mb-3">
                        Manage who can view your private album and individual photos
                      </p>
                      <Button 
                        onClick={openAlbumAccessDialog}
                        variant="outline" 
                        className="w-full bg-black border border-[#86db7d]/30 text-[#E6FFF4] hover:bg-[#86db7d]/10"
                      >
                        <UserPlus className="mr-2 h-4 w-4" />
                        Manage Album Access
                      </Button>
                    </div>
                  </div>
                )}
              </>
            ) : (
              <div className="flex flex-col items-center justify-center bg-[#1A1A1A] rounded-lg p-8">
                <Lock className="w-12 h-12 text-[#86db7d]/70 mb-4" />
                <h3 className="text-[#E6FFF4] text-xl font-medium mb-2">Private Album</h3>
                <p className="text-[#E6FFF4]/70 text-center mb-6 max-w-xs">
                  Your private photos and videos are securely stored. Only you and people you give access to can view them.
                </p>
                <div className="flex space-x-4">
                  <Button
                    onClick={handleTogglePrivate}
                    className="bg-[#86db7d] text-black hover:bg-[#86db7d]/90"
                  >
                    <Eye className="mr-2 h-4 w-4" />
                    View Album
                  </Button>
                  <div className="relative">
                    <Button
                      className="bg-black border border-[#86db7d]/50 text-[#E6FFF4] hover:bg-[#86db7d]/10"
                    >
                      <Upload className="mr-2 h-4 w-4" />
                      Upload New
                    </Button>
                    <Input
                      type="file"
                      accept="image/*,video/*"
                      multiple
                      className="absolute inset-0 opacity-0 cursor-pointer"
                      onChange={(e) => handleUploadMedia(e, 'private')}
                    />
                  </div>
                </div>
              </div>
            )}
          </TabsContent>
          
          {/* Profile Video Tab */}
          <TabsContent value="profile" className="mt-4">
            <div className="flex justify-between items-center mb-4">
              <h2 className="text-xl font-bold text-[#E6FFF4]">Profile Video</h2>
              <div className="relative">
                <Button 
                  className="w-10 h-10 rounded-full bg-[#86db7d] flex items-center justify-center"
                >
                  <Upload className="w-6 h-6 text-black" />
                </Button>
                <Input
                  type="file"
                  accept="video/*"
                  className="absolute inset-0 opacity-0 cursor-pointer"
                  onChange={(e) => handleUploadMedia(e, 'profile')}
                />
              </div>
            </div>
            
            {profileVideo ? (
              <div className="relative aspect-video rounded-lg overflow-hidden">
                <video
                  src={profileVideo}
                  className="w-full h-full object-cover"
                  controls
                  autoPlay
                  muted
                  loop
                />
                <button 
                  onClick={handleDeleteProfileVideo}
                  className="absolute top-2 right-2 w-8 h-8 rounded-full bg-black/70 flex items-center justify-center"
                >
                  <Trash2 className="w-4 h-4 text-white" />
                </button>
              </div>
            ) : (
              <div className="aspect-video bg-[#1A1A1A] rounded-lg flex flex-col items-center justify-center">
                <Video className="w-8 h-8 text-gray-400 mb-2" />
                <p className="text-sm text-gray-400 mb-4">No profile video yet</p>
                <div className="relative">
                  <Button 
                    className="bg-[#86db7d] text-black hover:bg-[#86db7d]/90"
                  >
                    <Upload className="mr-2 h-4 w-4" />
                    Upload video (10 sec max)
                  </Button>
                  <Input
                    type="file"
                    accept="video/*"
                    className="absolute inset-0 opacity-0 cursor-pointer"
                    onChange={(e) => handleUploadMedia(e, 'profile')}
                  />
                </div>
              </div>
            )}
            
            <div className="mt-4 p-4 bg-[#1A1A1A] rounded-lg">
              <h3 className="text-sm font-medium text-[#E6FFF4] mb-2">Profile Video Tips</h3>
              <ul className="text-xs text-[#E6FFF4]/70 space-y-1">
                <li>• Keep it short - 10 seconds max</li>
                <li>• Show your personality</li>
                <li>• Good lighting makes a big difference</li>
                <li>• Speak clearly if you're talking</li>
              </ul>
            </div>
          </TabsContent>
        </Tabs>
      </div>
      
      {/* Share Dialog */}
      <Dialog open={shareDialogOpen} onOpenChange={setShareDialogOpen}>
        <DialogContent className="bg-black border border-[#86db7d]/30 text-[#E6FFF4]">
          <DialogHeader>
            <DialogTitle className="text-[#E6FFF4]">Share Private Media</DialogTitle>
            <DialogDescription className="text-[#E6FFF4]/70">
              Select people to share this media with
            </DialogDescription>
          </DialogHeader>

          {selectedMediaId && (
            <div className="w-full h-40 bg-[#1A1A1A] rounded-md flex items-center justify-center mb-4">
              {privateMedia.find(m => m.id === selectedMediaId)?.type === 'image' ? (
                <img 
                  src={privateMedia.find(m => m.id === selectedMediaId)?.url} 
                  alt="Media preview" 
                  className="max-h-full rounded-md"
                />
              ) : (
                <video 
                  src={privateMedia.find(m => m.id === selectedMediaId)?.url}
                  className="max-h-full rounded-md"
                  muted
                />
              )}
            </div>
          )}

          <ScrollArea className="h-60 pr-4">
            <div className="space-y-2">
              {contacts.map(contact => (
                <div 
                  key={contact.id}
                  className={`flex items-center p-3 rounded-md cursor-pointer transition-colors ${
                    selectedContacts.includes(contact.id) 
                      ? 'bg-[#86db7d]/20 border border-[#86db7d]/30' 
                      : 'hover:bg-[#1A1A1A]'
                  }`}
                  onClick={() => toggleContactSelection(contact.id)}
                >
                  <img 
                    src={contact.image} 
                    alt={contact.name} 
                    className="w-10 h-10 rounded-full object-cover mr-3"
                  />
                  <span className="flex-1 text-[#E6FFF4]">{contact.name}</span>
                  <div className={`w-6 h-6 rounded-full flex items-center justify-center ${
                    selectedContacts.includes(contact.id) 
                      ? 'bg-[#86db7d] text-black' 
                      : 'border border-[#E6FFF4]/30'
                  }`}>
                    {selectedContacts.includes(contact.id) && (
                      <span className="text-xs font-bold">✓</span>
                    )}
                  </div>
                </div>
              ))}
            </div>
          </ScrollArea>

          <DialogFooter className="gap-2">
            <Button 
              variant="outline" 
              onClick={() => setShareDialogOpen(false)}
              className="border-[#E6FFF4]/20 text-[#E6FFF4]/70 hover:bg-transparent hover:text-[#E6FFF4]"
            >
              Cancel
            </Button>
            <Button 
              onClick={handleShareMedia}
              disabled={selectedContacts.length === 0}
              className="bg-[#86db7d] text-black hover:bg-[#86db7d]/90 disabled:bg-[#86db7d]/50"
            >
              <Share2 className="mr-2 h-4 w-4" />
              Share ({selectedContacts.length})
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
      
      {/* Album Access Dialog */}
      <Dialog open={albumAccessDialogOpen} onOpenChange={setAlbumAccessDialogOpen}>
        <DialogContent className="bg-black border border-[#86db7d]/30 text-[#E6FFF4]">
          <DialogHeader>
            <DialogTitle className="text-[#E6FFF4]">Manage Album Access</DialogTitle>
            <DialogDescription className="text-[#E6FFF4]/70">
              Choose who can view your private album
            </DialogDescription>
          </DialogHeader>

          <ScrollArea className="h-60 pr-4">
            <div className="space-y-2">
              {contacts.map(contact => (
                <div 
                  key={contact.id}
                  className="flex items-center p-3 rounded-md cursor-pointer transition-colors hover:bg-[#1A1A1A]"
                >
                  <img 
                    src={contact.image} 
                    alt={contact.name} 
                    className="w-10 h-10 rounded-full object-cover mr-3" 
                  />
                  <span className="flex-1 text-[#E6FFF4]">{contact.name}</span>
                  <Button
                    variant="outline"
                    size="sm"
                    className={`min-w-24 ${
                      contact.hasAccess 
                        ? 'bg-[#86db7d]/20 border-[#86db7d]/50 text-[#86db7d]' 
                        : 'bg-transparent border-[#E6FFF4]/30 text-[#E6FFF4]/70'
                    }`}
                    onClick={() => toggleContactAccess(contact.id)}
                  >
                    {contact.hasAccess ? (
                      <>
                        <Unlock className="mr-2 h-3 w-3" />
                        Has Access
                      </>
                    ) : (
                      <>
                        <Lock className="mr-2 h-3 w-3" />
                        No Access
                      </>
                    )}
                  </Button>
                </div>
              ))}
            </div>
          </ScrollArea>

          <div className="p-3 bg-[#1A1A1A] rounded-md mt-2">
            <p className="text-sm text-[#E6FFF4]/80">
              <Lock className="inline h-3 w-3 mr-1" />
              People with access can view your entire private album. You can also share individual photos separately.
            </p>
          </div>

          <DialogFooter className="gap-2 mt-4">
            <Button 
              variant="outline" 
              onClick={() => setAlbumAccessDialogOpen(false)}
              className="border-[#E6FFF4]/20 text-[#E6FFF4]/70 hover:bg-transparent hover:text-[#E6FFF4]"
            >
              Cancel
            </Button>
            <Button 
              onClick={saveAlbumAccessChanges}
              className="bg-[#86db7d] text-black hover:bg-[#86db7d]/90"
            >
              Save Changes
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
};

export default PhotoAlbumView;
