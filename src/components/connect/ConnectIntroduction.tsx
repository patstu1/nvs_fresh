
import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { ArrowRight, Heart, User, Sigma, Users } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { toast } from '@/hooks/use-toast';
import { useUserSession } from '@/hooks/useUserSession';

interface ConnectIntroductionProps {
  onComplete: () => void;
}

const ConnectIntroduction: React.FC<ConnectIntroductionProps> = ({ onComplete }) => {
  const [currentStep, setCurrentStep] = useState(1);
  const totalSteps = 3;
  
  const nextStep = () => {
    if (currentStep < totalSteps) {
      setCurrentStep(currentStep + 1);
    } else {
      completeIntroduction();
    }
  };
  
  const completeIntroduction = () => {
    toast({
      title: "Connect Setup Complete",
      description: "You're all set to explore AI-powered connections!",
    });
    onComplete();
  };
  
  return (
    <div className="min-h-[70vh] flex flex-col items-center justify-center p-4">
      <motion.div
        key={`step-${currentStep}`}
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        exit={{ opacity: 0, y: -20 }}
        transition={{ duration: 0.3 }}
        className="max-w-md w-full mx-auto"
      >
        {currentStep === 1 && (
          <div className="text-center">
            <div className="inline-flex p-3 rounded-full bg-[#2A2A2A] mb-6">
              <Users className="w-8 h-8 text-[#E6FFF4]" />
            </div>
            <h2 className="text-2xl font-bold text-[#E6FFF4] mb-4">Welcome to YO BRO Connect</h2>
            <p className="text-[#E6FFF4]/80 mb-6">
              Our innovative AI-powered matching system helps you find meaningful connections based on compatibility, shared interests, and values.
            </p>
            <div className="flex justify-center gap-4 mb-8">
              <div className="flex items-center justify-center w-12 h-12 rounded-full bg-[#2A2A2A] text-[#E6FFF4]">
                <Heart className="w-6 h-6" />
              </div>
              <div className="flex items-center justify-center w-12 h-12 rounded-full bg-[#2A2A2A] text-[#E6FFF4]">
                <Sigma className="w-6 h-6" />
              </div>
              <div className="flex items-center justify-center w-12 h-12 rounded-full bg-[#2A2A2A] text-[#E6FFF4]">
                <User className="w-6 h-6" />
              </div>
            </div>
          </div>
        )}
        
        {currentStep === 2 && (
          <div className="text-center">
            <div className="inline-flex p-3 rounded-full bg-[#2A2A2A] mb-6">
              <Sigma className="w-8 h-8 text-[#E6FFF4]" />
            </div>
            <h2 className="text-2xl font-bold text-[#E6FFF4] mb-4">AI-Powered Matching</h2>
            <p className="text-[#E6FFF4]/80 mb-6">
              Our algorithm analyzes your profile, preferences, and behavior to suggest compatible connections. The more information you provide, the better your matches will be.
            </p>
            <div className="bg-[#2A2A2A] p-4 rounded-lg mb-6">
              <ul className="text-left text-[#E6FFF4]/80 space-y-2">
                <li className="flex items-center gap-2">
                  <div className="w-2 h-2 rounded-full bg-[#E6FFF4]"></div>
                  <span>Smarter suggestions based on your preferences</span>
                </li>
                <li className="flex items-center gap-2">
                  <div className="w-2 h-2 rounded-full bg-[#E6FFF4]"></div>
                  <span>Higher quality connections with compatibility scores</span>
                </li>
                <li className="flex items-center gap-2">
                  <div className="w-2 h-2 rounded-full bg-[#E6FFF4]"></div>
                  <span>Personalized conversation starters</span>
                </li>
              </ul>
            </div>
          </div>
        )}
        
        {currentStep === 3 && (
          <div className="text-center">
            <div className="inline-flex p-3 rounded-full bg-[#2A2A2A] mb-6">
              <User className="w-8 h-8 text-[#E6FFF4]" />
            </div>
            <h2 className="text-2xl font-bold text-[#E6FFF4] mb-4">Complete Your Profile</h2>
            <p className="text-[#E6FFF4]/80 mb-6">
              To get started with Connect, we need to gather some additional information about your preferences and interests.
            </p>
            <div className="bg-[#2A2A2A] p-4 rounded-lg mb-6">
              <p className="text-[#E6FFF4]/80 text-center">
                Answer a few questions about yourself to help our AI understand your preferences better.
              </p>
            </div>
          </div>
        )}
        
        <div className="flex justify-between items-center mt-8">
          <div className="flex gap-1">
            {Array.from({ length: totalSteps }).map((_, index) => (
              <div 
                key={index} 
                className={`w-2 h-2 rounded-full ${currentStep === index + 1 ? 'bg-[#E6FFF4]' : 'bg-[#E6FFF4]/30'}`}
              ></div>
            ))}
          </div>
          
          <Button
            onClick={nextStep}
            className="bg-[#E6FFF4] text-black hover:bg-[#E6FFF4]/90"
          >
            {currentStep < totalSteps ? (
              <>
                Next <ArrowRight className="w-4 h-4 ml-2" />
              </>
            ) : (
              'Get Started'
            )}
          </Button>
        </div>
      </motion.div>
    </div>
  );
};

export default ConnectIntroduction;
