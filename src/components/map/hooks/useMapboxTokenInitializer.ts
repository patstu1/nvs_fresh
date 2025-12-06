
import { useState, useEffect } from 'react';
import { toast } from '@/hooks/use-toast';

interface MapboxTokenInitializerProps {
  onTokenReady: (token: string) => void;
}

export const useMapboxTokenInitializer = ({ onTokenReady }: MapboxTokenInitializerProps) => {
  const [token, setToken] = useState<string>('');
  const [isShowingTokenInput, setIsShowingTokenInput] = useState(false);

  // Updated primary token - April 2025
  const DEFAULT_TOKEN = 'pk.eyJ1IjoibWFwYm94IiwiYSI6ImNrbXExb2JsazBudmwyd3BpZ294ZW45ZWEifQ.NHcT1SsJz-2jKzg0nZRmig';

  // Backup tokens in case primary fails
  const BACKUP_TOKENS = [
    'pk.eyJ1IjoiZXhhbXBsZXMiLCJhIjoiY2p0MG01OGF0MDBvdTQzanRzNmlmZTJtaiJ9.SEZOFObuwz-L0IziU4DIvg',
    'pk.eyJ1IjoibWFwYm94LWdsLWpzIiwiYSI6ImNrbjg2c3IyZjA5ZXgydnBoOGQxODR1aGwifQ.f3M3vxUVdqJ0yVLZr7rMfw'
  ];

  useEffect(() => {
    const loadToken = async () => {
      try {
        // Check if user has saved a token
        const savedToken = localStorage.getItem('mapbox_token');
        
        if (savedToken) {
          console.log("Using saved Mapbox token");
          setToken(savedToken);
          onTokenReady(savedToken);
          return;
        }
        
        // Otherwise use default token
        console.log("Using default Mapbox token");
        setToken(DEFAULT_TOKEN);
        onTokenReady(DEFAULT_TOKEN);
        
      } catch (error) {
        console.error("Error initializing Mapbox token:", error);
        setIsShowingTokenInput(true);
      }
    };
    
    loadToken();
  }, [onTokenReady]);

  const handleUserProvidedToken = (userToken: string) => {
    if (!userToken) {
      toast({
        title: "Token Required",
        description: "Please enter a valid Mapbox token",
        variant: "destructive"
      });
      return;
    }
    
    // Basic validation - Ensure it's a public token
    if (userToken.startsWith('sk.')) {
      toast({
        title: "Invalid Token Type",
        description: "Please use a public token (starts with 'pk.') not a secret token",
        variant: "destructive"
      });
      return;
    }
    
    // Save token to localStorage
    try {
      localStorage.setItem('mapbox_token', userToken);
      setToken(userToken);
      onTokenReady(userToken);
      setIsShowingTokenInput(false);
      
      toast({
        title: "Token Saved",
        description: "Your Mapbox token has been saved",
      });
    } catch (error) {
      console.error("Error saving token:", error);
      toast({
        title: "Error",
        description: "Could not save token",
        variant: "destructive"
      });
    }
  };

  const handleTokenError = () => {
    // Try each backup token if the current one fails
    const currentIndex = [...BACKUP_TOKENS, DEFAULT_TOKEN].indexOf(token);
    const nextToken = currentIndex === BACKUP_TOKENS.length 
      ? DEFAULT_TOKEN 
      : BACKUP_TOKENS[(currentIndex + 1) % BACKUP_TOKENS.length];
    
    console.log(`Token error, switching to next token option: ${nextToken.substring(0, 10)}...`);
    setToken(nextToken);
    onTokenReady(nextToken);
    
    // If we've tried all options, show the token input
    if (nextToken === DEFAULT_TOKEN && currentIndex !== -1) {
      setIsShowingTokenInput(true);
    }
  };

  return {
    token,
    isShowingTokenInput,
    handleUserProvidedToken,
    handleTokenError,
    showTokenInput: () => setIsShowingTokenInput(true),
    hideTokenInput: () => setIsShowingTokenInput(false)
  };
};
