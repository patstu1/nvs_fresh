
import React from 'react';
import { Button } from '@/components/ui/button';
import { Settings, Eye, EyeOff } from 'lucide-react';

interface MapControlsProps {
  showSettings: boolean;
  blurImages: boolean;
  onSettingsClick: () => void;
  onBlurToggle: () => void;
}

export const MapControls: React.FC<MapControlsProps> = ({
  showSettings,
  blurImages,
  onSettingsClick,
  onBlurToggle
}) => {
  return (
    <div className="absolute top-4 right-4 flex space-x-2 z-20">
      <Button
        variant="outline"
        size="icon"
        className="bg-black/50 border-[#E6FFF4]/30 text-[#E6FFF4] backdrop-blur-md"
        onClick={onBlurToggle}
        title={blurImages ? "Show unblurred images" : "Blur images"}
      >
        {blurImages ? <EyeOff className="h-5 w-5" /> : <Eye className="h-5 w-5" />}
      </Button>
      
      <Button
        variant="outline"
        size="icon"
        className="bg-black/50 border-[#E6FFF4]/30 text-[#E6FFF4] backdrop-blur-md"
        onClick={onSettingsClick}
      >
        <Settings className="h-5 w-5" />
      </Button>
    </div>
  );
};
