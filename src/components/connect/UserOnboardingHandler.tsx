
import React from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { useOnboardingState } from './hooks/useOnboardingState';
import AIResearchHandler from './onboarding/AIResearchHandler';
import IntroductionHandler from './onboarding/IntroductionHandler';
import PreferencesHandler from './onboarding/PreferencesHandler';
import DashboardHandler from './onboarding/DashboardHandler';

interface UserOnboardingHandlerProps {
  children: React.ReactNode;
}

const UserOnboardingHandler: React.FC<UserOnboardingHandlerProps> = ({ children }) => {
  const {
    showAIResearch,
    hasSeenIntro,
    hasSetPreferences,
    showDashboard,
    isInitialized,
    setShowAIResearch,
    setHasSeenIntro,
    setHasSetPreferences,
    setShowDashboard
  } = useOnboardingState();

  if (!isInitialized) {
    return null;
  }

  if (showAIResearch) {
    return <AIResearchHandler onComplete={() => {
      setShowAIResearch(false);
      setHasSeenIntro(false);
    }} />;
  }

  if (!hasSeenIntro) {
    return <IntroductionHandler onComplete={() => {
      setHasSeenIntro(true);
      setHasSetPreferences(false);
    }} />;
  }

  if (!hasSetPreferences) {
    return <PreferencesHandler onComplete={() => {
      setHasSetPreferences(true);
      setShowDashboard(true);
    }} />;
  }

  if (showDashboard) {
    return <DashboardHandler onComplete={() => setShowDashboard(false)} />;
  }

  return (
    <AnimatePresence mode="wait">
      <motion.div
        key="children"
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        exit={{ opacity: 0 }}
        transition={{ duration: 0.3 }}
      >
        {children}
      </motion.div>
    </AnimatePresence>
  );
};

export default UserOnboardingHandler;
