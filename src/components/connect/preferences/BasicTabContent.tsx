
import React from 'react';
import { Button } from '@/components/ui/button';
import { Check } from 'lucide-react';
import { ConnectUserProfile, SexualRole, DatingIntent } from './ConnectPreferencesTypes';

interface BasicTabContentProps {
  formData: ConnectUserProfile;
  handleSelectOption: <T extends string>(field: keyof ConnectUserProfile, value: T) => void;
  handleToggleArrayOption: <T extends string>(field: keyof ConnectUserProfile, value: T) => void;
  isOptionSelected: (field: keyof ConnectUserProfile, value: string) => boolean;
}

const BasicTabContent: React.FC<BasicTabContentProps> = ({
  formData,
  handleSelectOption,
  handleToggleArrayOption,
  isOptionSelected
}) => {
  return (
    <>
      <h2 className="text-lg font-semibold text-[#E6FFF4] mb-2">Identity & Sexual Role</h2>
      <p className="text-[#E6FFF4]/70 mb-4">Select your preferred role (required):</p>
      
      <div className="grid grid-cols-2 gap-2 mb-4">
        {([
          { value: 'top-dom-breeder', label: 'Top Dom Breeder' },
          { value: 'top', label: 'Top' },
          { value: 'vers-top', label: 'Vers Top' },
          { value: 'vers', label: 'Vers' },
          { value: 'vers-bottom', label: 'Vers Bottom' },
          { value: 'bottom', label: 'Bottom' },
          { value: 'power-bottom', label: 'Power Bottom' },
        ] as const).map(option => (
          <Button 
            key={option.value}
            type="button"
            variant={isOptionSelected('sexualRole', option.value) ? 'ring-active' : 'ring'}
            onClick={() => handleSelectOption('sexualRole', option.value)}
            className="justify-start"
          >
            {isOptionSelected('sexualRole', option.value) && <Check className="w-4 h-4 mr-2" />}
            {option.label}
          </Button>
        ))}
      </div>
      
      <h2 className="text-lg font-semibold text-[#E6FFF4] mb-2 mt-6">Dating Intent</h2>
      <p className="text-[#E6FFF4]/70 mb-4">What are you looking for? (required):</p>
      
      <div className="grid grid-cols-2 gap-2 mb-4">
        {([
          { value: 'hookup-only', label: 'Hookup only' },
          { value: 'casual', label: 'Something casual' },
          { value: 'relationship', label: 'Relationship material' },
          { value: 'exploring', label: "Just seeing what's out there" },
        ] as const).map(option => (
          <Button 
            key={option.value}
            type="button"
            variant={isOptionSelected('datingIntent', option.value) ? 'ring-active' : 'ring'}
            onClick={() => handleSelectOption('datingIntent', option.value)}
            className="justify-start"
          >
            {isOptionSelected('datingIntent', option.value) && <Check className="w-4 h-4 mr-2" />}
            {option.label}
          </Button>
        ))}
      </div>
    </>
  );
};

export default BasicTabContent;
