
import React from 'react';
import { Beer, Coffee, Music } from 'lucide-react';
import { Toggle } from '@/components/ui/toggle';

interface VenueType {
  type: string;
  label: string;
  icon: React.ElementType;
}

interface VenueFilterProps {
  selectedVenueTypes: string[];
  setSelectedVenueTypes: (types: string[]) => void;
}

const VenueFilter: React.FC<VenueFilterProps> = ({
  selectedVenueTypes,
  setSelectedVenueTypes
}) => {
  const venueTypes: VenueType[] = [
    { type: 'bar', label: 'Bars', icon: Beer },
    { type: 'cafe', label: 'Cafes', icon: Coffee },
    { type: 'club', label: 'Clubs', icon: Music },
  ];
  
  const handleVenueTypeToggle = (value: string) => {
    if (selectedVenueTypes.includes(value)) {
      setSelectedVenueTypes(selectedVenueTypes.filter(v => v !== value));
    } else {
      setSelectedVenueTypes([...selectedVenueTypes, value]);
    }
  };
  
  return (
    <div className="w-full px-3 mb-4 bg-[#0F1828]/80 rounded-lg p-3 border border-[#C2FFE6]/20">
      <p className="text-sm text-[#C2FFE6] mb-2">Venue Types:</p>
      <div className="flex flex-wrap gap-2">
        {venueTypes.map((venue) => {
          const VenueIcon = venue.icon;
          return (
            <Toggle
              key={venue.type}
              pressed={selectedVenueTypes.includes(venue.type)}
              onPressedChange={() => handleVenueTypeToggle(venue.type)}
              className="flex items-center text-xs text-[#C2FFE6] border border-[#C2FFE6]/30 hover:bg-[#C2FFE6]/10"
            >
              <VenueIcon className="w-3 h-3 mr-1" />
              {venue.label}
            </Toggle>
          );
        })}
      </div>
    </div>
  );
};

export default VenueFilter;
