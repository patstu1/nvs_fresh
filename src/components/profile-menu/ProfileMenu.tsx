
import React from 'react';
import { Popover, PopoverContent, PopoverTrigger } from "@/components/ui/popover";
import { ProfileHeader } from './ProfileHeader';
import { MenuItems } from './MenuItems';

interface ProfileMenuProps {
  triggerElement: React.ReactNode;
}

const ProfileMenu: React.FC<ProfileMenuProps> = ({ triggerElement }) => {
  return (
    <Popover>
      <PopoverTrigger asChild>
        {triggerElement}
      </PopoverTrigger>
      <PopoverContent className="w-64 p-0 bg-black border border-[#C2FFE6]/30 shadow-[0_0_5px_rgba(194,255,230,0.2)] max-h-[80vh] overflow-y-auto">
        <ProfileHeader />
        <MenuItems />
      </PopoverContent>
    </Popover>
  );
};

export default ProfileMenu;
