
import React, { useState, useEffect, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import { toast } from '@/hooks/use-toast';
import ProfileGrid from './grid/ProfileGrid';
import { useGridFilters } from './grid/useGridFilters';
import { extendedProfiles } from './grid/mockData';
import { FilterType } from '@/types/FilterTypes';
import FilterBar from './FilterBar';

interface GridViewProps {
  onProfileClick: (id: string) => void;
  activeFilter?: FilterType;
}

const GridView: React.FC<GridViewProps> = ({ onProfileClick, activeFilter = 'popular' }) => {
  const [activeFilterState, setActiveFilterState] = useState<string>(activeFilter || 'all');
  const [visibleProfiles, setVisibleProfiles] = useState(25);
  const gridRef = useRef<HTMLDivElement>(null);
  
  const {
    filterOptions,
    setFilterOptions,
    resetFilters,
    sortBy,
    setSortBy,
    filteredProfiles
  } = useGridFilters(extendedProfiles, activeFilterState);

  const handleFilterChange = (filter: FilterType) => {
    setActiveFilterState(filter);
    toast({
      title: "Filter Changed",
      description: `View changed to ${filter}`,
    });
  };
  
  useEffect(() => {
    if (activeFilter) {
      setActiveFilterState(activeFilter);
    }
  }, [activeFilter]);

  useEffect(() => {
    const handleScroll = () => {
      if (!gridRef.current) return;
      
      const scrollPosition = window.innerHeight + window.scrollY;
      const bottomOfContent = gridRef.current.offsetTop + gridRef.current.offsetHeight;
      
      if (scrollPosition >= bottomOfContent - 500) {
        if (visibleProfiles < filteredProfiles.length) {
          setVisibleProfiles(prev => Math.min(prev + 15, filteredProfiles.length));
        }
      }
    };
    
    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, [visibleProfiles, filteredProfiles.length]);

  const visibleProfilesData = filteredProfiles.slice(0, visibleProfiles);

  // Add toolbar visibility check
  useEffect(() => {
    console.log('GridView mounted - checking toolbar visibility');
    const checkAndFixSymbolToolbar = () => {
      const toolbarEl = document.querySelector('.symbol-toolbar-wrapper');
      if (toolbarEl instanceof HTMLElement) {
        if (toolbarEl.style.visibility !== 'visible' || 
            toolbarEl.style.display !== 'flex' ||
            toolbarEl.style.opacity !== '1') {
          console.log('Fixing toolbar visibility from GridView');
          Object.assign(toolbarEl.style, {
            display: 'flex',
            visibility: 'visible',
            opacity: '1',
            position: 'fixed',
            bottom: '80px'
          });
        }
      }
    };
    
    checkAndFixSymbolToolbar();
    const timer = setTimeout(checkAndFixSymbolToolbar, 1000);
    return () => clearTimeout(timer);
  }, []);

  return (
    <div className="bg-black min-h-screen pb-60 pt-28 text-yobro-teal" ref={gridRef}>
      <FilterBar 
        activeFilter={activeFilterState as FilterType}
        onFilterChange={handleFilterChange}
      />
      
      <div className="mt-20 mb-60">
        <ProfileGrid 
          profiles={visibleProfilesData} 
          onProfileClick={onProfileClick} 
        />
        
        {visibleProfiles < filteredProfiles.length && (
          <div className="text-center py-8">
            <div className="inline-block h-5 w-5 animate-spin rounded-full border-2 border-[#4BEFE0] border-t-transparent"></div>
            <p className="mt-2 text-sm text-[#4BEFE0]">Loading more profiles...</p>
          </div>
        )}
        
        {visibleProfiles >= filteredProfiles.length && filteredProfiles.length > 20 && (
          <p className="text-center py-8 text-sm text-[#4BEFE0]">
            You've reached the end of results for now
          </p>
        )}
      </div>
    </div>
  );
}

export default GridView;
