
import React from 'react';
import { Lock } from 'lucide-react';

const PrivateAlbumPreview: React.FC = () => {
  return (
    <div className="grid grid-cols-3 gap-2">
      {[1, 2, 3].map((_, i) => (
        <div key={i} className="aspect-square rounded-md bg-[#2A2A2A] border border-[#333333]">
          <div className="w-full h-full flex items-center justify-center">
            <Lock className="w-8 h-8 text-[#E6FFF4]/30" />
          </div>
        </div>
      ))}
    </div>
  );
};

export default PrivateAlbumPreview;
