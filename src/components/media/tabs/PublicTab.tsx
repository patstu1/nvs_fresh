
import React from 'react';
import { Label } from '@/components/ui/label';
import { Input } from '@/components/ui/input';
import { Switch } from '@/components/ui/switch';
import { ScrollArea } from '@/components/ui/scroll-area';
import { Upload } from 'lucide-react';
import { MediaItem } from '@/types/MediaTypes';
import MediaItemComponent from '../MediaItemComponent';

interface PublicTabProps {
  publicAlbum: MediaItem[];
  isNsfw: boolean;
  setIsNsfw: (value: boolean) => void;
  handleFileUpload: (event: React.ChangeEvent<HTMLInputElement>, visibility: 'public' | 'private' | 'anonymous') => void;
  handleDelete: (media: MediaItem) => void;
  handleToggleNsfw: (media: MediaItem) => void;
  handleVisibilityChange: (media: MediaItem, newVisibility: 'public' | 'private' | 'anonymous') => void;
}

const PublicTab: React.FC<PublicTabProps> = ({
  publicAlbum,
  isNsfw,
  setIsNsfw,
  handleFileUpload,
  handleDelete,
  handleToggleNsfw,
  handleVisibilityChange
}) => {
  return (
    <div className="space-y-4">
      <div>
        <div className="flex items-center justify-between mb-2">
          <Label className="text-sm font-medium text-[#E6FFF4]">Public Album</Label>
          <div className="flex items-center space-x-2">
            <Switch
              id="nsfw-toggle-public"
              checked={isNsfw}
              onCheckedChange={setIsNsfw}
            />
            <Label htmlFor="nsfw-toggle-public" className="text-sm text-[#E6FFF4]/70">
              NSFW Content
            </Label>
          </div>
        </div>
        <p className="text-sm text-[#E6FFF4]/70 mb-2">
          These photos and videos will be visible to everyone (NSFW content only in NOW section)
        </p>
        <ScrollArea className="h-60 w-full border border-[#E6FFF4]/20 rounded-md p-2">
          <div className="grid grid-cols-3 gap-2">
            {publicAlbum.map((media) => (
              <MediaItemComponent 
                key={media.id}
                media={media}
                onDelete={() => handleDelete(media)}
                onToggleNsfw={() => handleToggleNsfw(media)}
                onVisibilityChange={handleVisibilityChange}
              />
            ))}
            
            <div className="relative border border-dashed border-[#E6FFF4]/20 rounded-md aspect-square flex items-center justify-center cursor-pointer hover:bg-[#222] transition-colors">
              <div className="text-center">
                <Upload className="mx-auto h-6 w-6 text-[#E6FFF4]/40 mb-1" />
                <p className="text-[#E6FFF4]/40 text-xs">Add Media</p>
              </div>
              <Input
                type="file"
                accept="image/*,video/*"
                multiple
                className="absolute inset-0 opacity-0 cursor-pointer"
                onChange={(e) => handleFileUpload(e, 'public')}
              />
            </div>
          </div>
        </ScrollArea>
      </div>
      
      <div className="bg-[#1A1A1A] p-3 rounded-md border border-[#E6FFF4]/10">
        <h4 className="text-sm text-[#E6FFF4] font-medium mb-1">Public Media Rules</h4>
        <ul className="text-xs text-[#E6FFF4]/70 list-disc pl-5 space-y-1">
          <li>Media marked as public will be visible in all sections</li>
          <li>NSFW content will only be visible in the NOW section</li>
          <li>Face or body pics are encouraged in GRID, CONNECT, and LIVE sections</li>
          <li>No explicit content will be shown in preview tiles</li>
        </ul>
      </div>
    </div>
  );
};

export default PublicTab;
