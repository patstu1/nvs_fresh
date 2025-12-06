
import { useState, useEffect, useMemo } from 'react';
import { UserProfile } from '@/types/UserProfile';

export interface FilterOptions {
  distance: number;
  minAge: number;
  maxAge: number;
  position: string | null;
  tribe: string | null;
  onlineOnly: boolean;
  minCompatibility: number;
}

export const defaultFilterOptions: FilterOptions = {
  distance: 100,
  minAge: 18,
  maxAge: 99,
  position: null,
  tribe: null,
  onlineOnly: false,
  minCompatibility: 0,
};

export const useGridFilters = (
  profiles: UserProfile[],
  activeFilterState: string
) => {
  const [filterOptions, setFilterOptions] = useState<FilterOptions>(defaultFilterOptions);
  const [sortBy, setSortBy] = useState<string>(activeFilterState === 'nearby' ? 'distance' : 'activity');
  
  // Set initial sort based on active filter
  useEffect(() => {
    if (activeFilterState === 'nearby') {
      setSortBy('distance');
    } else if (activeFilterState === 'visiting' || activeFilterState === 'new') {
      setSortBy('activity');
    }
  }, [activeFilterState]);
  
  const resetFilters = () => {
    setFilterOptions(defaultFilterOptions);
  };
  
  // Memoize filtered profiles for performance
  const filteredProfiles = useMemo(() => {
    let results = [...profiles];
    
    // Apply specific filter based on active filter state
    if (activeFilterState === 'new') {
      // Show profiles that are "new" (in this case, just shuffle and take first 30%)
      const shuffled = [...profiles].sort(() => 0.5 - Math.random());
      results = shuffled.slice(0, Math.floor(profiles.length * 0.3));
    } else if (activeFilterState === 'nearby') {
      // Sort by distance first
      results = [...profiles].sort((a, b) => a.distance - b.distance);
    } else if (activeFilterState === 'visiting') {
      // Filter to show more "online" users
      results = profiles.filter(profile => profile.lastActive === 'Online' || profile.lastActive === 'Just now');
    } else if (activeFilterState === 'popular') {
      // Sort by compatibility score first
      results = [...profiles].sort((a, b) => (b.compatibilityScore || 0) - (a.compatibilityScore || 0));
    }
    
    // Then apply user filters
    return results.filter(profile => {
      const distanceFilter = profile.distance <= filterOptions.distance;
      const ageFilter = !profile.age || (profile.age >= filterOptions.minAge && profile.age <= filterOptions.maxAge);
      const positionFilter = filterOptions.position ? false : true; // Position filter is no longer used
      const tribeFilter = filterOptions.tribe ? profile.tribe === filterOptions.tribe : true;
      const onlineOnlyFilter = filterOptions.onlineOnly ? profile.lastActive === 'Online' : true;
      const compatibilityFilter = profile.compatibilityScore !== undefined ? 
        profile.compatibilityScore >= filterOptions.minCompatibility : true;
      
      return distanceFilter && ageFilter && positionFilter && tribeFilter && onlineOnlyFilter && compatibilityFilter;
    }).sort((a, b) => {
      if (sortBy === 'distance') {
        return a.distance - b.distance;
      } else if (sortBy === 'activity') {
        // Sort by online status first, then by last active time
        const aOnline = a.lastActive === 'Online';
        const bOnline = b.lastActive === 'Online';
        if (aOnline && !bOnline) return -1;
        if (!aOnline && bOnline) return 1;
        // For demo purposes, just random sort if both same online status
        return 0.5 - Math.random();
      } else if (sortBy === 'name') {
        return a.name.localeCompare(b.name);
      }
      return 0;
    });
  }, [profiles, activeFilterState, filterOptions, sortBy]);

  return {
    filterOptions,
    setFilterOptions,
    resetFilters,
    sortBy,
    setSortBy,
    filteredProfiles
  };
};
