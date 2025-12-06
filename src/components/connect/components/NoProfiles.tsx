
import React from 'react';
import { useNavigate } from 'react-router-dom';
import { BarChart2 } from 'lucide-react';
import { Button } from '@/components/ui/button';

const NoProfiles: React.FC = () => {
  const navigate = useNavigate();

  return (
    <div className="flex flex-col items-center justify-center w-full max-w-md mx-auto py-8">
      <div className="bg-black border border-[#C2FFE6] rounded-lg p-8 shadow-lg text-center">
        <h3 className="text-xl font-bold text-[#AAFF50] mb-4">No Profiles Found</h3>
        <p className="text-[#E6FFF4] mb-6">Try adjusting your preferences or location settings to find more people.</p>
        <Button 
          onClick={() => navigate('/connect-stats')}
          className="bg-[#AAFF50] text-black hover:bg-[#AAFF50]/90"
        >
          <BarChart2 className="w-4 h-4 mr-2" />
          View Stats Instead
        </Button>
      </div>
    </div>
  );
};

export default NoProfiles;
