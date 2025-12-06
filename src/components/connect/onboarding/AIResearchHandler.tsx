
import React from 'react';
import ConnectAIResearchExplanation from '../ConnectAIResearchExplanation';
import { motion, AnimatePresence } from 'framer-motion';

interface AIResearchHandlerProps {
  onComplete: () => void;
}

const AIResearchHandler: React.FC<AIResearchHandlerProps> = ({ onComplete }) => {
  const handleAIResearchComplete = () => {
    localStorage.setItem('connect-ai-research-seen', 'true');
    onComplete();
  };

  return (
    <AnimatePresence mode="wait">
      <motion.div
        key="ai-research"
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        exit={{ opacity: 0 }}
        transition={{ duration: 0.3 }}
      >
        <ConnectAIResearchExplanation onComplete={handleAIResearchComplete} />
      </motion.div>
    </AnimatePresence>
  );
};

export default AIResearchHandler;
