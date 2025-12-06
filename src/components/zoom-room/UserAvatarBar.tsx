
import React from 'react';
import { ScrollArea } from '@/components/ui/scroll-area';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';

interface RoomUser {
  id: string;
  name: string;
  image?: string;
  isOnline: boolean;
}

interface UserAvatarBarProps {
  users: RoomUser[];
}

const UserAvatarBar: React.FC<UserAvatarBarProps> = ({ users }) => {
  return (
    <div className="p-2 border-b border-[#333] bg-[#1A1A1A]">
      <ScrollArea className="w-full whitespace-nowrap">
        <div className="flex space-x-2 p-1">
          {users.map(user => (
            <div key={user.id} className="flex flex-col items-center">
              <div className={`relative w-10 h-10 ${user.isOnline && 'ring-1 ring-[#C2FFE6] rounded-full'}`}>
                <Avatar className="w-10 h-10 border border-[#333]">
                  <AvatarImage src={user.image} />
                  <AvatarFallback className="bg-[#333] text-[#C2FFE6]">
                    {user.name.charAt(0)}
                  </AvatarFallback>
                </Avatar>
                {user.isOnline && (
                  <span className="absolute bottom-0 right-0 w-2 h-2 bg-green-500 rounded-full"></span>
                )}
              </div>
              <span className="text-xs text-gray-400 mt-1 truncate max-w-10">{user.name}</span>
            </div>
          ))}
        </div>
      </ScrollArea>
    </div>
  );
};

export default UserAvatarBar;
