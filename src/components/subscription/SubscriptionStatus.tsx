
import React, { useState } from 'react';
import { useUserSession } from '@/hooks/useUserSession';
import { Clock, CreditCard, CheckCircle, Crown, Trash } from 'lucide-react';
import SubscriptionDialog from './SubscriptionDialog';

interface SubscriptionStatusProps {
  showManageButton?: boolean;
  className?: string;
}

const SubscriptionStatus: React.FC<SubscriptionStatusProps> = ({ 
  showManageButton = false,
  className = '' 
}) => {
  const { subscription, cancelSubscription } = useUserSession();
  const [showDialog, setShowDialog] = useState(false);
  
  const formatDate = (date: Date | null) => {
    if (!date) return 'N/A';
    return date.toLocaleDateString('en-US', { 
      year: 'numeric', 
      month: 'long', 
      day: 'numeric' 
    });
  };
  
  return (
    <>
      <div className={`bg-gradient-to-r from-[#1A1A1A] to-[#252525] rounded-lg overflow-hidden border border-[#E6FFF4]/20 ${className}`}>
        <div className="p-5">
          <div className="flex items-center mb-4">
            <div className="mr-3">
              {subscription.isPro ? (
                <div className="rounded-full bg-[#E6FFF4]/10 p-2">
                  <Crown className="w-6 h-6 text-[#E6FFF4]" />
                </div>
              ) : (
                <div className="rounded-full bg-[#E6FFF4]/10 p-2">
                  <CreditCard className="w-6 h-6 text-[#E6FFF4]/70" />
                </div>
              )}
            </div>
            <div>
              <h3 className="text-lg font-semibold text-[#E6FFF4]">
                {subscription.isPro ? 'YO BRO PRO' : 'Free Account'}
              </h3>
              <p className="text-sm text-[#E6FFF4]/70">
                {subscription.isPro ? 'Your premium membership is active' : 'Limited features available'}
              </p>
            </div>
          </div>
          
          <div className="space-y-2">
            {subscription.isPro && subscription.trialEndDate && new Date() < subscription.trialEndDate && (
              <div className="flex items-center">
                <Clock className="w-4 h-4 text-[#E6FFF4]/70 mr-2" />
                <span className="text-sm text-[#E6FFF4]/70">
                  Free trial ends: {formatDate(subscription.trialEndDate)}
                </span>
              </div>
            )}
            
            {subscription.subscriptionEndDate && (
              <div className="flex items-center">
                <Clock className="w-4 h-4 text-[#E6FFF4]/70 mr-2" />
                <span className="text-sm text-[#E6FFF4]/70">
                  Renews on: {formatDate(subscription.subscriptionEndDate)}
                </span>
              </div>
            )}
            
            <div className="flex items-center">
              <CreditCard className="w-4 h-4 text-[#E6FFF4]/70 mr-2" />
              <span className="text-sm text-[#E6FFF4]/70">
                {subscription.hasPaymentMethod 
                  ? 'Payment method: •••• 4242' 
                  : 'No payment method added'}
              </span>
            </div>
            
            <div className="flex items-center">
              <CheckCircle className="w-4 h-4 text-[#E6FFF4]/70 mr-2" />
              <span className="text-sm text-[#E6FFF4]/70">
                {subscription.isPro 
                  ? 'All features unlocked' 
                  : 'Basic features only'}
              </span>
            </div>
          </div>
        </div>
        
        {showManageButton && (
          <div className="border-t border-[#E6FFF4]/10 p-4 flex justify-between">
            {subscription.isPro ? (
              <>
                <button 
                  onClick={cancelSubscription}
                  className="flex items-center text-sm text-[#E6FFF4]/80 hover:text-[#E6FFF4]"
                >
                  <Trash className="w-4 h-4 mr-1" />
                  Cancel
                </button>
                
                <button 
                  onClick={() => setShowDialog(true)}
                  className="flex items-center text-sm text-[#E6FFF4]/80 hover:text-[#E6FFF4]"
                >
                  <CreditCard className="w-4 h-4 mr-1" />
                  Update payment
                </button>
              </>
            ) : (
              <button 
                onClick={() => setShowDialog(true)}
                className="flex items-center text-sm text-[#E6FFF4]/80 hover:text-[#E6FFF4] mx-auto"
              >
                <CreditCard className="w-4 h-4 mr-1" />
                Add payment method
              </button>
            )}
          </div>
        )}
      </div>
      
      <SubscriptionDialog
        isOpen={showDialog}
        onClose={() => setShowDialog(false)}
      />
    </>
  );
};

export default SubscriptionStatus;
