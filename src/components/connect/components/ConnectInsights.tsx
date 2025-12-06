
import React from 'react';
import { Zap, Heart, User, Clock } from 'lucide-react';
import { Card, CardContent } from '@/components/ui/card';

interface ConnectInsightsProps {
  userProfileData: any;
}

const ConnectInsights: React.FC<ConnectInsightsProps> = ({ userProfileData }) => {
  return (
    <div className="space-y-4">
      <Card className="border-none rounded-xl mb-5 overflow-hidden backdrop-blur-md"
            style={{ 
              background: 'linear-gradient(135deg, rgba(0,15,20,0.8) 0%, rgba(0,10,15,0.9) 100%)',
              boxShadow: '0 0 15px rgba(0,255,204,0.15), inset 0 0 10px rgba(0,255,204,0.05)'
            }}>
        <CardContent className="p-4">
          <h3 className="text-[#00FFCC] font-medium mb-2 flex items-center">
            <Zap className="w-4 h-4 mr-2 text-[#00FFCC]" />
            Quantum AI Analysis
          </h3>
          <p className="text-[#B4FFE0]/80 text-sm">
            Based on neural pattern analysis, you resonate most with entities who share your interest in
            {userProfileData?.personalityTraits?.length > 0 ? 
              ` ${userProfileData.personalityTraits[0].replace(/-/g, ' ')} and ${userProfileData.personalityTraits[1]?.replace(/-/g, ' ') || 'existential exploration'}` : 
              ' cybernetic enhancement and neural expansion'}. Consider expanding your quantum field to include more entities with these resonance patterns.
          </p>
        </CardContent>
      </Card>
      
      <Card className="border-none rounded-xl overflow-hidden backdrop-blur-md"
            style={{ 
              background: 'linear-gradient(135deg, rgba(0,15,20,0.8) 0%, rgba(0,10,15,0.9) 100%)',
              boxShadow: '0 0 15px rgba(0,255,204,0.15), inset 0 0 10px rgba(0,255,204,0.05)'
            }}>
        <div className="p-4 border-b border-[#00FFCC]/10">
          <h3 className="text-[#00FFCC] font-medium">Temporal Activity Matrix</h3>
        </div>
        <CardContent className="p-4">
          <div className="space-y-3">
            <div className="flex justify-between items-center">
              <div className="flex items-center">
                <Heart className="w-4 h-4 mr-2 text-[#00FFCC]" />
                <span className="text-[#B4FFE0]/80 text-sm">Neural Links</span>
              </div>
              <span className="text-[#B4FFE0] font-medium">
                <span className="text-[#00FFCC]">8</span> new
              </span>
            </div>
            <div className="flex justify-between items-center">
              <div className="flex items-center">
                <User className="w-4 h-4 mr-2 text-[#00FFCC]" />
                <span className="text-[#B4FFE0]/80 text-sm">Pattern Recognition</span>
              </div>
              <span className="text-[#B4FFE0] font-medium">
                <span className="text-[#00FFCC]">27</span> scans
              </span>
            </div>
            <div className="flex justify-between items-center">
              <div className="flex items-center">
                <Clock className="w-4 h-4 mr-2 text-[#00FFCC]" />
                <span className="text-[#B4FFE0]/80 text-sm">Quantum Presence</span>
              </div>
              <span className="text-[#B4FFE0] font-medium">
                <span className="text-[#00FFCC]">3.5</span> hours
              </span>
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  );
};

export default ConnectInsights;
