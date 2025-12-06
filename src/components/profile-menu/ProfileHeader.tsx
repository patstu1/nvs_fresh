
import React from 'react';
import { useAuth } from '@/hooks/useAuth';
import { useUserSession } from '@/hooks/useUserSession';

export const ProfileHeader = () => {
  const { user } = useAuth();
  const { subscription } = useUserSession();

  const userProfile = {
    username: user?.email?.split('@')[0] || "User",
    avatar_url: "",
    isOnline: true
  };

  if (!user) return null;

  return (
    <div className="p-3 border-b border-[#C2FFE6]/20">
      <div className="flex items-center">
        <div className="w-10 h-10 rounded-full bg-[#2A2A2A] overflow-hidden mr-3">
          <img 
            src={userProfile.avatar_url || "https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=500&h=500&fit=crop"} 
            alt="Profile" 
            className="w-full h-full object-cover"
          />
        </div>
        <div>
          <p className="text-white font-medium">{userProfile.username}</p>
          <p className="text-[#C2FFE6] text-xs">
            {subscription.isPro ? "YO BRO PRO" : "Basic Member"}
          </p>
        </div>
      </div>
    </div>
  );
};
