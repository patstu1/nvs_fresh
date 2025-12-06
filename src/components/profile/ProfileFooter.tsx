
import React from 'react';
import { Flag, ShieldAlert, Share2 } from 'lucide-react';
import { toast } from '@/hooks/use-toast';

interface ProfileFooterProps {
  userName: string;
  isBlocked: boolean;
  onToggleBlock: () => void;
  onReport: () => void;
}

const ProfileFooter: React.FC<ProfileFooterProps> = ({ 
  userName, 
  isBlocked, 
  onToggleBlock,
  onReport
}) => {
  const handleShare = () => {
    toast({
      title: "Share Profile",
      description: "Profile sharing functionality would appear here",
    });
  };

  return (
    <div className="px-4 py-4 border-t border-[#333333]">
      <div className="flex flex-col space-y-2">
        <button 
          onClick={onToggleBlock}
          className="flex items-center py-3 text-red-400"
        >
          <ShieldAlert className="w-5 h-5 mr-3" />
          <span>{isBlocked ? 'Unblock User' : 'Block User'}</span>
        </button>
        <button 
          onClick={onReport}
          className="flex items-center py-3 text-red-400"
        >
          <Flag className="w-5 h-5 mr-3" />
          <span>Report User</span>
        </button>
        <button 
          className="flex items-center py-3 text-gray-400"
          onClick={handleShare}
        >
          <Share2 className="w-5 h-5 mr-3" />
          <span>Share Profile</span>
        </button>
      </div>
    </div>
  );
};

export default ProfileFooter;
