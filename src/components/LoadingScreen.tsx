
import React, { useEffect, useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { Spinner } from '@/components/ui/spinner';
import ConnectLoadingState from './connect/components/ConnectLoadingState';

interface LoadingScreenProps {
  isLoading: boolean;
  onLoadingComplete?: () => void;
  connectMode?: boolean;
}

const LoadingScreen: React.FC<LoadingScreenProps> = ({ 
  isLoading, 
  onLoadingComplete,
  connectMode = false
}) => {
  const [fadeOut, setFadeOut] = useState(false);
  
  useEffect(() => {
    if (!isLoading && onLoadingComplete) {
      // Start fade out animation
      setFadeOut(true);
      
      // After animation completes, call the completion handler
      const timer = setTimeout(() => {
        onLoadingComplete();
      }, 800); // Match this to the exit animation duration
      
      return () => clearTimeout(timer);
    }
  }, [isLoading, onLoadingComplete]);

  // If connect mode is active, show the special connect loading screen
  if (connectMode) {
    return <ConnectLoadingState message="Finding your perfect matches..." />;
  }

  return (
    <AnimatePresence mode="wait">
      {isLoading && (
        <motion.div
          className="fixed inset-0 z-50 flex items-center justify-center bg-black"
          initial={{ opacity: 1 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          transition={{ duration: 0.8, ease: "easeInOut" }}
        >
          <motion.div 
            className="flex flex-col items-center space-y-6"
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.3, duration: 0.5 }}
          >
            <motion.div
              initial={{ opacity: 0, scale: 0.8 }}
              animate={{ opacity: 1, scale: 1 }}
              transition={{ delay: 0.4, duration: 0.7 }}
              className="w-24 h-24 mb-4"
            >
              <div className="relative">
                <div className="absolute inset-0 rounded-full bg-gradient-to-r from-[#AAFF50] to-[#E6FFF4] opacity-20 animate-pulse"></div>
                <div className="flex items-center justify-center w-24 h-24 text-3xl font-bold text-[#E6FFF4] bg-black rounded-full border-2 border-[#AAFF50]">
                  YO
                </div>
              </div>
            </motion.div>
            
            <Spinner size="lg" className="text-[#AAFF50]" />
            
            <motion.p 
              className="text-[#E6FFF4] text-lg font-medium"
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ delay: 0.8 }}
            >
              Loading YO BRO...
            </motion.p>
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  );
};

export default LoadingScreen;
