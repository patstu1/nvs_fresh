
import React, { useEffect } from 'react';
import { Navigate, useLocation } from 'react-router-dom';
import { useAuth } from '@/hooks/useAuth';
import { useUserSession } from '@/hooks/useUserSession';
import { useAnalytics } from '@/hooks/useAnalytics';
import LoadingScreen from '@/components/LoadingScreen';

export const ProtectedRoute = ({ children }: { children: React.ReactNode }) => {
  const { user, loading } = useAuth();
  const { hasCompletedSetup } = useUserSession();
  const location = useLocation();
  const analytics = useAnalytics();
  
  useEffect(() => {
    if (!user && !loading) {
      analytics.trackEvent('access_denied', { path: location.pathname });
    }
  }, [user, loading, location, analytics]);
  
  if (loading) {
    return <LoadingScreen isLoading={true} />;
  }
  
  if (!user) {
    return <Navigate to="/auth" state={{ from: location.pathname }} replace />;
  }
  
  if (!hasCompletedSetup && 
      !location.pathname.includes('/profile-setup') && 
      !location.pathname.includes('/onboarding') &&
      !location.pathname.includes('/waitlist')) {
    return <Navigate to="/profile-setup" replace />;
  }
  
  return <>{children}</>;
};
