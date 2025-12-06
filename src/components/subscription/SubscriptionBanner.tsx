
import React, { useState } from 'react';
import { Crown, Lock, CheckCircle, CreditCard } from 'lucide-react';
import { motion } from 'framer-motion';
import { useUserSession } from '@/hooks/useUserSession';
import SubscriptionDialog from './SubscriptionDialog';

interface SubscriptionBannerProps {
  feature?: 'connect' | 'zoom' | 'profiles' | 'messaging';
  className?: string;
}

const SubscriptionBanner: React.FC<SubscriptionBannerProps> = ({ 
  feature,
  className = ''
}) => {
  const { subscription } = useUserSession();
  const [showDialog, setShowDialog] = useState(false);
  
  // Always return null to hide the banner during development
  // This allows you to preview all features without interruptions
  return null;

  // Original code is kept below for reference but won't execute
  /*
  // If user has active subscription or trial, don't show banner
  if (subscription.isPro) {
    return null;
  }
  
  const getFeatureText = () => {
    switch(feature) {
      case 'connect':
        return 'AI Connect matching';
      case 'zoom':
        return 'video calls and rooms';
      case 'profiles':
        return 'unlimited profile browsing';
      case 'messaging':
        return 'unlimited messaging';
      default:
        return 'premium features';
    }
  };

  return (
    <>
      <motion.div 
        className={`p-4 bg-gradient-to-r from-[#191919] to-[#292929] rounded-lg border border-[#E6FFF4]/30 shadow-lg ${className}`}
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.3 }}
      >
        <div className="flex items-center gap-3">
          <div className="rounded-full bg-[#E6FFF4]/10 p-2">
            {subscription.hasPaymentMethod ? 
              <Crown className="w-6 h-6 text-[#E6FFF4]" /> : 
              <CreditCard className="w-6 h-6 text-[#E6FFF4]" />
            }
          </div>
          <div className="flex-1">
            <h3 className="text-[#E6FFF4] font-semibold">
              {subscription.hasPaymentMethod ? 
                'Upgrade to YO BRO PRO' : 
                'Add payment method for free trial'
              }
            </h3>
            <p className="text-sm text-[#E6FFF4]/70">
              {subscription.hasPaymentMethod ? 
                (feature ? `Unlock ${getFeatureText()} with YO BRO PRO` : 'Get unlimited access to all features') : 
                'Enter your card details for 3 months of free YO BRO PRO'
              }
            </p>
          </div>
          <button
            onClick={() => setShowDialog(true)}
            className="bg-[#E6FFF4] text-black px-4 py-2 rounded-full font-medium hover:bg-white transition-colors"
          >
            {subscription.hasPaymentMethod ? 'Upgrade' : 'Start Free'}
          </button>
        </div>
      </motion.div>

      <SubscriptionDialog
        isOpen={showDialog}
        onClose={() => setShowDialog(false)}
      />
    </>
  );
  */
};

export default SubscriptionBanner;
