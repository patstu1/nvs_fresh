
import React from 'react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { ScrollArea } from '@/components/ui/scroll-area';
import { Switch } from '@/components/ui/switch';
import { Image as ImageIcon, Video, Upload, X } from 'lucide-react';
import { MediaItem } from '@/types/MediaTypes';
import MediaItemComponent from '../MediaItemComponent';

interface ProfileTabProps {
  profilePhotos: MediaItem[];
  profileVideo: MediaItem | null;
  isNsfw: boolean;
  setIsNsfw: (value: boolean) => void;
  handleFileUpload: (event: React.ChangeEvent<HTMLInputElement>, visibility: 'public' | 'private' | 'anonymous', isProfileMedia?: boolean) => void;
  handleDelete: (media: MediaItem) => void;
  handleToggleNsfw: (media: MediaItem) => void;
  handleShareClick: (media: MediaItem) => void;
  handleVisibilityChange: (media: MediaItem, newVisibility: 'public' | 'private' | 'anonymous') => void;
}

const ProfileTab: React.FC<ProfileTabProps> = ({
  profilePhotos,
  profileVideo,
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
      {/* Profile Pictures Section */}
      <div>
        <Label className="block text-sm font-medium mb-2 text-[#E6FFF4]">Profile Pictures</Label>
        <div className="mb-2">
          <ScrollArea className="h-32 w-full border border-[#E6FFF4]/20 rounded-md p-2">
            <div className="grid grid-cols-3 gap-2">
              {profilePhotos.map((photo) => (
                <MediaItemComponent 
                  key={photo.id}
                  media={photo}
                  onDelete={() => handleDelete(photo)}
                  onToggleNsfw={() => handleToggleNsfw(photo)}
                  onShare={photo.visibility === 'private' ? () => handleShareClick(photo) : undefined}
                  onVisibilityChange={handleVisibilityChange}
                />
              ))}
            </div>
          </ScrollArea>
        </div>
        <div className="flex items-center justify-between">
          <div className="flex items-center space-x-2">
            <Switch
              id="nsfw-toggle-profile"
              checked={isNsfw}
              onCheckedChange={setIsNsfw}
            />
            <Label htmlFor="nsfw-toggle-profile" className="text-sm text-[#E6FFF4]/70">
              NSFW Content
            </Label>
          </div>
          
          <div className="relative">
            <Button 
              type="button" 
              variant="outline"
              size="sm"
              className="bg-[#E6FFF4] text-black border-0 hover:bg-[#E6FFF4]/90"
              disabled={profilePhotos.length >= 6}
            >
              <ImageIcon className="mr-2 h-4 w-4" />
              Add Photos
            </Button>
            <Input
              type="file"
              accept="image/*"
              multiple
              className="absolute inset-0 opacity-0 cursor-pointer"
              onChange={(e) => handleFileUpload(e, 'public', true)}
              disabled={profilePhotos.length >= 6}
            />
          </div>
        </div>
        <p className="text-xs text-[#E6FFF4]/70 mt-1">
          Upload up to 6 profile pictures (NSFW content will only be shown in NOW section)
        </p>
      </div>
      
      {/* Profile Video Section */}
      <div>
        <Label className="block text-sm font-medium mb-2 text-[#E6FFF4]">Profile Video (15-30 seconds)</Label>
        {profileVideo ? (
          <div className="relative group">
            <video 
              src={profileVideo.url} 
              controls 
              className="w-full h-40 object-cover rounded-md" 
            />
            <button
              type="button"
              onClick={() => handleDelete(profileVideo)}
              className="absolute top-2 right-2 bg-black/70 rounded-full p-1 opacity-0 group-hover:opacity-100 transition-opacity"
            >
              <X size={16} className="text-white" />
            </button>
            
            <div className="absolute bottom-2 left-2 bg-black/70 px-2 py-1 rounded-md text-xs">
              <div className="flex items-center">
                <span className="mr-2">NSFW:</span>
                <Switch
                  checked={profileVideo.isNsfw}
                  onCheckedChange={() => handleToggleNsfw(profileVideo)}
                  className="scale-75"
                />
              </div>
            </div>
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
                  onChange={(e) => handleFileUpload(e, 'public', true)}
                />
              </div>
            </div>
          </div>
        )}
        <p className="text-xs text-[#E6FFF4]/70 mt-1">
          Create a short video to introduce yourself (15-30 seconds)
        </p>
      </div>
    </div>
  );
};

export default ProfileTab;
