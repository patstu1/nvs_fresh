
import React from 'react';
import { ProfileMetrics as ProfileMetricsType } from '@/types/ProfileTypes';
import { User, Ruler, Scale, Activity } from 'lucide-react';

interface ProfileMetricsProps {
  metrics: ProfileMetricsType;
  showPosition?: boolean;
}

const ProfileMetrics: React.FC<ProfileMetricsProps> = ({ metrics, showPosition = true }) => {
  return (
    <div className="grid grid-cols-2 gap-4 p-4 bg-[#1A1A1A] rounded-lg">
      {metrics.age && (
        <div className="flex items-center space-x-2">
          <User className="w-4 h-4 text-gray-400" />
          <span className="text-sm text-white">{metrics.age} years</span>
        </div>
      )}
      {metrics.height && (
        <div className="flex items-center space-x-2">
          <Ruler className="w-4 h-4 text-gray-400" />
          <span className="text-sm text-white">{metrics.height} cm</span>
        </div>
      )}
      {metrics.weight && (
        <div className="flex items-center space-x-2">
          <Scale className="w-4 h-4 text-gray-400" />
          <span className="text-sm text-white">{metrics.weight} kg</span>
        </div>
      )}
      {showPosition && metrics.position && (
        <div className="flex items-center space-x-2">
          <Activity className="w-4 h-4 text-gray-400" />
          <span className="text-sm text-white capitalize">{metrics.position}</span>
        </div>
      )}
      {metrics.bodyType && (
        <div className="flex items-center space-x-2">
          <span className="text-gray-400 text-sm">Body:</span>
          <span className="text-sm text-white capitalize">{metrics.bodyType}</span>
        </div>
      )}
      {metrics.ethnicity && (
        <div className="flex items-center space-x-2">
          <span className="text-gray-400 text-sm">Ethnicity:</span>
          <span className="text-sm text-white capitalize">{metrics.ethnicity}</span>
        </div>
      )}
    </div>
  );
};

export default ProfileMetrics;
