
import React from 'react';
import { motion } from 'framer-motion';
import WelcomeBadge from './completion/WelcomeBadge';
import WelcomeMessage from './completion/WelcomeMessage';

const CompletionView: React.FC = () => {
  return (
    <motion.div 
      className="flex-1 pt-16 pb-20 px-4 flex flex-col items-center justify-center"
      initial={{ opacity: 0, scale: 0.9 }}
      animate={{ opacity: 1, scale: 1 }}
      exit={{ opacity: 0 }}
      transition={{ duration: 0.5 }}
    >
      <div className="text-center">
        <WelcomeBadge />
        <WelcomeMessage />
      </div>
    </motion.div>
  );
};

export default CompletionView;
