
import React from 'react';
import { AlertTriangle } from 'lucide-react';

interface ModerationWarningProps {
  message: string | null;
}

const ModerationWarning: React.FC<ModerationWarningProps> = ({ message }) => {
  if (!message) return null;
  
  return (
    <div className="bg-red-900/80 text-white p-2 px-4 flex items-center">
      <AlertTriangle className="h-4 w-4 mr-2 flex-shrink-0" />
      <p className="text-sm">{message}</p>
    </div>
  );
};

export default ModerationWarning;
