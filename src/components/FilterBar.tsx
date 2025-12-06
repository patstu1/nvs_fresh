
import React, { useState } from 'react';
import { Filter, ArrowDownAZ, MapPin, Heart, Clock, Users, Flame } from 'lucide-react';
import { FilterButtons } from './filter-bar';
import { Button } from '@/components/ui/button';
import SearchBar from './filter-bar/SearchBar';
import { FilterType } from '@/types/FilterTypes';
import { useLocation } from 'react-router-dom';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";

interface FilterBarProps {
  activeFilter: FilterType;
  onFilterChange: (filter: FilterType) => void;
}

const FilterBar: React.FC<FilterBarProps> = ({ activeFilter, onFilterChange }) => {
  const [searchQuery, setSearchQuery] = useState('');
  const [sortBy, setSortBy] = useState<'distance' | 'activity' | 'name'>('activity');
  const [viewMode, setViewMode] = useState<'all' | 'favorites' | 'compatibility'>('all');
  const location = useLocation();

  // Don't show on map pages - this check should be first to optimize
  if (location.pathname === '/map' || 
      location.pathname.startsWith('/map/') ||
      location.pathname.includes('map')) {
    return null;
  }
  
  // Pages where search should be visible
  const searchVisiblePaths = ['/search', '/grid', '/connect', '/'];
  
  // Check if search should be visible on current path
  const showSearch = searchVisiblePaths.some(path => 
    location.pathname === path || 
    (path !== '/' && location.pathname.startsWith(path))
  );

  const handleSearchSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    // Handle search submit
    console.log('Search submitted:', searchQuery);
  };

  const filterOptions = [
    { 
      icon: <MapPin className="w-3 h-3 inline mr-1" />, 
      label: 'Distance', 
      type: 'sort', 
      value: 'distance',
      active: sortBy === 'distance',
      onClick: () => setSortBy('distance')
    },
    { 
      icon: <Clock className="w-3 h-3 inline mr-1" />, 
      label: 'Activity', 
      type: 'sort', 
      value: 'activity',
      active: sortBy === 'activity',
      onClick: () => setSortBy('activity')
    },
    { 
      icon: <ArrowDownAZ className="w-3 h-3 inline mr-1" />, 
      label: 'Name', 
      type: 'sort', 
      value: 'name',
      active: sortBy === 'name',
      onClick: () => setSortBy('name')
    },
    { 
      icon: <Users className="w-3 h-3 inline mr-1" />, 
      label: 'All', 
      type: 'view', 
      value: 'all',
      active: viewMode === 'all',
      onClick: () => setViewMode('all')
    },
    { 
      icon: <Heart className="w-3 h-3 inline mr-1" />, 
      label: 'Favorites', 
      type: 'view', 
      value: 'favorites',
      active: viewMode === 'favorites',
      onClick: () => setViewMode('favorites')
    },
    { 
      icon: <Flame className="w-3 h-3 inline mr-1" />, 
      label: 'Connect', 
      type: 'view', 
      value: 'compatibility',
      active: viewMode === 'compatibility',
      onClick: () => setViewMode('compatibility')
    }
  ];

  return (
    <div className="fixed top-[130px] left-0 right-0 w-full bg-black bg-opacity-100 z-30 border-b-2 border-[#C2FFE6]/40 shadow-lg shadow-[#40E0D0]/10">
      <div className="flex flex-col w-full">
        {/* Filter dropdown */}
        <div className="p-2 flex justify-between items-center">
          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <Button 
                variant="outline" 
                size="sm"
                className="bg-[#2A2A2A] text-[#C2FFE6] border-[#C2FFE6]/30 hover:bg-[#2A2A2A]/90"
              >
                <Filter className="w-4 h-4" />
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent 
              className="bg-[#1A1A1A] border border-[#C2FFE6]/30"
              align="start"
            >
              <div className="p-2">
                <FilterButtons
                  activeFilter={activeFilter}
                  onFilterChange={onFilterChange}
                  className="flex flex-col gap-2"
                />
              </div>
            </DropdownMenuContent>
          </DropdownMenu>
        </div>

        {/* Search bar - conditionally rendered */}
        {showSearch && (
          <SearchBar 
            searchQuery={searchQuery}
            setSearchQuery={setSearchQuery}
            onSubmit={handleSearchSubmit}
          />
        )}
      </div>
    </div>
  );
};

export default FilterBar;
