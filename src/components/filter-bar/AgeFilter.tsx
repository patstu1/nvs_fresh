
import React from 'react';
import { Slider } from '@/components/ui/slider';
import { Toggle } from '@/components/ui/toggle';

interface AgeFilterProps {
  ageRange: [number, number];
  setAgeRange: (range: [number, number]) => void;
  showOnlineOnly: boolean;
  setShowOnlineOnly: (show: boolean) => void;
}

const AgeFilter: React.FC<AgeFilterProps> = ({
  ageRange,
  setAgeRange,
  showOnlineOnly,
  setShowOnlineOnly
}) => {
  return (
    <div className="w-full px-3 mb-4 bg-[#0F1828]/80 rounded-lg p-3 border border-[#C2FFE6]/20">
      <p className="text-sm text-[#C2FFE6] mb-2">Age Range: {ageRange[0]} - {ageRange[1]}</p>
      <Slider
        defaultValue={[18, 50]}
        min={18}
        max={99}
        step={1}
        value={[ageRange[0], ageRange[1]]}
        onValueChange={(value) => setAgeRange([value[0], value[1]])}
        className="mb-2"
      />
      <Toggle 
        pressed={showOnlineOnly} 
        onPressedChange={setShowOnlineOnly}
        className="text-xs text-[#C2FFE6] border border-[#C2FFE6]/30 hover:bg-[#C2FFE6]/10"
      >
        Online Only
      </Toggle>
    </div>
  );
};

export default AgeFilter;
