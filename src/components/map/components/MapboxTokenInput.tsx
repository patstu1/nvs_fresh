
import React, { useState } from 'react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription } from '@/components/ui/dialog';

interface MapboxTokenInputProps {
  onSubmit: (token: string) => void;
  onSkip?: () => void;
  open: boolean;
}

const MapboxTokenInput: React.FC<MapboxTokenInputProps> = ({ onSubmit, onSkip, open }) => {
  const [token, setToken] = useState('');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    onSubmit(token);
  };

  return (
    <Dialog open={open}>
      <DialogContent className="bg-black/95 border-gray-800 text-white max-w-md">
        <DialogHeader>
          <DialogTitle className="text-xl font-bold text-[#00FFC4]">Mapbox Token Required</DialogTitle>
          <DialogDescription className="text-gray-300">
            The map requires a valid Mapbox token to function properly. Our default tokens may have expired or reached their usage limits.
          </DialogDescription>
        </DialogHeader>
        
        <form onSubmit={handleSubmit} className="space-y-4 mt-4">
          <div className="space-y-2">
            <p className="text-sm text-gray-300 mb-2">
              To get your free token:
            </p>
            <ol className="list-decimal pl-5 mb-4 space-y-1 text-sm text-gray-300">
              <li>Create a free account at <a href="https://www.mapbox.com/signup/" target="_blank" rel="noopener noreferrer" className="text-[#00FFC4] hover:underline">mapbox.com/signup</a></li>
              <li>Go to your Mapbox account dashboard</li>
              <li>Copy your default public token (starts with pk.)</li>
              <li>Paste it below</li>
            </ol>
            <Input
              value={token}
              onChange={(e) => setToken(e.target.value)}
              placeholder="Enter your Mapbox public token (starts with pk.)"
              className="bg-gray-900 border-gray-700 text-white"
              required
            />
          </div>
          
          <div className="flex flex-col sm:flex-row gap-2 pt-2">
            <Button 
              type="submit" 
              className="flex-1 bg-[#00FFC4] hover:bg-[#00EFB4] text-black"
            >
              Save Token
            </Button>
            
            {onSkip && (
              <Button
                type="button"
                variant="outline"
                onClick={onSkip}
                className="flex-1 border-gray-700 text-gray-300 hover:bg-gray-800"
              >
                Try Backup Token
              </Button>
            )}
          </div>
        </form>
      </DialogContent>
    </Dialog>
  );
};

export default MapboxTokenInput;
