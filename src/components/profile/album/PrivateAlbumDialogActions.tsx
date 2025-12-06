
import React from 'react';
import { Button } from '@/components/ui/button';

interface PrivateAlbumDialogActionsProps {
  onCancel: () => void;
  onSendRequest: () => void;
}

const PrivateAlbumDialogActions: React.FC<PrivateAlbumDialogActionsProps> = ({ 
  onCancel, 
  onSendRequest 
}) => {
  return (
    <div className="flex justify-between mt-4">
      <Button variant="outline" onClick={onCancel} className="border-[#E6FFF4]/30 text-[#E6FFF4]">
        Cancel
      </Button>
      <Button onClick={onSendRequest} className="bg-[#E6FFF4] text-black">
        Send Request
      </Button>
    </div>
  );
};

export default PrivateAlbumDialogActions;
