
import React from 'react';
import { Button } from '@/components/ui/button';
import { Check } from 'lucide-react';
import { PersonalityTrait } from './ConnectPreferencesTypes';

const PersonalityTabContent = ({
  personalityTraits,
  handleToggleTraits
}: {
  personalityTraits: PersonalityTrait[];
  handleToggleTraits: (trait: PersonalityTrait) => void;
}) => {
  return (
    <div>
      <h2 className="text-lg font-semibold text-[#E6FFF4] mb-2">Personality & Lifestyle</h2>
      <p className="text-[#E6FFF4]/70 mb-4">Choose up to 5 traits that describe you:</p>
      
      <div className="grid grid-cols-2 gap-2 mb-6">
        {([
          { value: 'gym-rat', label: 'Gym Rat' },
          { value: 'traveler', label: 'Traveler' },
          { value: 'homebody', label: 'Homebody' },
          { value: 'party-boy', label: 'Party Boy' },
          { value: 'bookish', label: 'Bookish' },
          { value: 'wildcard', label: 'Wildcard' },
          { value: 'clean-cut', label: 'Clean Cut' },
          { value: 'kinky', label: 'Kinky' },
          { value: 'spiritual', label: 'Spiritual' },
          { value: 'entrepreneurial', label: 'Entrepreneurial' },
          { value: 'artsy', label: 'Artsy' },
          { value: 'hustler', label: 'Hustler' },
          { value: 'low-key', label: 'Low-Key' },
          { value: 'drama-free', label: 'Drama-Free' },
          { value: 'daddy', label: 'Daddy' },
          { value: 'boy', label: 'Boy' },
          { value: 'masc', label: 'Masc' },
          { value: 'soft-masc', label: 'Soft Masc' },
          { value: 'faggy-proud', label: 'Faggy And Proud' },
        ] as const).map(option => (
          <Button 
            key={option.value}
            type="button"
            variant={personalityTraits.includes(option.value) ? 'ring-active' : 'ring'}
            onClick={() => handleToggleTraits(option.value)}
            className="justify-start"
          >
            {personalityTraits.includes(option.value) && <Check className="w-4 h-4 mr-2" />}
            {option.label}
          </Button>
        ))}
      </div>
    </div>
  );
};

export default PersonalityTabContent;
