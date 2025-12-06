
import React from 'react';
import GlobalCitySelector from '@/components/GlobalCitySelector';

interface LocationSelectorProps {
  currentCity: { name: string; country: string };
  onCitySelect: (city: { name: string; country: string }) => void;
}

const LocationSelector: React.FC<LocationSelectorProps> = ({ currentCity, onCitySelect }) => {
  return (
    <div className="px-4 py-3 border-b border-[#333333]">
      <div className="flex items-center justify-between">
        <span className="text-sm text-white">Virtual Location</span>
        <GlobalCitySelector onCitySelect={onCitySelect} />
      </div>
    </div>
  );
};

export default LocationSelector;
