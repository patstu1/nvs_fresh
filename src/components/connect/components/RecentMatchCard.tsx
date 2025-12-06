
import React from 'react';
import { motion } from 'framer-motion';
import { Star, Wifi } from 'lucide-react';
import { cn } from '@/lib/utils';
import { RecentMatch } from '../types/ConnectTypes';

interface RecentMatchCardProps {
  match: RecentMatch;
  isSelected: boolean;
  onClick: () => void;
  getRadialProgressBackground: (value: number) => string;
}

const RecentMatchCard: React.FC<RecentMatchCardProps> = ({
  match,
  isSelected,
  onClick,
  getRadialProgressBackground
}) => {
  return (
    <motion.div 
      onClick={onClick}
      whileHover={{ scale: 1.02 }}
      whileTap={{ scale: 0.98 }}
      className={cn(
        "relative flex items-center bg-black/40 backdrop-blur-xl p-4 rounded-xl cursor-pointer transition-all border border-[#FF00FF]/20",
        isSelected 
          ? "ring-2 ring-[#FF00FF] bg-black/50" 
          : "hover:bg-black/50 hover:border-[#FF00FF]/40"
      )}
      style={{ 
        boxShadow: isSelected ? '0 0 20px rgba(255,0,255,0.3)' : 'none',
        background: 'linear-gradient(135deg, rgba(0,0,0,0.8) 0%, rgba(25,0,25,0.9) 100%)'  
      }}
    >
      <div className="relative">
        <div className="w-14 h-14 rounded-full overflow-hidden border-2 border-[#FF00FF]/30">
          <img src={match.image} alt={match.name} className="w-full h-full object-cover" />
          <div className="absolute inset-0 bg-gradient-to-b from-transparent to-black/50" />
        </div>
        {match.isNew && (
          <div className="absolute -top-1 -right-1 w-4 h-4 bg-[#FF00FF] rounded-full border-2 border-black animate-pulse" />
        )}
        <div 
          className="absolute inset-0 rounded-full" 
          style={{ 
            background: getRadialProgressBackground(match.connectionStrength || 0),
            animation: 'pulse 2s infinite'
          }}
        />
      </div>

      <div className="ml-3 flex-1">
        <div className="flex justify-between items-center">
          <p className="text-[#FF00FF] font-medium tracking-wide">{match.name}</p>
          <div className="flex items-center bg-black/40 px-2 py-1 rounded-full">
            <Star className="w-3 h-3 text-[#FF00FF] mr-1" fill="#FF00FF" />
            <span className="text-xs text-[#FF00FF]">{match.compatibility}%</span>
          </div>
        </div>
        <p className="text-[#FF00FF]/60 text-xs flex items-center">
          <Wifi className="w-3 h-3 mr-1" />
          {match.isNew ? 'New quantum link detected' : 'Awaiting neural sync'}
        </p>
      </div>

      {/* Holographic scan effect */}
      <div className="absolute inset-0 pointer-events-none">
        <div className="absolute inset-0 rounded-xl opacity-30"
             style={{
               background: 'linear-gradient(transparent, #FF00FF, transparent)',
               backgroundSize: '100% 8px',
               animation: 'scan 4s linear infinite'
             }} />
      </div>
    </motion.div>
  );
};

export default RecentMatchCard;
