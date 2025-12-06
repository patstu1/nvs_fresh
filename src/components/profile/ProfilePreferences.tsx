
import React from 'react';
import { ProfilePreferences } from '@/types/ProfileTypes';
import { Heart, Target, Clock } from 'lucide-react';
import { Badge } from '@/components/ui/badge';

interface PreferencesDisplayProps {
  preferences: ProfilePreferences;
}

const PreferencesDisplay: React.FC<PreferencesDisplayProps> = ({ preferences }) => {
  return (
    <div className="space-y-4 p-4 bg-[#1A1A1A] rounded-lg">
      <div>
        <h3 className="text-sm font-medium text-gray-400 mb-2 flex items-center">
          <Heart className="w-4 h-4 mr-2" />
          Looking For
        </h3>
        <div className="flex flex-wrap gap-2">
          {preferences.lookingFor.map((item, index) => (
            <Badge 
              key={index} 
              variant="secondary"
              className="bg-[#2A2A2A] text-white"
            >
              {item}
            </Badge>
          ))}
        </div>
      </div>

      <div>
        <h3 className="text-sm font-medium text-gray-400 mb-2 flex items-center">
          <Target className="w-4 h-4 mr-2" />
          Tribes
        </h3>
        <div className="flex flex-wrap gap-2">
          {preferences.tribes.map((tribe, index) => (
            <Badge 
              key={index}
              variant="outline" 
              className="border-[#C2FFE6] text-[#C2FFE6]"
            >
              {tribe}
            </Badge>
          ))}
        </div>
      </div>

      {preferences.meetingPreference && (
        <div className="flex items-center space-x-2 text-sm">
          <Clock className="w-4 h-4 text-gray-400" />
          <span className="text-white capitalize">
            Looking to {preferences.meetingPreference}
          </span>
        </div>
      )}
    </div>
  );
};

export default PreferencesDisplay;
