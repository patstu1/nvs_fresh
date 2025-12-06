
import React from 'react';
import { BarChart2, Zap } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Progress } from '@/components/ui/progress';
import { Card, CardContent } from '@/components/ui/card';

interface ConnectHeaderProps {
  userProfileData: any;
  onViewStats: () => void;
  onStartMatching: () => void;
}

const ConnectHeader: React.FC<ConnectHeaderProps> = ({ userProfileData, onViewStats, onStartMatching }) => {
  return (
    <Card className="border-none rounded-2xl mb-6 overflow-hidden backdrop-blur-md electric-grid digital-noise"
          style={{ 
            background: 'linear-gradient(135deg, rgba(0,15,20,0.9) 0%, rgba(0,10,15,0.95) 100%)',
            boxShadow: '0 0 20px rgba(0,255,204,0.3), 0 0 40px rgba(0,255,204,0.1), inset 0 0 15px rgba(0,255,204,0.2)'
          }}>
      <CardContent className="p-5">
        <div className="flex items-center justify-between mb-4 relative">
          <h2 className="text-xl font-bold text-[#00FFCC] neon-text">YOUR PROFILE</h2>
          <div className="relative">
            <div 
              className="w-12 h-12 rounded-full flex items-center justify-center border border-[#00FFCC]/30 relative z-10"
              style={{ boxShadow: '0 0 10px rgba(0,255,204,0.5)' }}
            >
              <span className="text-[#00FFCC] font-bold text-xl">A+</span>
            </div>
          </div>
        </div>
        
        <p className="text-[#B4FFE0]/80 mb-4 text-sm">
          Your profile is compatible with 75% of potential matches in your area.
        </p>
        
        <div className="grid grid-cols-2 gap-4 mb-4">
          <div className="bg-black/40 backdrop-blur-md p-3 rounded-lg text-center border border-[#00FFCC]/20"
               style={{ boxShadow: 'inset 0 0 10px rgba(0,255,204,0.15)' }}>
            <p className="text-[#00FFCC]/70 text-xs mb-1">Match Compatibility</p>
            <div className="flex items-center justify-center">
              <p className="text-[#00FFCC] text-lg font-bold mr-2">96%</p>
              <Zap className="w-4 h-4 text-[#00FFCC]" />
            </div>
          </div>
          <div className="bg-black/40 backdrop-blur-md p-3 rounded-lg text-center border border-[#00FFCC]/20"
               style={{ boxShadow: 'inset 0 0 10px rgba(0,255,204,0.15)' }}>
            <p className="text-[#00FFCC]/70 text-xs mb-1">Connection Potential</p>
            <div className="flex items-center justify-center">
              <p className="text-[#00FFCC] text-lg font-bold mr-2">92%</p>
              <Zap className="w-4 h-4 text-[#00FFCC]" />
            </div>
          </div>
        </div>
        
        <div className="flex justify-between">
          <Button
            variant="outline"
            onClick={onViewStats}
            className="border border-[#00FFCC]/30 text-[#00FFCC] hover:bg-[#00FFCC]/10 hover:text-[#00FFCC] flex-1 mr-2"
          >
            <BarChart2 className="w-4 h-4 mr-2" />
            Profile Analytics
          </Button>
          <Button
            onClick={onStartMatching}
            className="bg-[#00FFCC]/20 text-[#00FFCC] hover:bg-[#00FFCC]/30 flex-1 ml-2 border border-[#00FFCC]/50"
            style={{ boxShadow: '0 0 10px rgba(0,255,204,0.3)' }}
          >
            <Zap className="w-4 h-4 mr-2" />
            Find Matches
          </Button>
        </div>
      </CardContent>
    </Card>
  );
};

export default ConnectHeader;
