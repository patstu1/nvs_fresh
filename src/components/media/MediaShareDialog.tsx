
import React, { useState } from 'react';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from '@/components/ui/dialog';
import { Button } from '@/components/ui/button';
import { MediaItem } from '@/types/MediaTypes';
import { toast } from '@/hooks/use-toast';
import { ScrollArea } from '@/components/ui/scroll-area';

interface MediaShareDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  onConfirm: (userIds: string[]) => void;
  media: MediaItem | null;
}

// Mock contacts data (in a real app, this would come from a user contacts hook/API)
const mockContacts = [
  { id: '1', name: 'Alex', image: 'https://images.unsplash.com/photo-1504257432389-52343af06ae3?w=500&h=500&fit=crop', isOnline: true },
  { id: '2', name: 'Brandon', image: 'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=500&h=500&fit=crop', isOnline: false },
  { id: '3', name: 'Carlos', image: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=500&h=500&fit=crop', isOnline: true },
  { id: '4', name: 'Damon', image: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=500&h=500&fit=crop', isOnline: false },
  { id: '5', name: 'Ethan', image: 'https://images.unsplash.com/photo-1568602471122-7832951cc4c5?w=500&h=500&fit=crop', isOnline: true }
];

const MediaShareDialog: React.FC<MediaShareDialogProps> = ({
  open,
  onOpenChange,
  onConfirm,
  media
}) => {
  const [selectedUsers, setSelectedUsers] = useState<string[]>([]);
  
  const handleToggleUser = (userId: string) => {
    if (selectedUsers.includes(userId)) {
      setSelectedUsers(prev => prev.filter(id => id !== userId));
    } else {
      setSelectedUsers(prev => [...prev, userId]);
    }
  };
  
  const handleConfirm = () => {
    if (selectedUsers.length === 0) {
      toast({
        title: "No users selected",
        description: "Please select at least one user to share with",
        variant: "destructive"
      });
      return;
    }
    
    onConfirm(selectedUsers);
    setSelectedUsers([]);
  };
  
  const handleCancel = () => {
    onOpenChange(false);
    setSelectedUsers([]);
  };
  
  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="bg-[#1A1A1A] border border-[#E6FFF4]/30 text-white">
        <DialogHeader>
          <DialogTitle className="text-[#E6FFF4]">Share Media</DialogTitle>
        </DialogHeader>
        
        {media && (
          <div className="flex justify-center mb-4">
            <img 
              src={media.url} 
              alt="Preview" 
              className="max-h-40 rounded-md object-contain"
            />
          </div>
        )}
        
        <div>
          <h4 className="text-sm text-[#E6FFF4]/70 mb-2">Select users to share with:</h4>
          <ScrollArea className="h-60">
            <div className="space-y-1">
              {mockContacts.map(contact => (
                <div 
                  key={contact.id}
                  onClick={() => handleToggleUser(contact.id)}
                  className={`flex items-center p-2 rounded-md cursor-pointer ${
                    selectedUsers.includes(contact.id) ? 'bg-[#E6FFF4]/10' : 'bg-[#222]'
                  }`}
                >
                  <div className="relative">
                    <img 
                      src={contact.image} 
                      alt={contact.name} 
                      className="w-10 h-10 rounded-full object-cover mr-3" 
                    />
                    {contact.isOnline && (
                      <div className="absolute bottom-0 right-2 w-2.5 h-2.5 bg-green-500 border-2 border-[#1A1A1A] rounded-full"></div>
                    )}
                  </div>
                  <span className="flex-1">{contact.name}</span>
                  <div 
                    className={`w-5 h-5 rounded-full flex items-center justify-center border ${
                      selectedUsers.includes(contact.id) 
                        ? 'bg-[#E6FFF4] text-black border-[#E6FFF4]' 
                        : 'border-[#E6FFF4]/50'
                    }`}
                  >
                    {selectedUsers.includes(contact.id) && '✓'}
                  </div>
                </div>
              ))}
            </div>
          </ScrollArea>
        </div>
        
        <DialogFooter className="space-x-2">
          <Button
            variant="ghost"
            onClick={handleCancel}
            className="border border-[#E6FFF4]/30 text-[#E6FFF4]/70"
          >
            Cancel
          </Button>
          <Button
            onClick={handleConfirm}
            className="bg-[#E6FFF4] text-black hover:bg-[#E6FFF4]/90"
            disabled={selectedUsers.length === 0}
          >
            Share with {selectedUsers.length} {selectedUsers.length === 1 ? 'user' : 'users'}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
};

export default MediaShareDialog;
