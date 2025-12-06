
import React from 'react';
import { TabType } from '@/types/TabTypes';
import TopToolbar from '@/components/TopToolbar';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '@/hooks/useAuth';
import { useUserSession } from '@/hooks/useUserSession';

interface ToolbarConfigProps {
  activeTab: TabType;
}

const ToolbarConfig: React.FC<ToolbarConfigProps> = ({ activeTab }) => {
  const navigate = useNavigate();
  const { user } = useAuth();
  const { hasCompletedSetup } = useUserSession();

  const handleProfileClick = () => {
    if (user) {
      if (!hasCompletedSetup) {
        navigate('/profile-setup');
      } else {
        navigate('/profile/me');
      }
    } else {
      navigate('/auth');
    }
  };

  // Determine if filter icon should be shown
  const showRightIcon = 
    activeTab === 'grid' || 
    activeTab === 'messages' || 
    activeTab === 'map' ? 'filter' : 'none';

  return (
    <TopToolbar 
      showProfile={true}
      showRightIcon={showRightIcon}
    />
  );
};

export default ToolbarConfig;
