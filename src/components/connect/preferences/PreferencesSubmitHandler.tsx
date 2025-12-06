
import React from 'react';
import { toast } from '@/hooks/use-toast';
import { processProfileForAIMatching } from '@/utils/profileApi';
import { usePreferences } from './PreferencesContext';
import { ProfileFormValues } from "@/types/ProfileSetupTypes";
import { useUserSession } from '@/hooks/useUserSession';

interface PreferencesSubmitHandlerProps {
  onComplete: () => void;
}

export const usePreferencesSubmit = ({ onComplete }: PreferencesSubmitHandlerProps) => {
  const { 
    preferences, 
    socialMedia, 
    allowSocialMediaAnalysis, 
    isProcessing, 
    setIsProcessing 
  } = usePreferences();
  const { completeProfileSetup } = useUserSession();

  const handleSubmit = async () => {
    if (preferences.lookingFor.length === 0) {
      toast({
        title: "Please select what you're looking for",
        description: "Select at least one option to continue",
        variant: "destructive"
      });
      return false;
    }

    setIsProcessing(true);

    try {
      // Process data with the AI matching algorithm
      const formData: ProfileFormValues = {
        personalDetails: {
          name: 'User', // This would normally come from user's profile
          age: 30, // This would normally come from user's profile
          bio: '', // This would normally come from user's profile
        },
        socialMedia,
        compatibility: {
          wantsKids: false,
          hasKids: false,
          isFamilyOriented: false, 
          isDrinker: !preferences.dealBreakers.includes('Drinking'),
          isSmoker: !preferences.dealBreakers.includes('Smoking'),
          isReligious: false,
          openToLongDistance: !preferences.dealBreakers.includes('Long Distance'),
          relationshipType: preferences.lookingFor,
          dealBreakers: preferences.dealBreakers,
        },
        interests: {
          hobbies: preferences.hobbies,
          interests: preferences.interests,
          favoriteActivities: [],
          music: [],
          movies: [],
          food: [],
        },
        media: {
          profilePictures: [],
          publicAlbum: [],
          privateAlbum: [],
        },
        allowAiAnalysis: allowSocialMediaAnalysis,
      };

      // Process the profile data for AI matching
      const result = await processProfileForAIMatching(formData);

      console.log("AI Matching result:", result);
      
      // Save to localStorage for demo purposes
      localStorage.setItem('connect-preferences-set', 'true');
      localStorage.setItem('connect-preferences', JSON.stringify({
        preferences,
        socialMedia,
        allowSocialMediaAnalysis
      }));
      
      // Ensure profile is marked as complete
      localStorage.setItem('onboardingCompleted', 'true');
      completeProfileSetup();
      
      toast({
        title: "Preferences Saved",
        description: "Your AI matching preferences have been updated!",
      });
      
      onComplete();
      return true;
    } catch (error) {
      console.error("Error processing preferences:", error);
      toast({
        title: "Error Saving Preferences",
        description: "There was an error processing your preferences. Please try again.",
        variant: "destructive"
      });
      return false;
    } finally {
      setIsProcessing(false);
    }
  };

  return { handleSubmit, isProcessing };
};
