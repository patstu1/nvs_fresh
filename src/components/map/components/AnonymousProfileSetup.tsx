
import React from 'react';
import { Button } from '@/components/ui/button';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription, DialogFooter } from '@/components/ui/dialog';
import { Badge } from '@/components/ui/badge';
import { Eye, Image, Lock, Camera, ToggleLeft, MessageSquare } from 'lucide-react';
import { toast } from '@/hooks/use-toast';

interface AnonymousProfileSetupProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  onSetupComplete: (data: any) => void;
}

const AnonymousProfileSetup: React.FC<AnonymousProfileSetupProps> = ({ 
  open, 
  onOpenChange, 
  onSetupComplete 
}) => {
  const handleSetupComplete = () => {
    toast({
      title: "Anonymous Profile Created",
      description: "Your anonymous profile is now active. You're hidden from others but can still browse and interact."
    });
    
    onSetupComplete({
      isAnonymous: true,
      displayName: "Anonymous",
      showDistance: true,
      allowMessages: true
    });
    
    onOpenChange(false);
  };

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="bg-black border border-[#E6FFF4]/30 text-white max-w-md">
        <DialogHeader>
          <DialogTitle className="text-white flex items-center">
            <Eye className="w-5 h-5 mr-2 text-[#E6FFF4]" /> 
            Setup Anonymous Profile
          </DialogTitle>
          <DialogDescription className="text-[#E6FFF4]/70">
            Create an anonymous profile to browse without revealing your identity
          </DialogDescription>
        </DialogHeader>
        
        <div className="bg-[#1A1A1A] p-3 mb-4 rounded-md border border-[#E6FFF4]/10">
          <p className="text-sm text-[#E6FFF4] font-medium mb-2">Anonymous Browsing Benefits</p>
          <ul className="text-xs text-[#E6FFF4]/70 space-y-1.5">
            <li className="flex items-center gap-2">
              <Lock className="w-3.5 h-3.5" />
              Hide your identity while browsing
            </li>
            <li className="flex items-center gap-2">
              <MessageSquare className="w-3.5 h-3.5" />
              Send messages without revealing your profile
            </li>
            <li className="flex items-center gap-2">
              <Eye className="w-3.5 h-3.5" />
              Browse privately without appearing in others' searches
            </li>
          </ul>
        </div>
        
        <div className="space-y-4 mb-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-2">
              <Camera className="w-4 h-4 text-[#E6FFF4]" />
              <span className="text-sm text-[#E6FFF4]">Profile Photo</span>
            </div>
            <Badge variant="outline" className="bg-[#1A1A1A] text-[#E6FFF4] border-[#E6FFF4]/30">
              Hidden
            </Badge>
          </div>
          
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-2">
              <ToggleLeft className="w-4 h-4 text-[#E6FFF4]" />
              <span className="text-sm text-[#E6FFF4]">Show Distance</span>
            </div>
            <Badge variant="outline" className="bg-[#1A1A1A] text-[#E6FFF4] border-[#E6FFF4]/30">
              Enabled
            </Badge>
          </div>
          
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-2">
              <MessageSquare className="w-4 h-4 text-[#E6FFF4]" />
              <span className="text-sm text-[#E6FFF4]">Allow Messages</span>
            </div>
            <Badge variant="outline" className="bg-[#1A1A1A] text-[#E6FFF4] border-[#E6FFF4]/30">
              Enabled
            </Badge>
          </div>
        </div>
        
        <DialogFooter className="flex flex-col gap-2 sm:flex-row">
          <Button 
            variant="outline" 
            onClick={() => onOpenChange(false)}
            className="border border-[#E6FFF4]/30 text-[#E6FFF4] hover:bg-[#E6FFF4]/10 w-full sm:w-auto"
          >
            Cancel
          </Button>
          <Button 
            onClick={handleSetupComplete}
            className="bg-[#E6FFF4] text-black hover:bg-[#E6FFF4]/90 w-full sm:w-auto"
          >
            Create Anonymous Profile
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
};

export default AnonymousProfileSetup;
