
import React from 'react';
import { useNavigate } from 'react-router-dom';
import { BarChart2 } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { motion } from 'framer-motion';
import ConnectLoadingState from './components/ConnectLoadingState';
import ConnectProfileDisplay from './components/ConnectProfileDisplay';
import ActionButtons from './components/ActionButtons';
import NoProfiles from './components/NoProfiles';
import ConnectConfirmation from './ConnectConfirmation';
import { useProfileManagement } from './hooks/useProfileManagement';
import type { ConnectMatchProps } from './types/ConnectTypes';

const ConnectMatchView: React.FC<ConnectMatchProps> = ({ 
  profile,
  onLike,
  onPass,
  onSuperLike,
  isLoading = false,
  onProfileMatch,
  onVideoCall,
  forceRender
}) => {
  const navigate = useNavigate();
  const {
    currentProfile,
    showConnectionConfirmation,
    isTransitioning,
    handleLike,
    handlePass,
    handleSuperLike,
    handleCloseConfirmation,
    handleMessageMatch
  } = useProfileManagement();

  if (isLoading) {
    return <ConnectLoadingState />;
  }

  if (!currentProfile && !isLoading && !showConnectionConfirmation) {
    return <NoProfiles />;
  }

  if (showConnectionConfirmation && currentProfile) {
    return (
      <ConnectConfirmation
        profile={currentProfile}
        onDismiss={handleCloseConfirmation}
        onMessage={handleMessageMatch}
        onVideoCall={() => onVideoCall?.(currentProfile.id)}
      />
    );
  }

  return (
    <div className="w-full max-w-md flex flex-col items-center">
      {currentProfile && (
        <ConnectProfileDisplay 
          profile={currentProfile}
          isTransitioning={isTransitioning}
          onVideoCall={onVideoCall}
        />
      )}
      
      {currentProfile && (
        <ActionButtons
          profileId={currentProfile.id}
          onLike={handleLike}
          onPass={handlePass}
          onSuperLike={handleSuperLike}
        />
      )}
      
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.4, delay: 0.3 }}
      >
        <Button
          onClick={() => navigate('/connect-stats')}
          size="sm"
          className="bg-transparent border border-[#E6FFF4] text-[#E6FFF4] hover:bg-[#E6FFF4]/10"
        >
          <BarChart2 className="w-4 h-4 mr-2" />
          View Stats
        </Button>
      </motion.div>
    </div>
  );
};

export default ConnectMatchView;
