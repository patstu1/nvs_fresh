
import { useState, useEffect } from 'react';

export const useMapboxState = () => {
  const [initializing, setInitializing] = useState(true);
  const [loadStartTime] = useState(Date.now());
  const [loadDuration, setLoadDuration] = useState(0);
  const [retryAttempts, setRetryAttempts] = useState(0);

  // Update loading duration counter
  useEffect(() => {
    const timer = setInterval(() => {
      setLoadDuration(Math.floor((Date.now() - loadStartTime) / 1000));
    }, 1000);
    
    return () => clearInterval(timer);
  }, [loadStartTime]);

  return {
    initializing,
    setInitializing,
    loadDuration,
    retryAttempts,
    setRetryAttempts
  };
};
