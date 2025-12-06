
import React from 'react';
import { useLocation } from 'react-router-dom';
import FilterBar from '@/components/FilterBar';
import { FilterType } from '@/types/FilterTypes';
import { toast } from '@/hooks/use-toast';

const GlobalToolbar = () => {
  const [activeFilter, setActiveFilter] = React.useState<FilterType>('popular');
  const location = useLocation();
  
  // Don't show on map pages - make this the first check and ensure it catches all map routes
  if (location.pathname === '/map' || 
      location.pathname.startsWith('/map/') ||
      location.pathname.includes('map')) {
    return null;
  }
  
  // Don't show on auth pages and specific pages where search shouldn't appear
  const hideToolbarPaths = [
    '/auth',
    '/profile-setup',
    '/onboarding',
    '/connect-stats',
    '/deployment-ready',
    '/profile',
  ];
  
  // Check if current path matches any path in the hide list (including partial matches)
  const shouldHideToolbar = hideToolbarPaths.some(path => 
    location.pathname.includes(path)
  );
  
  if (shouldHideToolbar) {
    return null;
  }

  const handleFilterChange = (filter: FilterType) => {
    setActiveFilter(filter);
    toast({
      title: "Filter Changed",
      description: `You selected ${filter} view`,
    });
  };

  return (
    <div className="fixed top-[130px] left-0 right-0 w-full bg-black/90 backdrop-blur-md z-30 border-b border-[#C2FFE6]/20">
      <FilterBar
        activeFilter={activeFilter}
        onFilterChange={handleFilterChange}
      />
    </div>
  );
};

export default GlobalToolbar;
