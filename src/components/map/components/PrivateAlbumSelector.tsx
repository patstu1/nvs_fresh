
import React from 'react';
import { Button } from '@/components/ui/button';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription, DialogFooter } from '@/components/ui/dialog';
import { ScrollArea } from '@/components/ui/scroll-area';
import { Lock, Eye, Image } from 'lucide-react';

interface PrivateAlbumSelectorProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  privateAlbum: string[];
  selectedImages: string[];
  onToggleImage: (imageUrl: string) => void;
  onConfirm: () => void;
  onManageAlbum: () => void;
}

const PrivateAlbumSelector: React.FC<PrivateAlbumSelectorProps> = ({
  open,
  onOpenChange,
  privateAlbum,
  selectedImages,
  onToggleImage,
  onConfirm,
  onManageAlbum
}) => {
  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="bg-black border border-[#E6FFF4]/30 text-[#E6FFF4]">
        <DialogHeader>
          <DialogTitle className="text-[#E6FFF4] flex items-center">
            <Lock className="w-4 h-4 mr-2" /> 
            Anonymous Profile Photos
          </DialogTitle>
          <DialogDescription className="text-[#E6FFF4]/70">
            Select photos to use while browsing anonymously. We recommend using private/intimate photos from your XXX collection for anonymous browsing on the map.
          </DialogDescription>
        </DialogHeader>
        
        <div className="bg-[#1A1A1A] p-3 mb-4 rounded-md border border-[#E6FFF4]/10">
          <p className="text-sm text-[#E6FFF4]/90 font-medium">Privacy Recommendation:</p>
          <p className="text-xs text-[#E6FFF4]/70 mt-1">
            For better privacy while browsing the map, we recommend using your private photos rather than your public profile pictures. This helps maintain anonymity while still allowing connections.
          </p>
        </div>
        
        <ScrollArea className="h-60 w-full">
          {privateAlbum.length > 0 ? (
            <div className="grid grid-cols-3 gap-2 p-1">
              {privateAlbum.map((image, index) => (
                <div 
                  key={index} 
                  className={`relative aspect-square rounded-md overflow-hidden cursor-pointer border-2 ${
                    selectedImages.includes(image) 
                      ? 'border-[#E6FFF4]' 
                      : 'border-transparent'
                  }`}
                  onClick={() => onToggleImage(image)}
                >
                  <img 
                    src={image} 
                    alt="Private album" 
                    className="w-full h-full object-cover"
                  />
                  {selectedImages.includes(image) && (
                    <div className="absolute inset-0 bg-[#E6FFF4]/20 flex items-center justify-center">
                      <div className="w-6 h-6 rounded-full bg-[#E6FFF4] flex items-center justify-center">
                        <Eye className="w-4 h-4 text-black" />
                      </div>
                    </div>
                  )}
                </div>
              ))}
            </div>
          ) : (
            <div className="flex flex-col items-center justify-center h-full py-8">
              <Image className="w-12 h-12 text-[#E6FFF4]/30 mb-2" />
              <p className="text-[#E6FFF4]/70">No private photos available</p>
              <Button 
                onClick={onManageAlbum}
                variant="outline"
                className="mt-4 border border-[#E6FFF4]/30 text-[#E6FFF4] hover:bg-[#E6FFF4]/10"
              >
                Manage XXX Album
              </Button>
            </div>
          )}
        </ScrollArea>
        
        <DialogFooter>
          <Button 
            variant="outline" 
            onClick={() => onOpenChange(false)}
            className="border border-[#E6FFF4]/30 text-[#E6FFF4] hover:bg-[#E6FFF4]/10"
          >
            Cancel
          </Button>
          <Button 
            onClick={onConfirm}
            className="bg-[#E6FFF4] text-black hover:bg-[#E6FFF4]/90"
          >
            {selectedImages.length > 0 ? 'Use Selected Photos' : 'Browse Without Photos'}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
};

export default PrivateAlbumSelector;
