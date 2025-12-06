
import React, { useState } from 'react';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from '@/components/ui/dialog';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { toast } from '@/hooks/use-toast';
import { Camera, Upload, X } from 'lucide-react';

interface AnonymousProfileEditorProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  onSave: (data: { name: string; avatar: string }) => void;
}

const AnonymousProfileEditor: React.FC<AnonymousProfileEditorProps> = ({ 
  open, 
  onOpenChange,
  onSave 
}) => {
  const [name, setName] = useState<string>('');
  const [avatarUrl, setAvatarUrl] = useState<string>('');
  const [avatarFile, setAvatarFile] = useState<File | null>(null);
  
  const handleFileUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    
    // For now, just create a local URL
    // In a real app, this would upload to a server/storage
    const url = URL.createObjectURL(file);
    setAvatarUrl(url);
    setAvatarFile(file);
    
    toast({
      title: "Image Selected",
      description: "Your anonymous profile image has been selected.",
    });
  };
  
  const handleSave = () => {
    // In a real app, we would upload the avatar file to a server
    // For now, we'll just use the local URL
    onSave({
      name: name || 'Anonymous',
      avatar: avatarUrl || '/placeholder.svg'
    });
    onOpenChange(false);
  };

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="bg-black border border-[#E6FFF4]/30 text-white max-w-md">
        <DialogHeader>
          <DialogTitle className="text-xl text-center">Set Up Your Cruise Profile</DialogTitle>
        </DialogHeader>
        
        <div className="space-y-4">
          <div>
            <Label htmlFor="name" className="text-[#E6FFF4]">
              Display Name (optional)
            </Label>
            <Input
              id="name"
              value={name}
              onChange={(e) => setName(e.target.value)}
              placeholder="Anonymous"
              className="bg-[#111] border-[#E6FFF4]/30 text-white"
            />
            <p className="text-xs text-[#E6FFF4]/70 mt-1">
              Leave blank to appear as "Anonymous"
            </p>
          </div>
          
          <div>
            <Label className="text-[#E6FFF4] block mb-2">
              Profile Image (can be NSFW)
            </Label>
            
            <div className="flex items-center gap-4">
              <div className="relative w-20 h-20 bg-[#111] rounded-md overflow-hidden flex items-center justify-center border border-[#E6FFF4]/30">
                {avatarUrl ? (
                  <>
                    <img 
                      src={avatarUrl} 
                      alt="Profile" 
                      className="w-full h-full object-cover" 
                    />
                    <button 
                      onClick={() => setAvatarUrl('')}
                      className="absolute top-1 right-1 bg-black/70 rounded-full p-1"
                    >
                      <X size={14} />
                    </button>
                  </>
                ) : (
                  <Camera size={24} className="text-[#E6FFF4]/70" />
                )}
              </div>
              
              <div className="flex-1">
                <Label 
                  htmlFor="avatar-upload"
                  className="flex items-center justify-center w-full h-10 bg-[#111] rounded-md border border-dashed border-[#E6FFF4]/30 text-[#E6FFF4]/70 cursor-pointer hover:bg-[#222] transition-colors"
                >
                  <Upload size={16} className="mr-2" />
                  Select Image
                </Label>
                <input
                  type="file"
                  id="avatar-upload"
                  accept="image/*"
                  onChange={handleFileUpload}
                  className="hidden"
                />
                <p className="text-xs text-[#E6FFF4]/70 mt-1">
                  NSFW images allowed. Will appear blurred to others.
                </p>
              </div>
            </div>
          </div>
        </div>
        
        <DialogFooter className="mt-4">
          <Button 
            onClick={() => onOpenChange(false)}
            variant="outline"
            className="border-[#E6FFF4]/30 text-[#E6FFF4]/80"
          >
            Cancel
          </Button>
          <Button 
            onClick={handleSave}
            className="bg-[#E6FFF4] text-black hover:bg-[#E6FFF4]/90"
          >
            Save Cruise Profile
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
};

export default AnonymousProfileEditor;
