
import React, { useState } from 'react';
import { MessageSquare, RefreshCw, Zap } from 'lucide-react';
import { motion } from 'framer-motion';

interface AIIcebreakerProps {
  suggestion: string;
  onRefresh?: () => void;
}

const AIIcebreaker: React.FC<AIIcebreakerProps> = ({ suggestion, onRefresh }) => {
  const [isRefreshing, setIsRefreshing] = useState(false);
  
  const handleRefresh = () => {
    if (onRefresh) {
      setIsRefreshing(true);
      setTimeout(() => {
        onRefresh();
        setIsRefreshing(false);
      }, 800);
    }
  };

  return (
    <motion.div 
      className="w-full backdrop-blur-sm p-4 rounded-lg mb-4 border border-[#00FFCC]/20"
      style={{ 
        background: 'rgba(0,0,0,0.3)',
        boxShadow: 'inset 0 0 10px rgba(0,255,204,0.1)' 
      }}
      initial={{ opacity: 0.8 }}
      animate={{ opacity: 1 }}
      transition={{ duration: 0.5 }}
    >
      <div className="flex items-center mb-2">
        <div className="flex items-center">
          <Zap className="w-3 h-3 text-[#00FFCC] mr-1" />
          <MessageSquare className="w-4 h-4 text-[#00FFCC] mr-1" />
        </div>
        <span className="text-[#00FFCC] text-sm font-medium">Neural Dialogue Suggestion</span>
        <button 
          className={`ml-auto ${isRefreshing ? 'animate-spin' : ''}`}
          onClick={handleRefresh}
          disabled={isRefreshing}
        >
          <RefreshCw className={`w-4 h-4 ${isRefreshing ? 'text-[#00FFCC]' : 'text-[#00FFCC]/50 hover:text-[#00FFCC]'}`} />
        </button>
      </div>
      <p className="text-[#B4FFE0] text-sm leading-relaxed">{suggestion}</p>
    </motion.div>
  );
};

export default AIIcebreaker;
