
import React, { useState, useEffect } from 'react';
import { useConnectOnboarding } from './connect/hooks/useConnectOnboarding';
import ConnectAIOnboarding from './connect/ConnectAIOnboarding';
import { useNavigate } from 'react-router-dom';
import { toast } from '@/hooks/use-toast';
import ConnectMatchView from './connect/ConnectMatchView';
import soundManager from '@/utils/soundManager';
import LoadingScreen from './LoadingScreen';
import { useUserSession } from '@/hooks/useUserSession';
import { Button } from '@/components/ui/button';
import { BarChart2 } from 'lucide-react';
import { motion } from 'framer-motion';
import UserOnboardingHandler from './connect/UserOnboardingHandler';
import { useProfileManagement } from './connect/hooks/useProfileManagement';
import ConnectHeaderActions from './connect/components/ConnectHeaderActions';
import ConnectLocationWrapper from './connect/components/ConnectLocationWrapper';

const ConnectView: React.FC = () => {
  const navigate = useNavigate();
  const { isNewUser } = useConnectOnboarding();
  const { 
    currentProfile,
    handleLike,
    handlePass,
    handleSuperLike
  } = useProfileManagement();
  
  if (isNewUser) {
    return <ConnectAIOnboarding />;
  }

  const [isLoading, setIsLoading] = useState(true);
  const [forceRender, setForceRender] = useState(false);
  const [dataInitialized, setDataInitialized] = useState(false);
  
  useEffect(() => {
    // Initialize sound manager
    try {
      soundManager.initialize();
    } catch (error) {
      console.error('Error initializing sound manager:', error);
    }
    
    // Ensure localStorage has the required keys for testing
    if (!localStorage.getItem('connect-preferences-set')) {
      localStorage.setItem('connect-preferences-set', 'true');
      localStorage.setItem('connect-intro-seen', 'true');
      localStorage.setItem('connect-returning-user', 'true');
      localStorage.setItem('connect-ai-research-seen', 'true');
    }
    
    console.log("ConnectView component mounted");
    
    // Simulate loading profiles
    setTimeout(() => {
      setIsLoading(false);
      
      // Force a re-render to ensure data appears
      setTimeout(() => {
        setForceRender(true);
        setDataInitialized(true);
        console.log("Data initialized and ready to render");
      }, 100);
    }, 600);
  }, []);

  const handleVideoCall = (id: string) => {
    navigate(`/profile/${id}`);
    try {
      soundManager.play('notification');
    } catch (error) {
      console.error('Error playing sound:', error);
    }
    setTimeout(() => {
      toast({
        title: "Video Call Initiated",
        description: `Starting video call with ${id}`,
      });
    }, 500);
  };
  
  const handleProfileMatch = () => {
    try {
      soundManager.play('yo', 0.7);
    } catch (error) {
      console.error('Error playing sound:', error);
    }
  };
  
  if (isLoading) {
    return <LoadingScreen isLoading={true} connectMode={true} />;
  }
  
  return (
    <UserOnboardingHandler>
      <div className="flex flex-col items-center justify-center w-full h-full bg-black pt-8 pb-24">
        <ConnectHeaderActions />
        <ConnectLocationWrapper />
        
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.2 }}
          className="w-full"
        >
          {currentProfile && (
            <ConnectMatchView 
              profile={currentProfile}
              onLike={handleLike}
              onPass={handlePass}
              onSuperLike={handleSuperLike}
              isLoading={!dataInitialized}
              onProfileMatch={handleProfileMatch}
              onVideoCall={handleVideoCall}
              forceRender={forceRender}
            />
          )}
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.4 }}
          className="mt-6"
        >
          <Button
            onClick={() => navigate('/connect-stats')}
            size="sm"
            className="bg-black border border-[#E6FFF4] text-[#E6FFF4] hover:bg-[#E6FFF4]/10"
          >
            <BarChart2 className="w-4 h-4 mr-2" />
            View Stats
          </Button>
        </motion.div>
      </div>
    </UserOnboardingHandler>
  );
};

export default ConnectView;
