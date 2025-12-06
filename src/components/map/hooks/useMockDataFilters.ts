
import { useState, useEffect, useMemo } from 'react';
import { mockUsers, mockVenues } from '../utils/mockData';
import { User, Venue } from '../types/markerTypes';

interface UseMockDataFiltersProps {
  hideUserLocation?: boolean;
  filters?: any;
  useNsfwUsers?: boolean;
}

export const useMockDataFilters = ({
  hideUserLocation = false,
  filters = {},
  useNsfwUsers = false
}: UseMockDataFiltersProps) => {
  const [isDataLoaded, setIsDataLoaded] = useState(false);
  const [filteredUsers, setFilteredUsers] = useState<User[]>([]);
  const [filteredVenues, setFilteredVenues] = useState<Venue[]>([]);
  const [clusterMarkers, setClusterMarkers] = useState<any[]>([]);

  // Generate user data with more options for NOW section
  const generateUsers = useMemo(() => {
    // Start with base mock users
    let users = [...mockUsers];
    
    // Add NSFW users for NOW section
    if (useNsfwUsers) {
      // Add additional users with NSFW content
      const nsfwUsers = Array.from({ length: 25 }, (_, i) => ({
        id: `nsfw-user-${i}`,
        name: `Anonymous${i}`,
        position: {
          lat: 34.05 + (Math.random() - 0.5) * 0.1,
          lng: -118.25 + (Math.random() - 0.5) * 0.1
        },
        profileImage: `https://picsum.photos/id/${200 + i}/200/200`,
        isNew: Math.random() > 0.7,
        hasPrivateAlbum: Math.random() > 0.5,
        isOnline: Math.random() > 0.7,
        age: Math.floor(Math.random() * 20) + 21,
        tags: ['now', 'nsfw']
      }));
      
      users = [...users, ...nsfwUsers];
    }
    
    return users;
  }, [useNsfwUsers]);
  
  // Simulate data loading and filtering
  useEffect(() => {
    const loadData = async () => {
      // Simulate API delay
      await new Promise(resolve => setTimeout(resolve, 1000));
      
      // Apply filters (simplified)
      let userResults = generateUsers;
      let venueResults = mockVenues;
      
      // Apply basic filters
      if (filters) {
        // Filter by position if specified
        if (filters.position) {
          userResults = userResults.filter((user: any) => 
            user.position && user.position.vers === filters.position
          );
        }
        
        // Filter by age range if specified
        if (filters.ageMin && filters.ageMax) {
          userResults = userResults.filter((user: any) => 
            user.age && user.age >= filters.ageMin && user.age <= filters.ageMax
          );
        }
        
        // Filter by venue type if specified
        if (filters.venueType) {
          venueResults = venueResults.filter((venue) => 
            venue.type === filters.venueType
          );
        }
      }
      
      // Generate a few clusters for dense areas (simplified)
      const clusters = [
        {
          id: 'cluster-1',
          position: { lat: 34.052, lng: -118.243 },
          count: 22,
          points: userResults.slice(0, 22)
        },
        {
          id: 'cluster-2',
          position: { lat: 34.047, lng: -118.259 },
          count: 12,
          points: userResults.slice(22, 34)
        },
        {
          id: 'cluster-3',
          position: { lat: 34.061, lng: -118.232 },
          count: 10, 
          points: userResults.slice(34, 44)
        }
      ];
      
      setFilteredUsers(userResults);
      setFilteredVenues(venueResults);
      setClusterMarkers(clusters);
      setIsDataLoaded(true);
    };
    
    loadData();
  }, [filters, generateUsers]);

  return {
    filteredUsers,
    filteredVenues,
    clusterMarkers,
    isDataLoaded
  };
};
