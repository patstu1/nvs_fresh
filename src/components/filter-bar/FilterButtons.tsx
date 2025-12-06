
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
  const filters: { value: FilterType; label: string }[] = [
    { value: 'popular', label: 'Popular' },
    { value: 'nearby', label: 'Nearby' },
    { value: 'new', label: 'New' },
    { value: 'visiting', label: 'Visiting' },
    { value: 'position', label: 'Position' },
    { value: 'age', label: 'Age' },
    { value: 'tags', label: 'Tags' },
    { value: 'connect', label: 'Connect' },
    { value: 'compatibility', label: 'Compatibility' }
  ];

  return (
    <div className={`${className}`}>
      {filters.map((filter) => (
        <button
          key={filter.value}
          onClick={() => onFilterChange(filter.value)}
          className={`text-sm px-4 py-2 rounded-full transition-colors w-full text-left ${
            activeFilter === filter.value
              ? 'bg-[#40E0D0] text-black font-medium'
              : 'text-[#C2FFE6] hover:bg-[#40E0D0]/10'
          }`}
        >
          {filter.label}
        </button>
      ))}
    </div>
  );
};
