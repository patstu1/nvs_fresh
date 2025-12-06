
import React from 'react';
import { Heart } from 'lucide-react';
import UserProfileTile from './UserProfileTile';

// Sample favorite profiles
const favoriteProfiles = [
  {
    id: '1',
    image: 'https://images.unsplash.com/photo-1504257432389-52343af06ae3?w=500&h=500&fit=crop',
    name: 'Alex',
    emojis: ['🔥', '💪'],
    distance: 0.8,
  },
  {
    id: '3',
    image: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=500&h=500&fit=crop',
    name: 'Carlos',
    emojis: ['🔄', '👅'],
    distance: 2.5,
  },
  {
    id: '6',
    image: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=500&h=500&fit=crop',
    name: 'Franklin',
    emojis: ['👑', '💋'],
    distance: 1.7,
  },
];

interface FavoritesViewProps {
  onProfileClick: (id: string) => void;
}

const FavoritesView: React.FC<FavoritesViewProps> = ({ onProfileClick }) => {
  return (
    <div className="w-full h-full pt-16 pb-20 bg-black">
      {favoriteProfiles.length > 0 ? (
        <div className="grid grid-cols-3 gap-2 px-2">
          {favoriteProfiles.map((profile) => (
            <UserProfileTile
              key={profile.id}
              id={profile.id}
              image={profile.image}
              name={profile.name}
              emojis={profile.emojis}
              distance={profile.distance}
              onProfileClick={onProfileClick}
            />
          ))}
        </div>
      ) : (
        <div className="flex flex-col items-center justify-center h-48 p-4 bg-black/40">
          <Heart className="w-12 h-12 text-[#C2FFE6] mb-4" />
          <p className="text-[#C2FFE6] text-center">No favorites yet</p>
          <p className="text-[#C2FFE6]/70 text-sm text-center mt-2">Tap the heart icon on profiles you like</p>
        </div>
      )}
    </div>
  );
};

export default FavoritesView;
