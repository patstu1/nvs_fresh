
import React, { Component, ErrorInfo, ReactNode } from 'react';
import { analytics } from '@/services/analytics';

interface Props {
  children: ReactNode;
  fallback?: ReactNode;
}

interface State {
  hasError: boolean;
}

class ErrorBoundary extends Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = { hasError: false };
  }

  static getDerivedStateFromError(_: Error): State {
    return { hasError: true };
  }

  componentDidCatch(error: Error, errorInfo: ErrorInfo) {
    // Log error to analytics service
    analytics.trackErrorOccurred('global_error', {
      error: error.toString(),
      componentStack: errorInfo.componentStack
    });

    // Optional: Send error to monitoring service
    console.error('Uncaught error:', error, errorInfo);
  }

  render() {
    if (this.state.hasError) {
      return this.props.fallback || (
        <div className="min-h-screen flex items-center justify-center bg-black text-[#E6FFF4]">
          <div className="text-center">
            <h1 className="text-2xl mb-4">Something went wrong</h1>
            <p>Please try refreshing the page</p>
          </div>
        </div>
      );
    }

    return this.props.children;
  }
}

export default ErrorBoundary;
