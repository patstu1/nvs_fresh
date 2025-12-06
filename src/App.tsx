
import React, { useState, useEffect, lazy, Suspense } from 'react';
import { Link } from 'react-router-dom';
import './App.css';
import LoadingScreen from './components/LoadingScreen';
import MobileWrapper from './components/MobileWrapper';
import { Toaster } from '@/components/ui/toaster';
import { useAnalytics } from './hooks/useAnalytics';
import { AppProviders } from './components/providers/AppProviders';
import AppRoutes from './routes/AppRoutes';
import { Skeleton } from '@/components/ui/skeleton';
import { Spinner } from '@/components/ui/spinner';

const SubscriptionPrompt = lazy(() => import('./components/index/SubscriptionPrompt'));

const AppContent = () => {
  useAnalytics();
  return null;
};

function App() {
  const [isLoading, setIsLoading] = useState(true);
  const [loadingComplete, setLoadingComplete] = useState(false);
  
  useEffect(() => {
    const hasLoaded = sessionStorage.getItem('app_loaded');
    
    if (hasLoaded) {
      setIsLoading(false);
      setLoadingComplete(true);
    } else {
      const timer = setTimeout(() => {
        setIsLoading(false);
        sessionStorage.setItem('app_loaded', 'true');
      }, 2000);
      
      return () => clearTimeout(timer);
    }
  }, []);
  
  const handleLoadingComplete = () => {
    setLoadingComplete(true);
  };

  return (
    <AppProviders>
      <MobileWrapper>
        <AppContent />
        
        <LoadingScreen 
          isLoading={isLoading} 
          onLoadingComplete={handleLoadingComplete}
        />
        
        {loadingComplete && (
          <>
            <div className="fixed top-4 right-4 z-50">
              <Link 
                to="/deployment-ready" 
                className="bg-[#1A1A1A]/80 backdrop-blur-sm text-[#E6FFF4] px-3 py-1 rounded-full text-xs hover:bg-[#2A2A2A]/80 transition-colors border border-[#E6FFF4]/20"
              >
                Deployment Checklist
              </Link>
            </div>
            <AppRoutes />
            
            <Suspense fallback={
              <div className="fixed bottom-0 w-full h-14 bg-black/80 backdrop-blur-sm flex items-center justify-center">
                <Spinner className="text-[#C2FFE6]" size="sm" />
              </div>
            }>
              <SubscriptionPrompt />
            </Suspense>
          </>
        )}
        
        <Toaster />
      </MobileWrapper>
    </AppProviders>
  );
}

export default App;
