
import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { toast } from '@/hooks/use-toast';
import { useAuth } from '@/hooks/useAuth';

import SettingsHeader from '@/components/settings/SettingsHeader';
import AccountSection from '@/components/settings/AccountSection';
import NotificationsSection from '@/components/settings/NotificationsSection';
import ChatSection from '@/components/settings/ChatSection';
import DisplaySection from '@/components/settings/DisplaySection';
import SocialSection from '@/components/settings/SocialSection';
import AboutSection from '@/components/settings/AboutSection';
import AccountActions from '@/components/settings/AccountActions';

const Settings = () => {
  const navigate = useNavigate();
  const { signOut } = useAuth();
  
  // Setting states
  const [receiveTaps, setReceiveTaps] = useState(true);
  const [sound, setSound] = useState(true);
  const [vibrations, setVibrations] = useState(true);
  const [markRecentlyChattedUsers, setMarkRecentlyChattedUsers] = useState(true);
  const [keepPhoneAwake, setKeepPhoneAwake] = useState(false);
  
  const handleSignOut = async () => {
    await signOut();
    toast({
      title: "Signed out",
      description: "You have been logged out successfully",
    });
    navigate('/auth');
  };
  
  const handleDeleteAccount = () => {
    // Show confirmation dialog
    if (confirm("Are you sure you want to delete your account? This action cannot be undone.")) {
      toast({
        title: "Account deletion initiated",
        description: "Your account will be deleted shortly",
      });
      navigate('/auth');
    }
  };
  
  const handleClearCache = () => {
    toast({
      title: "Cache cleared",
      description: "All temporary data has been cleared",
    });
  };

  return (
    <div className="min-h-screen bg-black text-white pb-24">
      <SettingsHeader />
      
      <div className="pt-20 px-4 pb-32">
        <AccountSection />
        
        <NotificationsSection 
          receiveTaps={receiveTaps}
          setReceiveTaps={setReceiveTaps}
          sound={sound}
          setSound={setSound}
          vibrations={vibrations}
          setVibrations={setVibrations}
        />
        
        <ChatSection 
          markRecentlyChattedUsers={markRecentlyChattedUsers}
          setMarkRecentlyChattedUsers={setMarkRecentlyChattedUsers}
          onClearCache={handleClearCache}
        />
        
        <DisplaySection 
          keepPhoneAwake={keepPhoneAwake}
          setKeepPhoneAwake={setKeepPhoneAwake}
        />
        
        <SocialSection />
        
        <AboutSection />
        
        <AccountActions 
          onSignOut={handleSignOut}
          onDeleteAccount={handleDeleteAccount}
        />
      </div>
    </div>
  );
};

export default Settings;
