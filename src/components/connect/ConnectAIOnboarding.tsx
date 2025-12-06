
import React from 'react';
import { motion } from 'framer-motion';
import { useNavigate } from 'react-router-dom';
import { BookOpen, ArrowRight, Instagram, Twitter, Facebook } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Progress } from '@/components/ui/progress';
import { toast } from '@/hooks/use-toast';

const ConnectAIOnboarding: React.FC = () => {
  const navigate = useNavigate();
  const [step, setStep] = React.useState(1);
  const totalSteps = 4;

  const handleComplete = () => {
    localStorage.setItem('connect-onboarding-completed', 'true');
    toast({
      title: "Onboarding Complete!",
      description: "Your AI CONNECT profile has been initialized.",
    });
    navigate('/connect-dashboard');
  };

  return (
    <div className="min-h-screen bg-black p-6">
      <div className="max-w-md mx-auto">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="text-center mb-8"
        >
          <div className="inline-block p-3 bg-[#1A1A1A] rounded-full mb-4">
            <BookOpen className="w-8 h-8 text-[#AAFF50]" />
          </div>
          <h1 className="text-2xl font-bold text-[#E6FFF4] mb-2">Welcome to AI CONNECT</h1>
          <p className="text-[#E6FFF4]/80">Let's set up your intelligent matching profile</p>
        </motion.div>

        <div className="mb-8">
          <div className="flex justify-between text-xs text-[#E6FFF4]/60 mb-2">
            <span>Progress</span>
            <span>{Math.round((step / totalSteps) * 100)}%</span>
          </div>
          <Progress value={(step / totalSteps) * 100} className="h-1" />
        </div>

        {step === 1 && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            className="space-y-6"
          >
            <div className="bg-[#1A1A1A] rounded-lg p-6">
              <h2 className="text-lg font-semibold text-[#E6FFF4] mb-4">AI-Powered Matching</h2>
              <p className="text-[#E6FFF4]/80 text-sm mb-4">
                Our advanced AI system learns from your preferences, interactions, and behavior to find your most compatible matches.
              </p>
              <ul className="space-y-3">
                <li className="flex items-center text-[#E6FFF4]/70 text-sm">
                  <div className="w-2 h-2 bg-[#AAFF50] rounded-full mr-3" />
                  Personality-based matching
                </li>
                <li className="flex items-center text-[#E6FFF4]/70 text-sm">
                  <div className="w-2 h-2 bg-[#AAFF50] rounded-full mr-3" />
                  Interest alignment scoring
                </li>
                <li className="flex items-center text-[#E6FFF4]/70 text-sm">
                  <div className="w-2 h-2 bg-[#AAFF50] rounded-full mr-3" />
                  Smart conversation suggestions
                </li>
              </ul>
            </div>
            <Button 
              onClick={() => setStep(2)} 
              className="w-full bg-[#AAFF50] text-black hover:bg-[#AAFF50]/90"
            >
              Start Profile Setup
              <ArrowRight className="w-4 h-4 ml-2" />
            </Button>
          </motion.div>
        )}

        {step === 2 && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            className="space-y-6"
          >
            <div className="bg-[#1A1A1A] rounded-lg p-6">
              <h2 className="text-lg font-semibold text-[#E6FFF4] mb-4">Personality Profile</h2>
              <p className="text-[#E6FFF4]/80 text-sm mb-6">
                Help our AI understand your personality better by selecting traits that resonate with you.
              </p>
              <div className="grid grid-cols-2 gap-3">
                {[
                  "Adventurous", "Creative", "Intellectual", "Empathetic",
                  "Ambitious", "Spiritual", "Playful", "Analytical"
                ].map((trait) => (
                  <Button
                    key={trait}
                    variant="outline"
                    className="border-[#E6FFF4]/20 text-[#E6FFF4] hover:bg-[#E6FFF4]/10"
                  >
                    {trait}
                  </Button>
                ))}
              </div>
            </div>
            <Button 
              onClick={() => setStep(3)}
              className="w-full bg-[#AAFF50] text-black hover:bg-[#AAFF50]/90"
            >
              Continue
              <ArrowRight className="w-4 h-4 ml-2" />
            </Button>
          </motion.div>
        )}

        {step === 3 && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            className="space-y-6"
          >
            <div className="bg-[#1A1A1A] rounded-lg p-6">
              <h2 className="text-lg font-semibold text-[#E6FFF4] mb-4">Social Integration</h2>
              <p className="text-[#E6FFF4]/80 text-sm mb-6">
                Connect your social media to enhance your matching accuracy.
              </p>
              <div className="space-y-4">
                <Button
                  variant="outline"
                  className="w-full border-[#E6FFF4]/20 text-[#E6FFF4] hover:bg-[#E6FFF4]/10"
                >
                  <Instagram className="w-5 h-5 mr-2" />
                  Connect Instagram
                </Button>
                <Button
                  variant="outline"
                  className="w-full border-[#E6FFF4]/20 text-[#E6FFF4] hover:bg-[#E6FFF4]/10"
                >
                  <Twitter className="w-5 h-5 mr-2" />
                  Connect Twitter
                </Button>
                <Button
                  variant="outline"
                  className="w-full border-[#E6FFF4]/20 text-[#E6FFF4] hover:bg-[#E6FFF4]/10"
                >
                  <Facebook className="w-5 h-5 mr-2" />
                  Connect Facebook
                </Button>
              </div>
            </div>
            <Button 
              onClick={() => setStep(4)}
              className="w-full bg-[#AAFF50] text-black hover:bg-[#AAFF50]/90"
            >
              Continue
              <ArrowRight className="w-4 h-4 ml-2" />
            </Button>
          </motion.div>
        )}

        {step === 4 && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            className="space-y-6"
          >
            <div className="bg-[#1A1A1A] rounded-lg p-6">
              <h2 className="text-lg font-semibold text-[#E6FFF4] mb-4">AI Learning Preferences</h2>
              <p className="text-[#E6FFF4]/80 text-sm mb-6">
                Choose how you'd like our AI to learn and adapt to your preferences.
              </p>
              <div className="space-y-4">
                <div className="flex items-center justify-between p-3 bg-[#2A2A2A] rounded-lg">
                  <span className="text-[#E6FFF4] text-sm">Learn from interactions</span>
                  <div className="w-12 h-6 bg-[#AAFF50] rounded-full" />
                </div>
                <div className="flex items-center justify-between p-3 bg-[#2A2A2A] rounded-lg">
                  <span className="text-[#E6FFF4] text-sm">Smart suggestions</span>
                  <div className="w-12 h-6 bg-[#AAFF50] rounded-full" />
                </div>
                <div className="flex items-center justify-between p-3 bg-[#2A2A2A] rounded-lg">
                  <span className="text-[#E6FFF4] text-sm">Profile optimization</span>
                  <div className="w-12 h-6 bg-[#AAFF50] rounded-full" />
                </div>
              </div>
            </div>
            <Button 
              onClick={handleComplete}
              className="w-full bg-[#AAFF50] text-black hover:bg-[#AAFF50]/90"
            >
              Complete Setup
              <ArrowRight className="w-4 h-4 ml-2" />
            </Button>
          </motion.div>
        )}
      </div>
    </div>
  );
};

export default ConnectAIOnboarding;
