
import React from 'react';
import { Button } from '@/components/ui/button';
import { toast } from '@/hooks/use-toast';
import { Fingerprint, Users } from 'lucide-react';

interface HeatMapToggleProps {
  showHeatMap: boolean;
  onToggle: () => void;
}

const HeatMapToggle: React.FC<HeatMapToggleProps> = ({ 
  showHeatMap, 
  onToggle
}) => {
  const toggleHeatMap = () => {
    onToggle();
    
    toast({
      title: showHeatMap ? "Heat Map Disabled" : "Heat Map Enabled",
      description: showHeatMap ? "Showing individual users" : "Showing user density visualization"
    });
  };

  return (
    <div className="absolute top-20 right-4 z-20 flex flex-col space-y-2">
      <Button 
        variant="outline" 
        size="sm"
        onClick={toggleHeatMap}
        className={`relative overflow-hidden group transition-all duration-300 ${showHeatMap 
          ? 'bg-black/80 text-[#FDE1D3] border-[#FDE1D3]/40' 
          : 'bg-black/80 text-[#4BEFE0] border-[#4BEFE0]/40'} 
          backdrop-blur-md px-4 py-2 h-auto`}
        style={{
          boxShadow: showHeatMap 
            ? '0 0 15px rgba(253, 225, 211, 0.2), 0 0 30px rgba(253, 225, 211, 0.1)'
            : '0 0 15px rgba(75, 239, 224, 0.2), 0 0 30px rgba(75, 239, 224, 0.1)'
        }}
      >
        {/* Background glow effect */}
        <div 
          className={`absolute inset-0 opacity-20 transition-opacity duration-300 ${
            showHeatMap ? 'bg-[#FDE1D3]/10' : 'bg-[#4BEFE0]/10'}`} 
        />
        
        {/* Icon with text display */}
        <div className="flex items-center justify-center space-x-2">
          {showHeatMap ? (
            <Fingerprint className="w-4 h-4 text-[#FDE1D3]" />
          ) : (
            <Users className="w-4 h-4 text-[#4BEFE0]" />
          )}
          <span className="text-sm font-medium">
            {showHeatMap ? 'Heat Map' : 'Users'}
          </span>
        </div>
        
        {/* Animated border effect */}
        <div 
          className={`absolute inset-0 opacity-0 group-hover:opacity-100 transition-opacity duration-500 pointer-events-none ${
            showHeatMap ? 'border border-[#FDE1D3]/40' : 'border border-[#4BEFE0]/40'}`}
          style={{
            boxShadow: showHeatMap 
              ? '0 0 10px rgba(253, 225, 211, 0.3) inset'
              : '0 0 10px rgba(75, 239, 224, 0.3) inset'
          }}
        />
      </Button>
    </div>
  );
};

export default HeatMapToggle;
