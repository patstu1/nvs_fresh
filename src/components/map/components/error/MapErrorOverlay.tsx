
import React from 'react';
import { Button } from '@/components/ui/button';
import { AlertTriangle } from 'lucide-react';

interface MapErrorOverlayProps {
  error: string;
  onRetry?: () => void;
}

export const MapErrorOverlay: React.FC<MapErrorOverlayProps> = ({ error, onRetry }) => (
  <div className="absolute inset-0 bg-black/90 flex items-center justify-center z-20 p-4">
    <div className="bg-black/70 border border-red-500/50 rounded-lg p-6 max-w-md text-center">
      <AlertTriangle className="h-12 w-12 text-red-500 mx-auto mb-4" />
      <h3 className="text-red-500 text-xl font-semibold mb-2">Map Error</h3>
      <p className="text-white/80 mb-4">{error}</p>
      {onRetry && (
        <Button 
          onClick={onRetry}
          className="bg-red-500 hover:bg-red-600 text-white font-semibold"
        >
          Try Again
        </Button>
      )}
      <div className="mt-4 text-xs text-white/60">
        <p>Try refreshing the page or providing a valid Mapbox token if the issue persists.</p>
      </div>
    </div>
  </div>
);
