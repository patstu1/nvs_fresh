
import React from 'react';
import { Button } from '@/components/ui/button';
import { Crosshair } from 'lucide-react';

interface LocationTrackerButtonProps {
  isLocating: boolean;
  onClick: () => void;
}

/**
 * Button component for the location tracker
 */
const LocationTrackerButton: React.FC<LocationTrackerButtonProps> = ({
  isLocating,
  onClick
}) => {
  return (
    <div className="absolute bottom-24 right-4 z-10">
      <Button
        onClick={onClick}
        disabled={isLocating}
        className="bg-[#4BEFE0] text-[#1A1F2C] hover:bg-[#4BEFE0]/90 rounded-full w-14 h-14 flex items-center justify-center shadow-lg shadow-[#4BEFE0]/20"
        style={{
          boxShadow: '0 0 15px rgba(75, 239, 224, 0.3), 0 0 30px rgba(75, 239, 224, 0.1)'
        }}
      >
        {isLocating ? (
          <div className="animate-spin h-6 w-6 border-3 border-[#1A1F2C] border-t-transparent rounded-full" />
        ) : (
          <Crosshair className="w-6 h-6" />
        )}
      </Button>
    </div>
  );
};

export default LocationTrackerButton;
