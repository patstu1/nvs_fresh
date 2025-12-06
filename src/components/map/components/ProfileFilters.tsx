
import React, { useState } from 'react';
import { Button } from '@/components/ui/button';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription } from '@/components/ui/dialog';
import { Slider } from '@/components/ui/slider';
import { Switch } from '@/components/ui/switch';
import { Label } from '@/components/ui/label';
import { Filter, UserX, Users, Clock, ArrowDownAZ, CircleCheck, X } from 'lucide-react';
import { Badge } from '@/components/ui/badge';

interface ProfileFiltersProps {
  onFilterChange: (filters: any) => void;
}

const ProfileFilters: React.FC<ProfileFiltersProps> = ({ onFilterChange }) => {
  const [isOpen, setIsOpen] = useState(false);
  const [filters, setFilters] = useState({
    distance: [5],
    onlineOnly: true,
    showBlocked: false,
    ageRange: [18, 50],
    sortBy: 'distance',
    bodyTypes: [] as string[],
    positions: [] as string[],
    explicit: true,
    verified: false,
  });

  const bodyTypeOptions = ['slim', 'average', 'muscular', 'toned', 'stocky', 'athletic'];
  const positionOptions = ['top', 'bottom', 'vers', 'side'];

  const handleFilterChange = (key: string, value: any) => {
    const newFilters = { ...filters, [key]: value };
    setFilters(newFilters);
    onFilterChange(newFilters);
  };

  const toggleBodyType = (type: string) => {
    const newTypes = filters.bodyTypes.includes(type)
      ? filters.bodyTypes.filter(t => t !== type)
      : [...filters.bodyTypes, type];
    
    handleFilterChange('bodyTypes', newTypes);
  };

  const togglePosition = (position: string) => {
    const newPositions = filters.positions.includes(position)
      ? filters.positions.filter(p => p !== position)
      : [...filters.positions, position];
    
    handleFilterChange('positions', newPositions);
  };

  return (
    <>
      <Button
        onClick={() => setIsOpen(true)}
        className="fixed top-24 right-4 bg-[#1A1A1A] border border-[#E6FFF4]/30 text-[#E6FFF4] hover:bg-[#1A1A1A]/80 z-40"
        size="sm"
      >
        <Filter className="w-4 h-4 mr-2" />
        Filters
      </Button>

      <Dialog open={isOpen} onOpenChange={setIsOpen}>
        <DialogContent className="bg-black border border-[#E6FFF4]/30 text-white max-w-md">
          <DialogHeader>
            <DialogTitle className="text-[#E6FFF4]">Profile Filters</DialogTitle>
            <DialogDescription className="text-[#E6FFF4]/70">
              Customize what profiles you see on the map
            </DialogDescription>
          </DialogHeader>

          <div className="space-y-6">
            {/* Distance filter */}
            <div className="space-y-2">
              <div className="flex justify-between">
                <Label className="text-[#E6FFF4]">Distance (km)</Label>
                <span className="text-[#E6FFF4]">{filters.distance[0]} km</span>
              </div>
              <Slider
                value={filters.distance}
                min={1}
                max={100}
                step={1}
                onValueChange={(value) => handleFilterChange('distance', value)}
                className="[&_[role=slider]]:bg-[#E6FFF4]"
              />
            </div>

            {/* Online status toggle */}
            <div className="flex items-center justify-between">
              <Label htmlFor="online-only" className="text-[#E6FFF4]">Show online only</Label>
              <Switch
                id="online-only"
                checked={filters.onlineOnly}
                onCheckedChange={(value) => handleFilterChange('onlineOnly', value)}
                className="data-[state=checked]:bg-[#E6FFF4]"
              />
            </div>

            {/* Explicit content toggle */}
            <div className="flex items-center justify-between">
              <Label htmlFor="explicit" className="text-[#E6FFF4]">Show explicit profiles</Label>
              <Switch
                id="explicit"
                checked={filters.explicit}
                onCheckedChange={(value) => handleFilterChange('explicit', value)}
                className="data-[state=checked]:bg-[#E6FFF4]"
              />
            </div>

            {/* Verified profiles toggle */}
            <div className="flex items-center justify-between">
              <Label htmlFor="verified" className="text-[#E6FFF4]">Verified profiles only</Label>
              <Switch
                id="verified"
                checked={filters.verified}
                onCheckedChange={(value) => handleFilterChange('verified', value)}
                className="data-[state=checked]:bg-[#E6FFF4]"
              />
            </div>

            {/* Blocked users toggle */}
            <div className="flex items-center justify-between">
              <Label htmlFor="show-blocked" className="text-[#E6FFF4]">Show blocked profiles</Label>
              <Switch
                id="show-blocked"
                checked={filters.showBlocked}
                onCheckedChange={(value) => handleFilterChange('showBlocked', value)}
                className="data-[state=checked]:bg-[#E6FFF4]"
              />
            </div>

            {/* Age range */}
            <div className="space-y-2">
              <div className="flex justify-between">
                <Label className="text-[#E6FFF4]">Age Range</Label>
                <span className="text-[#E6FFF4]">{filters.ageRange[0]} - {filters.ageRange[1]}</span>
              </div>
              <Slider
                value={filters.ageRange}
                min={18}
                max={99}
                step={1}
                onValueChange={(value) => handleFilterChange('ageRange', value)}
                className="[&_[role=slider]]:bg-[#E6FFF4]"
              />
            </div>

            {/* Body types */}
            <div className="space-y-2">
              <Label className="text-[#E6FFF4] block mb-2">Body Type</Label>
              <div className="flex flex-wrap gap-2">
                {bodyTypeOptions.map(type => (
                  <Badge
                    key={type}
                    className={`cursor-pointer ${
                      filters.bodyTypes.includes(type)
                        ? 'bg-[#E6FFF4] text-black'
                        : 'bg-transparent border border-[#E6FFF4]/30 text-[#E6FFF4]/70 hover:border-[#E6FFF4] hover:text-[#E6FFF4]'
                    }`}
                    onClick={() => toggleBodyType(type)}
                  >
                    {type}
                  </Badge>
                ))}
              </div>
            </div>

            {/* Positions */}
            <div className="space-y-2">
              <Label className="text-[#E6FFF4] block mb-2">Position</Label>
              <div className="flex flex-wrap gap-2">
                {positionOptions.map(position => (
                  <Badge
                    key={position}
                    className={`cursor-pointer ${
                      filters.positions.includes(position)
                        ? 'bg-[#E6FFF4] text-black'
                        : 'bg-transparent border border-[#E6FFF4]/30 text-[#E6FFF4]/70 hover:border-[#E6FFF4] hover:text-[#E6FFF4]'
                    }`}
                    onClick={() => togglePosition(position)}
                  >
                    {position}
                  </Badge>
                ))}
              </div>
            </div>

            {/* Sort by options */}
            <div className="space-y-2">
              <Label className="text-[#E6FFF4] block mb-2">Sort By</Label>
              <div className="grid grid-cols-3 gap-2">
                <Button
                  variant="outline"
                  size="sm"
                  className={`${
                    filters.sortBy === 'distance'
                      ? 'bg-[#E6FFF4] text-black'
                      : 'bg-transparent border border-[#E6FFF4]/30 text-[#E6FFF4]'
                  }`}
                  onClick={() => handleFilterChange('sortBy', 'distance')}
                >
                  <Users className="w-4 h-4 mr-1" />
                  Distance
                </Button>
                <Button
                  variant="outline"
                  size="sm"
                  className={`${
                    filters.sortBy === 'activity'
                      ? 'bg-[#E6FFF4] text-black'
                      : 'bg-transparent border border-[#E6FFF4]/30 text-[#E6FFF4]'
                  }`}
                  onClick={() => handleFilterChange('sortBy', 'activity')}
                >
                  <Clock className="w-4 h-4 mr-1" />
                  Activity
                </Button>
                <Button
                  variant="outline"
                  size="sm"
                  className={`${
                    filters.sortBy === 'name'
                      ? 'bg-[#E6FFF4] text-black'
                      : 'bg-transparent border border-[#E6FFF4]/30 text-[#E6FFF4]'
                  }`}
                  onClick={() => handleFilterChange('sortBy', 'name')}
                >
                  <ArrowDownAZ className="w-4 h-4 mr-1" />
                  Name
                </Button>
              </div>
            </div>

            <div className="flex justify-between pt-4 border-t border-[#E6FFF4]/10">
              <Button 
                variant="outline" 
                className="border-[#E6FFF4]/30 text-[#E6FFF4]"
                onClick={() => setIsOpen(false)}
              >
                <X className="w-4 h-4 mr-1" />
                Close
              </Button>
              
              <Button 
                className="bg-[#E6FFF4] text-black hover:bg-[#E6FFF4]/90"
                onClick={() => {
                  onFilterChange(filters);
                  setIsOpen(false);
                }}
              >
                <CircleCheck className="w-4 h-4 mr-1" />
                Apply Filters
              </Button>
            </div>
          </div>
        </DialogContent>
      </Dialog>
    </>
  );
};

export default ProfileFilters;
