
import React from 'react';
import { BrowserRouter as Router } from 'react-router-dom';
import { MotionConfig } from 'framer-motion';
import { AuthProvider } from '@/hooks/useAuth';
import { UserSessionProvider } from '@/hooks/useUserSession';
import { MediaProvider } from '@/context/MediaContext';
import ErrorBoundary from '@/components/ErrorBoundary';

export const AppProviders = ({ children }: { children: React.ReactNode }) => {
  return (
    <ErrorBoundary>
      <AuthProvider>
        <UserSessionProvider>
          <MediaProvider>
            <MotionConfig reducedMotion="user">
              <Router>
                {children}
              </Router>
            </MotionConfig>
          </MediaProvider>
        </UserSessionProvider>
      </AuthProvider>
    </ErrorBoundary>
  );
};
