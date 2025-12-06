
import React from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import ProfileCard from '../ProfileCard';
import { Profile } from '../types/ConnectTypes';

interface ConnectProfileDisplayProps {
  profile: Profile;
  isTransitioning: boolean;
  onVideoCall?: (id: string) => void;
}

const ConnectProfileDisplay = ({ 
  profile, 
  isTransitioning,
  onVideoCall 
}: ConnectProfileDisplayProps) => {
  return (
    <AnimatePresence mode="wait">
      {!isTransitioning && (
        <motion.div
          key={profile.id}
          initial={{ opacity: 0, scale: 0.9 }}
          animate={{ opacity: 1, scale: 1 }}
          exit={{ opacity: 0, scale: 0.9 }}
          transition={{ duration: 0.3 }}
          className="w-full"
        >
          <ProfileCard 
            profile={profile}
            onVideoCall={onVideoCall}
          />
        </motion.div>
      )}
    </AnimatePresence>
  );
};

export default ConnectProfileDisplay;
