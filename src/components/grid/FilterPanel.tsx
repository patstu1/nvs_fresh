
import React from 'react';
import { Heart, Users, Flame } from 'lucide-react';
import { ToggleGroup, ToggleGroupItem } from "@/components/ui/toggle-group";

interface FilterPanelProps {
  filterOptions: {
    distance: number;
    minAge: number;
    maxAge: number;
    position: string | null;
    tribe: string | null;
    onlineOnly: boolean;
    minCompatibility: number;
  };
  setFilterOptions: React.Dispatch<React.SetStateAction<{
    distance: number;
    minAge: number;
    maxAge: number;
    position: string | null;
    tribe: string | null;
    onlineOnly: boolean;
    minCompatibility: number;
  }>>;
  activeFilterState: string;
  onClose: () => void;
  onReset: () => void;
}

const FilterPanel: React.FC<FilterPanelProps> = ({
  filterOptions,
  setFilterOptions,
  activeFilterState,
  onClose,
  onReset
}) => {
  return (
    <div className="bg-black border-b border-[#333333] p-4 animate-in fade-in slide-in-from-top-4 z-20">
      <h3 className="text-lg font-medium text-white mb-4">Filter Profiles</h3>
      
      <div className="space-y-4">
        {/* Distance filter */}
        <div>
          <div className="flex justify-between mb-2">
            <label className="text-sm text-white">Distance</label>
            <span className="text-sm text-gray-400">
              {filterOptions.distance === 100 ? 'Any distance' : `${filterOptions.distance} km`}
            </span>
          </div>
          <input
            type="range"
            min="1"
            max="100"
            value={filterOptions.distance}
            onChange={(e) => setFilterOptions(prev => ({
              ...prev,
              distance: parseInt(e.target.value)
            }))}
            className="w-full accent-yobro-blue h-2 bg-[#2A2A2A] rounded-lg cursor-pointer"
          />
        </div>
        
        {/* Age filter */}
        <div>
          <div className="flex justify-between mb-2">
            <label className="text-sm text-white">Age range</label>
            <span className="text-sm text-gray-400">
              {filterOptions.minAge} - {filterOptions.maxAge === 99 ? '99+' : filterOptions.maxAge}
            </span>
          </div>
          <div className="flex space-x-4">
            <input
              type="range"
              min="18"
              max="99"
              value={filterOptions.minAge}
              onChange={(e) => setFilterOptions(prev => ({
                ...prev,
                minAge: parseInt(e.target.value),
                maxAge: Math.max(prev.maxAge, parseInt(e.target.value))
              }))}
              className="w-full accent-yobro-blue h-2 bg-[#2A2A2A] rounded-lg cursor-pointer"
            />
            <input
              type="range"
              min="18"
              max="99"
              value={filterOptions.maxAge}
              onChange={(e) => setFilterOptions(prev => ({
                ...prev,
                maxAge: parseInt(e.target.value),
                minAge: Math.min(prev.minAge, parseInt(e.target.value))
              }))}
              className="w-full accent-yobro-blue h-2 bg-[#2A2A2A] rounded-lg cursor-pointer"
            />
          </div>
        </div>
        
        {/* Position filter */}
        <div>
          <label className="text-sm text-white block mb-2">Position</label>
          <div className="flex flex-wrap gap-2">
            {['top', 'bottom', 'vers', 'not-specified'].map(position => (
              <button
                key={position}
                onClick={() => setFilterOptions(prev => ({
                  ...prev,
                  position: prev.position === position ? null : position
                }))}
                className={`px-3 py-1 rounded-full text-sm ${
                  filterOptions.position === position 
                    ? 'bg-yobro-blue text-white' 
                    : 'bg-[#2A2A2A] text-gray-300'
                }`}
              >
                {position.replace('-', ' ')}
              </button>
            ))}
          </div>
        </div>
        
        {/* Tribe filter */}
        <div>
          <label className="text-sm text-white block mb-2">Tribe</label>
          <div className="flex flex-wrap gap-2">
            {['bear', 'jock', 'twink', 'otter', 'daddy', 'clean-cut', 'rugged', 'not-specified'].map(tribe => (
              <button
                key={tribe}
                onClick={() => setFilterOptions(prev => ({
                  ...prev,
                  tribe: prev.tribe === tribe ? null : tribe
                }))}
                className={`px-3 py-1 rounded-full text-sm ${
                  filterOptions.tribe === tribe 
                    ? 'bg-yobro-blue text-white' 
                    : 'bg-[#2A2A2A] text-gray-300'
                }`}
              >
                {tribe.replace('-', ' ')}
              </button>
            ))}
          </div>
        </div>
        
        {/* Online only toggle */}
        <div className="flex items-center justify-between">
          <label className="text-sm text-white">Online only</label>
          <button
            onClick={() => setFilterOptions(prev => ({
              ...prev,
              onlineOnly: !prev.onlineOnly
            }))}
            className={`w-12 h-6 rounded-full relative ${
              filterOptions.onlineOnly ? 'bg-green-500' : 'bg-[#2A2A2A]'
            }`}
          >
            <span 
              className={`absolute w-5 h-5 rounded-full bg-white top-0.5 transform transition-transform ${
                filterOptions.onlineOnly ? 'translate-x-6' : 'translate-x-1'
              }`}
            />
          </button>
        </div>
        
        {/* Compatibility score filter (only visible when in compatibility mode) */}
        {activeFilterState === 'compatibility' && (
          <div>
            <div className="flex justify-between mb-2">
              <label className="text-sm text-white">Minimum compatibility</label>
              <span className="text-sm text-gray-400">{filterOptions.minCompatibility}%</span>
            </div>
            <input
              type="range"
              min="0"
              max="100"
              step="5"
              value={filterOptions.minCompatibility}
              onChange={(e) => setFilterOptions(prev => ({
                ...prev,
                minCompatibility: parseInt(e.target.value)
              }))}
              className="w-full accent-yobro-teal h-2 bg-[#2A2A2A] rounded-lg cursor-pointer"
            />
          </div>
        )}
        
        {/* Filter buttons */}
        <div className="flex space-x-3 pt-2">
          <button
            onClick={onReset}
            className="flex-1 py-2 text-sm font-medium text-white bg-[#2A2A2A] rounded-full"
          >
            Reset
          </button>
          <button
            onClick={onClose}
            className="flex-1 py-2 text-sm font-medium text-black bg-yobro-teal rounded-full"
          >
            Apply
          </button>
        </div>
      </div>
    </div>
  );
};

export default FilterPanel;
