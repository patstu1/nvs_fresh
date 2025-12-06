
import React from 'react';
import { MapPin } from 'lucide-react';
import GlobalCitySelector from '../GlobalCitySelector';
import LocationBasedMatchingToggle from '../LocationBasedMatchingToggle';

interface LocationControlsProps {
  isLocationMatchingEnabled: boolean;
  currentCity: { name: string; country: string };
  onLocationToggle: (enabled: boolean) => void;
  onCitySelect: (city: { name: string; country: string }) => void;
  distanceRadius?: number;
  onDistanceChange?: (radius: number) => void;
}

const LocationControls: React.FC<LocationControlsProps> = ({
  isLocationMatchingEnabled,
  currentCity,
  onLocationToggle,
  onCitySelect,
  distanceRadius = 25,
  onDistanceChange
}) => {
  return (
    <div className="w-full mb-6 flex justify-between items-center">
      <LocationBasedMatchingToggle 
        enabled={isLocationMatchingEnabled}
        onToggle={onLocationToggle}
      />
      
      <div className="flex items-center">
        {!isLocationMatchingEnabled && (
          <div className="bg-[#2A2A2A] px-2 py-1 rounded-full text-xs flex items-center mr-2">
            <MapPin className="w-3 h-3 text-[#C2FFE6] mr-1" />
            <span className="text-[#C2FFE6]">{currentCity.name}</span>
          </div>
        )}
        <GlobalCitySelector onCitySelect={onCitySelect} />
      </div>
    </div>
  );
};

export default LocationControls;
