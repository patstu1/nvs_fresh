
import React from 'react';
import { cn } from '@/lib/utils';
import YoBroLogo from './YoBroLogo';

interface GridNavButtonProps {
  isActive: boolean;
  onClick: () => void;
}

const GridNavButton: React.FC<GridNavButtonProps> = ({ isActive, onClick }) => {
  return (
    <button 
      onClick={onClick}
      className="flex flex-col items-center justify-center relative group"
    >
      <div className={cn(
        "w-16 h-16 rounded-full flex items-center justify-center transition-all duration-300 relative",
        isActive 
          ? "bg-black border-2 border-[#FDE1D3] shadow-[0_0_10px_rgba(253,225,211,0.7)]" 
          : "bg-black border-2 border-[#E6FFF4] shadow-[0_0_3px_rgba(194,255,230,0.4)]"
      )}>
        <YoBroLogo 
          className={cn(
            "w-12 h-12 transition-all duration-300",
            isActive 
              ? "text-[#FDE1D3] animate-pulse" 
              : "text-[#E6FFF4]/90 hover:text-[#E6FFF4]"
          )}
          style={{
            filter: isActive 
              ? 'drop-shadow(0 0 10px rgba(253, 225, 211, 0.9)) brightness(1.4)' 
              : 'drop-shadow(0 0 3px rgba(194, 255, 230, 0.5))',
          }}
        />
      </div>
      <span 
        className={cn(
          "absolute top-full mt-1 text-sm transition-all duration-200 opacity-0 group-hover:opacity-100 pointer-events-none",
          isActive 
            ? "neon-text-amber" 
            : "neon-text group-hover:text-[#E6FFF4]/90"
        )}
        style={{
          textShadow: isActive 
            ? '0 0 10px rgba(253, 225, 211, 0.9)' 
            : '0 0 3px rgba(194, 255, 230, 0.4)',
          transition: 'all 0.3s ease'
        }}
      >
        Home
      </span>
    </button>
  );
};

export default GridNavButton;
