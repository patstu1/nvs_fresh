
import React, { useState } from 'react';
import { Eye, EyeOff, Flag } from 'lucide-react';
import { toast } from '@/hooks/use-toast';
import {
  ContextMenu,
  ContextMenuContent,
  ContextMenuItem,
  ContextMenuTrigger,
} from "@/components/ui/context-menu";

interface BlurableImageProps {
  src: string;
  alt?: string;
  className?: string;
  onReportContent?: () => void;
  defaultBlurred?: boolean;
  alwaysBlurred?: boolean;
}

const BlurableImage: React.FC<BlurableImageProps> = ({
  src,
  alt = "Image",
  className = "",
  onReportContent,
  defaultBlurred = true,
  alwaysBlurred = false
}) => {
  const [isBlurred, setIsBlurred] = useState(defaultBlurred);
  
  const toggleBlur = () => {
    if (!alwaysBlurred) {
      setIsBlurred(prev => !prev);
    }
  };
  
  const handleReblur = () => {
    setIsBlurred(true);
    toast({
      title: "Image Blurred",
      description: "This image has been blurred again",
    });
  };
  
  const handleReport = () => {
    if (onReportContent) {
      onReportContent();
    } else {
      toast({
        title: "Content Reported",
        description: "Thank you for reporting. Our team will review this content.",
        variant: "destructive"
      });
    }
  };

  return (
    <ContextMenu>
      <ContextMenuTrigger>
        <div 
          className={`relative overflow-hidden ${className}`}
          onClick={toggleBlur}
        >
          <img 
            src={src} 
            alt={alt}
            className={`w-full h-full object-cover transition-all duration-300 ${isBlurred ? 'filter blur-xl scale-110' : ''}`}
          />
          
          {isBlurred && (
            <div className="absolute inset-0 flex flex-col items-center justify-center bg-black/30 text-white">
              <Eye size={32} className="mb-2" />
              <span className="text-sm font-medium">Tap to Reveal</span>
            </div>
          )}
        </div>
      </ContextMenuTrigger>
      
      <ContextMenuContent className="bg-black border border-[#E6FFF4]/30 text-[#E6FFF4] w-56">
        <ContextMenuItem 
          onClick={handleReblur}
          className="cursor-pointer hover:bg-[#E6FFF4]/10 flex items-center"
        >
          <EyeOff className="mr-2 h-4 w-4" />
          <span>Blur This Image Again</span>
        </ContextMenuItem>
        
        <ContextMenuItem 
          onClick={handleReport}
          className="cursor-pointer hover:bg-red-500/20 text-red-400 flex items-center"
        >
          <Flag className="mr-2 h-4 w-4" />
          <span>Report This Content</span>
        </ContextMenuItem>
      </ContextMenuContent>
    </ContextMenu>
  );
};

export default BlurableImage;
