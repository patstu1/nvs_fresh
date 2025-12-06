
import React from 'react';
import { motion } from 'framer-motion';
import { Zap } from 'lucide-react';

const WelcomeBadge: React.FC = () => {
  return (
    <div className="w-24 h-24 rounded-full border-4 border-yobro-cream flex items-center justify-center mx-auto mb-6 animate-pulse">
      <Zap className="w-12 h-12 text-cyberpunk-textGlow" />
    </div>
  );
};

export default WelcomeBadge;
