
import { useState, useEffect } from 'react';
import { useUserSession } from '@/hooks/useUserSession';

export const useOnboardingState = () => {
  const [showAIResearch, setShowAIResearch] = useState(false);
  const [hasSeenIntro, setHasSeenIntro] = useState(false);
  const [hasSetPreferences, setHasSetPreferences] = useState(false);
  const [showDashboard, setShowDashboard] = useState(false);
  const [isInitialized, setIsInitialized] = useState(false);
  const { completeProfileSetup } = useUserSession();

  useEffect(() => {
    const initializeOnboarding = () => {
      const aiResearchSeen = localStorage.getItem('connect-ai-research-seen');
      const introSeen = localStorage.getItem('connect-intro-seen');
      const preferencesSet = localStorage.getItem('connect-preferences-set');
      const returningUser = localStorage.getItem('connect-returning-user');
      
      if (!localStorage.getItem('onboardingCompleted')) {
        localStorage.setItem('onboardingCompleted', 'true');
        completeProfileSetup();
      }
      
      if (!aiResearchSeen && !introSeen && !preferencesSet) {
        localStorage.setItem('connect-ai-research-seen', 'true');
        localStorage.setItem('connect-intro-seen', 'true');
        localStorage.setItem('connect-preferences-set', 'true');
        localStorage.setItem('connect-returning-user', 'true');
        localStorage.setItem('onboardingCompleted', 'true');
        completeProfileSetup();
        
        setShowAIResearch(false);
        setHasSeenIntro(true);
        setHasSetPreferences(true);
      } else {
        if (aiResearchSeen === 'false') setShowAIResearch(true);
        if (introSeen === 'true') setHasSeenIntro(true);
        if (preferencesSet === 'true') {
          setHasSetPreferences(true);
          localStorage.setItem('onboardingCompleted', 'true');
          completeProfileSetup();
        }
        if (returningUser === 'false') setShowDashboard(true);
      }
      
      setIsInitialized(true);
    };

    initializeOnboarding();
  }, [completeProfileSetup]);

  return {
    showAIResearch,
    hasSeenIntro,
    hasSetPreferences,
    showDashboard,
    isInitialized,
    setShowAIResearch,
    setHasSeenIntro,
    setHasSetPreferences,
    setShowDashboard
  };
};
