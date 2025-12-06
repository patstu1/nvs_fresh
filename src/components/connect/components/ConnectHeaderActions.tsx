
import React from 'react';
import { MessageSquare, Settings } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { motion } from 'framer-motion';
import { useNavigate } from 'react-router-dom';

const ConnectHeaderActions = () => {
  const navigate = useNavigate();

  return (
    <div className="w-full max-w-md flex justify-between items-center mb-4 px-4">
      <motion.div
        initial={{ opacity: 0, y: -10 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.2 }}
      >
        <Button
          onClick={() => navigate('/messages')}
          size="sm"
          variant="ghost"
          className="text-[#E6FFF4] hover:bg-[#E6FFF4]/10"
        >
          <MessageSquare className="w-5 h-5" />
        </Button>
      </motion.div>
      
      <motion.div
        initial={{ opacity: 0, scale: 0.9 }}
        animate={{ opacity: 1, scale: 1 }}
        transition={{ delay: 0.3 }}
      >
        <h1 className="text-xl font-bold text-[#AAFF50]">CONNECT</h1>
      </motion.div>
      
      <motion.div
        initial={{ opacity: 0, y: -10 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.2 }}
      >
        <Button
          onClick={() => navigate('/settings')}
          size="sm"
          variant="ghost"
          className="text-[#E6FFF4] hover:bg-[#E6FFF4]/10"
        >
          <Settings className="w-5 h-5" />
        </Button>
      </motion.div>
    </div>
  );
};

export default ConnectHeaderActions;
