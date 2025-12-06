
import React from 'react';
import { Spinner } from "@/components/ui/spinner";
import { motion } from 'framer-motion';

interface ConnectLoadingStateProps {
  message?: string;
}

const ConnectLoadingState: React.FC<ConnectLoadingStateProps> = ({ 
  message = "Finding matches in your area..." 
}) => {
  // Animation variants for staggered dots
  const dotVariants = {
    initial: { opacity: 0.3, y: 0 },
    animate: {
      opacity: 1,
      y: [0, -5, 0],
      transition: {
        duration: 1,
        repeat: Infinity,
        repeatType: "loop" as const
      }
    }
  };

  return (
    <motion.div 
      className="flex flex-col items-center justify-center w-full h-[70vh] bg-black"
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      transition={{ duration: 0.5 }}
    >
      <Spinner className="mb-6 text-[#E6FFF4]" size="lg" />
      
      <motion.div
        className="flex flex-col items-center"
        initial={{ opacity: 0, y: 10 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.3 }}
      >
        <p className="text-[#E6FFF4] text-lg text-center mb-2">{message}</p>
        
        <div className="flex space-x-1 mt-1">
          {[0, 1, 2].map(i => (
            <motion.div
              key={i}
              variants={dotVariants}
              initial="initial"
              animate="animate"
              style={{ animationDelay: `${i * 0.2}s` }}
              className="w-2 h-2 bg-[#AAFF50] rounded-full"
            />
          ))}
        </div>
      </motion.div>
    </motion.div>
  );
};

export default ConnectLoadingState;
