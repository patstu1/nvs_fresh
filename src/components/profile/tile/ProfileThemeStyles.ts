
import { cn } from '@/lib/utils';

export const getCyberpunkStyles = (theme: 'default' | 'cyberpunk') => {
  const baseStyles = "relative aspect-square overflow-hidden rounded-lg cursor-pointer border-2 transition-all duration-300 hover:scale-105";
  
  const themeStyles = {
    cyberpunk: cn(
      baseStyles,
      "border-[#C2FFE6] shadow-[0_0_3px_rgba(194,255,230,0.3),0_0_3px_rgba(170,255,80,0.2),inset_0_0_2px_rgba(194,255,230,0.2)]",
      "bg-gradient-to-b from-black via-black to-black"
    ),
    default: baseStyles
  };

  return themeStyles[theme];
};
