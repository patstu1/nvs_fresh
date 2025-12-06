
import { useState } from 'react';
import { Room, ConnectProfile } from '../RoomTypes';

export function useRoomData() {
  // Quick connect profiles
  const [popularConnects, setPopularConnects] = useState([
    { id: '1', name: 'Michael', image: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=500&h=500&fit=crop', distance: 2.4 },
    { id: '2', name: 'Alex', image: 'https://images.unsplash.com/photo-1618641986557-1ecd230959aa?w=500&h=500&fit=crop', distance: 3.1 },
    { id: '3', name: 'John', image: 'https://images.unsplash.com/photo-1568602471122-7832951cc4c5?w=500&h=500&fit=crop', distance: 1.8 },
  ]);
  
  // Available zoom rooms (city-based)
  const [citiesWithRooms, setCitiesWithRooms] = useState([
    { id: 'local-1', name: 'Local Room', country: '', userCount: 175, capacity: 200, isNearYou: true, type: 'local' as const, distance: 0 },
    { id: 'city-1', name: 'New York', country: 'USA', userCount: 175, capacity: 200, isNearYou: true, type: 'city' as const },
    { id: 'city-2', name: 'San Francisco', country: 'USA', userCount: 123, capacity: 200, isNearYou: false, type: 'city' as const },
    { id: 'city-3', name: 'London', country: 'UK', userCount: 145, capacity: 200, isNearYou: false, type: 'city' as const },
    { id: 'city-4', name: 'Tokyo', country: 'Japan', userCount: 132, capacity: 200, isNearYou: false, type: 'city' as const },
    { id: 'city-5', name: 'Paris', country: 'France', userCount: 98, capacity: 200, isNearYou: false, type: 'city' as const },
    { id: 'city-6', name: 'Berlin', country: 'Germany', userCount: 87, capacity: 200, isNearYou: false, type: 'city' as const },
  ]);
  
  // Forum topic rooms
  const [forumRooms, setForumRooms] = useState([
    { id: 'forum-1', name: 'Fitness', country: '', userCount: 147, capacity: 200, isNearYou: false, type: 'forum' as const, topic: 'Fitness & Gym' },
    { id: 'forum-2', name: 'Travel', country: '', userCount: 129, capacity: 200, isNearYou: false, type: 'forum' as const, topic: 'Travel & Adventures' },
    { id: 'forum-3', name: 'Gaming', country: '', userCount: 183, capacity: 200, isNearYou: false, type: 'forum' as const, topic: 'Gaming & Esports' },
    { id: 'forum-4', name: 'Food', country: '', userCount: 105, capacity: 200, isNearYou: false, type: 'forum' as const, topic: 'Food & Cooking' },
  ]);

  // Update local room users (in reality would be based on proximity API call)
  const updateLocalRoomUsers = () => {
    // In a real app, this would fetch users within X km of the user's location
    
    // Find users within 25km and set them as the local room count (simulated)
    const nearbyUserCount = Math.floor(Math.random() * 50) + 150; // 150-200 nearby users
    
    setCitiesWithRooms(prev => prev.map(city => 
      city.id === 'local-1' ? { ...city, userCount: nearbyUserCount } : city
    ));
    
    return nearbyUserCount;
  };

  // Update local room name
  const updateLocalRoomName = (nearestCity: string) => {
    setCitiesWithRooms(prev => prev.map(city => 
      city.id === 'local-1' 
        ? { ...city, name: `${nearestCity} (Local)` } 
        : city
    ));
  };

  return {
    popularConnects,
    citiesWithRooms,
    forumRooms,
    updateLocalRoomUsers,
    updateLocalRoomName,
    setCitiesWithRooms
  };
}
