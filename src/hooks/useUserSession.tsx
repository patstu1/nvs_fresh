
import { useState, useEffect, useContext, createContext, useCallback } from 'react';

// Define interfaces for better type support
export interface SubscriptionInfo {
  isPro: boolean;
  hasPaymentMethod: boolean;
  trialEndDate: Date | null;
  subscriptionEndDate: Date | null;
}

export interface UserSessionState {
  hasCompletedSetup: boolean;
  profile: any; // We'll define a proper type later
  subscription: SubscriptionInfo;
  updateSession: (newProfile: any) => void;
  completeProfileSetup: () => void;
  activateSubscription: (months: number) => void;
  cancelSubscription: () => void;
  isCheckingAuth: boolean;
}

const UserSessionContext = createContext<UserSessionState | undefined>(undefined);

export const UserSessionProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [hasCompletedSetup, setHasCompletedSetup] = useState<boolean>(false);
  const [profile, setProfile] = useState<any>(null);
  const [isCheckingAuth, setIsCheckingAuth] = useState<boolean>(true);
  const [subscription, setSubscription] = useState<SubscriptionInfo>({
    isPro: false,
    hasPaymentMethod: false,
    trialEndDate: null,
    subscriptionEndDate: null,
  });

  useEffect(() => {
    const loadUserData = async () => {
      try {
        setIsCheckingAuth(true);
        const storedOnboardingStatus = localStorage.getItem('onboardingCompleted');
        const storedProfile = localStorage.getItem('userProfile');
        const storedSubscription = localStorage.getItem('userSubscription');

        if (storedOnboardingStatus === 'true') {
          setHasCompletedSetup(true);
        }

        if (storedProfile) {
          try {
            setProfile(JSON.parse(storedProfile));
          } catch (error) {
            console.error("Error parsing user profile from localStorage:", error);
            // In case of parsing error, reset the profile
            localStorage.removeItem('userProfile');
          }
        }

        if (storedSubscription) {
          try {
            const parsedSubscription = JSON.parse(storedSubscription);
            // Convert date strings back to Date objects
            if (parsedSubscription.trialEndDate) {
              parsedSubscription.trialEndDate = new Date(parsedSubscription.trialEndDate);
            }
            if (parsedSubscription.subscriptionEndDate) {
              parsedSubscription.subscriptionEndDate = new Date(parsedSubscription.subscriptionEndDate);
            }
            setSubscription(parsedSubscription);
          } catch (error) {
            console.error("Error parsing user subscription from localStorage:", error);
            // In case of parsing error, reset the subscription
            localStorage.removeItem('userSubscription');
          }
        }
      } finally {
        // Simulate a network delay for better UX
        setTimeout(() => {
          setIsCheckingAuth(false);
        }, 500);
      }
    };

    loadUserData();
  }, []);

  const updateSession = useCallback((newProfile: any) => {
    setProfile(newProfile);
    localStorage.setItem('userProfile', JSON.stringify(newProfile));
    setHasCompletedSetup(true);
    localStorage.setItem('onboardingCompleted', 'true');
    console.log("Profile setup completed via updateSession");
  }, []);

  const completeProfileSetup = useCallback(() => {
    setHasCompletedSetup(true);
    localStorage.setItem('onboardingCompleted', 'true');
    console.log("Profile setup completed via completeProfileSetup");
  }, []);

  const activateSubscription = useCallback((months: number) => {
    const now = new Date();
    const trialEnd = new Date(now);
    trialEnd.setDate(trialEnd.getDate() + 7); // 7-day trial

    const subscriptionEnd = new Date(now);
    subscriptionEnd.setMonth(subscriptionEnd.getMonth() + months);
    
    const newSubscription: SubscriptionInfo = {
      isPro: true,
      hasPaymentMethod: true,
      trialEndDate: trialEnd,
      subscriptionEndDate: subscriptionEnd,
    };

    setSubscription(newSubscription);
    localStorage.setItem('userSubscription', JSON.stringify(newSubscription));
    
    // Show an in-app notification or trigger an event for analytics
    console.log(`Subscription activated for ${months} months`);
  }, []);

  const cancelSubscription = useCallback(() => {
    const now = new Date();
    const subscriptionEnd = new Date(now);
    subscriptionEnd.setMonth(now.getMonth() + 1); // Keep access for 1 month after cancellation
    
    const newSubscription: SubscriptionInfo = {
      ...subscription,
      subscriptionEndDate: subscriptionEnd,
    };

    setSubscription(newSubscription);
    localStorage.setItem('userSubscription', JSON.stringify(newSubscription));
  }, [subscription]);

  const value: UserSessionState = {
    hasCompletedSetup,
    profile,
    subscription,
    updateSession,
    completeProfileSetup,
    activateSubscription,
    cancelSubscription,
    isCheckingAuth
  };

  return (
    <UserSessionContext.Provider value={value}>
      {children}
    </UserSessionContext.Provider>
  );
};

export const useUserSession = () => {
  const context = useContext(UserSessionContext);
  if (context === undefined) {
    throw new Error('useUserSession must be used within a UserSessionProvider');
  }
  return context;
};
