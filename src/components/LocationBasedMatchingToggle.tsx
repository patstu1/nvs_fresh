
import React from 'react';
import { Switch } from '@/components/ui/switch';
import { Label } from '@/components/ui/label';
import { MapPin } from 'lucide-react';
import { toast } from '@/hooks/use-toast';

interface LocationBasedMatchingToggleProps {
  enabled: boolean;
  onToggle: (enabled: boolean) => void;
  className?: string;
}

const LocationBasedMatchingToggle: React.FC<LocationBasedMatchingToggleProps> = ({
  enabled,
  onToggle,
  className
}) => {
  const handleToggle = (checked: boolean) => {
    onToggle(checked);
    toast({
      title: checked ? "Location Matching Enabled" : "Location Matching Disabled",
      description: checked 
        ? "You'll be matched with people close to your location and can join local Zoom rooms" 
        : "You'll be matched with people globally and can join global Zoom rooms",
    });
  };

  return (
    <div className={`flex items-center space-x-2 ${className || ''}`}>
      <MapPin className={`h-4 w-4 ${enabled ? 'text-[#C2FFE6]' : 'text-gray-400'}`} />
      <Label htmlFor="location-matching" className="text-white text-sm cursor-pointer">Nearby Matches</Label>
      <Switch
        id="location-matching"
        checked={enabled}
        onCheckedChange={handleToggle}
        className="data-[state=checked]:bg-[#C2FFE6]"
      />
    </div>
  );
};

export default LocationBasedMatchingToggle;
