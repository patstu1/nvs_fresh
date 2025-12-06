
import React from 'react';
import { X, User, Heart, Zap } from 'lucide-react';
import { motion } from 'framer-motion';
import { useNavigate } from 'react-router-dom';

interface ActionButtonsProps {
  profileId: string;
  onLike: () => void;
  onPass: () => void;
  onSuperLike: () => void;
}

const ActionButtons: React.FC<ActionButtonsProps> = ({
  profileId,
  onLike,
  onPass,
  onSuperLike
}) => {
  const navigate = useNavigate();

  return (
    <motion.div 
      className="flex space-x-6 mb-6"
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.4, delay: 0.2 }}
    >
      <motion.button 
        onClick={onPass}
        className="w-14 h-14 rounded-full flex items-center justify-center border-2 border-[#C2FFE6] bg-black"
        style={{ boxShadow: '0 0 3px rgba(194, 255, 230, 0.3)' }}
        whileHover={{ scale: 1.05, boxShadow: '0 0 8px rgba(194, 255, 230, 0.5)' }}
        whileTap={{ scale: 0.95 }}
      >
        <X className="w-7 h-7 text-[#C2FFE6]" />
      </motion.button>
      
      <motion.button 
        onClick={() => navigate(`/profile/${profileId}`)}
        className="w-14 h-14 rounded-full flex items-center justify-center border-2 border-[#C2FFE6] bg-black"
        style={{ boxShadow: '0 0 3px rgba(194, 255, 230, 0.3)' }}
        whileHover={{ scale: 1.05, boxShadow: '0 0 8px rgba(194, 255, 230, 0.5)' }}
        whileTap={{ scale: 0.95 }}
      >
        <User className="w-7 h-7 text-[#C2FFE6]" />
      </motion.button>
      
      <motion.button 
        onClick={onLike}
        className="w-14 h-14 rounded-full flex items-center justify-center border-2 border-[#AAFF50] bg-black"
        style={{ boxShadow: '0 0 3px rgba(170, 255, 80, 0.3)' }}
        whileHover={{ scale: 1.05, boxShadow: '0 0 8px rgba(170, 255, 80, 0.5)' }}
        whileTap={{ scale: 0.95 }}
      >
        <Heart className="w-7 h-7 text-[#AAFF50]" />
      </motion.button>
      
      <motion.button 
        onClick={onSuperLike}
        className="w-14 h-14 rounded-full flex items-center justify-center border-2 border-[#C2FFE6] bg-black"
        style={{ boxShadow: '0 0 3px rgba(194, 255, 230, 0.3)' }}
        whileHover={{ scale: 1.05, boxShadow: '0 0 8px rgba(194, 255, 230, 0.5)' }}
        whileTap={{ scale: 0.95 }}
      >
        <Zap className="w-7 h-7 text-[#C2FFE6]" />
      </motion.button>
    </motion.div>
  );
};

export default ActionButtons;
