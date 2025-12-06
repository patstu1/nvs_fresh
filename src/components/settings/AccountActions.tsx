
import React from 'react';
import { Button } from '@/components/ui/button';

interface AccountActionsProps {
  onSignOut: () => void;
  onDeleteAccount: () => void;
}

const AccountActions = ({ onSignOut, onDeleteAccount }: AccountActionsProps) => {
  return (
    <div className="mt-8 space-y-4">
      <Button 
        onClick={onSignOut}
        className="w-full bg-[#222222] hover:bg-[#333333] text-white py-4"
      >
        Log Out
      </Button>
      
      <div className="text-center text-xs text-gray-400">
        <p>Version 1.0.0</p>
      </div>
      
      <Button 
        onClick={onDeleteAccount}
        className="w-full bg-[#FF5050]/20 hover:bg-[#FF5050]/30 text-[#FF5050] py-4 mt-4"
        variant="ghost"
      >
        Delete Profile
      </Button>
    </div>
  );
};

export default AccountActions;
