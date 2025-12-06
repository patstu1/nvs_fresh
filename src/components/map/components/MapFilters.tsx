
import React from 'react';
import {
  DrawerContent,
  DrawerHeader,
  DrawerTitle,
  DrawerDescription,
  DrawerFooter,
} from '@/components/ui/drawer';
import { Button } from '@/components/ui/button';
import { Switch } from '@/components/ui/switch';
import { Slider } from '@/components/ui/slider';
import { FilterSettings } from '@/types/MapTypes';

interface MapFiltersProps {
  filters: FilterSettings;
  onFilterChange: (filters: FilterSettings) => void;
  onClose: () => void;
}

const MapFilters: React.FC<MapFiltersProps> = ({
  filters,
  onFilterChange,
  onClose
}) => {
  const handleDistanceChange = (value: number[]) => {
    onFilterChange({
      ...filters,
      distance: value[0]
    });
  };

  const handleAgeRangeChange = (value: number[]) => {
    onFilterChange({
      ...filters,
      ageRange: [value[0], value[1]]
    });
  };

  return (
    <DrawerContent>
      <DrawerHeader>
        <DrawerTitle>Filter Options</DrawerTitle>
        <DrawerDescription>
          Customize who appears on your map
        </DrawerDescription>
      </DrawerHeader>

      <div className="px-4 space-y-6">
        <div className="space-y-4">
          <div className="flex items-center justify-between">
            <label className="text-sm font-medium">Online Only</label>
            <Switch 
              checked={filters.showOnline}
              onCheckedChange={(checked) => 
                onFilterChange({...filters, showOnline: checked})
              }
            />
          </div>

          <div className="space-y-2">
            <label className="text-sm font-medium">Maximum Distance (km)</label>
            <Slider
              value={[filters.distance]}
              onValueChange={handleDistanceChange}
              max={100}
              step={1}
            />
          </div>

          <div className="space-y-2">
            <label className="text-sm font-medium">Age Range</label>
            <Slider
              value={[filters.ageRange[0], filters.ageRange[1]]}
              onValueChange={handleAgeRangeChange}
              max={99}
              min={18}
              step={1}
            />
            <div className="text-xs text-gray-400">
              {filters.ageRange[0]} - {filters.ageRange[1]} years
            </div>
          </div>

          <div className="flex items-center justify-between">
            <label className="text-sm font-medium">Has Photos</label>
            <Switch 
              checked={filters.hasPhotos}
              onCheckedChange={(checked) => 
                onFilterChange({...filters, hasPhotos: checked})
              }
            />
          </div>
        </div>
      </div>

      <DrawerFooter>
        <Button variant="outline" onClick={onClose}>
          Close
        </Button>
      </DrawerFooter>
    </DrawerContent>
  );
};

export default MapFilters;
