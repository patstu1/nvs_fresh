
import React from 'react';
import { X, Crown } from 'lucide-react';
import { motion } from 'framer-motion';

interface SubscriptionHeaderProps {
  onClose: () => void;
  step: 'info' | 'payment';
  trialEndDate: Date | null;
}

const SubscriptionHeader: React.FC<SubscriptionHeaderProps> = ({ 
  onClose, 
  step,
  trialEndDate 
}) => {
  const formatDate = (date: Date | null) => {
    if (!date) return 'N/A';
    return date.toLocaleDateString('en-US', { 
      year: 'numeric', 
      month: 'long', 
      day: 'numeric' 
    });
  };
  
  return (
    <div className="relative bg-gradient-to-r from-[#2A2A2A] to-[#343434] px-6 py-8">
      <button
        className="absolute top-4 right-4 text-[#E6FFF4]/70 hover:text-[#E6FFF4]"
        onClick={onClose}
      >
        <X className="w-6 h-6" />
      </button>
      
      <div className="flex items-center justify-center gap-3 mb-4">
        <Crown className="w-8 h-8 text-[#E6FFF4]" />
        <h2 className="text-2xl font-bold neon-text-bright animate-pulse">YO BRO PRO</h2>
      </div>
      
      <p className="text-center neon-text">
        {step === 'info' ? 'Upgrade to unlock all premium features' : 'Add payment method to activate'}
      </p>
      
      {trialEndDate && step === 'info' && (
        <div className="mt-4 bg-[#E6FFF4]/10 rounded-lg p-3 text-center neon-border">
          <p className="text-sm neon-text-amber">
            {new Date() < trialEndDate ? (
              <>Your free trial ends on {formatDate(trialEndDate)}</>
            ) : (
              <>Your free trial has ended</>
            )}
          </p>
        </div>
      )}
    </div>
  );
};

export default SubscriptionHeader;
