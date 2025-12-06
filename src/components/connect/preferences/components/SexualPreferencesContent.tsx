
import React from 'react';
import { Button } from '@/components/ui/button';
import { Check } from 'lucide-react';
import { SexualPreference } from '../ConnectPreferencesTypes';

interface SexualPreferencesContentProps {
  preferences: SexualPreference[];
  onTogglePreference: (preference: SexualPreference) => void;
}

export const SexualPreferencesContent: React.FC<SexualPreferencesContentProps> = ({
  preferences,
  onTogglePreference
}) => {
  const options = [
    { value: 'dom-sub' as const, label: 'Into dom/sub dynamics' },
    { value: 'kink-friendly' as const, label: 'Kink-friendly' },
    { value: 'masculine-energy' as const, label: 'Prefer masculine energy' },
    { value: 'romantic' as const, label: 'Romantic over raunchy' },
    { value: 'video-cam' as const, label: 'Into video / cam' },
    { value: 'groups-voyeur' as const, label: 'Into groups / voyeur' },
    { value: 'slow-build' as const, label: 'Prefer slow build / teasing' },
  ];

  return (
    <>
      <h2 className="text-lg font-semibold text-[#E6FFF4] mb-2">Sexual Chemistry & Preferences</h2>
      <p className="text-[#E6FFF4]/70 mb-4">Select all that apply:</p>
      
      <div className="grid grid-cols-2 gap-2 mb-6">
        {options.map(option => (
          <Button 
            key={option.value}
            type="button"
            variant={preferences.includes(option.value) ? 'ring-active' : 'ring'}
            onClick={() => onTogglePreference(option.value)}
            className="justify-start"
          >
            {preferences.includes(option.value) && <Check className="w-4 h-4 mr-2" />}
            {option.label}
          </Button>
        ))}
      </div>
    </>
  );
};

