
import React from 'react';
import ProgressDot from './progress/ProgressDot';

interface ProgressIndicatorProps {
  currentStep: number;
  totalSteps: number;
}

const ProgressIndicator: React.FC<ProgressIndicatorProps> = ({ 
  currentStep, 
  totalSteps 
}) => {
  return (
    <div className="fixed bottom-8 left-0 right-0 flex justify-center gap-2">
      {Array.from({ length: totalSteps }).map((_, index) => (
        <ProgressDot 
          key={index}
          isActive={currentStep === index + 1} 
        />
      ))}
    </div>
  );
};

export default ProgressIndicator;
