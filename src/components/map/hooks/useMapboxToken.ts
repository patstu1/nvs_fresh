
import { useState, useEffect, useCallback } from 'react';
import { toast } from '@/hooks/use-toast';

interface UseMapboxTokenReturn {
  token: string | null;
  setToken: (newToken: string) => void;
  isTokenValid: boolean;
  handleTokenSubmit: (inputToken: string) => void;
  resetToDefaultToken: () => void;
  clearToken: () => void;
  handleSkip: () => void;  // Added this missing property
}

export const useMapboxToken = (): UseMapboxTokenReturn => {
  const [token, setTokenState] = useState<string | null>(null);
  const [isTokenValid, setIsTokenValid] = useState<boolean>(false);

  // Default fallback tokens (in case user doesn't provide one)
  const defaultTokens = [
    'pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4M29iazA2Z2gycXA4N2pmbDZmangifQ.-g_vE53SD2WrJ6tFX7QHmA',
    'pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw'
  ];

  const setToken = useCallback((newToken: string) => {
    if (!newToken) return;
    
    try {
      // Store token in local storage for persistence
      localStorage.setItem('mapbox_token', newToken);
    } catch (e) {
      console.warn('Could not store token in localStorage:', e);
    }
    
    setTokenState(newToken);
    setIsTokenValid(true);
    
    console.log(`Token set: ${newToken.substring(0, 5)}...`);
  }, []);
  
  const clearToken = useCallback(() => {
    try {
      localStorage.removeItem('mapbox_token');
    } catch (e) {
      console.warn('Could not remove token from localStorage:', e);
    }
    
    setTokenState(null);
    setIsTokenValid(false);
    
    console.log('Token cleared');
  }, []);
  
  const resetToDefaultToken = useCallback(() => {
    // Try a fallback token
    const fallbackToken = defaultTokens[Math.floor(Math.random() * defaultTokens.length)];
    setToken(fallbackToken);
    
    toast({
      title: "Using Default Token",
      description: "Using a default Mapbox token with limited functionality",
    });
    
    console.log('Reset to default token');
  }, [setToken, defaultTokens]);

  const validateToken = useCallback((tokenToValidate: string): boolean => {
    if (!tokenToValidate || tokenToValidate.trim() === '') return false;
    
    // Mapbox tokens start with pk. for public tokens
    if (!tokenToValidate.startsWith('pk.')) {
      console.warn('Token may not be valid - should start with pk.');
      // We'll still allow it to try
    }
    
    return true;
  }, []);
  
  const handleTokenSubmit = useCallback((inputToken: string) => {
    if (!validateToken(inputToken)) {
      toast({
        title: "Invalid Token",
        description: "Please provide a valid Mapbox token",
        variant: "destructive"
      });
      return;
    }
    
    setToken(inputToken);
    
    toast({
      title: "Token Saved",
      description: "Mapbox token has been saved",
      variant: "default"
    });
  }, [validateToken, setToken]);
  
  // Handle skip button functionality
  const handleSkip = useCallback(() => {
    resetToDefaultToken();
    toast({
      title: "Skipped",
      description: "Using a default token instead",
    });
  }, [resetToDefaultToken]);
  
  // Initialize from localStorage on mount
  useEffect(() => {
    try {
      const storedToken = localStorage.getItem('mapbox_token');
      if (storedToken) {
        setToken(storedToken);
      }
    } catch (e) {
      console.warn('Could not retrieve token from localStorage:', e);
    }
  }, [setToken]);

  return {
    token,
    setToken,
    isTokenValid,
    handleTokenSubmit,
    resetToDefaultToken,
    clearToken,
    handleSkip
  };
};
