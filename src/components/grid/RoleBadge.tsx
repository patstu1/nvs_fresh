
import React from 'react';
import { cn } from '@/lib/utils';

export type SexualRole = 
  | 'top-dom' 
  | 'top' 
  | 'vers-top' 
  | 'vers' 
  | 'vers-bottom' 
  | 'bottom' 
  | 'power-bottom';

interface RoleBadgeProps {
  role: SexualRole;
  size?: 'sm' | 'md' | 'lg';
  className?: string;
  glow?: boolean;
}

const RoleBadge: React.FC<RoleBadgeProps> = ({
  role,
  size = 'md',
  className,
  glow = true
}) => {
  // Role specific colors and labels
  const roleConfig = {
    'top-dom': {
      label: 'Top Dom',
      bgColor: 'from-red-600 to-orange-500',
      textColor: 'text-white',
      glowColor: 'shadow-red-500/50'
    },
    'top': {
      label: 'Top',
      bgColor: 'from-red-500 to-pink-500',
      textColor: 'text-white',
      glowColor: 'shadow-red-500/50'
    },
    'vers-top': {
      label: 'Vers Top',
      bgColor: 'from-purple-600 to-pink-500',
      textColor: 'text-white',
      glowColor: 'shadow-purple-500/50'
    },
    'vers': {
      label: 'Vers',
      bgColor: 'from-indigo-500 to-purple-500',
      textColor: 'text-white',
      glowColor: 'shadow-indigo-500/50'
    },
    'vers-bottom': {
      label: 'Vers Btm',
      bgColor: 'from-blue-500 to-indigo-500',
      textColor: 'text-white',
      glowColor: 'shadow-blue-500/50'
    },
    'bottom': {
      label: 'Bottom',
      bgColor: 'from-cyan-500 to-blue-500',
      textColor: 'text-white',
      glowColor: 'shadow-cyan-500/50'
    },
    'power-bottom': {
      label: 'Power Btm',
      bgColor: 'from-teal-400 to-cyan-500',
      textColor: 'text-black',
      glowColor: 'shadow-teal-500/50'
    }
  };

  const config = roleConfig[role];
  
  // Size variants
  const sizeClasses = {
    sm: 'text-xs py-0.5 px-2',
    md: 'text-sm py-1 px-3',
    lg: 'text-base py-1.5 px-4'
  };

  return (
    <div
      className={cn(
        'rounded-full font-medium tracking-wide transition-all duration-300',
        `bg-gradient-to-r ${config.bgColor}`,
        config.textColor,
        sizeClasses[size],
        glow && `shadow-lg ${config.glowColor}`,
        className
      )}
    >
      {config.label}
    </div>
  );
};

export default RoleBadge;
