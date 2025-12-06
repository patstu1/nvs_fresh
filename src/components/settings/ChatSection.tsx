
import React from 'react';
import { ChevronRight } from 'lucide-react';
import { Switch } from '@/components/ui/switch';

interface ChatSectionProps {
  markRecentlyChattedUsers: boolean;
  setMarkRecentlyChattedUsers: (value: boolean) => void;
  onClearCache: () => void;
}

const ChatSection = ({
  markRecentlyChattedUsers,
  setMarkRecentlyChattedUsers,
  onClearCache
}: ChatSectionProps) => {
  return (
    <div className="mb-6">
      <h2 className="text-sm font-semibold text-[#AAFF50] mb-2">CHAT</h2>
      
      <div className="bg-[#121212] rounded-md overflow-hidden">
        <div className="flex items-center justify-between p-4 border-b border-white/10">
          <span>Mark Recently Chatted</span>
          <Switch 
            checked={markRecentlyChattedUsers}
            onCheckedChange={setMarkRecentlyChattedUsers}
            className="data-[state=checked]:bg-[#AAFF50]"
          />
        </div>
        
        <button 
          onClick={onClearCache}
          className="w-full flex items-center justify-between p-4"
        >
          <div>
            <span>Clear Cache</span>
            <p className="text-xs text-gray-400">Cache data is temporarily stored data that can be downloaded again later.</p>
          </div>
          <ChevronRight className="w-5 h-5 text-gray-500 flex-shrink-0" />
        </button>
      </div>
    </div>
  );
};

export default ChatSection;
