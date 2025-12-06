
import React from 'react';
import { Switch } from '@/components/ui/switch';

interface NotificationsSectionProps {
  receiveTaps: boolean;
  setReceiveTaps: (value: boolean) => void;
  sound: boolean;
  setSound: (value: boolean) => void;
  vibrations: boolean;
  setVibrations: (value: boolean) => void;
}

const NotificationsSection = ({
  receiveTaps,
  setReceiveTaps,
  sound,
  setSound,
  vibrations,
  setVibrations
}: NotificationsSectionProps) => {
  return (
    <div className="mb-6">
      <h2 className="text-sm font-semibold text-[#AAFF50] mb-2">NOTIFICATIONS</h2>
      
      <div className="bg-[#121212] rounded-md overflow-hidden">
        <div className="flex items-center justify-between p-4 border-b border-white/10">
          <span>Received Taps</span>
          <Switch 
            checked={receiveTaps}
            onCheckedChange={setReceiveTaps}
            className="data-[state=checked]:bg-[#AAFF50]"
          />
        </div>
        
        <div className="flex items-center justify-between p-4 border-b border-white/10">
          <span>Sound</span>
          <Switch 
            checked={sound}
            onCheckedChange={setSound}
            className="data-[state=checked]:bg-[#AAFF50]"
          />
        </div>
        
        <div className="flex items-center justify-between p-4">
          <span>Vibrations</span>
          <Switch 
            checked={vibrations}
            onCheckedChange={setVibrations}
            className="data-[state=checked]:bg-[#AAFF50]"
          />
        </div>
      </div>
    </div>
  );
};

export default NotificationsSection;
