
import React, { useEffect, useState } from 'react';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription, DialogFooter } from '@/components/ui/dialog';
import { Button } from '@/components/ui/button';
import { AlertTriangle } from 'lucide-react';

interface NOWWarningModalProps {
  onConfirm: () => void;
  onDecline?: () => void;
}

const NOWWarningModal: React.FC<NOWWarningModalProps> = ({ onConfirm, onDecline }) => {
  const [open, setOpen] = useState(false);
  
  useEffect(() => {
    // Only show if age verification was completed
    const hasVerifiedAge = localStorage.getItem('ageVerified') === 'true';
    
    if (!hasVerifiedAge) {
      return;
    }
    
    // Check if user has already acknowledged the warning
    const hasAcknowledgedWarning = localStorage.getItem('nowWarningAcknowledged') === 'true';
    if (!hasAcknowledgedWarning) {
      setOpen(true);
    }
  }, []);

  const handleConfirm = () => {
    // Store confirmation in localStorage
    localStorage.setItem('nowWarningAcknowledged', 'true');
    setOpen(false);
    onConfirm();
  };

  const handleDecline = () => {
    setOpen(false);
    if (onDecline) onDecline();
  };

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogContent className="bg-black border border-[#E6FFF4]/30 max-w-md">
        <DialogHeader>
          <div className="flex items-center justify-center mb-4 text-[#FF3366]">
            <AlertTriangle size={32} />
          </div>
          <DialogTitle className="text-xl text-center text-white">Welcome to NOW</DialogTitle>
        </DialogHeader>
        
        <DialogDescription className="text-center text-white/80">
          NOW contains user-submitted content that may include nudity or explicit material. 
          Content is blurred by default for your privacy.
        </DialogDescription>
        
        <div className="mt-4 border-t border-[#E6FFF4]/10 pt-4">
          <ul className="text-sm text-white/70 space-y-2 mb-4">
            <li className="flex items-start">
              <span className="text-[#E6FFF4] mr-2">•</span>
              <span>Anonymous profiles and explicit images are supported</span>
            </li>
            <li className="flex items-start">
              <span className="text-[#E6FFF4] mr-2">•</span>
              <span>Tap images to reveal blurred content</span>
            </li>
            <li className="flex items-start">
              <span className="text-[#E6FFF4] mr-2">•</span>
              <span>You can report inappropriate content</span>
            </li>
            <li className="flex items-start">
              <span className="text-[#E6FFF4] mr-2">•</span>
              <span>All content and interactions are location-based</span>
            </li>
          </ul>
        </div>
        
        <DialogFooter className="flex flex-col gap-2 mt-4">
          <Button 
            onClick={handleConfirm}
            className="w-full bg-[#E6FFF4] text-black hover:bg-[#E6FFF4]/90"
          >
            I Understand - Enter NOW
          </Button>
          <Button 
            onClick={handleDecline} 
            variant="outline"
            className="w-full border-[#E6FFF4]/30 text-[#E6FFF4]/80 hover:text-[#E6FFF4]"
          >
            Go Back
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
};

export default NOWWarningModal;
