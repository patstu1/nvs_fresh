
import React from 'react';
import { Heart, MessageCircle, Search } from 'lucide-react';
import NavTabButton from './NavTabButton';
import YoBroLogo from './YoBroLogo';
import { TabType } from '@/types/TabTypes';
import soundManager from '@/utils/soundManager';
import { motion } from 'framer-motion';

interface BottomNavBarProps {
  activeTab: TabType;
  onTabChange: (tab: TabType) => void;
}

const BottomNavBar: React.FC<BottomNavBarProps> = ({ 
  activeTab, 
  onTabChange 
}) => {
  const handleYoTabClick = () => {
    if (activeTab !== 'yo') {
      soundManager.play('yo');
    }
    onTabChange('yo');
  };

  return (
    <div className="fixed bottom-0 left-0 right-0 bg-black bg-opacity-95 backdrop-blur-lg border-t border-[#4BEFE0]/30 py-3 z-50 shadow-lg shadow-black/50">
      <div className="flex justify-around items-center max-w-screen-md mx-auto">
        {/* First group: Logo and YO */}
        <div className="flex gap-6">
          <NavTabButton 
            icon={YoBroLogo}
            label=""
            isActive={activeTab === 'grid'}
            onClick={() => onTabChange('grid')}
            customIcon={true}
            noBgEffect={true}
          />
          
          <NavTabButton 
            label="YO"
            isActive={activeTab === 'yo'}
            onClick={handleYoTabClick}
            isYoButton={true}
            customLabel="YO"
            noBgEffect={true}
          />
        </div>

        {/* Middle group: Heart, Message, Search */}
        <div className="flex gap-8">
          <NavTabButton 
            icon={Heart}
            label=""
            isActive={activeTab === 'favorites'}
            onClick={() => onTabChange('favorites')}
            noBgEffect={true}
          />
          
          <NavTabButton 
            icon={MessageCircle}
            label=""
            isActive={activeTab === 'messages'}
            onClick={() => onTabChange('messages')}
            noBgEffect={true}
          />
          
          <NavTabButton 
            icon={Search}
            label=""
            isActive={activeTab === 'search'}
            onClick={() => onTabChange('search')}
            noBgEffect={true}
          />
        </div>
        
        {/* Third group: Right side icons (can be customized) */}
        <div className="flex gap-6">
          <motion.div 
            whileHover={{ scale: 1.1 }}
            className="flex items-center justify-center"
          >
            <div className="text-[#4BEFE0] w-8 h-8 flex items-center justify-center">
              <svg viewBox="0 0 24 24" fill="none" className="w-7 h-7">
                <path 
                  d="M12 13a5 5 0 100-10 5 5 0 000 10z" 
                  stroke="currentColor" 
                  strokeWidth="1.5"
                />
                <path 
                  d="M16 21v-1a4 4 0 00-4-4h-4a4 4 0 00-4 4v1" 
                  stroke="currentColor" 
                  strokeWidth="1.5"
                />
              </svg>
            </div>
          </motion.div>
          
          <motion.div 
            whileHover={{ scale: 1.1 }}
            className="flex items-center justify-center"
          >
            <div className="text-[#4BEFE0] w-8 h-8 flex items-center justify-center">
              <svg viewBox="0 0 24 24" fill="none" className="w-7 h-7">
                <rect x="2" y="2" width="20" height="20" rx="5" stroke="currentColor" strokeWidth="1.5" />
                <rect x="7" y="7" width="10" height="10" rx="1" stroke="currentColor" strokeWidth="1.5" />
              </svg>
            </div>
          </motion.div>
        </div>
      </div>
    </div>
  );
};

export default BottomNavBar;
