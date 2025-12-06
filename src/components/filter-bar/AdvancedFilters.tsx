
import React from 'react';
import { ChevronDown, ChevronUp, Globe, Users, Zap } from 'lucide-react';
import { 
  Collapsible,
  CollapsibleContent,
  CollapsibleTrigger 
} from '@/components/ui/collapsible';
import { Switch } from '@/components/ui/switch';
import { ToggleGroup, ToggleGroupItem } from '@/components/ui/toggle-group';
import { Button } from '@/components/ui/button';

interface AdvancedFiltersProps {
  isVerifiedOnly: boolean;
  setIsVerifiedOnly: (value: boolean) => void;
  distance: string;
  setDistance: (value: string) => void;
  activityStatus: string;
  setActivityStatus: (value: string) => void;
}

const AdvancedFilters: React.FC<AdvancedFiltersProps> = ({
  isVerifiedOnly,
  setIsVerifiedOnly,
  distance,
  setDistance,
  activityStatus,
  setActivityStatus
}) => {
  const [isOpen, setIsOpen] = React.useState(false);

  return (
    <div className="w-full px-3 mb-4">
      <Collapsible
        open={isOpen}
        onOpenChange={setIsOpen}
        className="w-full bg-[#0F1828]/80 rounded-lg p-3 border border-[#C2FFE6]/20"
      >
        <div className="flex items-center justify-between">
          <div className="flex items-center space-x-2">
            <Zap className="h-4 w-4 text-[#C2FFE6]" />
            <h4 className="text-sm font-medium text-[#C2FFE6]">Advanced Filters</h4>
          </div>
          <CollapsibleTrigger asChild>
            <Button variant="ghost" size="sm" className="p-0 h-8 w-8">
              {isOpen ? (
                <ChevronUp className="h-4 w-4 text-[#C2FFE6]" />
              ) : (
                <ChevronDown className="h-4 w-4 text-[#C2FFE6]" />
              )}
            </Button>
          </CollapsibleTrigger>
        </div>

        <CollapsibleContent className="mt-3 space-y-4">
          {/* Verified only switch */}
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-2">
              <Users className="h-4 w-4 text-[#C2FFE6]" />
              <span className="text-xs text-[#C2FFE6]">Verified profiles only</span>
            </div>
            <Switch 
              checked={isVerifiedOnly} 
              onCheckedChange={setIsVerifiedOnly} 
              className="data-[state=checked]:bg-[#C2FFE6] data-[state=checked]:text-black"
            />
          </div>

          {/* Distance filter */}
          <div className="space-y-2">
            <div className="flex items-center space-x-2">
              <Globe className="h-4 w-4 text-[#C2FFE6]" />
              <span className="text-xs text-[#C2FFE6]">Distance</span>
            </div>
            <ToggleGroup 
              type="single" 
              value={distance} 
              onValueChange={(value) => value && setDistance(value)}
              className="flex justify-between"
            >
              <ToggleGroupItem 
                value="1km" 
                className="text-xs flex-1 text-[#C2FFE6] border border-[#C2FFE6]/30 data-[state=on]:bg-[#C2FFE6]/20"
              >
                1km
              </ToggleGroupItem>
              <ToggleGroupItem 
                value="5km" 
                className="text-xs flex-1 text-[#C2FFE6] border border-[#C2FFE6]/30 data-[state=on]:bg-[#C2FFE6]/20"
              >
                5km
              </ToggleGroupItem>
              <ToggleGroupItem 
                value="10km" 
                className="text-xs flex-1 text-[#C2FFE6] border border-[#C2FFE6]/30 data-[state=on]:bg-[#C2FFE6]/20"
              >
                10km
              </ToggleGroupItem>
              <ToggleGroupItem 
                value="25km" 
                className="text-xs flex-1 text-[#C2FFE6] border border-[#C2FFE6]/30 data-[state=on]:bg-[#C2FFE6]/20"
              >
                25km+
              </ToggleGroupItem>
            </ToggleGroup>
          </div>

          {/* Activity status filter */}
          <div className="space-y-2">
            <span className="text-xs text-[#C2FFE6]">Activity Status</span>
            <ToggleGroup 
              type="single" 
              value={activityStatus} 
              onValueChange={(value) => value && setActivityStatus(value)}
              className="flex justify-between"
            >
              <ToggleGroupItem 
                value="all" 
                className="text-xs flex-1 text-[#C2FFE6] border border-[#C2FFE6]/30 data-[state=on]:bg-[#C2FFE6]/20"
              >
                All
              </ToggleGroupItem>
              <ToggleGroupItem 
                value="active" 
                className="text-xs flex-1 text-[#C2FFE6] border border-[#C2FFE6]/30 data-[state=on]:bg-[#C2FFE6]/20"
              >
                Active
              </ToggleGroupItem>
              <ToggleGroupItem 
                value="recent" 
                className="text-xs flex-1 text-[#C2FFE6] border border-[#C2FFE6]/30 data-[state=on]:bg-[#C2FFE6]/20"
              >
                Recent
              </ToggleGroupItem>
            </ToggleGroup>
          </div>
        </CollapsibleContent>
      </Collapsible>
    </div>
  );
};

export default AdvancedFilters;
