
import React from 'react';
import { ArrowRight, CreditCard } from 'lucide-react';

interface SubscriptionPricingProps {
  onContinue: () => void;
  hasPaymentMethod: boolean;
  isPro: boolean;
  isDisabled?: boolean;
}

const SubscriptionPricing: React.FC<SubscriptionPricingProps> = ({ 
  onContinue, 
  hasPaymentMethod,
  isPro,
  isDisabled = false
}) => {
  return (
    <>
      <div className="bg-[#2A2A2A] rounded-lg p-4 mb-6 neon-border">
        <div className="flex justify-between items-center mb-2">
          <span className="text-[#E6FFF4]/70 neon-text">Monthly subscription</span>
          <span className="text-[#E6FFF4] font-semibold neon-text-bright">$19.99/month</span>
        </div>
        <div className="text-xs text-[#E6FFF4]/60 neon-text">
          First 3 months free, then $19.99/month. Cancel anytime.
        </div>
      </div>
      
      {!hasPaymentMethod && (
        <button
          onClick={onContinue}
          disabled={isDisabled}
          className="w-full bg-[#E6FFF4] text-black py-3 rounded-lg font-semibold hover:bg-white transition-colors flex items-center justify-center neon-border disabled:opacity-70 disabled:cursor-not-allowed"
        >
          Continue <ArrowRight className="ml-2 w-4 h-4" />
        </button>
      )}
      
      {hasPaymentMethod && !isPro && (
        <button
          onClick={onContinue}
          disabled={isDisabled}
          className="w-full bg-[#E6FFF4] text-black py-3 rounded-lg font-semibold hover:bg-white transition-colors flex items-center justify-center neon-border disabled:opacity-70 disabled:cursor-not-allowed"
        >
          Add Payment Method
        </button>
      )}
      
      {isPro && (
        <div className="text-center text-sm text-[#E6FFF4]/70 neon-text">
          You're currently on the YO BRO PRO plan
        </div>
      )}
      
      <p className="text-xs text-center text-[#E6FFF4]/50 mt-4 neon-text">
        By subscribing, you agree to our Terms of Service and Privacy Policy.
      </p>
    </>
  );
};

export default SubscriptionPricing;
