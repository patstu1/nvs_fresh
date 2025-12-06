
import React from 'react';
import { MediaItem, MediaVisibility } from '@/types/MediaTypes';
import { Badge } from '@/components/ui/badge';
import { 
  Lock, 
  Unlock, 
  EyeOff, 
  X, 
  Share2, 
  Eye, 
  Video 
} from 'lucide-react';

interface MediaItemComponentProps {
  media: MediaItem;
  onDelete: () => void;
  onToggleNsfw: () => void;
  onShare?: () => void;
  onVisibilityChange?: (media: MediaItem, newVisibility: MediaVisibility) => void;
  hideVisibilityToggle?: boolean;
  defaultBlurred?: boolean;
}

const MediaItemComponent: React.FC<MediaItemComponentProps> = ({
  media,
  onDelete,
  onToggleNsfw,
  onShare,
  onVisibilityChange,
  hideVisibilityToggle = false,
  defaultBlurred = false
}) => {
  const renderVisibilityIcon = () => {
    switch (media.visibility) {
      case 'public':
        return <Unlock size={14} />;
      case 'private':
        return <Lock size={14} />;
      case 'anonymous':
        return <EyeOff size={14} />;
    }
  };
  
  const handleVisibilityClick = () => {
    if (!onVisibilityChange) return;
    
    // Cycle through visibilities
    const visibilities: MediaVisibility[] = ['public', 'private', 'anonymous'];
    const currentIndex = visibilities.indexOf(media.visibility);
    const nextIndex = (currentIndex + 1) % visibilities.length;
    onVisibilityChange(media, visibilities[nextIndex]);
  };
  
  const shouldBlur = defaultBlurred || media.isNsfw;
  
  return (
    <div className="relative group rounded-md overflow-hidden">
      {media.type === 'image' ? (
        <img 
          src={media.url} 
          alt="Media" 
          className={`w-full aspect-square object-cover ${shouldBlur ? 'filter blur-sm group-hover:blur-none transition-all duration-200' : ''}`} 
        />
      ) : (
        <div className="w-full aspect-square bg-[#1A1A1A] flex items-center justify-center relative">
          <Video className="text-[#E6FFF4]/70" size={24} />
          <span className="text-xs text-[#E6FFF4]/70 mt-1">Video</span>
        </div>
      )}
      
      <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity flex flex-col justify-end p-2">
        <div className="flex justify-between items-center">
          <Badge className={`text-[10px] ${media.isNsfw ? 'bg-red-500' : 'bg-green-500'} text-white`}>
            {media.isNsfw ? 'NSFW' : 'SFW'}
          </Badge>
          
          <div className="flex space-x-1">
            {onShare && (
              <button
                onClick={onShare}
                className="bg-[#222] hover:bg-[#333] rounded-full p-1"
              >
                <Share2 size={14} className="text-[#E6FFF4]" />
              </button>
            )}
            
            {onVisibilityChange && !hideVisibilityToggle && (
              <button
                onClick={handleVisibilityClick}
                className="bg-[#222] hover:bg-[#333] rounded-full p-1"
              >
                {renderVisibilityIcon()}
              </button>
            )}
            
            <button
              onClick={onDelete}
              className="bg-[#222] hover:bg-[#333] rounded-full p-1"
            >
              <X size={14} className="text-[#E6FFF4]" />
            </button>
          </div>
        </div>
        
        <div className="flex justify-between items-center mt-1">
          <button
            onClick={onToggleNsfw}
            className={`text-[10px] ${media.isNsfw ? 'text-red-400' : 'text-green-400'} flex items-center`}
          >
            {media.isNsfw ? (
              <>
                <Eye size={10} className="mr-1" /> 
                Make SFW
              </>
            ) : (
              <>
                <EyeOff size={10} className="mr-1" /> 
                Mark NSFW
              </>
            )}
          </button>
        </div>
      </div>
    </div>
  );
};

export default MediaItemComponent;
