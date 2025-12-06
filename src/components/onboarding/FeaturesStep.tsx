
import React, { useEffect } from 'react';
import { Map, MessageSquare, Video, Heart } from 'lucide-react';
import { Button } from '@/components/ui/button';

interface FeaturesStepProps {
  onNext: () => void;
}

const FeaturesStep: React.FC<FeaturesStepProps> = ({ onNext }) => {
  useEffect(() => {
    console.log('FeaturesStep rendered');
  }, []);

  return (
    <div className="flex flex-col items-center w-full max-w-sm">
      <h3 className="text-xl mb-6 text-center text-cyberpunk-textGlow ultra-neon-text-teal">YO BRO Features:</h3>
      
      <div className="grid grid-cols-1 gap-5 w-full mb-8">
        {[
          { icon: Map, title: "Location Map", description: "Explore connections in your area with optional anonymity" },
          { icon: MessageSquare, title: "Chat & Connect", description: "Message and connect with your matches" },
          { icon: Video, title: "Video & Zoom Rooms", description: "Connect face-to-face with video calls and join group sessions" },
          { icon: Heart, title: "AI-Powered Matching", description: "Find compatible connections through our intelligent system" }
        ].map(({ icon: Icon, title, description }, index) => (
          <div key={index} className="bg-black border-2 border-yobro-cream p-4 rounded-lg neon-glow-teal flex items-center">
            <div className="w-12 h-12 rounded-full border-2 border-yobro-cream flex items-center justify-center mr-4">
              <Icon className="w-6 h-6 text-cyberpunk-textGlow" />
            </div>
            <div>
              <h4 className="font-medium text-cyberpunk-textGlow ultra-neon-text-teal">{title}</h4>
              <p className="text-sm text-cyberpunk-textGlow/80">{description}</p>
            </div>
          </div>
        ))}
      </div>
      
      <Button 
        onClick={onNext}
        variant="ring"
        className="w-full border-2 border-yobro-cream bg-black text-cyberpunk-textGlow font-medium py-3 rounded-lg hover:border-yobro-teal/80 transition-all"
      >
        Continue
      </Button>
    </div>
  );
};

export default FeaturesStep;
