
import React from 'react';
import { motion, AnimatePresence } from 'framer-motion';

interface ConnectFlashIntroProps {
  onComplete: () => void;
}

const ConnectFlashIntro: React.FC<ConnectFlashIntroProps> = ({ onComplete }) => {
  return (
    <AnimatePresence>
      <motion.div 
        className="fixed inset-0 z-50 bg-black flex items-center justify-center"
        initial={{ opacity: 1 }}
        animate={{ opacity: 1 }}
        exit={{ opacity: 0 }}
        onAnimationComplete={onComplete}
      >
        <motion.h1
          className="text-6xl font-bold text-[#AAFF50]"
          initial={{ opacity: 0, scale: 0.8 }}
          animate={{ 
            opacity: [0, 1, 1, 0],
            scale: [0.8, 1, 1, 0.9],
            filter: [
              'brightness(1) blur(0px)',
              'brightness(1.2) blur(2px)',
              'brightness(1.2) blur(2px)',
              'brightness(1) blur(4px)'
            ]
          }}
          transition={{ 
            duration: 2,
            times: [0, 0.3, 0.7, 1],
          }}
        >
          CONNECT
        </motion.h1>
      </motion.div>
    </AnimatePresence>
  );
};

export default ConnectFlashIntro;
