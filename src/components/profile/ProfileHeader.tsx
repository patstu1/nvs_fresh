
import React from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, Heart, Grid, Map, Sparkles, Video } from 'lucide-react';
import { UserProfile } from '@/types/UserProfile';
import { TabType } from '@/types/TabTypes';
import { motion } from 'framer-motion';

interface ProfileHeaderProps {
  profile: UserProfile;
  compatibilityScore?: number;
  activeSection?: TabType;
  onToggleSection?: (section: TabType) => void;
}

const ProfileHeader: React.FC<ProfileHeaderProps> = ({ 
  profile, 
  compatibilityScore,
  activeSection = 'grid',
  onToggleSection
}) => {
  const navigate = useNavigate();
  
  const handleBack = () => {
    navigate(-1);
  };
  
  const getSectionName = (section: TabType) => {
    switch (section) {
      case 'grid': return 'GRID';
      case 'map': return 'NOW';
      case 'connect': return 'CONNECT';
      case 'rooms': return 'LIVE';
      default: return 'GRID';
    }
  };
  
  return (
    <motion.div 
      className="fixed top-0 left-0 right-0 z-30 bg-black/80 backdrop-blur-md border-b border-[#E6FFF4]/20"
      initial={{ opacity: 0, y: -10 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.3 }}
      style={{ paddingTop: 'env(safe-area-inset-top)' }}
    >
      <div className="flex items-center justify-between h-16 px-4">
        <div className="flex items-center">
          <button 
            onClick={handleBack} 
            className="p-2 mr-2 rounded-full hover:bg-[#E6FFF4]/10 transition-colors"
            aria-label="Go back"
          >
            <ArrowLeft className="w-6 h-6 text-[#E6FFF4]" />
          </button>
          <div>
            <h1 className="text-lg font-semibold text-[#E6FFF4]">{profile.name}</h1>
            {compatibilityScore && (
              <div className="flex items-center text-xs text-[#B7FEE2]">
                <Heart className="w-3 h-3 mr-1" fill="#B7FEE2" />
                <span>{compatibilityScore}% Match</span>
              </div>
            )}
          </div>
        </div>
        
        {onToggleSection && (
          <div className="flex items-center space-x-2">
            <span className="text-xs text-gray-400">View as:</span>
            <div className="flex bg-[#202020] rounded-lg p-1">
              <button
                onClick={() => onToggleSection('grid')}
                className={`p-1.5 rounded-md ${activeSection === 'grid' ? 'bg-[#E6FFF4]/20 text-[#E6FFF4]' : 'text-gray-400'}`}
                title="GRID View"
              >
                <Grid className="w-4 h-4" />
              </button>
              <button
                onClick={() => onToggleSection('map')}
                className={`p-1.5 rounded-md ${activeSection === 'map' ? 'bg-[#E6FFF4]/20 text-[#E6FFF4]' : 'text-gray-400'}`}
                title="NOW View"
              >
                <Map className="w-4 h-4" />
              </button>
              <button
                onClick={() => onToggleSection('connect')}
                className={`p-1.5 rounded-md ${activeSection === 'connect' ? 'bg-[#E6FFF4]/20 text-[#E6FFF4]' : 'text-gray-400'}`}
                title="CONNECT View"
              >
                <Sparkles className="w-4 h-4" />
              </button>
              <button
                onClick={() => onToggleSection('rooms')}
                className={`p-1.5 rounded-md ${activeSection === 'rooms' ? 'bg-[#E6FFF4]/20 text-[#E6FFF4]' : 'text-gray-400'}`}
                title="LIVE View"
              >
                <Video className="w-4 h-4" />
              </button>
            </div>
          </div>
        )}
      </div>
      
      {activeSection && (
        <div className="px-4 py-1 bg-[#181818]">
          <span className="text-xs text-gray-400">
            Viewing as appears in <span className="text-[#E6FFF4] font-medium">{getSectionName(activeSection)}</span>
          </span>
        </div>
      )}
    </motion.div>
  );
};

export default ProfileHeader;
