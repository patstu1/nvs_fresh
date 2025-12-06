
import React from 'react';

interface ConnectingStateProps {
  message?: string;
}

const ConnectingState: React.FC<ConnectingStateProps> = ({ 
  message = "Connecting to Zoom..." 
}) => {
  return (
    <div className="text-center">
      <div className="animate-pulse flex flex-col items-center">
        <div className="h-12 w-12 bg-[#333] rounded-full mb-4"></div>
        <div className="h-4 w-40 bg-[#333] rounded mb-2"></div>
        <div className="h-4 w-60 bg-[#333] rounded"></div>
      </div>
      <p className="text-[#C2FFE6] mt-4">{message}</p>
    </div>
  );
};

export default ConnectingState;
