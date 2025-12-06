
import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { Button } from '@/components/ui/button';
import { Shield, Lock, Check, ArrowRight } from 'lucide-react';
import { toast } from '@/hooks/use-toast';

interface ConnectAIResearchExplanationProps {
  onComplete: () => void;
}

const ConnectAIResearchExplanation: React.FC<ConnectAIResearchExplanationProps> = ({ onComplete }) => {
  const [hasAcknowledged, setHasAcknowledged] = useState(false);
  
  const handleAcknowledge = () => {
    setHasAcknowledged(true);
    toast({
      title: "Privacy Settings Updated",
      description: "Your AI matching privacy preferences have been saved.",
    });
  };
  
  return (
    <div className="min-h-[80vh] flex flex-col items-center justify-center p-4 bg-black text-white">
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5 }}
        className="max-w-md w-full mx-auto bg-[#121212] p-6 rounded-xl border border-[#333]"
      >
        {!hasAcknowledged ? (
          <>
            <div className="flex justify-center mb-6">
              <div className="p-3 bg-[#293241] rounded-full">
                <Shield className="w-8 h-8 text-[#E6FFF4]" />
              </div>
            </div>
            
            <h2 className="text-2xl font-bold text-center mb-6 text-[#E6FFF4]">
              AI-Powered Match Research
            </h2>
            
            <p className="text-[#E6FFF4]/80 mb-6">
              YoBro Connect uses advanced AI to analyze profiles and create better matches. 
              This helps us understand your preferences and connect you with compatible people.
            </p>
            
            <div className="space-y-4 mb-6">
              <div className="flex items-start">
                <div className="p-1 bg-[#293241] rounded-full mr-3 mt-1">
                  <Check className="w-4 h-4 text-[#AAFF50]" />
                </div>
                <p className="text-sm text-[#E6FFF4]/70">
                  Your data is analyzed privately and securely to improve your matches
                </p>
              </div>
              
              <div className="flex items-start">
                <div className="p-1 bg-[#293241] rounded-full mr-3 mt-1">
                  <Check className="w-4 h-4 text-[#AAFF50]" />
                </div>
                <p className="text-sm text-[#E6FFF4]/70">
                  You control what information is used for matching
                </p>
              </div>
              
              <div className="flex items-start">
                <div className="p-1 bg-[#293241] rounded-full mr-3 mt-1">
                  <Check className="w-4 h-4 text-[#AAFF50]" />
                </div>
                <p className="text-sm text-[#E6FFF4]/70">
                  You can opt out or update your preferences anytime
                </p>
              </div>
            </div>
            
            <div className="flex justify-center">
              <Button 
                onClick={handleAcknowledge}
                className="bg-[#E6FFF4] hover:bg-[#E6FFF4]/90 text-black font-medium px-8"
              >
                I Understand
              </Button>
            </div>
            
            <p className="text-xs text-center mt-4 text-[#E6FFF4]/50">
              By continuing, you agree to our AI matching technology terms
            </p>
          </>
        ) : (
          <>
            <div className="flex justify-center mb-6">
              <div className="p-3 bg-[#293241] rounded-full">
                <Lock className="w-8 h-8 text-[#AAFF50]" />
              </div>
            </div>
            
            <h2 className="text-2xl font-bold text-center mb-6 text-[#E6FFF4]">
              Privacy Settings
            </h2>
            
            <p className="text-[#E6FFF4]/80 mb-6">
              Choose what data you'd like to share with our AI matching system to enhance your connections.
            </p>
            
            <div className="space-y-4 mb-8">
              <div className="p-3 bg-[#1A1A1A] rounded-lg border border-[#333]">
                <label className="flex items-center justify-between">
                  <span className="text-[#E6FFF4]">Profile Information</span>
                  <input type="checkbox" checked={true} readOnly className="accent-[#AAFF50]" />
                </label>
                <p className="text-xs text-[#E6FFF4]/50 mt-1">Basic profile data (required for matching)</p>
              </div>
              
              <div className="p-3 bg-[#1A1A1A] rounded-lg border border-[#333]">
                <label className="flex items-center justify-between">
                  <span className="text-[#E6FFF4]">Preference History</span>
                  <input type="checkbox" defaultChecked={true} className="accent-[#AAFF50]" />
                </label>
                <p className="text-xs text-[#E6FFF4]/50 mt-1">Who you've liked and passed on</p>
              </div>
              
              <div className="p-3 bg-[#1A1A1A] rounded-lg border border-[#333]">
                <label className="flex items-center justify-between">
                  <span className="text-[#E6FFF4]">Conversation Analysis</span>
                  <input type="checkbox" defaultChecked={false} className="accent-[#AAFF50]" />
                </label>
                <p className="text-xs text-[#E6FFF4]/50 mt-1">Improve matches based on conversation compatibility</p>
              </div>
            </div>
            
            <div className="flex justify-center">
              <Button 
                onClick={onComplete}
                className="bg-[#AAFF50] hover:bg-[#AAFF50]/90 text-black font-medium px-8 flex items-center"
              >
                Continue <ArrowRight className="ml-2 w-4 h-4" />
              </Button>
            </div>
          </>
        )}
      </motion.div>
    </div>
  );
};

export default ConnectAIResearchExplanation;
