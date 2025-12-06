
import { UserProfile } from '@/types/UserProfile';

export const searchProfiles = (
  profiles: UserProfile[], 
  searchQuery: string, 
  searchType: 'all' | 'profiles' | 'tags' | 'cities'
): UserProfile[] => {
  const query = searchQuery.toLowerCase().trim();
  
  if (!query) return [];
  
  switch(searchType) {
    case 'profiles':
      return profiles.filter(profile => 
        profile.name.toLowerCase().includes(query) ||
        profile.bio?.toLowerCase().includes(query)
      );
    case 'tags':
      return profiles.filter(profile => 
        profile.tags?.some(tag => tag.toLowerCase().includes(query)) ||
        profile.tribe?.toLowerCase().includes(query)
      );
    case 'cities':
      return profiles.filter(profile => 
        profile.location?.toLowerCase().includes(query)
      );
    default:
      // 'all' search type - search across everything
      return profiles.filter(profile => 
        profile.name.toLowerCase().includes(query) ||
        profile.bio?.toLowerCase().includes(query) ||
        profile.tags?.some(tag => tag.toLowerCase().includes(query)) ||
        profile.tribe?.toLowerCase().includes(query) ||
        profile.location?.toLowerCase().includes(query)
      );
  }
};

// Sample data moved to a separate module
export const sampleSearchProfiles: UserProfile[] = [
  {
    id: '1',
    image: 'https://images.unsplash.com/photo-1504257432389-52343af06ae3?w=500&h=500&fit=crop',
    name: 'Alex',
    age: 28,
    emojis: ['🔥', '💪'],
    distance: 0.8,
    lastActive: '2 min ago',
    bio: 'Gym rat looking for workout buddies',
    height: 183,
    weight: 82,
    bodyType: 'muscular',
    ethnicity: 'white',
    lookingFor: ['dates', 'friends', 'networking'],
    tribe: 'jock',
    location: 'San Francisco',
    tags: ['fitness', 'outdoors', 'tech'],
  },
  {
    id: '2',
    image: 'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=500&h=500&fit=crop',
    name: 'Brandon',
    age: 23,
    emojis: ['💦', '🍑'],
    distance: 1.2,
    lastActive: 'Online',
    bio: 'Recent grad, new to the area',
    height: 175,
    weight: 68,
    bodyType: 'slim',
    ethnicity: 'latino',
    lookingFor: ['chat', 'right now'],
    tribe: 'twink',
    location: 'Los Angeles',
    tags: ['gaming', 'movies', 'art'],
  },
  {
    id: '3',
    image: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=500&h=500&fit=crop',
    name: 'Carlos',
    age: 32,
    emojis: ['🔄', '👅'],
    distance: 2.5,
    lastActive: '35 min ago',
    bio: 'Just looking to meet cool people',
    height: 180,
    weight: 77,
    bodyType: 'average',
    ethnicity: 'latino',
    lookingFor: ['relationships', 'dates'],
    tribe: 'clean-cut',
    location: 'Miami',
    tags: ['travel', 'cuisine', 'music'],
  },
];
