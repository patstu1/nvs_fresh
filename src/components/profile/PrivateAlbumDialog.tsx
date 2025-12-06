
import React from 'react';
import { UserProfile } from '@/types/UserProfile';
import RequestAccessDialog from './album/RequestAccessDialog';
import { Dialog, DialogContent, DialogHeader, DialogTitle } from '@/components/ui/dialog';
import { Button } from '@/components/ui/button';
import { Images, Lock } from 'lucide-react';
import { toast } from '@/hooks/use-toast';

interface PrivateAlbumDialogProps {
  profile: UserProfile;
  isOpen: boolean;
  onOpenChange: (open: boolean) => void;
  onSendRequest: () => void;
}

const PrivateAlbumDialog: React.FC<PrivateAlbumDialogProps> = ({ 
  profile, 
  isOpen, 
  onOpenChange,
  onSendRequest
}) => {
  // Handle case where there is no private album
  if (!profile.privateAlbum && isOpen) {
    return (
      <Dialog open={isOpen} onOpenChange={onOpenChange}>
        <DialogContent className="bg-black border border-[#E6FFF4]/30 text-white max-w-md">
          <DialogHeader>
            <DialogTitle className="text-white flex items-center">
              <Lock className="w-5 h-5 mr-2 text-[#E6FFF4]" /> 
              Private Album
            </DialogTitle>
          </DialogHeader>
          
          <div className="py-4">
            <p className="text-[#E6FFF4]/70">
              This user doesn't have a private album yet.
            </p>
          </div>
          
          <Button 
            onClick={() => onOpenChange(false)}
            className="w-full bg-[#E6FFF4] text-black hover:bg-[#E6FFF4]/90"
          >
            Close
          </Button>
        </DialogContent>
      </Dialog>
    );
  }

  // If access is already granted, show the album
  if (profile.privateAlbum?.isShared) {
    return (
      <Dialog open={isOpen} onOpenChange={onOpenChange}>
        <DialogContent className="bg-black border border-[#E6FFF4]/30 text-white max-w-md">
          <DialogHeader>
            <DialogTitle className="text-white flex items-center">
              <Images className="w-5 h-5 mr-2 text-[#E6FFF4]" /> 
              Private Album
            </DialogTitle>
          </DialogHeader>
          
          <div className="grid grid-cols-2 gap-2 my-4">
            {profile.privateAlbum?.images.map((image, index) => (
              <div key={index} className="aspect-square rounded-md overflow-hidden">
                <img 
                  src={image} 
                  alt={`Private ${index + 1}`} 
                  className="w-full h-full object-cover"
                />
              </div>
            ))}
          </div>
          
          {profile.privateAlbum?.isExplicit && (
            <div className="bg-[#1A1A1A] p-3 my-4 rounded-md border border-[#E6FFF4]/10">
              <p className="text-sm text-[#FF3366]">
                This album contains explicit content
              </p>
            </div>
          )}
          
          <Button 
            onClick={() => onOpenChange(false)}
            className="w-full bg-[#E6FFF4] text-black hover:bg-[#E6FFF4]/90"
          >
            Close
          </Button>
        </DialogContent>
      </Dialog>
    );
  }

  // Default: Show request access dialog
  return (
    <RequestAccessDialog
      profile={profile}
      isOpen={isOpen}
      onOpenChange={onOpenChange}
      onSendRequest={onSendRequest}
    />
  );
};

export default PrivateAlbumDialog;
