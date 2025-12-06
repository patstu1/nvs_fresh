
import React from 'react';
import { Button } from '@/components/ui/button';
import { X } from 'lucide-react';

interface ZoomHeaderProps {
  title: string;
  participantCount?: number;
  capacity?: number;
  onClose: () => void;
}

const ZoomHeader: React.FC<ZoomHeaderProps> = ({ 
  title, 
  participantCount,
  capacity,
  onClose 
}) => {
  return (
    <div className="flex items-center justify-between p-4 border-b border-[#333]">
      <div className="flex items-center">
        <h2 className="text-[#C2FFE6] font-semibold">
          {participantCount !== undefined && capacity !== undefined 
            ? `${title} (${participantCount}/${capacity})` 
            : title}
        </h2>
      </div>
      <Button variant="ghost" size="icon" onClick={onClose}>
        <X className="h-4 w-4 text-[#C2FFE6]" />
      </Button>
    </div>
  );
};

export default ZoomHeader;
