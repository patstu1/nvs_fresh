
import React from 'react';
import { Toggle } from '@/components/ui/toggle';

interface PositionFilterProps {
  selectedPositions: string[];
  setSelectedPositions: (positions: string[]) => void;
}

const PositionFilter: React.FC<PositionFilterProps> = ({
  selectedPositions,
  setSelectedPositions
}) => {
  const positions = [
    'active', 'social', 'dating', 'friends', 'networking'
  ];
  
  const handlePositionToggle = (value: string) => {
    if (selectedPositions.includes(value)) {
      setSelectedPositions(selectedPositions.filter(p => p !== value));
    } else {
      setSelectedPositions([...selectedPositions, value]);
    }
  };
  
  return (
    <div className="w-full px-3 mb-4 bg-[#0F1828]/80 rounded-lg p-3 border border-[#C2FFE6]/20">
      <p className="text-sm text-[#C2FFE6] mb-2">Looking for:</p>
      <div className="flex flex-wrap gap-2">
        {positions.map((pos) => (
          <Toggle
            key={pos}
            pressed={selectedPositions.includes(pos)}
            onPressedChange={() => handlePositionToggle(pos)}
            className="text-xs text-[#C2FFE6] border border-[#C2FFE6]/30 hover:bg-[#C2FFE6]/10 capitalize"
          >
            {pos}
          </Toggle>
        ))}
      </div>
    </div>
  );
};

export default PositionFilter;
