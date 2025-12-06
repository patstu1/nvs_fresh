
import React from 'react';
import { Button } from '@/components/ui/button';
import { Check } from 'lucide-react';
import { ConnectUserProfile, DietPreference, DrugUse } from './ConnectPreferencesTypes';

interface LifestyleTabContentProps {
  formData: ConnectUserProfile;
  handleSelectOption: <T extends string>(field: keyof ConnectUserProfile, value: T) => void;
  isOptionSelected: (field: keyof ConnectUserProfile, value: string) => boolean;
}

const LifestyleTabContent: React.FC<LifestyleTabContentProps> = ({
  formData,
  handleSelectOption,
  isOptionSelected
}) => {
  return (
    <div className="space-y-6">
      <h2 className="text-lg font-semibold text-[#E6FFF4] mb-2">Lifestyle Preferences</h2>
      <p className="text-[#E6FFF4]/70 mb-4">Tell us about your lifestyle:</p>
      
      <div className="mb-6">
        <h3 className="text-md font-medium text-[#E6FFF4] mb-2">Diet</h3>
        <div className="grid grid-cols-2 gap-2 mb-4">
          {([
            { value: 'omnivore', label: 'Omnivore' },
            { value: 'vegetarian', label: 'Vegetarian' },
            { value: 'vegan', label: 'Vegan' },
            { value: 'keto', label: 'Keto' },
            { value: 'paleo', label: 'Paleo' },
          ] as const).map(option => (
            <Button 
              key={option.value}
              type="button"
              variant={isOptionSelected('dietPreference', option.value) ? 'ring-active' : 'ring'}
              onClick={() => handleSelectOption('dietPreference', option.value)}
              className="justify-start"
            >
              {isOptionSelected('dietPreference', option.value) && <Check className="w-4 h-4 mr-2" />}
              {option.label}
            </Button>
          ))}
        </div>
        
        <h3 className="text-md font-medium text-[#E6FFF4] mb-2 mt-6">Substance Use</h3>
        <div className="grid grid-cols-2 gap-2 mb-4">
          {([
            { value: 'never', label: 'Never' },
            { value: 'socially', label: 'Socially' },
            { value: 'regularly', label: 'Regularly' },
          ] as const).map(option => (
            <Button 
              key={option.value}
              type="button"
              variant={isOptionSelected('drugUse', option.value) ? 'ring-active' : 'ring'}
              onClick={() => handleSelectOption('drugUse', option.value)}
              className="justify-start"
            >
              {isOptionSelected('drugUse', option.value) && <Check className="w-4 h-4 mr-2" />}
              {option.label}
            </Button>
          ))}
        </div>
      </div>
    </div>
  );
};

export default LifestyleTabContent;
