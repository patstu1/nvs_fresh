
import React, { memo } from 'react';
import { motion } from 'framer-motion';

interface AnimatedTextProps {
  text: string;
  gradient: string;
}

const AnimatedText: React.FC<AnimatedTextProps> = memo(({ text, gradient }) => {
  return (
    <motion.div
      initial={{ opacity: 0, scale: 0.8 }}
      animate={{ opacity: 1, scale: 1 }}
      exit={{ opacity: 0, scale: 1.2 }}
      transition={{ duration: 0.3 }}
      className="text-9xl font-extrabold relative will-change-transform"
    >
      <span 
        className={`text-transparent bg-clip-text ${gradient}`}
        style={{
          textShadow: '0 0 15px rgba(194, 255, 230, 0.8), 0 0 25px rgba(194, 255, 230, 0.5), 0 0 35px rgba(194, 255, 230, 0.3)',
          transform: 'translateZ(0)'
        }}
      >
        {text}
      </span>
    </motion.div>
  );
});

AnimatedText.displayName = 'AnimatedText';

export default AnimatedText;
