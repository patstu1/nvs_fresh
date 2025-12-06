
import React, { useState } from 'react';
import ConnectPreferences from '../ConnectPreferences';
import ConnectQuestionnaire from '../preferences/ConnectQuestionnaire';
import { motion, AnimatePresence } from 'framer-motion';
import { toast } from '@/hooks/use-toast';
import { useUserSession } from '@/hooks/useUserSession';

interface PreferencesHandlerProps {
  onComplete: () => void;
}

const PreferencesHandler: React.FC<PreferencesHandlerProps> = ({ onComplete }) => {
  const { completeProfileSetup } = useUserSession();
  const [showQuestionnaire, setShowQuestionnaire] = useState(true);
  const [questionnaireAnswers, setQuestionnaireAnswers] = useState<Record<string, string | string[]>>({});

  const handleQuestionnaireComplete = (answers: Record<string, string | string[]>) => {
    setQuestionnaireAnswers(answers);
    setShowQuestionnaire(false);
    
    // Save answers to localStorage
    localStorage.setItem('connect-questionnaire-completed', 'true');
    localStorage.setItem('connect-questionnaire-answers', JSON.stringify(answers));
    
    toast({
      title: "Preferences Saved",
      description: "Your detailed preferences have been recorded!",
    });
  };

  const handlePreferencesComplete = () => {
    localStorage.setItem('connect-preferences-set', 'true');
    localStorage.setItem('onboardingCompleted', 'true');
    completeProfileSetup();
    
    toast({
      title: "Profile Setup Complete",
      description: "Your CONNECT profile has been created and optimized for matching.",
    });
    
    onComplete();
  };

  const handleSkipQuestionnaire = () => {
    setShowQuestionnaire(false);
    
    toast({
      title: "Questionnaire Skipped",
      description: "You can always update your preferences later",
    });
  };

  return (
    <AnimatePresence mode="wait">
      {showQuestionnaire ? (
        <motion.div
          key="questionnaire"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          transition={{ duration: 0.3 }}
        >
          <ConnectQuestionnaire 
            onComplete={handleQuestionnaireComplete} 
            onSkip={handleSkipQuestionnaire}
            autoStart={true}
          />
        </motion.div>
      ) : (
        <motion.div
          key="preferences"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          transition={{ duration: 0.3 }}
        >
          <ConnectPreferences onComplete={handlePreferencesComplete} />
        </motion.div>
      )}
    </AnimatePresence>
  );
};

export default PreferencesHandler;
