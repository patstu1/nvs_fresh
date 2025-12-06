
import React from 'react';
import { Button } from '@/components/ui/button';
import { Settings } from 'lucide-react';

interface MediaManagerHeaderProps {
  title: string;
}

const MediaManagerHeader: React.FC<MediaManagerHeaderProps> = ({ title }) => {
  return (
    <div className="flex items-center justify-between mb-6">
      <h2 className="text-2xl font-bold text-[#E6FFF4]">{title}</h2>
      <Button variant="outline" size="icon" className="border-[#E6FFF4]/30 text-[#E6FFF4]">
        <Settings size={18} />
      </Button>
    </div>
  );
};

export default MediaManagerHeader;
