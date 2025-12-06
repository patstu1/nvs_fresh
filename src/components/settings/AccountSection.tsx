
import React from 'react';
import { ChevronRight } from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '@/hooks/useAuth';
import { useUserSession } from '@/hooks/useUserSession';

const AccountSection = () => {
  const navigate = useNavigate();
  const { user } = useAuth();
  const { subscription } = useUserSession();
  
  const navigateTo = (path: string) => {
    navigate(path);
  };

  return (
    <div className="mb-6">
      <h2 className="text-sm font-semibold text-[#AAFF50] mb-2">ACCOUNT</h2>
      
      <div className="bg-[#121212] rounded-md overflow-hidden">
        <button 
          onClick={() => navigateTo('/subscription')}
          className="w-full flex items-center justify-between p-4 border-b border-white/10"
        >
          <span>{subscription.isPro ? "Unlimited Membership" : "Go Premium"}</span>
          <div className="flex items-center">
            {subscription.isPro && <span className="text-[#AAFF50] mr-2">Active</span>}
            <ChevronRight className="w-5 h-5 text-gray-500" />
          </div>
        </button>
        
        <button 
          onClick={() => navigateTo('/profile-setup')}
          className="w-full flex items-center justify-between p-4 border-b border-white/10"
        >
          <span>Email</span>
          <div className="flex items-center">
            <span className="text-gray-400 mr-2 text-sm truncate max-w-[180px]">
              {user?.email || "Add email"}
            </span>
            <ChevronRight className="w-5 h-5 text-gray-500" />
          </div>
        </button>
        
        <button 
          onClick={() => navigateTo('/change-password')}
          className="w-full flex items-center justify-between p-4 border-b border-white/10"
        >
          <span>Password</span>
          <ChevronRight className="w-5 h-5 text-gray-500" />
        </button>
        
        <button 
          onClick={() => navigateTo('/restore-purchase')}
          className="w-full flex items-center justify-between p-4"
        >
          <span>Restore Purchase</span>
          <ChevronRight className="w-5 h-5 text-gray-500" />
        </button>
      </div>
    </div>
  );
};

export default AccountSection;
