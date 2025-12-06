
import React, { useEffect } from 'react';
import { Zap } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { toast } from '@/hooks/use-toast';

interface GetStartedStepProps {
  onComplete: () => void;
}

const GetStartedStep: React.FC<GetStartedStepProps> = ({ onComplete }) => {
  useEffect(() => {
    console.log('GetStartedStep rendered');
  }, []);

  const handleGetStarted = () => {
    toast({
      title: "Set up your profile",
      description: "Let's create your profile for the complete YO BRO experience!",
    });
    
    onComplete();
  };

  return (
    <div className="flex flex-col items-center text-center">
      <div className="relative w-48 h-48 mb-8">
        <div className="absolute inset-0 rounded-full border-4 border-yobro-cream animate-pulse-neon"></div>
        <div className="absolute inset-4 rounded-full border-2 border-yobro-cream flex items-center justify-center">
          <Zap className="w-24 h-24 text-cyberpunk-textGlow" />
        </div>
      </div>
      
      <h3 className="text-2xl font-bold mb-4 text-cyberpunk-textGlow ultra-neon-text-teal">Ready to Join?</h3>
      <p className="text-cyberpunk-textGlow mb-8">Experience the full spectrum of YO BRO's social connections!</p>
      
      <Button 
        onClick={handleGetStarted}
        variant="ring"
        className="w-full max-w-sm border-2 border-yobro-cream bg-black text-cyberpunk-textGlow font-medium py-6 text-xl rounded-lg hover:border-yobro-teal/80 transition-all"
      >
        SET UP YOUR PROFILE
      </Button>
    </div>
  );
};

export default GetStartedStep;
