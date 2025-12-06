
import React from 'react';
import { Button } from '@/components/ui/button';
import { Eye, EyeOff } from 'lucide-react';

interface AnonymousToggleProps {
  anonymousMode: boolean;
  onToggle: () => void;
}

const AnonymousToggle: React.FC<AnonymousToggleProps> = ({ anonymousMode, onToggle }) => {
  return (
    <div className="absolute bottom-24 right-4 z-10">
      <Button 
        onClick={onToggle}
        variant="outline"
        className={`flex items-center space-x-2 px-3 py-2 rounded-full ${
          anonymousMode 
            ? 'bg-[#E6FFF4]/10 text-[#E6FFF4] border-[#E6FFF4]/30' 
            : 'bg-black border-[#E6FFF4]/20 text-[#E6FFF4]/70'
        }`}
      >
        {anonymousMode ? (
          <>
            <EyeOff className="w-4 h-4 mr-2" />
            <span className="text-sm font-medium">Anonymous</span>
          </>
        ) : (
          <>
            <Eye className="w-4 h-4 mr-2" />
            <span className="text-sm font-medium">Visible</span>
          </>
        )}
      </Button>
    </div>
  );
};

export default AnonymousToggle;
