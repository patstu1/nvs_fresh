
import React from 'react';
import { Dialog, DialogContent, DialogHeader, DialogTitle } from '@/components/ui/dialog';
import { Button } from '@/components/ui/button';
import { UserProfile } from '@/types/UserProfile';
import { toast } from '@/hooks/use-toast';
import { Lock, Image } from 'lucide-react';

interface RequestAccessDialogProps {
  profile: UserProfile;
  isOpen: boolean;
  onOpenChange: (open: boolean) => void;
  onSendRequest: () => void;
}

const RequestAccessDialog: React.FC<RequestAccessDialogProps> = ({
  profile,
  isOpen,
  onOpenChange,
  onSendRequest
}) => {
  const handleRequestAccess = () => {
    onSendRequest();
    toast({
      title: "Request Sent",
      description: `Your request for ${profile.name}'s private album was sent`
    });
    onOpenChange(false);
  };

  return (
    <Dialog open={isOpen} onOpenChange={onOpenChange}>
      <DialogContent className="bg-black border border-[#E6FFF4]/30 text-white max-w-md">
        <DialogHeader>
          <DialogTitle className="text-white flex items-center">
            <Lock className="w-5 h-5 mr-2 text-[#E6FFF4]" /> 
            Request Private Album Access
          </DialogTitle>
        </DialogHeader>
        
        <div className="flex items-center gap-3 my-4">
          <div className="w-16 h-16 rounded-full overflow-hidden border-2 border-[#E6FFF4]/30">
            <img src={profile.image} alt={profile.name} className="w-full h-full object-cover" />
          </div>
          <div>
            <p className="font-medium text-lg">{profile.name}, {profile.age}</p>
            <p className="text-sm text-[#E6FFF4]/70">{profile.distance}km away</p>
          </div>
        </div>
        
        <div className="bg-[#1A1A1A] p-3 mb-4 rounded-md border border-[#E6FFF4]/10">
          <p className="text-sm text-[#E6FFF4] font-medium">Private Album (XXX)</p>
          <div className="flex items-center mt-2">
            <p className="text-xs text-[#E6FFF4]/70">
              This user has a private album with explicit content ({profile.privateAlbum?.images.length || 0} images)
            </p>
          </div>
        </div>
        
        <div className="grid grid-cols-5 gap-2 mb-4">
          {[1, 2, 3, 4, 5].map((_, i) => (
            <div key={i} className="aspect-square bg-[#1A1A1A] rounded-md border border-[#E6FFF4]/10 flex items-center justify-center">
              <Image className="w-6 h-6 text-[#E6FFF4]/30" />
              <div className="absolute inset-0 bg-black/60 flex items-center justify-center">
                <Lock className="w-4 h-4 text-[#E6FFF4]" />
              </div>
            </div>
          ))}
        </div>
        
        <div className="flex flex-col gap-3">
          <Button 
            onClick={handleRequestAccess}
            className="w-full bg-[#E6FFF4] text-black hover:bg-[#E6FFF4]/90"
          >
            Request Access
          </Button>
          <Button 
            variant="outline" 
            onClick={() => onOpenChange(false)}
            className="w-full border-[#E6FFF4]/30 text-[#E6FFF4] hover:bg-[#E6FFF4]/10"
          >
            Cancel
          </Button>
        </div>
      </DialogContent>
    </Dialog>
  );
};

export default RequestAccessDialog;
