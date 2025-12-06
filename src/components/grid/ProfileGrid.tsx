
import React, { useCallback } from 'react';
import { UserProfile } from '@/types/UserProfile';
import { motion } from 'framer-motion';
import ProfileGridTile from './ProfileGridTile';

interface ProfileGridProps {
  profiles: UserProfile[];
  onProfileClick: (id: string) => void;
}

const ProfileGrid: React.FC<ProfileGridProps> = ({ profiles, onProfileClick }) => {
  // Memoized handler to prevent re-renders
  const handleProfileClick = useCallback((id: string) => {
    onProfileClick(id);
  }, [onProfileClick]);
  
  return (
    <div className="grid grid-cols-3 gap-[3px] px-[3px]">
      {profiles.map((profile, index) => (
        <motion.div 
          key={profile.id}
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.2, delay: Math.min(0.03 * (index % 6), 0.15) }}
        >
          <ProfileGridTile
            profile={profile}
            onProfileClick={handleProfileClick}
          />
        </motion.div>
      ))}
    </div>
  );
};

export default ProfileGrid;
