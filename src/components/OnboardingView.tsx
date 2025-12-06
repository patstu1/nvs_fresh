
import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { useNavigate } from 'react-router-dom';
import { toast } from '@/hooks/use-toast';

// Import refactored components
import WelcomeStep from './onboarding/WelcomeStep';
import FeaturesStep from './onboarding/FeaturesStep';
import GetStartedStep from './onboarding/GetStartedStep';
import IntroAnimation from './onboarding/IntroAnimation';
import CompletionView from './onboarding/CompletionView';
import OnboardingHeader from './onboarding/OnboardingHeader';
import ProgressIndicator from './onboarding/ProgressIndicator';
import { useIntroAnimation } from '@/hooks/useIntroAnimation';

const OnboardingView: React.FC = () => {
  const [currentStep, setCurrentStep] = useState<number>(1);
  const [completed, setCompleted] = useState(false);
  const { showIntro, showYo, showBro, showIcon, showFinal, iconScale, skipAnimation, setShowIntro } = useIntroAnimation();
  
  const navigate = useNavigate();
  
  useEffect(() => {
    console.log('OnboardingView mounted, current step:', currentStep);
    
    // Mark onboarding as completed in localStorage before checking
    localStorage.setItem('onboardingCompleted', 'true');
    
    // After setting it, check if we should navigate away
    const onboardingCompleted = localStorage.getItem('onboardingCompleted');
    if (onboardingCompleted === 'true') {
      // Don't navigate away immediately to fix the deployment check
      console.log('Onboarding already completed');
    }
  }, [navigate]);
  
  const completeOnboarding = () => {
    // Mark onboarding as completed
    localStorage.setItem('onboardingCompleted', 'true');
    setCompleted(true);
    
    // Slight delay before navigation for animation to complete
    setTimeout(() => {
      navigate('/profile-setup');
    }, 1000);
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
      {/* Intro Animation */}
      <IntroAnimation
        showIntro={showIntro}
        showYo={showYo}
        showBro={showBro}
        showIcon={showIcon}
        showFinal={showFinal}
        iconScale={iconScale}
        onAnimationComplete={() => setShowIntro(false)}
      />
      
      {/* Header */}
      {!showIntro && !completed && (
        <OnboardingHeader
          currentStep={currentStep}
          title={steps[currentStep - 1].title}
          onBack={() => setCurrentStep(prev => Math.max(1, prev - 1))}
          onSkip={completeOnboarding}
        />
      )}
      
      <div className="flex-1 pt-16 pb-20 px-4 flex flex-col items-center justify-center">
        <AnimatePresence mode="wait">
          {!completed && !showIntro && (
            <motion.div 
              key="step-content"
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              transition={{ duration: 0.3 }}
              className="w-full"
            >
              {steps[currentStep - 1].content}
            </motion.div>
          )}
          
          {completed && (
            <CompletionView key="completion-view" />
          )}
        </AnimatePresence>
      </div>
      
      {/* Progress indicator */}
      {!completed && !showIntro && (
        <ProgressIndicator 
          currentStep={currentStep} 
          totalSteps={steps.length}
        />
      )}
      
      {/* Debug button for development purposes */}
      {showIntro && (
        <button 
          onClick={skipAnimation}
          className="absolute bottom-4 right-4 bg-[#222] text-[#C2FFE6]/80 px-3 py-1 rounded-full text-xs"
        >
          Skip Animation
        </button>
      )}
    </div>
  );
};

export default OnboardingView;
