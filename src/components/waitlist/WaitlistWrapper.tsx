
import React from 'react';
import { Navigate } from 'react-router-dom';
import { useAuth } from '@/hooks/useAuth';
import { useWaitlist } from '@/hooks/useWaitlist';
import LoadingScreen from '@/components/LoadingScreen';

interface WaitlistWrapperProps {
  children: React.ReactNode;
}

const WaitlistWrapper: React.FC<WaitlistWrapperProps> = ({ children }) => {
  const { user, loading } = useAuth();
  const { userStatus, isLoading, isWaitlistActive } = useWaitlist();
  
  if (loading || isLoading) {
    return <LoadingScreen isLoading={true} />;
  }
  
  // If not logged in, redirect to auth
  if (!user) {
    return <Navigate to="/auth" replace />;
  }
  
  // If waitlist is deactivated, show children directly
  if (!isWaitlistActive) {
    return <>{children}</>;
  }
  
  // If user is not approved and waitlist is active, redirect to waitlist screen
  if (userStatus === 'pending') {
    return <Navigate to="/waitlist" replace />;
  }
  
  // User is approved or has early access, show children
  return <>{children}</>;
};

export default WaitlistWrapper;
