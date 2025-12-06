
import React from 'react';
import ConnectIntroduction from '../ConnectIntroduction';
import { motion, AnimatePresence } from 'framer-motion';

interface IntroductionHandlerProps {
  onComplete: () => void;
}

const IntroductionHandler: React.FC<IntroductionHandlerProps> = ({ onComplete }) => {
  const handleIntroComplete = () => {
    localStorage.setItem('connect-intro-seen', 'true');
    onComplete();
  };

  return (
    <AnimatePresence mode="wait">
      <motion.div
        key="introduction"
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        exit={{ opacity: 0 }}
        transition={{ duration: 0.3 }}
      >
        <ConnectIntroduction onComplete={handleIntroComplete} />
      </motion.div>
    </AnimatePresence>
  );
};

export default IntroductionHandler;
