
import React, { useState } from 'react';
import { Video } from 'lucide-react';
import VideoCallDialog from '@/components/VideoCallDialog';
import { toast } from '@/hooks/use-toast';

interface VideoCallButtonProps {
  userId: string;
  userName: string;
  userImage?: string;
  distance: number;
}

const VideoCallButton: React.FC<VideoCallButtonProps> = ({ 
  userId, 
  userName, 
  userImage,
  distance 
}) => {
  const [isVideoCallOpen, setIsVideoCallOpen] = useState(false);
  
  const handleVideoCall = () => {
    if (distance > 50) {
      toast({
        title: "Long Distance Call",
        description: `${userName} is far away. This will use premium credits.`,
      });
    }
    setIsVideoCallOpen(true);
  };

  return (
    <>
      <button 
        onClick={handleVideoCall}
        className="flex flex-col items-center"
      >
        <div className="w-12 h-12 rounded-full bg-[#2A2A2A] flex items-center justify-center mb-1">
          <Video className="w-6 h-6 text-[#C2FFE6]" />
        </div>
        <span className="text-xs text-gray-300">Video</span>
      </button>
      
      <VideoCallDialog 
        isOpen={isVideoCallOpen} 
        onClose={() => setIsVideoCallOpen(false)} 
        user={{
          id: userId,
          name: userName,
          avatar: userImage
        }}
      />
    </>
  );
};

export default VideoCallButton;
