
import React from 'react';
import { Loader2 } from 'lucide-react';
import { cn } from '@/lib/utils';

interface SpinnerProps {
  size?: 'sm' | 'md' | 'lg' | 'xl';
  color?: string;
  className?: string;
  aria?: string;
}

export const Spinner = ({ 
  size = 'md',
  color = 'currentColor',
  className,
  aria = 'Loading',
  ...props 
}: SpinnerProps) => {
  const sizeClasses = {
    sm: 'w-4 h-4',
    md: 'w-6 h-6',
    lg: 'w-8 h-8',
    xl: 'w-12 h-12'
  };

  return (
    <Loader2 
      className={cn(
        'animate-spin',
        sizeClasses[size],
        className
      )}
      style={{ color }}
      aria-label={aria}
      {...props}
    />
  );
};

export default Spinner;
