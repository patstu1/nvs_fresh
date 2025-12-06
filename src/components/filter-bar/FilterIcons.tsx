
import React from 'react';
import { FilterType } from '@/types/FilterTypes';

interface FilterButtonsProps {
  activeFilter: FilterType;
  onFilterChange: (filter: FilterType) => void;
  className?: string;
}

export const FilterButtons: React.FC<FilterButtonsProps> = ({ 
  activeFilter, 
  onFilterChange,
  className = ''
}) => {
  const filters = [
    { id: 'popular', label: 'popular' },
    { id: 'new', label: 'new' },
    { id: 'nearby', label: 'nearby' },
    { id: 'visiting', label: 'visiting' },
    { id: 'position', label: 'position' },
    { id: 'age', label: 'age' },
    { id: 'tags', label: 'tags' },
    { id: 'connect', label: 'connect' }
  ];

  return (
    <div className={className}>
      {filters.map((filter) => (
        <div
          key={filter.id}
          onClick={() => onFilterChange(filter.id as FilterType)}
          className={`px-2 py-1.5 text-xs rounded cursor-pointer whitespace-nowrap transition-colors
            ${activeFilter === filter.id 
              ? 'bg-[#C2FFE6] text-black' 
              : 'hover:bg-[#2A2A2A] text-[#C2FFE6]'
            }`}
        >
          {filter.label}
        </div>
      ))}
    </div>
  );
};
