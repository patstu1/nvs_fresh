
import React from 'react';
import BackButton from './header/BackButton';
import SkipButton from './header/SkipButton';

interface OnboardingHeaderProps {
  currentStep: number;
  title: string;
  onBack?: () => void;
  onSkip: () => void;
}

const OnboardingHeader: React.FC<OnboardingHeaderProps> = ({ 
  currentStep, 
  title, 
  onBack, 
  onSkip 
}) => {
  return (
    <div className="fixed top-0 left-0 right-0 bg-black/90 backdrop-blur-lg z-40">
      <div className="flex items-center px-4 py-3 border-b border-yobro-cream">
        {currentStep > 1 && onBack && (
          <BackButton onClick={onBack} />
        )}
        <h2 className="text-xl font-medium text-cyberpunk-textGlow ultra-neon-text-teal">{title}</h2>
        
        {/* Skip button */}
        <SkipButton onClick={onSkip} />
      </div>
    </div>
  );
};

export default OnboardingHeader;
