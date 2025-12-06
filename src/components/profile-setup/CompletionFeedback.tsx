
import React, { useEffect } from 'react';
import { Check, Loader2 } from 'lucide-react';
import { motion } from 'framer-motion';
import { useUserSession } from '@/hooks/useUserSession';

interface CompletionFeedbackProps {
  isProcessing: boolean;
  isComplete: boolean;
}

const CompletionFeedback: React.FC<CompletionFeedbackProps> = ({ isProcessing, isComplete }) => {
  const { completeProfileSetup } = useUserSession();
  
  useEffect(() => {
    // When the profile setup is complete, update the user session
    if (isComplete) {
      completeProfileSetup();
      localStorage.setItem('onboardingCompleted', 'true');
    }
  }, [isComplete, completeProfileSetup]);
  
  if (!isProcessing && !isComplete) {
    return null;
  }
  
  return (
    <motion.div 
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
      className="fixed inset-0 flex items-center justify-center bg-black/80 z-50 backdrop-blur-sm"
    >
      <motion.div 
        className="bg-[#1A1A1A] border border-[#E6FFF4]/30 rounded-lg p-8 flex flex-col items-center max-w-md"
        initial={{ scale: 0.8, y: 20 }}
        animate={{ scale: 1, y: 0 }}
        transition={{ type: "spring", damping: 20, stiffness: 100 }}
      >
        {isProcessing && (
          <>
            <motion.div
              initial={{ rotate: 0 }}
              animate={{ rotate: 360 }}
              transition={{ duration: 2, repeat: Infinity, ease: "linear" }}
            >
              <Loader2 className="h-16 w-16 text-[#E6FFF4] mb-4" />
            </motion.div>
            <h3 className="text-2xl font-semibold text-[#E6FFF4] mb-2">Creating Your Profile</h3>
            <p className="text-[#E6FFF4]/80 text-center">
              We're setting up your profile and optimizing your connection preferences.
            </p>
          </>
        )}
        
        {isComplete && (
          <>
            <motion.div 
              initial={{ scale: 0 }}
              animate={{ scale: 1 }}
              transition={{ type: "spring", stiffness: 200, damping: 10, delay: 0.2 }}
              className="w-20 h-20 bg-[#00E676] rounded-full flex items-center justify-center mb-4"
            >
              <Check className="h-10 w-10 text-black" />
            </motion.div>
            <h3 className="text-2xl font-semibold text-[#E6FFF4] mb-2">Profile Complete!</h3>
            <p className="text-[#E6FFF4]/80 text-center mb-4">
              Your profile has been created successfully. Redirecting you to discover new connections...
            </p>
            <motion.div 
              className="w-full bg-[#2A2A2A] h-2 rounded-full overflow-hidden"
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ delay: 0.4 }}
            >
              <motion.div 
                className="h-full bg-[#E6FFF4]"
                initial={{ width: "0%" }}
                animate={{ width: "100%" }}
                transition={{ duration: 2, ease: "easeInOut" }}
              />
            </motion.div>
          </>
        )}
      </motion.div>
    </motion.div>
  );
};

export default CompletionFeedback;
