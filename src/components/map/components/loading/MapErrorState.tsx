
import React from 'react';
import { AlertTriangle, RefreshCw, ExternalLink, HelpCircle } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { toast } from '@/hooks/use-toast';
import { useMapStore } from '../../stores/useMapStore';

interface MapErrorStateProps {
  errorMessage: string;
  retryAttempts: number;
  onRetry: () => void;
}

const MapErrorState: React.FC<MapErrorStateProps> = ({
  errorMessage,
  retryAttempts,
  onRetry
}) => {
  // Extract token error if this is a token-related issue
  const isTokenError = errorMessage.toLowerCase().includes('token') || 
                       errorMessage.toLowerCase().includes('access') ||
                       errorMessage.toLowerCase().includes('unauthorized') ||
                       errorMessage.toLowerCase().includes('not authorized');
                       
  const isNetworkError = errorMessage.toLowerCase().includes('network') ||
                        errorMessage.toLowerCase().includes('connection') ||
                        errorMessage.toLowerCase().includes('offline');
                        
  const handleShowHelp = () => {
    toast({
      title: "Map Troubleshooting",
      description: isTokenError ? 
        "Get a free token at mapbox.com or try another browser if issues persist." :
        "Try clearing browser cache or using a different browser if issues persist.",
      duration: 5000,
    });
  };
  
  return (
    <div className="absolute inset-0 bg-black/90 flex items-center justify-center z-20">
      <div className="bg-black/70 border border-red-500/50 rounded-lg p-6 max-w-md text-center">
        <AlertTriangle className="h-12 w-12 text-red-500 mx-auto mb-4" />
        <h3 className="text-red-500 text-xl font-semibold mb-2">Map Error</h3>
        <div className="text-white/80 mb-4">
          {isTokenError ? (
            <p>You may have provided an invalid Mapbox access token. See{' '}
              <a 
                href="https://docs.mapbox.com/api/overview/#access-tokens-and-token-scopes"
                target="_blank"
                rel="noopener noreferrer"
                className="text-blue-400 underline"
              >
                Mapbox documentation
              </a>
            </p>
          ) : (
            <p>{errorMessage}</p>
          )}
          
          {isTokenError && (
            <div className="mt-3 text-sm text-white/60">
              <p className="mb-2">The default token might not be working. You can provide your own token below.</p>
              <a 
                href="https://account.mapbox.com/access-tokens/" 
                target="_blank" 
                rel="noopener noreferrer"
                className="inline-flex items-center text-blue-400 hover:text-blue-300"
              >
                <ExternalLink className="h-3 w-3 mr-1" />
                Get a free Mapbox token
              </a>
            </div>
          )}
          
          {isNetworkError && (
            <div className="mt-3 text-sm text-white/60">
              <p className="mb-2">Check your internet connection and make sure Mapbox services are accessible.</p>
            </div>
          )}
        </div>
        
        <div className="flex flex-col gap-2">
          <button 
            onClick={onRetry}
            className="bg-red-500 hover:bg-red-600 text-white font-semibold py-2 px-6 rounded-md flex items-center justify-center mx-auto"
          >
            <RefreshCw className="h-4 w-4 mr-2" /> 
            {retryAttempts >= 2 ? "Try Alternative Token" : "Retry Map Load"}
          </button>
          
          <button 
            onClick={handleShowHelp}
            className="bg-transparent border border-white/20 hover:bg-white/10 text-white/70 font-medium py-2 px-6 rounded-md flex items-center justify-center mx-auto"
          >
            <HelpCircle className="h-4 w-4 mr-2" /> 
            Troubleshooting Help
          </button>
        </div>
        
        {retryAttempts > 0 && (
          <p className="mt-4 text-xs text-white/60">
            Retry attempt {retryAttempts}/3. {retryAttempts >= 2 ? "Trying alternate Mapbox token." : "Trying different token."}
          </p>
        )}
      </div>
    </div>
  );
};

export default MapErrorState;
