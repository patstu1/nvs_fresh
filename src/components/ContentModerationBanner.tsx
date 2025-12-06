
import React from 'react';
import { Shield, AlertTriangle } from 'lucide-react';

interface ContentModerationBannerProps {
  variant?: 'warning' | 'info';
  message?: string;
}

const ContentModerationBanner: React.FC<ContentModerationBannerProps> = ({ 
  variant = 'warning',
  message
}) => {
  const defaultWarningMessage = "Drug use and solicitation are strictly prohibited during video calls and in Zoom rooms.";
  const displayMessage = message || defaultWarningMessage;
  
  return (
    <div className={`p-2 px-4 flex items-center text-sm ${
      variant === 'warning' 
        ? 'bg-red-900/70 text-white' 
        : 'bg-blue-900/70 text-white'
    }`}>
      {variant === 'warning' ? (
        <Shield className="h-4 w-4 mr-2 flex-shrink-0" />
      ) : (
        <AlertTriangle className="h-4 w-4 mr-2 flex-shrink-0" />
      )}
      <p>{displayMessage}</p>
    </div>
  );
};

export default ContentModerationBanner;
