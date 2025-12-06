
import React from 'react';
import { Button } from '@/components/ui/button';
import { Boxes, Cpu } from 'lucide-react';

interface Mode3DToggleProps {
  is3DMode: boolean;
  onToggle: () => void;
}

const Mode3DToggle: React.FC<Mode3DToggleProps> = ({ is3DMode, onToggle }) => {
  return (
    <Button
      onClick={onToggle}
      variant="outline"
      size="sm"
      className={`fixed bottom-24 left-4 p-2 z-20 backdrop-blur-md 
        ${is3DMode ? 'bg-cyan-500/10 border-cyan-500/50 text-cyan-500' : 
                     'bg-white/5 border-white/20 text-white/70'}`}
    >
      {is3DMode ? (
        <>
          <Boxes className="w-5 h-5 mr-2" />
          <span className="text-xs font-medium">3D Mode</span>
        </>
      ) : (
        <>
          <Cpu className="w-5 h-5 mr-2" />
          <span className="text-xs font-medium">2D Mode</span>
        </>
      )}
    </Button>
  );
};

export default Mode3DToggle;
