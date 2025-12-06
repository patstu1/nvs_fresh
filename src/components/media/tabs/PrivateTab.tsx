
import React from 'react';
import { Label } from '@/components/ui/label';
import { Input } from '@/components/ui/input';
import { Switch } from '@/components/ui/switch';
import { ScrollArea } from '@/components/ui/scroll-area';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Lock, Users } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { MediaItem } from '@/types/MediaTypes';
import MediaItemComponent from '../MediaItemComponent';
import { toast } from '@/hooks/use-toast';
import AnonymousTab from './AnonymousTab';

interface PrivateTabProps {
  privateAlbum: MediaItem[];
  anonymousAlbum: MediaItem[];
  isNsfw: boolean;
  setIsNsfw: (value: boolean) => void;
  handleFileUpload: (event: React.ChangeEvent<HTMLInputElement>, visibility: 'public' | 'private' | 'anonymous') => void;
  handleDelete: (media: MediaItem) => void;
  handleToggleNsfw: (media: MediaItem) => void;
  handleShareClick: (media: MediaItem) => void;
  handleVisibilityChange: (media: MediaItem, newVisibility: 'public' | 'private' | 'anonymous') => void;
}

const PrivateTab: React.FC<PrivateTabProps> = ({
  privateAlbum,
  anonymousAlbum,
  isNsfw,
  setIsNsfw,
  handleFileUpload,
  handleDelete,
  handleToggleNsfw,
  handleShareClick,
  handleVisibilityChange
}) => {
  return (
    <div className="space-y-4">
      <div>
        <div className="flex items-center justify-between mb-2">
          <Label className="text-sm font-medium text-[#E6FFF4]">Private Album</Label>
          <div className="flex items-center space-x-2">
            <Switch
              id="nsfw-toggle-private"
              checked={isNsfw}
              onCheckedChange={setIsNsfw}
            />
            <Label htmlFor="nsfw-toggle-private" className="text-sm text-[#E6FFF4]/70">
              NSFW Content
            </Label>
          </div>
        </div>
        <p className="text-sm text-[#E6FFF4]/70 mb-2">
          These photos and videos will only be visible to people you give access to
        </p>
        <ScrollArea className="h-60 w-full border border-[#E6FFF4]/20 rounded-md p-2">
          <div className="grid grid-cols-3 gap-2">
            {privateAlbum.map((media) => (
              <MediaItemComponent 
                key={media.id}
                media={media}
                onDelete={() => handleDelete(media)}
                onToggleNsfw={() => handleToggleNsfw(media)}
                onShare={() => handleShareClick(media)}
                onVisibilityChange={handleVisibilityChange}
              />
            ))}
            
            <div className="relative border border-dashed border-[#E6FFF4]/20 rounded-md aspect-square flex items-center justify-center cursor-pointer hover:bg-[#222] transition-colors">
              <div className="text-center">
                <Lock className="mx-auto h-6 w-6 text-[#E6FFF4]/40 mb-1" />
                <p className="text-[#E6FFF4]/40 text-xs">Add Private Media</p>
              </div>
              <Input
                type="file"
                accept="image/*,video/*"
                multiple
                className="absolute inset-0 opacity-0 cursor-pointer"
                onChange={(e) => handleFileUpload(e, 'private')}
              />
            </div>
          </div>
        </ScrollArea>
      </div>
      
      <div className="bg-[#1A1A1A] p-3 rounded-md border border-[#E6FFF4]/10">
        <h4 className="text-sm text-[#E6FFF4] font-medium mb-1">Private Album Rules</h4>
        <ul className="text-xs text-[#E6FFF4]/70 list-disc pl-5 space-y-1">
          <li>Private media requires you to explicitly grant access to other users</li>
          <li>You can share any private media individually through chat or the share button</li>
          <li>NSFW private media will be available in the NOW section, but always blurred</li>
          <li>You can revoke access to shared media at any time</li>
        </ul>
      </div>
      
      <Tabs defaultValue="private-nsfw" className="w-full">
        <TabsList className="w-full mb-2 bg-[#1A1A1A]">
          <TabsTrigger value="private-nsfw" className="flex-1">NSFW Private</TabsTrigger>
          <TabsTrigger value="anonymous" className="flex-1">Anonymous (NOW)</TabsTrigger>
        </TabsList>
        
        <TabsContent value="private-nsfw" className="space-y-2">
          <div className="bg-[#1A1A1A] p-3 rounded-md border border-[#E6FFF4]/10">
            <h4 className="text-sm text-[#E6FFF4] font-medium">NSFW Media Sharing</h4>
            <p className="text-xs text-[#E6FFF4]/70 mt-1">
              Control who can see your private NSFW content. You can share media individually or grant access to your entire private album.
            </p>
          </div>
          <div className="bg-[#1A1A1A] p-3 rounded-md border border-[#E6FFF4]/10">
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
        
        <TabsContent value="anonymous">
          <AnonymousTab 
            anonymousAlbum={anonymousAlbum}
            handleFileUpload={handleFileUpload}
            handleDelete={handleDelete}
            handleToggleNsfw={handleToggleNsfw}
            handleVisibilityChange={handleVisibilityChange}
          />
        </TabsContent>
      </Tabs>
    </div>
  );
};

export default PrivateTab;
