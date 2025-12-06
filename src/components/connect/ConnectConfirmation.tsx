
import React, { useState } from 'react';
import { Video, MessageSquare, X, Heart, Star } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { motion } from 'framer-motion';
import { useNavigate } from 'react-router-dom';

interface Profile {
  id: string;
  name: string;
  image: string;
  compatibility?: number;
}

interface ConnectConfirmationProps {
  profile: Profile;
  onDismiss: () => void;
  onMessage: () => void;
  onVideoCall: () => void;
}

const ConnectConfirmation: React.FC<ConnectConfirmationProps> = ({
  profile,
  onDismiss,
  onMessage,
  onVideoCall
}) => {
  const navigate = useNavigate();
  const [isExiting, setIsExiting] = useState(false);
  
  const handleDismiss = () => {
    setIsExiting(true);
    setTimeout(onDismiss, 300);
  };
  
  const handleMessage = () => {
    navigate(`/chat/${profile.id}`);
    onMessage();
  };

  return (
    <motion.div 
      className="w-full max-w-md bg-gradient-to-b from-gray-900 to-black rounded-lg overflow-hidden p-6 flex flex-col items-center text-center border border-[#AAFF50]/30 shadow-xl"
      initial={{ scale: 0.9, opacity: 0 }}
      animate={{ scale: isExiting ? 0.9 : 1, opacity: isExiting ? 0 : 1 }}
      transition={{ duration: 0.3 }}
    >
      <button onClick={handleDismiss} className="self-end text-gray-400 hover:text-white">
        <X className="w-5 h-5" />
      </button>
      
      <div className="py-6">
        <motion.div 
          className="relative inline-block mb-6"
          initial={{ scale: 0.8 }}
          animate={{ scale: 1 }}
          transition={{ duration: 0.5, delay: 0.2 }}
        >
          <div className="relative w-28 h-28 rounded-full overflow-hidden border-4 border-[#AAFF50]">
            <img 
              src={profile.image} 
              alt={profile.name} 
              className="w-full h-full object-cover"
            />
            <div className="absolute inset-0 bg-gradient-to-t from-black/50 to-transparent"></div>
          </div>
          
          <div className="absolute -top-3 -right-3 bg-[#AAFF50] text-black text-sm font-bold w-10 h-10 rounded-full flex items-center justify-center">
            <Heart className="w-5 h-5 fill-current" />
          </div>
          
          <div className="absolute -bottom-2 -right-2 flex items-center justify-center">
            {profile.compatibility && (
              <div className="bg-[#AAFF50]/90 text-black text-xs font-medium px-2 py-1 rounded-full flex items-center">
                <Star className="w-3 h-3 mr-1 fill-current" />
                {profile.compatibility}%
              </div>
            )}
          </div>
          
          <motion.div 
            className="absolute top-0 left-0 right-0 bottom-0 flex items-center justify-center"
            animate={{ 
              scale: [1, 1.1, 1],
              opacity: [0.7, 0.3, 0.7]
            }}
            transition={{ 
              duration: 3,
              repeat: Infinity,
              repeatType: "reverse"
            }}
          >
            <div className="w-36 h-36 rounded-full border-4 border-[#AAFF50]/50 absolute"></div>
          </motion.div>
        </motion.div>
        
        <motion.div
          initial={{ y: 20, opacity: 0 }}
          animate={{ y: 0, opacity: 1 }}
          transition={{ delay: 0.3, duration: 0.4 }}
        >
          <h2 className="text-3xl font-bold text-white mb-2">It's a Match!</h2>
          <p className="text-[#C2FFE6] mb-8 text-lg">
            You and {profile.name} have liked each other
            {profile.compatibility && <span className="block text-sm text-gray-300 mt-1">With {profile.compatibility}% compatibility</span>}
          </p>
        </motion.div>
        
        <motion.div 
          className="flex flex-col gap-3 w-full"
          initial={{ y: 20, opacity: 0 }}
          animate={{ y: 0, opacity: 1 }}
          transition={{ delay: 0.5, duration: 0.4 }}
        >
          <Button 
            onClick={onVideoCall}
            className="w-full flex items-center justify-center gap-2 bg-gradient-to-r from-[#AAFF50] to-[#C2FFE6] text-black hover:opacity-90"
          >
            <Video className="w-5 h-5" />
            <span className="font-medium">Video Call Now</span>
          </Button>
          
          <Button 
            onClick={handleMessage}
            variant="outline"
            className="w-full flex items-center justify-center gap-2 border-[#AAFF50] text-[#AAFF50] hover:bg-[#AAFF50]/10"
          >
            <MessageSquare className="w-5 h-5" />
            <span>Send Message</span>
          </Button>
          
          <Button
            onClick={handleDismiss}
            variant="link"
            className="text-gray-400 hover:text-white"
          >
            Continue Browsing
          </Button>
        </motion.div>
      </div>
    </motion.div>
  );
};

export default ConnectConfirmation;
