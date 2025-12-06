
import React from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import AnimatedText from './intro/AnimatedText';
import AnimatedIcon from './intro/AnimatedIcon';
import YoBroLogo from '../YoBroLogo';

interface IntroAnimationProps {
  showIntro: boolean;
  showYo: boolean;
  showBro: boolean;
  showIcon: boolean;
  showFinal: boolean;
  iconScale: number;
  onAnimationComplete?: () => void;
}

const IntroAnimation: React.FC<IntroAnimationProps> = ({
  showIntro,
  showYo,
  showBro,
  showIcon,
  showFinal,
  iconScale,
  onAnimationComplete
}) => {
  if (!showIntro) return null;

  return (
    <motion.div 
      className="fixed inset-0 z-50 bg-black flex items-center justify-center flex-col"
      initial={{ opacity: 1 }}
      exit={{ opacity: 0 }}
      transition={{ duration: 0.5 }}
      onAnimationComplete={onAnimationComplete}
    >
      <div className="relative">
        {showYo && (
          <AnimatedText 
            key="yo-text" 
            text="YO" 
            gradient="bg-gradient-to-r from-[#C2FFE6] to-[#FDE1D3]" 
          />
        )}
        
        {showBro && (
          <AnimatedText 
            key="bro-text" 
            text="BRO" 
            gradient="bg-gradient-to-r from-[#FDE1D3] to-[#C2FFE6]" 
          />
        )}
        
        {showIcon && (
          <AnimatedIcon key="icon" scale={iconScale} />
        )}

        {showFinal && (
          <motion.div
            className="flex flex-col items-center justify-center"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            transition={{ duration: 0.5 }}
          >
            <div className="flex items-center justify-center mb-4">
              <YoBroLogo width={60} height={60} className="mr-4" />
              <h1 
                className="text-6xl font-bold text-transparent bg-clip-text bg-gradient-to-r from-[#C2FFE6] to-[#FDE1D3]"
                style={{
                  textShadow: '0 0 15px rgba(194, 255, 230, 0.8), 0 0 25px rgba(194, 255, 230, 0.5)'
                }}
              >
                YO BRO
              </h1>
            </div>
            <motion.div 
              className="text-[#E6FFF4] text-xl"
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.3 }}
            >
              YOUR ALL-IN-ONE SOCIAL PLATFORM
            </motion.div>
          </motion.div>
        )}
      </div>
    </motion.div>
  );
};

export default IntroAnimation;
