
import React from 'react';
import ConnectDashboard from '../ConnectDashboard';
import { motion, AnimatePresence } from 'framer-motion';

interface DashboardHandlerProps {
  onComplete: () => void;
}

const DashboardHandler: React.FC<DashboardHandlerProps> = ({ onComplete }) => {
  const handleStartMatching = () => {
    localStorage.setItem('connect-returning-user', 'true');
    onComplete();
  };

  return (
    <AnimatePresence mode="wait">
      <motion.div
        key="dashboard"
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        exit={{ opacity: 0 }}
        transition={{ duration: 0.3 }}
      >
        <ConnectDashboard onStartMatching={handleStartMatching} />
      </motion.div>
    </AnimatePresence>
  );
};

export default DashboardHandler;
