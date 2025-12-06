
import React from 'react';
import { Button } from '@/components/ui/button';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription, DialogFooter } from '@/components/ui/dialog';
import { Badge } from '@/components/ui/badge';
import { Eye, Image } from 'lucide-react';

interface AnonymousProfileDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  onRegister: () => void;
}

const AnonymousProfileDialog: React.FC<AnonymousProfileDialogProps> = ({ 
  open, 
  onOpenChange, 
  onRegister 
}) => {
  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="bg-black border border-blue-500/30 text-white max-w-md">
        <DialogHeader>
          <DialogTitle className="text-white flex items-center">
            <Eye className="w-5 h-5 mr-2" /> 
            Create Anonymous Profile
          </DialogTitle>
          <DialogDescription className="text-white/70">
            Register an anonymous profile to unlock private messaging and real-time connections with nearby users.
          </DialogDescription>
        </DialogHeader>
        
        <div className="bg-[#1A1A1A] p-3 mb-4 rounded-md border border-blue-500/20">
          <p className="text-sm text-white/90 font-medium">Why Register Anonymously?</p>
          <p className="text-xs text-white/70 mt-1">
            Protect your identity while still connecting with like-minded people around you. Your personal information stays private while enabling real-time chat and meetups.
          </p>
        </div>
        
        <div className="grid grid-cols-3 gap-2 mb-4">
          {[1, 2, 3].map((_, i) => (
            <div key={i} className="aspect-square rounded-md bg-gray-800 flex items-center justify-center">
              <Image className="w-8 h-8 text-white/30" />
            </div>
          ))}
        </div>
        
        <div className="space-y-4 mb-4">
          <div className="flex items-center justify-between">
            <span className="text-sm text-white/70">Profile Visibility</span>
            <Badge variant="outline" className="bg-blue-500/20 text-blue-300 border-blue-500/30">
              Anonymous Only
            </Badge>
          </div>
          
          <div className="flex items-center justify-between">
            <span className="text-sm text-white/70">Distance Tracking</span>
            <Badge variant="outline" className="bg-blue-500/20 text-blue-300 border-blue-500/30">
              Enabled
            </Badge>
          </div>
          
          <div className="flex items-center justify-between">
            <span className="text-sm text-white/70">Private Messaging</span>
            <Badge variant="outline" className="bg-blue-500/20 text-blue-300 border-blue-500/30">
              Unlimited
            </Badge>
          </div>
        </div>
        
        <DialogFooter className="flex flex-col gap-2 sm:flex-row">
          <Button 
            variant="outline" 
            onClick={() => onOpenChange(false)}
            className="border border-white/30 text-white hover:bg-white/10 w-full sm:w-auto"
          >
            Cancel
          </Button>
          <Button 
            onClick={onRegister}
            className="bg-blue-500 text-white hover:bg-blue-600 w-full sm:w-auto"
          >
            Register Anonymous Profile
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
};

export default AnonymousProfileDialog;
