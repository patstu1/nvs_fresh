
import React from 'react';
import { ArrowLeft } from 'lucide-react';

interface BackButtonProps {
  onClick: () => void;
}

const BackButton: React.FC<BackButtonProps> = ({ onClick }) => {
  return (
    <button onClick={onClick} className="mr-2">
      <ArrowLeft className="w-6 h-6 text-cyberpunk-textGlow" />
    </button>
  );
};

export default BackButton;
