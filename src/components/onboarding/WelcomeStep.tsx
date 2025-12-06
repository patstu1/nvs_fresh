
import React, { useEffect } from 'react';
import { Users, Zap } from 'lucide-react';
import { Button } from '@/components/ui/button';

interface WelcomeStepProps {
  onNext: () => void;
}

const WelcomeStep: React.FC<WelcomeStepProps> = ({ onNext }) => {
  useEffect(() => {
    console.log('WelcomeStep rendered');
  }, []);

  return (
    <div className="flex flex-col items-center text-center">
      <div className="text-5xl font-bold text-cyberpunk-textGlow ultra-neon-text-teal mb-6 border-b-2 border-yobro-cream pb-2">
        YO BRO
      </div>
      
      <div className="mb-10 text-lg text-cyberpunk-textGlow">
        <p>Welcome to YO BRO, your complete social connection platform.</p>
      </div>
      
      <div className="grid grid-cols-1 gap-6 w-full max-w-sm mb-8">
        <div className="bg-black border-2 border-yobro-cream p-4 rounded-lg neon-glow-teal">
          <div className="flex items-center mb-2">
            <div className="w-8 h-8 rounded-full border-2 border-yobro-cream flex items-center justify-center mr-3">
              <Users className="w-5 h-5 text-cyberpunk-textGlow" />
            </div>
            <h3 className="text-lg font-medium text-cyberpunk-textGlow ultra-neon-text-teal">Connect Your Way</h3>
          </div>
          <p className="text-sm text-cyberpunk-textGlow/80">Explore multiple ways to connect with others through our comprehensive platform.</p>
        </div>
        
        <div className="bg-black border-2 border-yobro-cream p-4 rounded-lg neon-glow-teal">
          <div className="flex items-center mb-2">
            <div className="w-8 h-8 rounded-full border-2 border-yobro-cream flex items-center justify-center mr-3">
              <Zap className="w-5 h-5 text-cyberpunk-textGlow" />
            </div>
            <h3 className="text-lg font-medium text-cyberpunk-textGlow ultra-neon-text-teal">Personalized Experience</h3>
          </div>
          <p className="text-sm text-cyberpunk-textGlow/80">Customize your profile and interactions for a truly unique experience.</p>
        </div>
      </div>
      
      <Button 
        onClick={onNext}
        variant="ring"
        className="w-full max-w-sm border-2 border-yobro-cream bg-black text-cyberpunk-textGlow font-medium py-3 rounded-lg hover:border-yobro-teal/80 transition-all"
      >
        Continue
      </Button>
    </div>
  );
};

export default WelcomeStep;
