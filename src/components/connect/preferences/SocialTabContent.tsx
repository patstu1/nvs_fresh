
import React from 'react';
import { Button } from '@/components/ui/button';
import { Check } from 'lucide-react';
import { ConnectUserProfile, PersonalityTrait, SexualPreference } from './ConnectPreferencesTypes';

interface SocialTabContentProps {
  formData: ConnectUserProfile;
  handleSelectOption: <T extends string>(field: keyof ConnectUserProfile, value: T) => void;
  handleToggleArrayOption: <T extends string>(field: keyof ConnectUserProfile, value: T) => void;
  isOptionSelected: (field: keyof ConnectUserProfile, value: string) => boolean;
}

const SocialTabContent: React.FC<SocialTabContentProps> = ({ 
  formData, 
  handleSelectOption,
  handleToggleArrayOption,
  isOptionSelected 
}) => {
  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-lg font-semibold text-[#E6FFF4] mb-2">Personality Traits</h2>
        <p className="text-[#E6FFF4]/70 mb-4">Select up to 5 traits that describe you:</p>
        
        <div className="grid grid-cols-2 gap-2 mb-4">
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
            { value: 'low-key', label: 'Low Key' },
            { value: 'drama-free', label: 'Drama Free' },
            { value: 'daddy', label: 'Daddy' },
            { value: 'boy', label: 'Boy' },
            { value: 'masc', label: 'Masc' },
            { value: 'soft-masc', label: 'Soft Masc' },
            { value: 'faggy-proud', label: 'Faggy & Proud' },
          ] as const).map(option => (
            <Button 
              key={option.value}
              type="button"
              variant={formData.personalityTraits.includes(option.value) ? 'ring-active' : 'ring'}
              onClick={() => handleToggleArrayOption('personalityTraits', option.value)}
              className="justify-start"
            >
              {formData.personalityTraits.includes(option.value) && <Check className="w-4 h-4 mr-2" />}
              {option.label}
            </Button>
          ))}
        </div>
      </div>
      
      <div>
        <h2 className="text-lg font-semibold text-[#E6FFF4] mb-2 mt-6">Sexual Preferences</h2>
        <p className="text-[#E6FFF4]/70 mb-4">What are you into? (Select all that apply):</p>
        
        <div className="grid grid-cols-2 gap-2">
          {([
            { value: 'dom-sub', label: 'Dom/Sub Play' },
            { value: 'kink-friendly', label: 'Kink Friendly' },
            { value: 'masculine-energy', label: 'Masculine Energy' },
            { value: 'romantic', label: 'Romantic' },
            { value: 'video-cam', label: 'Video/Cam' },
            { value: 'groups-voyeur', label: 'Groups/Voyeur' },
            { value: 'slow-build', label: 'Slow Build' },
          ] as const).map(option => (
            <Button 
              key={option.value}
              type="button"
              variant={formData.sexualPreferences.includes(option.value) ? 'ring-active' : 'ring'}
              onClick={() => handleToggleArrayOption('sexualPreferences', option.value)}
              className="justify-start"
            >
              {formData.sexualPreferences.includes(option.value) && <Check className="w-4 h-4 mr-2" />}
              {option.label}
            </Button>
          ))}
        </div>
      </div>
    </div>
  );
};

export default SocialTabContent;
