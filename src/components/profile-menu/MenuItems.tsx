
import React from 'react';
import {
  Crown, User, Settings, Layout, Cpu, LogOut,
  Edit, Album, Stethoscope, ShieldAlert, Zap,
  MapPin, Smile
} from 'lucide-react';
import { Switch } from "@/components/ui/switch";
import { useNavigate } from 'react-router-dom';
import { useAuth } from '@/hooks/useAuth';
import { toast } from '@/hooks/use-toast';
import { useMapState } from '@/components/map/hooks/useMapState';
import { useUserSession } from '@/hooks/useUserSession';

export const useMenuItems = () => {
  const navigate = useNavigate();
  const { subscription } = useUserSession();
  const { signOut, user } = useAuth();
  const { anonymousMode, toggleAnonymousMode } = useMapState();

  const handleSignOut = async () => {
    await signOut();
    navigate('/auth');
    toast({
      title: "Signed out successfully",
      description: "You've been logged out of your account",
    });
  };

  const handleSignIn = () => {
    navigate('/auth');
  };

  // Main profile menu options
  const menuItems = user ? [
    {
      icon: <User className="w-4 h-4 text-[#C2FFE6] mr-2" />,
      text: "My Profile",
      action: () => navigate('/profile/me'),
    },
    {
      icon: <Edit className="w-4 h-4 text-[#C2FFE6] mr-2" />,
      text: "Edit Profile",
      action: () => navigate('/profile-setup'),
    },
    {
      icon: <Album className="w-4 h-4 text-[#C2FFE6] mr-2" />,
      text: "My Albums",
      action: () => navigate('/albums'),
    },
    {
      icon: <Zap className="w-4 h-4 text-[#AAFF50] mr-2" />,
      text: "Boost",
      isPro: true,
      action: () => navigate('/boost'),
    },
    {
      icon: <MapPin className="w-4 h-4 text-[#C2FFE6] mr-2" />,
      text: "Right Now",
      badge: "NOW",
      action: () => navigate('/right-now'),
    },
    {
      divider: true,
      title: "Add-ons"
    },
    {
      icon: <Crown className="w-4 h-4 text-[#AAFF50] mr-2" />,
      text: "YO BRO PRO",
      action: () => navigate('/subscription'),
    },
    {
      icon: <Cpu className="w-4 h-4 text-[#C2FFE6] mr-2" />,
      text: "AI Connect",
      action: () => {
        if (!subscription.isPro) {
          toast({
            title: "Premium Feature",
            description: "AI Connect is available with YO BRO PRO",
          });
          navigate('/subscription');
          return;
        }
        navigate('/connect');
      },
    },
    {
      item: (
        <div className="flex items-center justify-between w-full px-3 py-3">
          <div className="flex items-center">
            <Smile className="w-4 h-4 text-[#C2FFE6] mr-2" />
            <span className="text-white text-sm">Incognito Mode</span>
          </div>
          <Switch 
            checked={anonymousMode} 
            onCheckedChange={toggleAnonymousMode} 
            className="data-[state=checked]:bg-[#AAFF50]"
          />
        </div>
      )
    },
    {
      divider: true,
      title: "Help & Settings"
    },
    {
      icon: <Settings className="w-4 h-4 text-[#C2FFE6] mr-2" />,
      text: "Settings",
      action: () => navigate('/settings'),
    },
    {
      icon: <ShieldAlert className="w-4 h-4 text-[#C2FFE6] mr-2" />,
      text: "Safety & Privacy",
      action: () => navigate('/privacy-center'),
    },
    {
      icon: <Stethoscope className="w-4 h-4 text-[#C2FFE6] mr-2" />,
      text: "Free HIV Home Test",
      action: () => navigate('/hiv-test'),
    },
    {
      icon: <LogOut className="w-4 h-4 text-[#C2FFE6] mr-2" />,
      text: "Logout",
      action: handleSignOut,
    },
  ] : [
    {
      icon: <User className="w-4 h-4 text-[#C2FFE6] mr-2" />,
      text: "Sign In",
      action: handleSignIn,
    },
  ];

  return menuItems;
};

const MenuItem = ({ item }: { item: any }) => {
  if (item.divider) {
    return (
      <div className="pt-2 pb-1 px-3 mt-1 border-t border-[#C2FFE6]/20">
        {item.title && (
          <p className="text-[#C2FFE6]/80 text-xs font-medium uppercase tracking-wider">
            {item.title}
          </p>
        )}
      </div>
    );
  }

  if (item.item) {
    return item.item;
  }

  return (
    <button
      onClick={item.action}
      className="w-full px-3 py-2 flex items-center justify-between text-left hover:bg-[#C2FFE6]/10 text-white text-sm"
    >
      <div className="flex items-center">
        {item.icon}
        <span>{item.text}</span>
      </div>
      {item.badge && (
        <span className="bg-[#AAFF50]/20 text-[#AAFF50] text-xs px-1.5 py-0.5 rounded">
          {item.badge}
        </span>
      )}
      {item.isPro && (
        <span className="bg-[#AAFF50]/20 text-[#AAFF50] text-xs px-1.5 py-0.5 rounded">
          PRO
        </span>
      )}
    </button>
  );
};

export const MenuItems = () => {
  const menuItems = useMenuItems();
  return (
    <div className="py-2">
      {menuItems.map((item, i) => (
        <MenuItem key={i} item={item} />
      ))}
    </div>
  );
};
