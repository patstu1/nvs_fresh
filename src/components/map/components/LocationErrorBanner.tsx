
import React from 'react';
import { AlertCircle } from 'lucide-react';

interface LocationErrorBannerProps {
  locationError: string | null;
}

const LocationErrorBanner: React.FC<LocationErrorBannerProps> = ({ locationError }) => {
  if (!locationError) return null;
  
  return (
    <div className="absolute top-28 left-1/2 transform -translate-x-1/2 z-30">
      <div className="bg-black/80 backdrop-blur-md border-l-4 border-red-500 px-5 py-3 rounded-md shadow-lg animate-in fade-in slide-in-from-top duration-300">
        <div className="flex items-center space-x-3">
          <AlertCircle className="w-5 h-5 text-red-400 flex-shrink-0" />
          <div>
            <p className="text-sm text-red-300 font-medium">
              Location error: <span className="text-red-200">{locationError}</span>
            </p>
            <p className="text-xs text-red-400/70 mt-1">
              The map will use a default location instead
            </p>
          </div>
        </div>
        
        {/* Pulsing glow effect */}
        <div className="absolute inset-0 rounded-md bg-red-500/5 -z-10 animate-pulse" />
      </div>
    </div>
  );
};

export default LocationErrorBanner;
