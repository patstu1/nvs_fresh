
import React, { memo } from 'react';
import { motion } from 'framer-motion';

interface AnimatedIconProps {
  scale: number;
}

const AnimatedIcon: React.FC<AnimatedIconProps> = memo(({ scale }) => {
  return (
    <motion.div
      initial={{ opacity: 0 }}
      animate={{ opacity: 1, scale }}
      exit={{ opacity: 0 }}
      className="flex items-center justify-center will-change-transform"
    >
      <div className="relative">
        {/* Jockstrap SVG - simplified representation */}
        <svg width="120" height="120" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
          <motion.g
            initial={{ opacity: 0.8 }}
            animate={{ 
              opacity: [0.8, 1, 0.8],
              filter: ['drop-shadow(0 0 5px rgba(194, 255, 230, 0.7))', 'drop-shadow(0 0 10px rgba(194, 255, 230, 0.9))', 'drop-shadow(0 0 5px rgba(194, 255, 230, 0.7))'] 
            }}
            transition={{ repeat: Infinity, duration: 1.5 }}
          >
            {/* Waistband */}
            <rect x="2" y="7" width="20" height="3" rx="1" fill="#C2FFE6" />
            
            {/* Straps */}
            <path d="M4 8.5C4 8.5 3.5 10 6 12C8 13.5 10 15 12 16" stroke="#40E0D0" strokeWidth="1.2" />
            <path d="M20 8.5C20 8.5 20.5 10 18 12C16 13.5 14 15 12 16" stroke="#40E0D0" strokeWidth="1.2" />
            
            {/* Pouch */}
            <path 
              d="M9 9C9 9 9 14.5 9 17.5C9 17.5 10 20 12 20C14 20 15 17.5 15 17.5C15 14.5 15 9 15 9H9Z" 
              fill="#8AFF56" 
            />
            <path 
              d="M12 9C12 13 12 15 12 20C14 20 15 17.5 15 17.5C15 14.5 15 9 15 9H12Z" 
              fill="#40E0D0" 
            />
          </motion.g>
        </svg>
        
        <motion.div 
          className="absolute inset-0 rounded-full"
          animate={{ 
            boxShadow: ['0 0 10px rgba(194, 255, 230, 0.7)', '0 0 25px rgba(194, 255, 230, 0.9)', '0 0 10px rgba(194, 255, 230, 0.7)']
          }}
          transition={{ repeat: Infinity, duration: 2 }}
        />
      </div>
    </motion.div>
  );
});

AnimatedIcon.displayName = 'AnimatedIcon';

export default AnimatedIcon;
