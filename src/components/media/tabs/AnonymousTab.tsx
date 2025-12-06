
import React from 'react';
import { ScrollArea } from '@/components/ui/scroll-area';
import { EyeOff, Shield } from 'lucide-react';
import { MediaItem } from '@/types/MediaTypes';
import MediaItemComponent from '../MediaItemComponent';
import UploadMediaButton from '../UploadMediaButton';
import { toast } from '@/hooks/use-toast';

interface AnonymousTabProps {
  anonymousAlbum: MediaItem[];
  handleFileUpload: (event: React.ChangeEvent<HTMLInputElement>, visibility: 'public' | 'private' | 'anonymous') => void;
  handleDelete: (media: MediaItem) => void;
  handleToggleNsfw: (media: MediaItem) => void;
  handleVisibilityChange: (media: MediaItem, newVisibility: 'public' | 'private' | 'anonymous') => void;
}

const AnonymousTab: React.FC<AnonymousTabProps> = ({
  anonymousAlbum,
  handleFileUpload,
  handleDelete,
  handleToggleNsfw,
  handleVisibilityChange
}) => {
  const handleNsfwContentUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
    // Force NSFW flag for anonymous content
    handleFileUpload(e, 'anonymous');
    
    // Inform user about content handling
    toast({
      title: "Anonymous Content Added",
      description: "Your content will appear blurred on the NOW map",
    });
  };

  return (
    <div className="space-y-2">
      <div className="bg-[#1A1A1A] p-3 rounded-md border border-[#E6FFF4]/10">
        <div className="flex items-center justify-between mb-1">
          <h4 className="text-sm text-[#E6FFF4] font-medium">Anonymous NOW Media</h4>
          <div className="flex items-center">
            <Shield className="h-4 w-4 text-[#E6FFF4]/70 mr-1" />
            <span className="text-xs text-[#E6FFF4]/70">Privacy Protected</span>
          </div>
        </div>
        <p className="text-xs text-[#E6FFF4]/70 mb-2">
          These photos will only appear in the NOW section and won't be linked to your main profile
        </p>
        
        <ScrollArea className="h-40 w-full border border-[#222] rounded-md p-2 mb-2">
          <div className="grid grid-cols-3 gap-2">
            {anonymousAlbum.map((media) => (
              <MediaItemComponent 
                key={media.id}
                media={media}
                onDelete={() => handleDelete(media)}
                onToggleNsfw={() => handleToggleNsfw(media)}
                onVisibilityChange={handleVisibilityChange}
                hideVisibilityToggle={true} // No visibility changes for anonymous content
                defaultBlurred={true} // Always blur anonymous content by default
              />
            ))}
            
            <UploadMediaButton 
              icon={EyeOff}
              label="Add Anonymous"
              acceptTypes="image/*"
              multiple={true}
              onUpload={handleNsfwContentUpload}
              variant="outline"
              className="border-dashed border-[#E6FFF4]/20 rounded-md aspect-square flex items-center justify-center cursor-pointer hover:bg-[#222] transition-colors"
            />
          </div>
        </ScrollArea>
        
        <div className="rounded-md bg-[#222] p-2 border border-[#E6FFF4]/10">
          <p className="text-xs text-[#E6FFF4]/70">
            <span className="font-medium text-[#E6FFF4]">Safety Note:</span> Anonymous photos can include mature content. All content in NOW will remain blurred until manually revealed by viewers.
          </p>
        </div>
      </div>
    </div>
  );
};

export default AnonymousTab;
