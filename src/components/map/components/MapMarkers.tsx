
import React, { useState, useEffect } from 'react';
import mapboxgl from 'mapbox-gl';
import { User, Venue } from '../types/markerTypes';
import UserMarker from './UserMarker';
import VenueMarker from './VenueMarker';
import ClusterMarker from './ClusterMarker';
import BlurrableUserMarker from './BlurrableUserMarker';

interface MapMarkersProps {
  map: mapboxgl.Map | null;
  mapLoaded: boolean;
  users: User[];
  venues: Venue[];
  clusterMarkers: any[];
  onUserClick: (user: User) => void;
  onVenueClick: (venue: Venue) => void;
  blurUserImages?: boolean;
}

const MapMarkers: React.FC<MapMarkersProps> = ({
  map,
  mapLoaded,
  users,
  venues,
  clusterMarkers,
  onUserClick,
  onVenueClick,
  blurUserImages = false
}) => {
  // Enhanced map readiness state
  const [isMapFullyReady, setIsMapFullyReady] = useState(false);
  
  // Additional check to verify map is truly ready for markers
  useEffect(() => {
    if (!map || !mapLoaded) return;
    
    console.log('MapMarkers: Checking if map is fully ready for markers');
    
    // Check map readiness with more thorough verification
    const verifyMapReady = () => {
      try {
        if (map && map.loaded() && map.getCanvas() && map.getCanvasContainer()) {
          console.log('MapMarkers: Map is fully ready for markers');
          setIsMapFullyReady(true);
          return true;
        }
      } catch (err) {
        console.warn('Map not fully ready for markers yet:', err);
      }
      return false;
    };
    
    // Try immediately
    if (verifyMapReady()) return;
    
    // Set up polling to check map readiness
    const readyCheckInterval = setInterval(() => {
      if (verifyMapReady()) {
        clearInterval(readyCheckInterval);
      }
    }, 200);
    
    // Force map resize to help with initialization
    const resizeTimeout = setTimeout(() => {
      try {
        if (map) {
          console.log('MapMarkers: Triggering map resize');
          map.resize();
        }
      } catch (e) {
        console.warn('Error resizing map:', e);
      }
    }, 500);
    
    // Clean up interval
    return () => {
      clearInterval(readyCheckInterval);
      clearTimeout(resizeTimeout);
    };
  }, [map, mapLoaded]);
  
  // Don't render markers if map isn't ready
  if (!map || !mapLoaded || !isMapFullyReady) {
    return null;
  }
  
  console.log(`Rendering markers: ${users.length} users, ${venues.length} venues, ${clusterMarkers.length} clusters`);
  
  return (
    <>
      {/* User markers */}
      {users.map((currentUser) => 
        blurUserImages ? (
          <BlurrableUserMarker
            key={currentUser.id}
            user={currentUser}
            map={map}
            onUserClick={onUserClick}
          />
        ) : (
          <UserMarker
            key={currentUser.id}
            user={currentUser}
            map={map}
            onUserClick={onUserClick}
          />
        )
      )}
      
      {/* Venue markers */}
      {venues.map((venue) => (
        <VenueMarker
          key={venue.id}
          venue={venue}
          map={map}
          onVenueClick={onVenueClick}
        />
      ))}
      
      {/* Cluster markers */}
      {clusterMarkers.map((cluster) => (
        <ClusterMarker
          key={cluster.id}
          count={cluster.count}
          coordinates={[cluster.position.lng, cluster.position.lat]}
          map={map}
          pointCount={cluster.points?.length || 0}
          onClusterClick={() => {
            if (map) {
              map.flyTo({
                center: [cluster.position.lng, cluster.position.lat],
                zoom: map.getZoom() + 2,
                duration: 800
              });
            }
          }}
        />
      ))}
    </>
  );
};

export default MapMarkers;
