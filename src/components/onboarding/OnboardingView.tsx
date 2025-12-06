
import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { useNavigate } from 'react-router-dom';
import { toast } from '@/hooks/use-toast';
import { useUserSession } from '@/hooks/useUserSession';

// Import refactored components
import WelcomeStep from './WelcomeStep';
import FeaturesStep from './FeaturesStep';
import GetStartedStep from './GetStartedStep';
import IntroAnimation from './IntroAnimation';
import CompletionView from './CompletionView';
import OnboardingHeader from './OnboardingHeader';
import ProgressIndicator from './ProgressIndicator';
import { useIntroAnimation } from '@/hooks/useIntroAnimation';

const OnboardingView: React.FC = () => {
  const [currentStep, setCurrentStep] = useState<number>(1);
  const [completed, setCompleted] = useState(false);
  const { showIntro, showYo, showBro, showIcon, showFinal, iconScale, skipAnimation, setShowIntro } = useIntroAnimation();
  const { completeProfileSetup } = useUserSession();
  
  const navigate = useNavigate();
  
  useEffect(() => {
    console.log('OnboardingView mounted, current step:', currentStep);
    
    // Mark onboarding as completed in localStorage
    localStorage.setItem('onboardingCompleted', 'true');
    completeProfileSetup();
    
    // After setting it, check if we should navigate away
    const onboardingCompleted = localStorage.getItem('onboardingCompleted');
    if (onboardingCompleted === 'true') {
      // Don't navigate away immediately to fix the deployment check
      console.log('Onboarding already completed');
    }
  }, [completeProfileSetup]);
  
  const completeOnboarding = () => {
    // Mark onboarding as completed
    localStorage.setItem('onboardingCompleted', 'true');
    completeProfileSetup();
    setCompleted(true);
    
    toast({
      title: "Profile Setup Complete",
      description: "Your profile has been successfully set up!"
    });
    
    // Slight delay before navigation for animation to complete
    setTimeout(() => {
      navigate('/profile-setup');
    }, 1500);
  };
  
  const steps = [
    {
      title: "Welcome to YO BRO",
      description: "Your complete social connection platform",
      content: <WelcomeStep onNext={() => setCurrentStep(2)} />
    },
    {
      title: "App Features",
      description: "Discover all YO BRO has to offer",
      content: <FeaturesStep onNext={() => setCurrentStep(3)} />
    },
    {
      title: "Get Started",
      description: "Begin your connection journey",
      content: <GetStartedStep onComplete={completeOnboarding} />
    }
  ];
  
  return (
    <div className="min-h-screen bg-black text-cyberpunk-textGlow flex flex-col">
      <AnimatePresence mode="wait">
        {/* Intro Animation */}
        {showIntro && (
          <motion.div
            key="intro-animation"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            transition={{ duration: 0.3 }}
            className="absolute inset-0 z-50"
          >
            <IntroAnimation
              showIntro={showIntro}
              showYo={showYo}
              showBro={showBro}
              showIcon={showIcon}
              showFinal={showFinal}
              iconScale={iconScale}
              onAnimationComplete={() => setShowIntro(false)}
            />
          </motion.div>
        )}
      
        {/* Header */}
        {!showIntro && !completed && (
          <motion.div
            key="header"
            initial={{ opacity: 0, y: -20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.4 }}
          >
            <OnboardingHeader
              currentStep={currentStep}
              title={steps[currentStep - 1].title}
              onBack={() => setCurrentStep(prev => Math.max(1, prev - 1))}
              onSkip={completeOnboarding}
            />
          </motion.div>
        )}
      
        <div className="flex-1 pt-16 pb-20 px-4 flex flex-col items-center justify-center">
          {!completed && !showIntro && (
            <AnimatePresence mode="wait">
              <motion.div 
                key={`step-${currentStep}`}
                initial={{ opacity: 0, x: 20 }}
                animate={{ opacity: 1, x: 0 }}
                exit={{ opacity: 0, x: -20 }}
                transition={{ duration: 0.3 }}
                className="w-full"
              >
                {steps[currentStep - 1].content}
              </motion.div>
            </AnimatePresence>
          )}
            
          {completed && (
            <motion.div
              key="completion"
              initial={{ opacity: 0, scale: 0.9 }}
              animate={{ opacity: 1, scale: 1 }}
              transition={{ duration: 0.4 }}
            >
              <CompletionView />
            </motion.div>
          )}
        </div>
        
        {/* Progress indicator */}
        {!completed && !showIntro && (
          <motion.div
            key="progress"
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.4, delay: 0.2 }}
          >
            <ProgressIndicator 
              currentStep={currentStep} 
              totalSteps={steps.length}
            />
          </motion.div>
        )}
        
        {/* Debug button for development purposes */}
        {showIntro && (
          <motion.button 
            onClick={skipAnimation}
            className="absolute bottom-4 right-4 bg-[#222] text-[#C2FFE6]/80 px-3 py-1 rounded-full text-xs z-50"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 1 }}
            whileHover={{ backgroundColor: '#333' }}
            whileTap={{ scale: 0.95 }}
          >
            Skip Animation
          </motion.button>
        )}
      </AnimatePresence>
    </div>
  );
};

export default OnboardingView;
