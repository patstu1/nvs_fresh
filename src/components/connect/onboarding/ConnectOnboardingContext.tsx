
import React, { createContext, useState, useContext } from 'react';
import { ConnectUserProfile } from '../preferences/ConnectPreferencesTypes';

const initialProfileState: ConnectUserProfile = {
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
};

interface OnboardingState {
  step: number;
  profile: ConnectUserProfile;
}

interface OnboardingContextType {
  state: OnboardingState;
  setStep: (step: number) => void;
  updateProfile: (updates: Partial<ConnectUserProfile>) => void;
  completeOnboarding: () => void;
}

const OnboardingContext = createContext<OnboardingContextType | undefined>(undefined);

export const useConnectOnboarding = () => {
  const context = useContext(OnboardingContext);
  if (!context) {
    throw new Error('useConnectOnboarding must be used within a ConnectOnboardingProvider');
  }
  return context;
};

export const ConnectOnboardingProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [state, setState] = useState<OnboardingState>({
    step: 1,
    profile: initialProfileState
  });

  const setStep = (step: number) => {
    setState(prev => ({ ...prev, step }));
  };

  const updateProfile = (updates: Partial<ConnectUserProfile>) => {
    setState(prev => ({
      ...prev,
      profile: { ...prev.profile, ...updates }
    }));
  };

  const completeOnboarding = () => {
    setState(prev => ({
      ...prev,
      profile: { ...prev.profile, profileSetupComplete: true }
    }));
  };

  return (
    <OnboardingContext.Provider value={{
      state,
      setStep,
      updateProfile,
      completeOnboarding
    }}>
      {children}
    </OnboardingContext.Provider>
  );
};
