
import React from 'react';
import { Shield, Activity, Radar, Database } from 'lucide-react';
import { Card, CardContent } from '@/components/ui/card';
import { ProfileStatsProps } from '../types/ConnectTypes';

const ProfileStats: React.FC<ProfileStatsProps> = ({ stats, userProfileData }) => {
  // Use either the provided stats or extract from userProfileData
  const displayStats = {
    neuralSync: stats?.neuralSync || (userProfileData?.neuralSync ?? 85),
    quantumCoherence: stats?.quantumCoherence || (userProfileData?.quantumCoherence ?? 92)
  };

  return (
    <div className="relative backdrop-blur-xl p-4 rounded-xl mb-4 overflow-hidden"
         style={{ 
           background: 'linear-gradient(135deg, rgba(0,0,0,0.9) 0%, rgba(25,0,25,0.95) 100%)',
           boxShadow: '0 0 30px rgba(255,0,255,0.2), inset 0 0 20px rgba(255,0,255,0.1)'
         }}>
      <div className="absolute inset-0 overflow-hidden">
        <div className="absolute inset-0" 
             style={{
               backgroundImage: 'radial-gradient(circle at 50% 50%, rgba(255,0,255,0.1) 0%, transparent 50%)',
               animation: 'pulse 4s infinite'
             }} />
        <div className="absolute inset-0" 
             style={{
               backgroundImage: 'linear-gradient(0deg, transparent 24%, rgba(255,0,255,0.05) 25%, rgba(255,0,255,0.05) 26%, transparent 27%, transparent 74%, rgba(255,0,255,0.05) 75%, rgba(255,0,255,0.05) 76%, transparent 77%, transparent)',
               backgroundSize: '60px 60px',
               animation: 'grid-scroll 3s linear infinite'
             }} />
      </div>

      <h3 className="text-[#FF00FF] font-medium mb-4 flex items-center relative z-10">
        <Shield className="w-4 h-4 mr-2 text-[#FF00FF]" />
        Quantum Identity Matrix
      </h3>

      <div className="grid grid-cols-2 gap-4 relative z-10">
        <div className="bg-black/60 p-3 rounded-lg border border-[#FF00FF]/20">
          <div className="flex items-center justify-between mb-2">
            <span className="text-[#FF00FF]/70 text-sm">Neural Sync</span>
            <Activity className="w-4 h-4 text-[#FF00FF]" />
          </div>
          <div className="text-[#FF00FF] text-xl font-bold">
            {displayStats.neuralSync}%
          </div>
        </div>

        <div className="bg-black/60 p-3 rounded-lg border border-[#FF00FF]/20">
          <div className="flex items-center justify-between mb-2">
            <span className="text-[#FF00FF]/70 text-sm">Quantum Coherence</span>
            <Radar className="w-4 h-4 text-[#FF00FF]" />
          </div>
          <div className="text-[#FF00FF] text-xl font-bold">
            {displayStats.quantumCoherence}%
          </div>
        </div>
      </div>

      {/* Data flow animation */}
      <div className="absolute bottom-0 left-0 right-0 h-1 overflow-hidden">
        <div className="h-full w-1/3 bg-[#FF00FF]/30"
             style={{
               animation: 'data-flow 2s linear infinite',
               boxShadow: '0 0 10px #FF00FF'
             }} />
      </div>
    </div>
  );
};

export default ProfileStats;
