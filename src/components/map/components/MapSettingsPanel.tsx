
import React from 'react';
import { Switch } from '@/components/ui/switch';
import {
  DrawerContent,
  DrawerHeader,
  DrawerTitle,
  DrawerDescription,
  DrawerFooter,
} from '@/components/ui/drawer';
import { Button } from '@/components/ui/button';

interface MapSettingsPanelProps {
  settings: {
    showHeatMap: boolean;
    setShowHeatMap: (show: boolean) => void;
    anonymousMode: boolean;
    toggleAnonymousMode: () => void;
    is3DMode: boolean;
    toggle3DMode: () => void;
  };
  onClose: () => void;
}

const MapSettingsPanel: React.FC<MapSettingsPanelProps> = ({
  settings,
  onClose
}) => {
  return (
    <DrawerContent>
      <DrawerHeader>
        <DrawerTitle>Map Settings</DrawerTitle>
        <DrawerDescription>
          Customize your NOW experience
        </DrawerDescription>
      </DrawerHeader>

      <div className="px-4 space-y-4">
        <div className="flex items-center justify-between">
          <label className="text-sm font-medium">Anonymous Mode</label>
          <Switch 
            checked={settings.anonymousMode}
            onCheckedChange={settings.toggleAnonymousMode}
          />
        </div>

        <div className="flex items-center justify-between">
          <label className="text-sm font-medium">3D Mode</label>
          <Switch 
            checked={settings.is3DMode}
            onCheckedChange={settings.toggle3DMode}
          />
        </div>

        <div className="flex items-center justify-between">
          <label className="text-sm font-medium">Heat Map</label>
          <Switch 
            checked={settings.showHeatMap}
            onCheckedChange={settings.setShowHeatMap}
          />
        </div>
      </div>

      <DrawerFooter>
        <Button onClick={onClose}>Close</Button>
      </DrawerFooter>
    </DrawerContent>
  );
};

export default MapSettingsPanel;
