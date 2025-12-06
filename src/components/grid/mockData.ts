import { UserProfile } from '@/types/UserProfile';

// Helper function to generate random profiles
const generateRandomProfiles = (count: number, startIndex: number = 0): UserProfile[] => {
  const tribes = ['jock', 'twink', 'bear', 'clean-cut', 'daddy', 'leather', 'geek', 'poz', 'trans'];
  const bodyTypes: ('slim' | 'average' | 'muscular' | 'toned' | 'stocky' | 'athletic')[] = ['slim', 'average', 'muscular', 'toned', 'stocky', 'athletic'];
  const emojis = ['🔥', '💪', '💦', '🍑', '🐻', '🍆', '😈', '🏋️‍♂️', '🤓', '🎮', '🔄', '👅', '🍒', '👨‍💻', '✈️', '🏊‍♂️'];
  const lastActiveOptions = ['Online', 'Just now', '1 min ago', '5 min ago', '10 min ago', '15 min ago', '30 min ago', '1 hr ago', '2 hrs ago', 'Today'];
  const locations = ['San Francisco', 'New York', 'Los Angeles', 'Chicago', 'Miami', 'Seattle', 'Austin', 'Denver', 'Portland', 'Boston'];
  const tagOptions = ['travel', 'fitness', 'music', 'art', 'gaming', 'outdoors', 'tech', 'food', 'sports', 'movies', 'photography', 'dance', 'yoga'];

  return Array.from({ length: count }, (_, i) => {
    const idx = i + startIndex;
    const randomEmojis = Array.from({ length: Math.floor(Math.random() * 3) + 1 }, () => 
      emojis[Math.floor(Math.random() * emojis.length)]
    );
    
    const hasPrivateAlbum = Math.random() > 0.7;
    
    return {
      id: `profile-${idx}`,
      image: `https://source.unsplash.com/random/500x500?face&${idx}`,
      name: `User${idx}`,
      age: Math.floor(Math.random() * 30) + 18,
      emojis: randomEmojis,
      distance: parseFloat((Math.random() * 20).toFixed(1)),
      lastActive: lastActiveOptions[Math.floor(Math.random() * lastActiveOptions.length)],
      bio: Math.random() > 0.3 ? `Hi there! I'm User${idx} and I love to explore new places.` : undefined,
      height: Math.floor(Math.random() * 30) + 165,
      weight: Math.floor(Math.random() * 50) + 60,
      bodyType: bodyTypes[Math.floor(Math.random() * bodyTypes.length)],
      ethnicity: Math.random() > 0.5 ? 'white' : Math.random() > 0.5 ? 'latino' : 'asian',
      lookingFor: Math.random() > 0.5 ? ['chat', 'dates'] : ['friends', 'relationships'],
      tribe: tribes[Math.floor(Math.random() * tribes.length)],
      compatibilityScore: Math.floor(Math.random() * 100),
      hasPrivateAlbum: hasPrivateAlbum,
      privateAlbum: hasPrivateAlbum ? {
        isShared: Math.random() > 0.7,
        images: Array.from({ length: Math.floor(Math.random() * 5) + 2 }, (_, j) => 
          `https://source.unsplash.com/random/500x500?person&${idx}-${j}`
        )
      } : undefined,
      location: locations[Math.floor(Math.random() * locations.length)],
      tags: Array.from({ length: Math.floor(Math.random() * 4) + 1 }, () => 
        tagOptions[Math.floor(Math.random() * tagOptions.length)]
      ),
    };
  });
};

// Original sample profiles - keeping for reference
export const sampleProfiles: UserProfile[] = [
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
    compatibilityScore: 75,
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
    compatibilityScore: 92,
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
    compatibilityScore: 60,
  },
  {
    id: '4',
    image: 'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=500&h=500&fit=crop',
    name: 'Daniel',
    age: 26,
    emojis: ['🐻', '🍆'],
    distance: 5.1,
    lastActive: '1 hr ago',
    bio: 'Looking for a long-term relationship',
    height: 185,
    weight: 95,
    bodyType: 'stocky',
    ethnicity: 'white',
    lookingFor: ['relationships'],
    tribe: 'bear',
    compatibilityScore: 88,
  },
  {
    id: '5',
    image: 'https://images.unsplash.com/photo-1531427186611-ecfd6d936e63?w=500&h=500&fit=crop',
    name: 'Ethan',
    age: 29,
    emojis: ['😈', '🏋️‍♂️'],
    distance: 0.3,
    lastActive: 'Online',
    bio: 'Love hitting the gym and exploring new places',
    height: 178,
    weight: 79,
    bodyType: 'athletic',
    ethnicity: 'asian',
    lookingFor: ['friends', 'dates'],
    tribe: 'jock',
    compatibilityScore: 70,
  },
  {
    id: '6',
    image: 'https://images.unsplash.com/photo-1519085360753-af0119f8252e?w=500&h=500&fit=crop',
    name: 'Finn',
    age: 24,
    emojis: ['🤓', '🎮'],
    distance: 3.8,
    lastActive: '12 min ago',
    bio: 'Gamer and tech enthusiast',
    height: 170,
    weight: 65,
    bodyType: 'slim',
    ethnicity: 'white',
    lookingFor: ['chat', 'friends'],
    tribe: 'twink',
    compatibilityScore: 95,
  },
];

// Extended profile set for a more realistic app experience
export const extendedProfiles: UserProfile[] = [
  ...sampleProfiles,
  ...generateRandomProfiles(94, 7) // Generate 94 more profiles to have 100 total
];
