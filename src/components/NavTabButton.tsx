
import React from 'react';
import { LucideIcon } from 'lucide-react';
import { cn } from '@/lib/utils';
import YoBroLogo from './YoBroLogo';
import { motion } from 'framer-motion';

interface NavTabButtonProps {
  icon?: LucideIcon | typeof YoBroLogo;
  label: string;
  isActive: boolean;
  onClick: () => void;
  smaller?: boolean;
  customIcon?: boolean;
  isYoButton?: boolean;
  customLabel?: string;
  noBgEffect?: boolean;
}

const NavTabButton: React.FC<NavTabButtonProps> = ({ 
  icon: Icon, 
  label, 
  isActive, 
  onClick, 
  smaller = false,
  customIcon = false,
  isYoButton = false,
  customLabel,
  noBgEffect = false
}) => {
  const iconSize = 28;
  const yoBroLogoSize = 32;
  
  return (
    <motion.button 
      onClick={onClick}
      whileHover={{ scale: 1.1 }}
      whileTap={{ scale: 0.95 }}
      className={cn(
        "flex flex-col items-center justify-center relative", 
        noBgEffect ? "" : "group p-1"
      )}
    >
      {isYoButton ? (
        <div 
          className={cn(
            "flex items-center justify-center transition-all duration-300 text-2xl font-bold", 
            isActive 
              ? "text-[#4BEFE0]" 
              : "text-[#E6FFF4] hover:text-[#E6FFF4]/90"
          )}
          style={{
            filter: isActive 
              ? 'drop-shadow(0 0 14px rgba(75, 239, 224, 0.9)) brightness(1.4)' 
              : 'drop-shadow(0 0 6px rgba(230, 255, 244, 0.5))',
          }}
        >
          <span className={`font-bold ${isActive ? 'text-[#4BEFE0]' : 'text-[#E6FFF4]'}`}>
            {customLabel || label}
          </span>
        </div>
      ) : customIcon ? (
        <YoBroLogo 
          width={yoBroLogoSize}
          height={yoBroLogoSize}
          className={cn(
            "transition-all duration-300",
            isActive 
              ? "text-[#4BEFE0]" 
              : "text-[#E6FFF4] hover:text-[#E6FFF4]/90"
          )}
          style={{
            filter: isActive 
              ? 'drop-shadow(0 0 14px rgba(75, 239, 224, 0.9)) brightness(1.4)' 
              : 'drop-shadow(0 0 6px rgba(230, 255, 244, 0.5))',
          }}
        />
      ) : Icon ? (
        <Icon 
          className={cn(
            "transition-all duration-300",
            isActive 
              ? "text-[#4BEFE0]" 
              : "text-[#E6FFF4] hover:text-[#E6FFF4]/90"
          )}
          style={{
            width: `${iconSize}px`,
            height: `${iconSize}px`,
            filter: isActive 
              ? 'drop-shadow(0 0 14px rgba(75, 239, 224, 0.9)) brightness(1.4)' 
              : 'drop-shadow(0 0 6px rgba(230, 255, 244, 0.5))',
            transition: 'all 0.3s ease'
          }}
        />
      ) : null}
      
      {label && (
        <span 
          className={cn(
            "text-xs font-medium group-hover:opacity-100 transition-all duration-200",
            isActive 
              ? "text-[#4BEFE0] font-semibold opacity-100" 
              : "text-[#E6FFF4] group-hover:text-[#E6FFF4]/90 opacity-80"
          )}
          style={{
            textShadow: isActive 
              ? '0 0 14px rgba(75, 239, 224, 0.9)' 
              : '0 0 6px rgba(230, 255, 244, 0.4)',
            transition: 'all 0.3s ease'
          }}
        >
          {label}
        </span>
      )}
    </motion.button>
  );
};

export default NavTabButton;
