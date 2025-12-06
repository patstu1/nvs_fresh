
import React, { useEffect } from 'react';
import { motion } from 'framer-motion';
import { useWaitlist } from '@/hooks/useWaitlist';
import { useAuth } from '@/hooks/useAuth';
import { Button } from '@/components/ui/button';
import { Link } from 'react-router-dom';
import { Zap, Bell, Users, ChevronRight, Share2 } from 'lucide-react';
import { analytics } from '@/services/analytics';

const WaitlistScreen: React.FC = () => {
  const { userStatus, position, estimatedWaitTime, referralCode, isLoading } = useWaitlist();
  const { user } = useAuth();
  
  useEffect(() => {
    analytics.trackPageView('/waitlist');
  }, []);
  
  const pulseAnimation = {
    scale: [1, 1.05, 1],
    opacity: [0.7, 1, 0.7],
    transition: {
      duration: 2,
      repeat: Infinity,
      ease: "easeInOut"
    }
  };
  
  if (isLoading) {
    return (
      <div className="flex flex-col items-center justify-center min-h-screen bg-black text-[#E6FFF4] p-6">
        <motion.div 
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          className="w-full max-w-md text-center"
        >
          <div className="loading-spinner mb-6">
            Loading...
          </div>
          <p>Checking your waitlist status...</p>
        </motion.div>
      </div>
    );
  }
  
  return (
    <div className="flex flex-col items-center min-h-screen bg-black text-[#E6FFF4] p-6">
      <motion.div 
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        className="w-full max-w-md"
      >
        <div className="text-center mb-8">
          <motion.div 
            animate={pulseAnimation} 
            className="w-24 h-24 mx-auto mb-6 rounded-full bg-[#AAFF50]/20 flex items-center justify-center"
          >
            <Zap size={48} className="text-[#AAFF50]" />
          </motion.div>
          
          <h1 className="text-2xl font-bold mb-2">Thanks for joining Yo Bro</h1>
          <p className="text-[#E6FFF4]/70 mb-6">
            You're on the waitlist while we grow the community the right way.
            We'll let you know as soon as your invite is ready.
          </p>
          
          <div className="bg-[#1A1A1A] rounded-lg p-4 mb-6">
            <div className="flex justify-between items-center mb-2">
              <span className="text-[#E6FFF4]/70">Your position</span>
              <span className="font-bold">{position.toLocaleString()}</span>
            </div>
            
            <div className="w-full h-2 bg-[#333] rounded-full overflow-hidden mb-2">
              <motion.div 
                className="h-full bg-gradient-to-r from-[#AAFF50] to-[#E6FFF4]"
                style={{ width: '30%' }}
                animate={{ width: ['30%', '32%', '30%'] }}
                transition={{ duration: 2, repeat: Infinity }}
              />
            </div>
            
            <div className="flex justify-between items-center text-sm">
              <span>Estimated wait: {estimatedWaitTime}</span>
            </div>
          </div>
        </div>
        
        <div className="space-y-4">
          <Link to="/profile-setup" className="block w-full">
            <Button variant="outline" className="w-full justify-between border-[#AAFF50]/50 hover:bg-[#AAFF50]/10">
              <span className="flex items-center">
                <Users size={18} className="mr-2" />
                Complete Your Profile
              </span>
              <ChevronRight size={16} />
            </Button>
          </Link>
          
          <Link to="/media-manager" className="block w-full">
            <Button variant="outline" className="w-full justify-between border-[#E6FFF4]/50 hover:bg-[#E6FFF4]/10">
              <span className="flex items-center">
                <Bell size={18} className="mr-2" />
                Upload Photos
              </span>
              <ChevronRight size={16} />
            </Button>
          </Link>
          
          <div className="pt-6">
            <p className="text-sm text-center mb-2">Want to move up in line?</p>
            <Button 
              className="w-full bg-[#AAFF50] text-black hover:bg-[#AAFF50]/90"
              onClick={() => {
                navigator.clipboard.writeText(`https://yobro.app/join?ref=${referralCode}`);
                analytics.trackEvent('referral_link_copied', { referral_code: referralCode });
              }}
            >
              <Share2 size={18} className="mr-2" />
              Share Your Invite Link
            </Button>
            <p className="text-xs text-center mt-2 text-[#E6FFF4]/50">
              Each friend who joins with your code moves you up in line
            </p>
          </div>
        </div>
        
        <div className="mt-12 text-xs text-center text-[#E6FFF4]/50">
          <div className="space-x-3">
            <Link to="/privacy-policy" className="hover:text-[#E6FFF4]">Privacy Policy</Link>
            <span>•</span>
            <Link to="/terms-of-service" className="hover:text-[#E6FFF4]">Terms of Service</Link>
            <span>•</span>
            <Link to="/auth" className="hover:text-[#E6FFF4]">Sign Out</Link>
          </div>
        </div>
      </motion.div>
    </div>
  );
};

export default WaitlistScreen;
