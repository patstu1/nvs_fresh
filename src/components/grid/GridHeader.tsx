
import React from 'react';
import { Filter, ArrowDownAZ, MapPin, Heart, Clock, Users, Flame } from 'lucide-react';
import { ToggleGroup, ToggleGroupItem } from "@/components/ui/toggle-group";

interface GridHeaderProps {
  isFilterOpen: boolean;
  setIsFilterOpen: (isOpen: boolean) => void;
  sortBy: string;
  setSortBy: (sort: string) => void;
  activeFilterState: string;
  setActiveFilterState: (filter: string) => void;
}

const GridHeader: React.FC<GridHeaderProps> = ({
  isFilterOpen,
  setIsFilterOpen,
  sortBy,
  setSortBy,
  activeFilterState,
  setActiveFilterState
}) => {
  return (
    <div 
      className="fixed top-16 left-0 right-0 bg-black bg-opacity-100 z-40 border-b border-yobro-teal px-2 py-2"
      style={{ 
        backdropFilter: 'blur(12px)',
        WebkitBackdropFilter: 'blur(12px)',
        paddingTop: 'env(safe-area-inset-top)'
      }}
    >
      <div className="flex justify-between items-center">
        <div className="flex space-x-2">
          {/* Filter button */}
          <button
            onClick={() => setIsFilterOpen(!isFilterOpen)}
            className="p-2 rounded-full bg-[#2A2A2A] flex items-center justify-center"
          >
            <Filter className="w-5 h-5 text-yobro-teal" />
          </button>
          
          {/* Sort buttons */}
          <ToggleGroup type="single" value={sortBy} onValueChange={(value) => {
            if (value) setSortBy(value as 'distance' | 'activity' | 'name');
          }}>
            <ToggleGroupItem value="distance" aria-label="Sort by distance">
              <MapPin className="w-4 h-4" />
            </ToggleGroupItem>
            <ToggleGroupItem value="activity" aria-label="Sort by activity">
              <Clock className="w-4 h-4" />
            </ToggleGroupItem>
            <ToggleGroupItem value="name" aria-label="Sort by name">
              <ArrowDownAZ className="w-4 h-4" />
            </ToggleGroupItem>
          </ToggleGroup>
        </div>
        
        {/* Category buttons */}
        <ToggleGroup type="single" value={activeFilterState} onValueChange={(value) => {
          if (value) setActiveFilterState(value as 'all' | 'favorites' | 'compatibility');
        }}>
          <ToggleGroupItem value="all" aria-label="All Users">
            <Users className="w-4 h-4" />
          </ToggleGroupItem>
          <ToggleGroupItem value="favorites" aria-label="Favorites">
            <Heart className="w-4 h-4" />
          </ToggleGroupItem>
          <ToggleGroupItem value="compatibility" aria-label="AI Compatibility">
            <Flame className="w-4 h-4" />
          </ToggleGroupItem>
        </ToggleGroup>
      </div>
    </div>
  );
};

export default GridHeader;
