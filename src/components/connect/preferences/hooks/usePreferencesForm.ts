
import { useState } from 'react';
import { ConnectUserProfile, PersonalityTrait, SexualRole, DatingIntent } from '../ConnectPreferencesTypes';
import { toast } from '@/hooks/use-toast';

export const usePreferencesForm = () => {
  const [formData, setFormData] = useState<ConnectUserProfile>({
    sexualRole: undefined,
    datingIntent: undefined,
    sexualPreferences: [],
    personalityTraits: [],
    politicalLeaning: undefined,
    familyValues: undefined,
    dietPreference: undefined,
    religiousView: undefined,
    drugUse: undefined,
    familyViews: undefined,
    lifeGoals: [],
    coreValues: [],
    religiousBackground: undefined,
    religiousLevel: undefined,
    socialMedia: {
      instagram: '',
      twitter: '',
      tiktok: '',
      displayOnProfile: false
    },
    profileSetupComplete: false
  });

  // Use proper generic type parameter for type safety
  const handleSelectOption = <T extends string>(field: keyof ConnectUserProfile, value: T) => {
    setFormData(prev => ({
      ...prev,
      [field]: value
    } as ConnectUserProfile));
  };

  // Use proper generic type parameter for type safety
  const handleToggleArrayOption = <T extends string>(field: keyof ConnectUserProfile, value: T) => {
    setFormData(prev => {
      // Type assertion with proper typing
      const currentArray = prev[field] as T[] | undefined;
      
      if (Array.isArray(currentArray) && currentArray.includes(value)) {
        return {
          ...prev,
          [field]: currentArray.filter(item => item !== value)
        } as ConnectUserProfile;
      } else {
        // Add limits for different array fields
        const maxItems: Record<string, number> = {
          personalityTraits: 5,
          lifeGoals: 3,
          coreValues: 5,
          sexualPreferences: 7
        };
        
        if (field in maxItems && Array.isArray(prev[field]) && (prev[field] as unknown as T[]).length >= maxItems[field as keyof typeof maxItems]) {
          toast({
            title: "Selection Limit",
            description: `You can only select up to ${maxItems[field as keyof typeof maxItems]} ${field.replace(/([A-Z])/g, ' $1').toLowerCase()}.`,
          });
          return prev;
        }
        
        const updatedValue = Array.isArray(currentArray) ? [...currentArray, value] : [value];
        
        return {
          ...prev,
          [field]: updatedValue
        } as ConnectUserProfile;
      }
    });
  };

  const handleSocialMediaChange = (platform: keyof typeof formData.socialMedia, value: string | boolean) => {
    setFormData(prev => ({
      ...prev,
      socialMedia: {
        ...prev.socialMedia,
        [platform]: value
      }
    }));
  };

  return {
    formData,
    handleSelectOption,
    handleToggleArrayOption,
    handleSocialMediaChange,
  };
};
