
import React from 'react';
import { BellRing } from 'lucide-react';
import ProfileMenu from './profile-menu/ProfileMenu';
import { useAuth } from '@/hooks/useAuth';
import { Button } from './ui/button';
import { useNavigate } from 'react-router-dom';
import { Avatar, AvatarFallback, AvatarImage } from './ui/avatar';

interface TopToolbarProps {
  showProfile?: boolean;
  showRightIcon?: 'filter' | 'none';
}

const TopToolbar: React.FC<TopToolbarProps> = ({ 
  showProfile = true,
  showRightIcon = 'none',
}) => {
  const { user } = useAuth();
  const navigate = useNavigate();

  const userProfile = {
    username: user?.email?.split('@')[0] || "User",
    avatar_url: "",
    isOnline: true
  };

  const profileImage = userProfile.avatar_url || 'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=500&h=500&fit=crop';

  return (
    <div 
      className="fixed top-0 left-0 right-0 bg-black bg-opacity-90 backdrop-blur-lg z-40"
      style={{ 
        WebkitBackdropFilter: 'blur(12px)',
        paddingTop: 'env(safe-area-inset-top)'
      }}
    >
      <div className="flex items-center justify-between h-16 px-4">
        <div className="flex-none">
          {showProfile && (
            <div className="relative">
              <ProfileMenu
                triggerElement={
                  <Avatar className="h-10 w-10 border-2 border-[#C2FFE6] cursor-pointer">
                    <AvatarImage src={profileImage} alt="Profile" />
                    <AvatarFallback className="bg-[#2A2A2A] text-[#C2FFE6]">
                      {userProfile.username.charAt(0).toUpperCase()}
                    </AvatarFallback>
                  </Avatar>
                }
              />
              {userProfile.isOnline && (
                <span className="absolute bottom-0 right-0 w-3 h-3 bg-green-500 border-2 border-black rounded-full"></span>
              )}
            </div>
          )}
        </div>
        
        <div className="flex-1 flex flex-col items-center justify-center">
          <div className="flex items-center">
            <span 
              className="text-[#E6FFF4] text-5xl font-bold tracking-wide flex items-center"
              style={{
                textShadow: '1px 1px 0 #40E0D0, -1px -1px 0 #40E0D0, 1px -1px 0 #40E0D0, -1px 1px 0 #40E0D0'
              }}
            >
              <span className="mr-2">YO</span>
              <span>BRO</span>
            </span>
          </div>
        </div>
        
        <div className="flex items-center space-x-3">
          <button 
            className="p-2 relative active:opacity-70 transition-opacity"
            style={{ WebkitTapHighlightColor: 'transparent' }}
          >
            <BellRing className="w-5 h-5 text-[#C2FFE6]" />
            <span className="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full" />
          </button>
          
          {!showProfile && !user && (
            <Button 
              onClick={() => navigate('/auth')}
              size="sm"
              className="bg-[#C2FFE6] text-black hover:bg-[#C2FFE6]/90 active:opacity-70 transition-opacity"
            >
              Sign In
            </Button>
          )}
        </div>
      </div>
    </div>
  );
};

export default TopToolbar;
