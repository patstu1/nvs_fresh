
import React from 'react';
import { Navigate, useLocation } from 'react-router-dom';
import { useAuth } from '@/hooks/useAuth';
import { useUserSession } from '@/hooks/useUserSession';
import LoadingScreen from '@/components/LoadingScreen';

export const AuthRoute = ({ children }: { children: React.ReactNode }) => {
  const { user, loading } = useAuth();
  const { hasCompletedSetup } = useUserSession();
  const location = useLocation();
  const from = location.state?.from || '/';
  
  if (loading) {
    return <LoadingScreen isLoading={true} />;
  }
  
  if (user) {
    if (!hasCompletedSetup) {
      return <Navigate to="/profile-setup" replace />;
    }
    return <Navigate to={from} replace />;
  }
  
  return <>{children}</>;
};
