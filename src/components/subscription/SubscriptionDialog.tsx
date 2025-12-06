
import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { useUserSession } from '@/hooks/useUserSession';
import { toast } from '@/hooks/use-toast';
import * as z from "zod";
import { Link } from 'react-router-dom';

import SubscriptionHeader from './SubscriptionHeader';
import SubscriptionBenefitsList from './SubscriptionBenefitsList';
import SubscriptionPricing from './SubscriptionPricing';
import PaymentForm from './PaymentForm';

interface SubscriptionDialogProps {
  isOpen: boolean;
  onClose: () => void;
}

const SubscriptionDialog: React.FC<SubscriptionDialogProps> = ({ 
  isOpen, 
  onClose 
}) => {
  const { subscription, activateSubscription } = useUserSession();
  const [step, setStep] = useState<'info' | 'payment'>('info');
  const [isProcessing, setIsProcessing] = useState(false);
  
  const handleSubscribe = async (values: z.infer<any>) => {
    // In a real app, this would securely process the payment information
    // and integrate with Stripe or another payment processor
    
    try {
      setIsProcessing(true);
      
      // Simulate API call delay
      await new Promise(resolve => setTimeout(resolve, 1500));
      
      // For demo purposes, we'll simulate a successful subscription
      toast({
        title: "Payment Processed",
        description: "Your YO BRO PRO subscription is now active!",
      });
      
      activateSubscription(1); // Subscribe for 1 month
      onClose();
    } catch (error) {
      toast({
        title: "Payment Failed",
        description: "There was a problem processing your payment. Please try again.",
        variant: "destructive"
      });
    } finally {
      setIsProcessing(false);
    }
  };
  
  const handleApplePay = async () => {
    // In a real app, this would trigger Apple Pay flow
    try {
      setIsProcessing(true);
      
      // Simulate API call delay
      await new Promise(resolve => setTimeout(resolve, 1500));
      
      toast({
        title: "Apple Pay",
        description: "Apple Pay payment processed successfully!",
      });
      
      // Simulate subscription activation
      activateSubscription(1);
      onClose();
    } catch (error) {
      toast({
        title: "Payment Failed",
        description: "There was a problem with Apple Pay. Please try again or use another payment method.",
        variant: "destructive"
      });
    } finally {
      setIsProcessing(false);
    }
  };
  
  return (
    <AnimatePresence>
      {isOpen && (
        <motion.div
          className="fixed inset-0 bg-black bg-opacity-80 z-50 flex items-center justify-center p-4"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
        >
          <motion.div
            className="bg-[#1A1A1A] border border-[#E6FFF4]/30 rounded-xl w-full max-w-md shadow-2xl overflow-hidden"
            initial={{ scale: 0.9, y: 20 }}
            animate={{ scale: 1, y: 0 }}
            exit={{ scale: 0.9, y: 20 }}
          >
            {/* Header */}
            <SubscriptionHeader 
              onClose={isProcessing ? undefined : onClose} 
              step={step} 
              trialEndDate={subscription.trialEndDate} 
            />
            
            {/* Content */}
            <div className="p-6">
              {step === 'info' && (
                <>
                  <h3 className="text-lg font-semibold text-[#E6FFF4] mb-4">
                    Membership includes:
                  </h3>
                  
                  <SubscriptionBenefitsList />
                  
                  <SubscriptionPricing 
                    onContinue={() => setStep('payment')} 
                    hasPaymentMethod={subscription.hasPaymentMethod}
                    isPro={subscription.isPro}
                    isDisabled={isProcessing}
                  />
                </>
              )}
              
              {step === 'payment' && (
                <PaymentForm 
                  onSubmit={handleSubscribe}
                  onApplePay={handleApplePay}
                  onBack={() => setStep('info')}
                  isProcessing={isProcessing}
                />
              )}
              
              <div className="mt-4 text-center text-xs text-[#E6FFF4]/50">
                By continuing, you agree to our{' '}
                <Link to="/terms-of-service" className="underline hover:text-[#E6FFF4]/80" onClick={() => onClose()}>
                  Terms of Service
                </Link>{' '}
                and{' '}
                <Link to="/privacy-policy" className="underline hover:text-[#E6FFF4]/80" onClick={() => onClose()}>
                  Privacy Policy
                </Link>
              </div>
            </div>
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  );
};

export default SubscriptionDialog;
