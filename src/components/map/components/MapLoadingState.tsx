
import React from 'react';
import { Spinner } from "@/components/ui/spinner";
import { motion } from 'framer-motion';

interface MapLoadingStateProps {
  message?: string;
  loadingDuration?: number;
  onRetry?: () => void;
}

const MapLoadingState: React.FC<MapLoadingStateProps> = ({ 
  message = "Finding nearby users...",
  loadingDuration,
  onRetry 
}) => {
  return (
    <motion.div 
      className="flex flex-col items-center justify-center w-full h-[70vh] bg-black"
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      transition={{ duration: 0.5 }}
    >
      <div className="relative mb-8">
        <motion.div
          className="w-16 h-16 rounded-full border-2 border-[#E6FFF4] opacity-30"
          initial={{ scale: 0.8, opacity: 0 }}
          animate={{ scale: [0.8, 1.5, 0.8], opacity: [0, 0.5, 0] }}
          transition={{ duration: 2, repeat: Infinity, ease: "easeInOut" }}
        />
        <motion.div
          className="w-16 h-16 rounded-full border-2 border-[#E6FFF4] opacity-50 absolute top-0"
          initial={{ scale: 0.8, opacity: 0 }}
          animate={{ scale: [0.8, 1.2, 0.8], opacity: [0, 0.7, 0] }}
          transition={{ duration: 2, repeat: Infinity, delay: 0.5, ease: "easeInOut" }}
        />
        <div className="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2">
          <Spinner className="text-[#E6FFF4]" size="lg" />
        </div>
      </div>
      
      <motion.p
        className="text-[#E6FFF4] text-lg text-center"
        initial={{ opacity: 0, y: 10 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.3 }}
      >
        {message}
      </motion.p>
      
      <motion.p
        className="text-[#E6FFF4]/60 text-sm text-center mt-2"
        initial={{ opacity: 0, y: 10 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.5 }}
      >
        {loadingDuration !== undefined ? `Loading for ${loadingDuration} seconds...` : 'Scanning for anonymous users nearby'}
      </motion.p>
      
      {onRetry && loadingDuration && loadingDuration > 10 && (
        <motion.button
          className="mt-4 px-4 py-2 bg-[#333]/50 text-[#E6FFF4] rounded-md hover:bg-[#444]/50 transition-colors"
          onClick={onRetry}
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.8 }}
        >
          Retry Connection
        </motion.button>
      )}
    </motion.div>
  );
};

export default MapLoadingState;
