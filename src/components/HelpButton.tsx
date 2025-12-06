
import React, { useState } from 'react';
import { Button } from '@/components/ui/button';
import { HelpCircle } from 'lucide-react';
import HelpCenterDialog from './HelpCenterDialog';

const HelpButton: React.FC = () => {
  const [isHelpOpen, setIsHelpOpen] = useState(false);

  return (
    <>
      <Button
        variant="ghost"
        size="icon"
        className="fixed bottom-20 right-4 w-12 h-12 rounded-full bg-[#C2FFE6] text-black shadow-lg z-50 hover:scale-105 transition-transform"
        onClick={() => setIsHelpOpen(true)}
      >
        <HelpCircle className="h-6 w-6" />
      </Button>
      
      <HelpCenterDialog 
        isOpen={isHelpOpen}
        onClose={() => setIsHelpOpen(false)}
      />
    </>
  );
};

export default HelpButton;
