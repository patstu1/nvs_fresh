
import React, { useState } from 'react';
import { ArrowLeft, Crown, Shield, Zap, Users, Video, MessageCircle, CreditCard } from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import SubscriptionStatus from '@/components/subscription/SubscriptionStatus';
import SubscriptionDialog from '@/components/subscription/SubscriptionDialog';
import { useUserSession } from '@/hooks/useUserSession';

const Subscription: React.FC = () => {
  const navigate = useNavigate();
  const { subscription } = useUserSession();
  const [showDialog, setShowDialog] = useState(false);
  
  return (
    <div className="min-h-screen bg-black text-[#E6FFF4] pb-20">
      {/* Header */}
      <div className="fixed top-0 left-0 right-0 bg-[#1A1A1A] z-10">
        <div className="flex items-center px-4 py-3">
          <button onClick={() => navigate(-1)} className="mr-3">
            <ArrowLeft className="w-6 h-6" />
          </button>
          <h1 className="text-xl font-semibold">YO BRO PRO</h1>
        </div>
      </div>
      
      <div className="pt-16 px-4">
        {/* Current subscription status */}
        <SubscriptionStatus showManageButton className="mb-6" />
        
        {/* Pro features */}
        <div className="bg-[#1A1A1A] rounded-lg border border-[#E6FFF4]/20 p-5 mb-6">
          <h2 className="flex items-center gap-2 text-xl font-semibold mb-4">
            <Crown className="w-6 h-6 text-[#E6FFF4]" />
            <span>YO BRO PRO Benefits</span>
          </h2>
          
          <div className="space-y-4">
            <div className="flex items-start gap-3">
              <Zap className="w-5 h-5 text-[#E6FFF4] mt-0.5" />
              <div>
                <h3 className="font-medium">AI Connect Matching</h3>
                <p className="text-sm text-[#E6FFF4]/70">
                  Our advanced AI matches you with compatible bros
                </p>
              </div>
            </div>
            
            <div className="flex items-start gap-3">
              <Video className="w-5 h-5 text-[#E6FFF4] mt-0.5" />
              <div>
                <h3 className="font-medium">Unlimited Video Calls</h3>
                <p className="text-sm text-[#E6FFF4]/70">
                  Video chat with bros and join group rooms anytime
                </p>
              </div>
            </div>
            
            <div className="flex items-start gap-3">
              <Users className="w-5 h-5 text-[#E6FFF4] mt-0.5" />
              <div>
                <h3 className="font-medium">Unlimited Profiles</h3>
                <p className="text-sm text-[#E6FFF4]/70">
                  Browse without limits and discover more bros
                </p>
              </div>
            </div>
            
            <div className="flex items-start gap-3">
              <MessageCircle className="w-5 h-5 text-[#E6FFF4] mt-0.5" />
              <div>
                <h3 className="font-medium">Unlimited Messaging</h3>
                <p className="text-sm text-[#E6FFF4]/70">
                  No restrictions on how many bros you can message
                </p>
              </div>
            </div>
            
            <div className="flex items-start gap-3">
              <Shield className="w-5 h-5 text-[#E6FFF4] mt-0.5" />
              <div>
                <h3 className="font-medium">Ad-Free Experience</h3>
                <p className="text-sm text-[#E6FFF4]/70">
                  No advertisements or interruptions
                </p>
              </div>
            </div>
          </div>
        </div>
        
        {/* Pricing box */}
        <div className="bg-[#1A1A1A] rounded-lg border border-[#E6FFF4]/20 p-5 mb-8">
          <div className="text-center mb-4">
            <div className="text-2xl font-bold mb-1">$19.99<span className="text-sm font-normal text-[#E6FFF4]/70">/month</span></div>
            <p className="text-sm text-[#E6FFF4]/70">Cancel anytime. No contracts.</p>
          </div>
          
          <div className="bg-[#252525] rounded-lg p-3 text-center mb-4 flex items-center justify-center gap-2">
            <CreditCard className="w-4 h-4 text-[#4CAF50]" />
            <p className="text-sm">New users get <span className="font-semibold text-[#4CAF50]">3 months free</span> with a valid card</p>
          </div>
          
          {!subscription.hasPaymentMethod && (
            <button
              onClick={() => setShowDialog(true)}
              className="w-full bg-[#E6FFF4] text-black py-3 rounded-lg font-semibold hover:bg-white transition-colors"
            >
              Start Free Trial
            </button>
          )}
          
          {subscription.hasPaymentMethod && !subscription.isPro && (
            <button
              onClick={() => setShowDialog(true)}
              className="w-full bg-[#E6FFF4] text-black py-3 rounded-lg font-semibold hover:bg-white transition-colors"
            >
              Add Payment Method
            </button>
          )}
          
          {subscription.isPro && (
            <div className="text-center text-sm text-[#E6FFF4]/70">
              You're currently on the YO BRO PRO plan
            </div>
          )}
        </div>
        
        {/* FAQ */}
        <div className="mb-8">
          <h2 className="text-xl font-semibold mb-4">Frequently Asked Questions</h2>
          
          <div className="space-y-4">
            <div>
              <h3 className="font-medium mb-1">How does the free trial work?</h3>
              <p className="text-sm text-[#E6FFF4]/70">
                All new users get 3 months of YO BRO PRO for free after adding a valid payment method. You won't be charged until the trial ends.
              </p>
            </div>
            
            <div>
              <h3 className="font-medium mb-1">When will I be charged?</h3>
              <p className="text-sm text-[#E6FFF4]/70">
                Your card will only be charged when your 3-month free trial ends. We'll send you a reminder before the first charge.
              </p>
            </div>
            
            <div>
              <h3 className="font-medium mb-1">Can I cancel anytime?</h3>
              <p className="text-sm text-[#E6FFF4]/70">
                Yes, you can cancel your subscription at any time without penalties. If you cancel during the trial, you won't be charged at all.
              </p>
            </div>
            
            <div>
              <h3 className="font-medium mb-1">Is my payment information secure?</h3>
              <p className="text-sm text-[#E6FFF4]/70">
                All payment data is encrypted and securely processed. We never store your full card details on our servers.
              </p>
            </div>
          </div>
        </div>
      </div>
      
      <SubscriptionDialog 
        isOpen={showDialog}
        onClose={() => setShowDialog(false)}
      />
    </div>
  );
};

export default Subscription;
