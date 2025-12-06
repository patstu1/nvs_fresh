
// Simple analytics service with basic tracking capabilities

interface TrackingEvent {
  name: string;
  properties?: Record<string, any>;
}

class AnalyticsService {
  private isInitialized = false;
  
  init() {
    if (this.isInitialized) return;
    
    try {
      console.log('Analytics service initialized');
      this.isInitialized = true;
      
      // Track page view on initialization
      this.trackPageView();
      
      // Add listeners for app visibility changes to track session time
      document.addEventListener('visibilitychange', () => {
        if (document.visibilityState === 'hidden') {
          this.trackEvent('app_background');
        } else {
          this.trackEvent('app_foreground');
        }
      });
      
    } catch (error) {
      console.error('Failed to initialize analytics service:', error);
    }
  }
  
  trackEvent(eventName: string, properties?: Record<string, any>) {
    if (!this.isInitialized) this.init();
    
    try {
      console.log(`Analytics event tracked: ${eventName}`, properties);
      // In a production app, you would send this to your analytics service
    } catch (error) {
      console.error(`Failed to track event ${eventName}:`, error);
    }
  }
  
  trackPageView(path?: string) {
    const currentPath = path || window.location.pathname;
    this.trackEvent('page_view', { path: currentPath });
  }
  
  trackFeatureUsage(featureName: string, section?: string) {
    this.trackEvent('feature_used', { 
      feature: featureName,
      section: section || 'unknown'
    });
  }
  
  trackProfileView(profileId: string) {
    this.trackEvent('profile_view', { profileId });
  }
  
  trackYoSent(recipientId: string) {
    this.trackEvent('yo_sent', { recipientId });
  }
  
  trackSubscriptionView() {
    this.trackEvent('subscription_view');
  }
  
  trackErrorOccurred(errorName: string, errorDetails?: any) {
    this.trackEvent('error_occurred', { 
      errorName, 
      details: errorDetails 
    });
  }
  
  trackUserLogin(method: string) {
    this.trackEvent('user_login', { method });
  }
  
  trackUserRegistration(method: string) {
    this.trackEvent('user_registration', { method });
  }
}

// Export singleton instance
export const analytics = new AnalyticsService();
