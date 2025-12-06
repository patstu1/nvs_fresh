
import React from 'react';
import { Button } from '@/components/ui/button';
import { ArrowRight } from 'lucide-react';
import { cn } from '@/lib/utils';

interface PreferencesProgressProps {
  activeTab: string;
  onNext: () => void;
}

export const PreferencesProgress: React.FC<PreferencesProgressProps> = ({ activeTab, onNext }) => {
  const tabs = ['identity', 'sexual', 'personality', 'values', 'social'];
  
  return (
    <div className="flex justify-between mt-6">
      <div className="flex gap-1">
        {tabs.map((tab) => (
          <div 
            key={tab} 
            className={cn(
              "w-2 h-2 rounded-full",
              activeTab === tab ? "bg-[#AAFF50]" : "bg-[#E6FFF4]/30"
            )}
          />
        ))}
      </div>
      
      <Button
        onClick={onNext}
        className="bg-[#AAFF50] text-black hover:bg-[#AAFF50]/90"
      >
        {activeTab === 'social' ? (
          'Complete Profile'
        ) : (
          <>
            Next <ArrowRight className="w-4 h-4 ml-2" />
          </>
        )}
      </Button>
    </div>
  );
};

