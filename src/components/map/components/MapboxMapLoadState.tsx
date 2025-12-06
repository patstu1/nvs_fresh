
import React, { useState, useEffect } from 'react';
import MapLoadingState from './MapLoadingState';
import { useMapStore } from '../stores/useMapStore';
import MapErrorState from './loading/MapErrorState';

interface MapboxMapLoadStateProps {
  onRetry: () => void;
}

const MapboxMapLoadState: React.FC<MapboxMapLoadStateProps> = ({ onRetry }) => {
  const [loadingDuration, setLoadingDuration] = useState<number>(0);
  const mapStatus = useMapStore(state => state.status);
  const mapError = useMapStore(state => state.error);
  const retryCount = useMapStore(state => state.retryCount);
  
  useEffect(() => {
    let timer: NodeJS.Timeout;
    
    if (mapStatus === 'loading') {
      // Start counting loading time
      const startTime = Date.now();
      
      timer = setInterval(() => {
        const elapsed = Math.floor((Date.now() - startTime) / 1000);
        setLoadingDuration(elapsed);
      }, 1000);
    }
    
    return () => {
      if (timer) clearInterval(timer);
    };
  }, [mapStatus]);

  if (mapStatus === 'error' && mapError) {
    return (
      <div className="absolute inset-0 z-20 bg-black">
        <MapErrorState 
          errorMessage={mapError}
          retryAttempts={retryCount}
          onRetry={onRetry}
        />
      </div>
    );
  }

  if (mapStatus !== 'loading') {
    return null;
  }

  return (
    <div className="absolute inset-0 z-20 bg-black">
      <MapLoadingState 
        message="Connecting to nearby users..."
        loadingDuration={loadingDuration}
        onRetry={loadingDuration > 10 ? onRetry : undefined}
      />
    </div>
  );
};

export default MapboxMapLoadState;
