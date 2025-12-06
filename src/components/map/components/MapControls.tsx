
import React from 'react';
import HeatMapToggle from './HeatMapToggle';
import AnonymousToggle from './AnonymousToggle';
import Mode3DToggle from './Mode3DToggle';
import ProfileFilters from './ProfileFilters';
import ChatOverlay from './ChatOverlay';

interface MapControlsProps {
  showHeatMap: boolean;
  setShowHeatMap: (show: boolean) => void;
  anonymousMode: boolean;
  toggleAnonymousMode: () => void;
  is3DMode: boolean;
  toggle3DMode: () => void;
  showChatOverlay: boolean;
  setShowChatOverlay: (show: boolean) => void;
  onFilterChange: (filters: any) => void;
}

const MapControls: React.FC<MapControlsProps> = ({
  showHeatMap,
  setShowHeatMap,
  anonymousMode,
  toggleAnonymousMode,
  is3DMode,
  toggle3DMode,
  showChatOverlay,
  setShowChatOverlay,
  onFilterChange
}) => {
  return (
    <>
      <HeatMapToggle 
        showHeatMap={showHeatMap} 
        onToggle={() => setShowHeatMap(!showHeatMap)} 
      />
      
      <AnonymousToggle 
        anonymousMode={anonymousMode} 
        onToggle={toggleAnonymousMode} 
      />
      
      <Mode3DToggle
        is3DMode={is3DMode}
        onToggle={toggle3DMode}
      />

      <ProfileFilters onFilterChange={onFilterChange} />
      
      <ChatOverlay 
        showChatOverlay={showChatOverlay}
        setShowChatOverlay={setShowChatOverlay}
      />
    </>
  );
};

export default MapControls;
