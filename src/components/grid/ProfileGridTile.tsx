
import React from 'react';
import { UserProfile } from '@/types/UserProfile';
import { Lock, CircleCheck, MessageCircle } from 'lucide-react';
import { cn } from '@/lib/utils';
import { useNavigate } from 'react-router-dom';
import { supabase } from '@/integrations/supabase/client';
import { getOrCreateChatSession } from '@/services/chatService';

interface ProfileGridTileProps {
  profile: UserProfile;
  onProfileClick: (id: string) => void;
}

const ProfileGridTile: React.FC<ProfileGridTileProps> = ({ profile, onProfileClick }) => {
  const navigate = useNavigate();
  
  // Format distance for display
  const formatDistance = (distance: number): string => {
    if (distance < 0.1) return '<0.1 km';
    if (distance < 1) return `${Math.round(distance * 10) / 10} km`;
    return `${Math.round(distance)} km`;
  };

  const handleChatClick = async (e: React.MouseEvent) => {
    e.stopPropagation();
    
    // Check if user is authenticated
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) {
      navigate('/auth');
      return;
    }
    
    // Get or create chat session
    const { data, error } = await getOrCreateChatSession(profile.id);
    
    if (error) {
      console.error('Error creating chat session:', error);
      return;
    }
    
    if (data) {
      navigate(`/messages/${data.id}`);
    }
  };

  return (
    <div 
      className="relative cursor-pointer overflow-hidden rounded-md"
      onClick={() => onProfileClick(profile.id)}
    >
      {/* Main profile image */}
      <div className="aspect-square">
        <img 
          src={profile.image} 
          alt={profile.name}
          className="w-full h-full object-cover"
        />
      </div>

      {/* Online indicator */}
      {profile.isOnline && (
        <div className="absolute top-2 right-2 w-3 h-3 rounded-full bg-green-400 border border-white"></div>
      )}

      {/* Private album indicator */}
      {profile.hasPrivateAlbum && (
        <div className="absolute top-2 left-2 bg-black/60 rounded-full p-1">
          <Lock className="w-3 h-3 text-white" />
        </div>
      )}
      
      {/* Premium/verified indicator */}
      {profile.compatibilityScore && profile.compatibilityScore > 90 && (
        <div className="absolute top-2 right-2 bg-yellow-500/80 rounded-full p-0.5">
          <CircleCheck className="w-3 h-3 text-white" />
        </div>
      )}

      {/* Explicit photo indicator */}
      {profile.explicitMainPhoto && (
        <div className="absolute top-2 right-10 bg-[#FF3366] rounded-full px-1.5 py-0.5">
          <span className="text-[10px] font-bold text-white">XXX</span>
        </div>
      )}

      {/* Bottom info overlay */}
      <div className="absolute bottom-0 left-0 right-0 bg-gradient-to-t from-black/80 to-transparent p-2">
        <div className="flex justify-between items-end">
          <div>
            <h3 className="text-sm font-bold text-white truncate">{profile.name}</h3>
            <p className="text-xs text-white/80">{formatDistance(profile.distance)}</p>
          </div>
          <div className="flex gap-1">
            {profile.tags && profile.tags.length > 0 && (
              <span className="bg-black/50 text-white text-[10px] px-1.5 py-0.5 rounded-full">
                {profile.tags[0]}
              </span>
            )}
            
            {/* Unread message badge */}
            {profile.unreadMessages && profile.unreadMessages > 0 && (
              <div className="absolute top-2 right-8 w-4 h-4 rounded-full bg-red-500 flex items-center justify-center">
                <span className="text-[8px] font-bold text-white">{profile.unreadMessages}</span>
              </div>
            )}
            
            <button 
              onClick={handleChatClick}
              className="bg-[#E6FFF4] text-black rounded-full p-1.5 hover:bg-[#E6FFF4]/80 transition-colors"
            >
              <MessageCircle className="w-3 h-3" />
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ProfileGridTile;
