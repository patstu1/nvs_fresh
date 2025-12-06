
import React, { useState } from 'react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription } from '@/components/ui/dialog';
import { Compass, ExternalLink, AlertTriangle } from 'lucide-react';
import { toast } from '@/hooks/use-toast';

interface MapTokenInputProps {
  onSubmit: (token: string) => void;
  onSkip?: () => void;
  open: boolean;
  initialToken?: string;
}

const MapTokenInput: React.FC<MapTokenInputProps> = ({ onSubmit, onSkip, open, initialToken = '' }) => {
  const [token, setToken] = useState(initialToken);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [validationError, setValidationError] = useState<string | null>(null);

  const validateToken = (value: string): boolean => {
    setValidationError(null);
    
    if (!value.trim()) {
      setValidationError("Please enter a token");
      return false;
    }
    
    if (value.startsWith('sk.')) {
      setValidationError("Please use a public token (starts with 'pk.') not a secret token");
      return false;
    }
    
    // Basic format check for Mapbox tokens
    if (!value.startsWith('pk.')) {
      setValidationError("Warning: This doesn't look like a valid Mapbox token - tokens usually start with 'pk.'");
      return true; // Still let them try, just warn
    }
    
    return true;
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!validateToken(token)) {
      toast({
        title: "Validation Error",
        description: validationError || "Invalid token format",
        variant: "destructive"
      });
      return;
    }
    
    setIsSubmitting(true);
    
    try {
      // Submit the token
      onSubmit(token);
      
      // Store for future use
      try {
        localStorage.setItem('mapbox_token', token);
      } catch (err) {
        console.warn('Could not save token to localStorage:', err);
      }
      
      toast({
        title: "Token Saved",
        description: "Your Mapbox token has been saved",
        variant: "default"
      });
    } catch (error) {
      console.error("Error submitting token:", error);
      toast({
        title: "Error",
        description: "Could not save token",
        variant: "destructive"
      });
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <Dialog open={open}>
      <DialogContent className="bg-black/95 border-gray-800 text-white max-w-md">
        <DialogHeader>
          <DialogTitle className="text-xl font-bold text-[#00FFC4] flex items-center gap-2">
            <Compass className="h-6 w-6" />
            Mapbox Token Required
          </DialogTitle>
          <DialogDescription className="text-gray-300">
            Get your free Mapbox token to enable the map functionality.
          </DialogDescription>
        </DialogHeader>
        
        <form onSubmit={handleSubmit} className="space-y-4 mt-4">
          <div className="space-y-2">
            <p className="text-sm text-gray-300 mb-2">
              To get your free token:
            </p>
            <ol className="list-decimal pl-5 mb-4 space-y-1 text-sm text-gray-300">
              <li>
                Create a free account at 
                <a 
                  href="https://www.mapbox.com/signup/" 
                  target="_blank" 
                  rel="noopener noreferrer" 
                  className="text-[#00FFC4] hover:underline inline-flex items-center ml-1"
                >
                  mapbox.com/signup
                  <ExternalLink className="h-3 w-3 ml-1" />
                </a>
              </li>
              <li>Go to your Mapbox account dashboard</li>
              <li>Copy your default public token (starts with pk.)</li>
              <li>Paste it below</li>
            </ol>
            <div className="relative">
              <Input
                value={token}
                onChange={(e) => setToken(e.target.value)}
                placeholder="Enter your Mapbox public token (starts with pk.)"
                className="bg-gray-900 border-gray-700 text-white pr-10"
              />
              {token && token.startsWith('pk.') && (
                <span className="absolute right-3 top-2.5 text-green-500">✓</span>
              )}
            </div>
            
            {validationError && (
              <div className="flex items-center gap-2 text-amber-500 text-xs mt-1">
                <AlertTriangle className="h-3 w-3" />
                <span>{validationError}</span>
              </div>
            )}
          </div>
          
          <div className="flex flex-col sm:flex-row gap-2 pt-2">
            <Button 
              type="submit" 
              className="flex-1 bg-[#00FFC4] hover:bg-[#00EFB4] text-black"
              disabled={!token || isSubmitting}
            >
              {isSubmitting ? "Saving..." : "Save Token"}
            </Button>
            
            {onSkip && (
              <Button
                type="button"
                variant="outline"
                onClick={onSkip}
                className="flex-1 border-gray-700 text-gray-300 hover:bg-gray-800"
                disabled={isSubmitting}
              >
                Continue Without Map
              </Button>
            )}
          </div>
        </form>
      </DialogContent>
    </Dialog>
  );
};

export default MapTokenInput;
