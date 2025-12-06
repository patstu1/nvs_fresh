
import { useEffect } from 'react';
import { useLocation } from 'react-router-dom';
import { isMobileApp } from '@/utils/mobileConfig';

type EventType = 'page_view' | 'user_action' | 'error' | 'access_denied' | 'feature_usage';

type AnalyticsEvent = {
  name: EventType;
  properties?: Record<string, any>;
  timestamp?: number;
};

// Simple in-memory analytics for now
const analyticsQueue: AnalyticsEvent[] = [];

export const useAnalytics = () => {
  const location = useLocation();
  const isRunningOnMobile = isMobileApp();
  
  // Track page views
  useEffect(() => {
    trackPageView(location.pathname);
    
    // Log initial device information
    if (isRunningOnMobile) {
      trackEvent('feature_usage', { 
        feature: 'mobile_app_session',
        userAgent: navigator.userAgent
      });
    }
  }, [location.pathname, isRunningOnMobile]);
  
  const trackPageView = (path: string) => {
    analyticsQueue.push({
      name: 'page_view',
      properties: { path },
      timestamp: Date.now()
    });
    
    console.log(`[Analytics] Page view: ${path}`);
  };
  
  const trackEvent = (name: EventType, properties?: Record<string, any>) => {
    analyticsQueue.push({
      name,
      properties,
      timestamp: Date.now()
    });
    
    console.log(`[Analytics] Event: ${name}`, properties);
  };
  
  return {
    trackPageView,
    trackEvent
  };
};
