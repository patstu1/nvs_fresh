
import React from 'react';
import { Heart, Lock, Shield } from 'lucide-react';
import { UserProfile } from '@/types/UserProfile';
import { motion } from 'framer-motion';

interface ProfileImageProps {
  profile: UserProfile;
  compatibilityScore: number;
  showNsfw?: boolean;
}

const ProfileImage: React.FC<ProfileImageProps> = ({ profile, compatibilityScore, showNsfw = false }) => {
  return (
    <motion.div 
      className="relative w-full h-96"
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.5 }}
    >
      <img 
        src={profile.image} 
        alt={profile.name}
        className="w-full h-full object-cover"
        loading="eager"
      />
      
      <div className="absolute top-4 left-4 bg-black/60 backdrop-blur-sm px-3 py-2 rounded-lg flex items-center">
        <Heart className="w-4 h-4 text-[#C2FFE6] mr-2" />
        <span className="text-sm font-medium text-white">
          AI Connect: <span className="text-[#C2FFE6]">{compatibilityScore}%</span>
        </span>
      </div>
      
      {(profile.hasPrivateAlbum || showNsfw) && (
        <div className="absolute top-4 right-4 bg-black/60 backdrop-blur-sm px-3 py-2 rounded-lg flex items-center">
          <Lock className="w-4 h-4 text-[#C2FFE6] mr-2" />
          <span className="text-sm font-medium text-white">{showNsfw ? "NSFW" : "XXX"} Album</span>
        </div>
      )}
      
      {profile.verifiedPhotos && (
        <div className="absolute top-16 left-4 px-3 py-1 bg-[#293241]/80 backdrop-blur-sm text-[#C2FFE6] text-xs rounded-full flex items-center">
          <Shield className="w-3 h-3 mr-1" />
          Verified Photos
        </div>
      )}
      
      {profile.lastActive === 'Online' && (
        <div className="absolute top-16 right-4 px-3 py-1 bg-green-500 text-white text-xs rounded-full">
          Online Now
        </div>
      )}
      
      <div className="absolute bottom-0 left-0 right-0 h-1/2 bg-gradient-to-t from-black to-transparent px-4 pt-10">
        <div className="absolute bottom-4 left-4">
          <h1 className="text-3xl font-bold text-white">{profile.name}, {profile.age}</h1>
          <div className="flex flex-wrap items-center mt-1 gap-2">
            <span className="text-sm text-gray-300">
              {profile.distance < 1 ? `${Math.round(profile.distance * 1000)}m away` : `${profile.distance.toFixed(1)}km away`}
            </span>
            <span className="text-gray-500">•</span>
            <span className="text-sm text-gray-300">{profile.lastActive}</span>
            {profile.emojis && profile.emojis.length > 0 && (
              <>
                <span className="text-gray-500">•</span>
                <span className="text-sm">
                  {profile.emojis.map((emoji, index) => (
                    <span key={index} className="mr-1">{emoji}</span>
                  ))}
                </span>
              </>
            )}
          </div>
        </div>
      </div>
    </motion.div>
  );
};

export default ProfileImage;
