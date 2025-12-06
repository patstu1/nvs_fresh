
import React from 'react';
import { Location } from '../types/markerTypes';

export interface CitySelectorProps {
  options: Array<{ label: string; location: Location }>;
  selectedLocation: Location | null;
  onCitySelect: (city: any) => void;
}

const CitySelector: React.FC<CitySelectorProps> = ({ options, selectedLocation, onCitySelect }) => {
  return (
    <div className="absolute top-16 left-4 z-30 bg-black/80 backdrop-blur-md rounded-lg shadow-lg px-2 py-1.5">
      <select 
        className="bg-transparent text-white border border-gray-600 rounded px-2 py-1 text-sm"
        value={selectedLocation ? options.findIndex(opt => 
          opt.location.lat === selectedLocation.lat && 
          opt.location.lng === selectedLocation.lng
        ) : 0}
        onChange={(e) => onCitySelect(options[Number(e.target.value)])}
      >
        {options.map((city, index) => (
          <option key={city.label} value={index}>{city.label}</option>
        ))}
      </select>
    </div>
  );
};

export default CitySelector;
