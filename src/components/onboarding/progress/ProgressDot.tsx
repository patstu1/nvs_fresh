
import React from 'react';

interface ProgressDotProps {
  isActive: boolean;
}

const ProgressDot: React.FC<ProgressDotProps> = ({ isActive }) => {
  return (
    <div 
      className={`w-2 h-2 rounded-full ${isActive ? 'bg-yobro-cream' : 'bg-yobro-cream/30'}`}
    />
  );
};

export default ProgressDot;
