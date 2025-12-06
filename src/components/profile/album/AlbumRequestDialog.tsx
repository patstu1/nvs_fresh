
import React, { useState } from 'react';
import { Dialog, DialogContent } from '@/components/ui/dialog';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { Lock, Send, ImageIcon, X } from 'lucide-react';
import { UserProfile } from '@/types/UserProfile';

interface AlbumRequestDialogProps {
  profile: UserProfile;
  isOpen: boolean;
  onOpenChange: (open: boolean) => void;
  onSendRequest: () => void;
}

const AlbumRequestDialog: React.FC<AlbumRequestDialogProps> = ({
  profile,
  isOpen,
  onOpenChange,
  onSendRequest
}) => {
  const [message, setMessage] = useState('');
  
  const handleSendRequest = () => {
    onSendRequest();
    onOpenChange(false);
  };
  
  return (
    <Dialog open={isOpen} onOpenChange={onOpenChange}>
      <DialogContent className="bg-black border border-gray-800 p-0 overflow-hidden max-w-md">
        <div className="relative bg-gradient-to-b from-gray-900 to-black p-4">
          <Button 
            variant="ghost" 
            size="icon" 
            className="absolute right-2 top-2 text-white p-1 h-auto w-auto rounded-full bg-black/50"
            onClick={() => onOpenChange(false)}
          >
            <X className="h-4 w-4" />
          </Button>
          
          <div className="flex items-center space-x-3 mb-4">
            <Avatar className="h-12 w-12 border-2 border-purple-600">
              <AvatarImage src={profile.image} alt={profile.name} />
              <AvatarFallback>{profile.name[0]}</AvatarFallback>
            </Avatar>
            <div>
              <h3 className="text-white font-bold text-lg">{profile.name}</h3>
              <p className="text-gray-400 text-sm">
                {profile.distance < 1 
                  ? `${Math.round(profile.distance * 1000)}m away` 
                  : `${profile.distance.toFixed(1)}km away`}
              </p>
            </div>
          </div>
          
          <div className="bg-gray-900 rounded-md p-3 mb-4 flex items-center space-x-3">
            <div className="bg-gray-800 p-2 rounded-full">
              <Lock className="h-5 w-5 text-purple-400" />
            </div>
            <div>
              <h4 className="text-white font-medium">Unlock Private Album</h4>
              <p className="text-gray-400 text-xs">
                Request access to {profile.name}'s private photos
              </p>
            </div>
          </div>
          
          <div className="bg-gray-900/50 rounded-md p-3 mb-4">
            <div className="flex gap-2 mb-2">
              <div className="w-16 h-16 bg-gray-800 rounded-md flex items-center justify-center">
                <ImageIcon className="h-6 w-6 text-gray-500" />
              </div>
              <div className="w-16 h-16 bg-gray-800 rounded-md flex items-center justify-center">
                <ImageIcon className="h-6 w-6 text-gray-500" />
              </div>
              <div className="w-16 h-16 bg-gray-800 rounded-md flex items-center justify-center">
                <Lock className="h-6 w-6 text-gray-500" />
              </div>
            </div>
            <p className="text-gray-400 text-xs text-center">
              Previews not available until access is granted
            </p>
          </div>
          
          <div className="relative">
            <Input
              value={message}
              onChange={(e) => setMessage(e.target.value)}
              placeholder="Add a message (optional)"
              className="bg-gray-900/50 border-gray-700 text-white pr-10"
            />
            <Send className="absolute right-3 top-2.5 h-4 w-4 text-gray-400" />
          </div>
          
          <div className="mt-4">
            <Button 
              className="w-full bg-purple-600 text-white hover:bg-purple-700"
              onClick={handleSendRequest}
            >
              Send Request
            </Button>
          </div>
        </div>
      </DialogContent>
    </Dialog>
  );
};

export default AlbumRequestDialog;
