
import React from 'react';
import { MapPin, Phone, Heart, Star, Badge, Shield, User, Activity } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { cn } from '@/lib/utils';

interface ProfileCardProps {
  profile: {
    id: string;
    name: string;
    age: number;
    image: string;
    compatibility: number;
    interests: string[];
    bio: string;
    emojis?: string[];
    distance: number;
    role?: string;
    attributes?: {
      icon: React.ReactNode;
      label: string;
      value?: string | number;
      color?: string;
    }[];
    isMatch?: boolean;
  };
  onVideoCall?: (id: string) => void;
  onLike?: (id: string) => void;
  onDislike?: (id: string) => void;
  onSuperLike?: (id: string) => void;
}

const ProfileCard: React.FC<ProfileCardProps> = ({ 
  profile, 
  onVideoCall,
  onLike,
  onDislike,
  onSuperLike
}) => {
  const compatibilityColor = () => {
    if (profile.compatibility >= 85) return 'bg-[#AAFF50] text-black';
    if (profile.compatibility >= 70) return 'bg-[#C2FFE6] text-black';
    if (profile.compatibility >= 50) return 'bg-yellow-400 text-black';
    return 'bg-gray-400 text-black';
  };
  
  return (
    <div className="w-full max-w-md bg-gradient-to-b from-gray-900 to-black rounded-lg overflow-hidden mb-4 shadow-lg border border-gray-800 relative">
      {profile.isMatch && (
        <div className="absolute top-0 left-0 right-0 bg-gradient-to-r from-[#AAFF50]/80 to-[#C2FFE6]/80 p-1 z-10 text-center text-black font-medium text-sm">
          MATCH
        </div>
      )}
      
      <div className="relative">
        <img 
          src={profile.image} 
          alt={profile.name}
          className="w-full h-[370px] object-cover"
        />
        <div className="absolute bottom-0 left-0 right-0 bg-gradient-to-t from-black via-black/80 to-transparent p-4">
          <div className="flex items-center">
            <h2 className="text-2xl font-bold text-white mr-2">{profile.name}, {profile.age}</h2>
            <div className={cn("text-sm font-medium px-2 py-1 rounded-full flex items-center gap-1", compatibilityColor())}>
              <Star className="w-3 h-3" fill="currentColor" strokeWidth={0} />
              {profile.compatibility}% Match
            </div>
            {profile.role && (
              <span className="ml-2 px-2 py-0.5 rounded-full bg-purple-500/50 text-white text-xs">
                {profile.role}
              </span>
            )}
          </div>
          <div className="flex items-center text-gray-300 text-sm">
            <MapPin className="w-4 h-4 mr-1" />
            <span>{profile.distance} km away</span>
          </div>
        </div>
        
        {onVideoCall && (
          <Button
            onClick={() => onVideoCall(profile.id)}
            className="absolute top-4 right-4 bg-black/40 hover:bg-black/60 rounded-full w-10 h-10 flex items-center justify-center"
          >
            <Phone className="w-5 h-5 text-white" />
          </Button>
        )}
      </div>
      
      <div className="p-4">
        <div className="flex flex-wrap gap-2 mb-3">
          {profile.emojis && profile.emojis.map((emoji, index) => (
            <span key={index} className="text-xl">{emoji}</span>
          ))}
        </div>
        
        <p className="text-gray-300 mb-4">{profile.bio}</p>
        
        {profile.attributes && profile.attributes.length > 0 && (
          <div className="grid grid-cols-2 gap-2 mb-4">
            {profile.attributes.map((attr, idx) => (
              <div key={idx} className={`flex items-center gap-2 bg-gray-800/50 p-2 rounded-md ${attr.color}`}>
                {attr.icon}
                <div className="flex flex-col">
                  <span className="text-xs text-gray-400">{attr.label}</span>
                  {attr.value && <span className="text-sm text-white">{attr.value}</span>}
                </div>
              </div>
            ))}
          </div>
        )}
        
        <div className="flex flex-wrap gap-2">
          {profile.interests.map((interest, index) => (
            <span 
              key={index}
              className="bg-gray-800 text-gray-200 px-2 py-1 rounded-full text-xs border border-gray-700"
            >
              {interest}
            </span>
          ))}
        </div>
        
        {(onLike || onDislike || onSuperLike) && (
          <div className="flex justify-center gap-6 mt-4 pt-4 border-t border-gray-800">
            {onDislike && (
              <Button
                onClick={() => onDislike(profile.id)}
                className="w-12 h-12 rounded-full bg-gray-800 border border-gray-700 hover:bg-red-900/20 hover:border-red-400/30"
              >
                <User className="w-5 h-5 text-gray-400" />
              </Button>
            )}
            
            {onLike && (
              <Button
                onClick={() => onLike(profile.id)}
                className="w-12 h-12 rounded-full bg-gray-800 border border-[#AAFF50]/30 hover:bg-green-900/20 hover:border-[#AAFF50]"
              >
                <Heart className="w-5 h-5 text-[#AAFF50]" />
              </Button>
            )}
            
            {onSuperLike && (
              <Button
                onClick={() => onSuperLike(profile.id)}
                className="w-12 h-12 rounded-full bg-gray-800 border border-[#C2FFE6]/30 hover:bg-blue-900/20 hover:border-[#C2FFE6]"
              >
                <Activity className="w-5 h-5 text-[#C2FFE6]" />
              </Button>
            )}
          </div>
        )}
      </div>
    </div>
  );
};

export default ProfileCard;
