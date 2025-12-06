
import React, { useEffect, useState } from 'react';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription, DialogFooter } from '@/components/ui/dialog';
import { Button } from '@/components/ui/button';
import { toast } from '@/hooks/use-toast';
import { AlertTriangle } from 'lucide-react';

interface AgeVerificationDialogProps {
  onVerify: () => void;
  onCancel: () => void;
  isOpen?: boolean;
}

const AgeVerificationDialog: React.FC<AgeVerificationDialogProps> = ({ 
  onVerify,
  onCancel,
  isOpen: propIsOpen
}) => {
  // Local state to manage the dialog's open state
  const [isOpen, setIsOpen] = useState(false);
  
  // Check if verification has been done on mount
  useEffect(() => {
    const hasVerifiedAge = localStorage.getItem('ageVerified') === 'true';
    
    // If age not verified and dialog should be shown according to props
    if (!hasVerifiedAge && propIsOpen !== false) {
      setIsOpen(true);
    }
  }, [propIsOpen]);
  
  // Handle age verification
  const handleVerify = () => {
    // Store verification in localStorage
    localStorage.setItem('ageVerified', 'true');
    setIsOpen(false);
    
    toast({
      title: "Age verified",
      description: "You now have access to all content",
      variant: "default",
    });
    
    if (onVerify) onVerify();
  };
  
  // Handle when user indicates they are not 18+
  const handleCancel = () => {
    setIsOpen(false);
    
    toast({
      title: "Age verification required",
      description: "You must be 18+ to access this application",
      variant: "destructive",
    });
    
    if (onCancel) onCancel();
  };

  return (
    <Dialog open={isOpen} onOpenChange={setIsOpen}>
      <DialogContent className="bg-black border border-[#E6FFF4]/20 max-w-md">
        <DialogHeader>
          <div className="flex items-center justify-center mb-4 text-[#FF3366]">
            <AlertTriangle size={32} />
          </div>
          <DialogTitle className="text-xl text-center text-white">Age Verification Required</DialogTitle>
        </DialogHeader>
        
        <DialogDescription className="text-center text-white/80">
          This application contains mature content that requires users to be 18 years or older.
        </DialogDescription>
        
        <div className="mt-4 border-t border-[#E6FFF4]/10 pt-4">
          <p className="text-sm text-white/70 mb-4">
            By continuing, you confirm that you are at least 18 years old and agree to access content intended for mature audiences.
          </p>
        </div>
        
        <DialogFooter className="flex flex-col gap-2 mt-4">
          <Button 
            onClick={handleVerify}
            className="w-full bg-[#E6FFF4] text-black hover:bg-[#E6FFF4]/90"
          >
            I am 18+ - Continue
          </Button>
          <Button 
            onClick={handleCancel}
            variant="outline"
            className="w-full border-[#E6FFF4]/30 text-[#E6FFF4]/80 hover:text-[#E6FFF4]"
          >
            Cancel
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
};

export default AgeVerificationDialog;
