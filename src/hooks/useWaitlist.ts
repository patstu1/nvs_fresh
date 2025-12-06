
import { create } from 'zustand';
import { useAuth } from './useAuth';
import { WaitlistStatus } from '@/types/WaitlistTypes';
import { useEffect } from 'react';
import { supabase } from '@/integrations/supabase/client';
import { toast } from './use-toast';
import { analytics } from '@/services/analytics';

interface WaitlistState {
  isWaitlistActive: boolean;
  userStatus: WaitlistStatus;
  position: number;
  estimatedWaitTime: string;
  referralCount: number;
  referralCode: string;
  isLoading: boolean;
  error: string | null;
  
  // Action methods
  checkWaitlistStatus: () => Promise<WaitlistStatus>;
  generateReferralCode: () => void;
  toggleWaitlist: (active: boolean) => void; // Admin only
  approveUser: (userId: string) => void; // Admin only
  getAdminWaitlistStats: () => Promise<any>; // Admin only
}

export const useWaitlistStore = create<WaitlistState>((set, get) => ({
  isWaitlistActive: true, // Default to active
  userStatus: 'pending',
  position: 0,
  estimatedWaitTime: '2-3 weeks',
  referralCount: 0,
  referralCode: '',
  isLoading: false,
  error: null,
  
  checkWaitlistStatus: async () => {
    set({ isLoading: true, error: null });
    
    try {
      // In a real implementation, this would fetch from Supabase
      // For now, simulate a network call with a timeout
      await new Promise(resolve => setTimeout(resolve, 500));
      
      // Simulate different statuses for testing (80% pending, 20% approved)
      const randomStatus: WaitlistStatus = Math.random() > 0.8 ? 'approved' : 'pending';
      
      // Generate a random position between 100-5000
      const randomPosition = Math.floor(Math.random() * 4900) + 100;
      
      set({ 
        userStatus: randomStatus,
        position: randomPosition,
        isLoading: false,
      });
      
      return randomStatus;
    } catch (error) {
      console.error('Error checking waitlist status:', error);
      set({ 
        error: 'Failed to check waitlist status. Please try again.',
        isLoading: false 
      });
      return 'pending';
    }
  },
  
  generateReferralCode: () => {
    // Generate a unique referral code
    const characters = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    let result = 'YB-';
    for (let i = 0; i < 6; i++) {
      result += characters.charAt(Math.floor(Math.random() * characters.length));
    }
    set({ referralCode: result });
  },
  
  toggleWaitlist: (active: boolean) => {
    // Admin only function
    set({ isWaitlistActive: active });
    toast({
      title: active ? "Waitlist activated" : "Waitlist deactivated",
      description: active ? "All new users will be waitlisted" : "New users will get immediate access",
    });
  },
  
  approveUser: (userId: string) => {
    // Admin only function - would call a Supabase function
    toast({
      title: "User approved",
      description: `User ${userId} has been approved and notified`,
    });
    
    analytics.trackEvent('admin_action', {
      action: 'approve_user',
      user_id: userId
    });
  },
  
  getAdminWaitlistStats: async () => {
    // Admin only function
    try {
      // Mock data - would be real data from Supabase
      return {
        totalWaitlisted: 12453,
        approvedToday: 250,
        topLocations: [
          { city: "New York", count: 2341 },
          { city: "Los Angeles", count: 1876 },
          { city: "Chicago", count: 943 },
        ],
        referralStats: {
          totalReferrals: 4231,
          conversionRate: "23%"
        }
      };
    } catch (error) {
      console.error('Error fetching admin stats:', error);
      throw new Error('Could not fetch waitlist stats');
    }
  }
}));

export const useWaitlist = () => {
  const { user } = useAuth();
  const waitlistStore = useWaitlistStore();
  
  // Check waitlist status whenever the user changes
  useEffect(() => {
    if (user && user.id) {
      waitlistStore.checkWaitlistStatus();
      
      // Generate referral code if none exists
      if (!waitlistStore.referralCode) {
        waitlistStore.generateReferralCode();
      }
    }
  }, [user, waitlistStore]);
  
  return waitlistStore;
};
