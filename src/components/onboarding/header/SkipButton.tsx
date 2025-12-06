
import React from 'react';

interface SkipButtonProps {
  onClick: () => void;
}

const SkipButton: React.FC<SkipButtonProps> = ({ onClick }) => {
  return (
    <button 
      onClick={onClick} 
      className="ml-auto text-sm text-cyberpunk-textGlow/70 hover:text-cyberpunk-textGlow"
    >
      Skip
    </button>
  );
};

export default SkipButton;
