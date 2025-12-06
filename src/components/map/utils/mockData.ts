
import { User, Venue, Location } from '../types/markerTypes';

/**
 * Generate mock user data for map testing
 */
export const getMockUsers = (): User[] => {
  return [
    {
      id: '1',
      name: 'Anonymous',
      position: { lat: 37.7749, lng: -122.4194 },
      profileImage: 'https://via.placeholder.com/150',
      isNew: true,
      hasPrivateAlbum: true,
      isOnline: true
    },
    {
      id: '2',
      name: 'Anonymous',
      position: { lat: 37.7599, lng: -122.4148 },
      profileImage: 'https://via.placeholder.com/150?text=XXX',
      hasPrivateAlbum: true
    },
    {
      id: '3',
      name: 'Anonymous',
      position: { lat: 37.7841, lng: -122.4075 },
      profileImage: 'https://via.placeholder.com/150?text=Hot'
    },
    {
      id: '4',
      name: 'Anonymous',
      position: { lat: 37.7694, lng: -122.4862 },
      profileImage: 'https://via.placeholder.com/150',
      isOnline: true
    },
    {
      id: '5',
      name: 'Anonymous',
      position: { lat: 37.7936, lng: -122.3930 },
      profileImage: 'https://via.placeholder.com/150?text=Party'
    }
  ];
};

/**
 * Generate mock venue data for map testing
 */
export const getMockVenues = (): Venue[] => {
  return [
    {
      id: '101',
      name: 'The Club',
      position: { lat: 37.7833, lng: -122.4167 },
      type: 'club',
      userCount: 24,
      image: 'https://via.placeholder.com/150?text=Club',
      activeUsers: 24
    },
    {
      id: '102',
      name: 'Hot Bar',
      position: { lat: 37.7683, lng: -122.4294 },
      type: 'bar',
      userCount: 15,
      image: 'https://via.placeholder.com/150?text=Bar',
      activeUsers: 15
    },
    {
      id: '103',
      name: 'Cruise Spot',
      position: { lat: 37.8036, lng: -122.4472 },
      type: 'cruise',
      userCount: 8,
      image: 'https://via.placeholder.com/150?text=Cruise',
      activeUsers: 8
    }
  ];
};

/**
 * Generate more detailed mock user data
 */
export const generateMockUserDetails = (user: User) => {
  return {
    ...user,
    age: Math.floor(Math.random() * 20) + 21,
    height: `${Math.floor(Math.random() * 30) + 165}cm`,
    weight: `${Math.floor(Math.random() * 30) + 65}kg`,
    image: user.profileImage || 'https://via.placeholder.com/400x600?text=NSFW',
    distance: `${(Math.random() * 5).toFixed(1)}`,
    lastActive: ['now', '5m', '20m', '1h', '3h'][Math.floor(Math.random() * 5)],
    privateAlbum: Boolean(user.hasPrivateAlbum),
    emojis: ['🔥', '👀', '💯', '👅', '😈', '🍆'].sort(() => 0.5 - Math.random()).slice(0, 3),
    privateAlbumCount: user.hasPrivateAlbum ? Math.floor(Math.random() * 10) + 3 : 0,
    explicitMainPhoto: Math.random() > 0.5,
  };
};

// Export an empty array as the default to maintain compatibility
export const mockUsers: User[] = [];
export const mockVenues: Venue[] = [];
