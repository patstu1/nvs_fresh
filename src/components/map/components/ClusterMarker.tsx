
import React, { useEffect, useRef, useState } from 'react';
import mapboxgl from 'mapbox-gl';

export interface ClusterMarkerProps {
  count: number;
  coordinates: [number, number];
  map: mapboxgl.Map;
  pointCount?: number;
  onClusterClick?: () => void;
}

/**
 * ClusterMarker component - Creates and manages mapbox markers for clusters of users
 * with enhanced safety checks and modern styling
 */
const ClusterMarker: React.FC<ClusterMarkerProps> = ({
  count,
  coordinates,
  map,
  pointCount = 0,
  onClusterClick
}) => {
  const markerRef = useRef<mapboxgl.Marker | null>(null);
  const [isMapReady, setIsMapReady] = useState(false);
  const markerElementRef = useRef<HTMLDivElement | null>(null);
  
  // Check if map is fully ready before creating marker
  useEffect(() => {
    if (!map) return;
    
    console.log('ClusterMarker: Checking if map is ready for cluster markers');
    
    const checkMapReady = () => {
      try {
        if (map && map.loaded() && map.getCanvas() && map.getCanvasContainer()) {
          console.log('ClusterMarker: Map is ready for cluster markers');
          setIsMapReady(true);
          return true;
        }
      } catch (err) {
        return false;
      }
      return false;
    };
    
    // Check immediately
    if (checkMapReady()) return;
    
    // Set up polling to check readiness
    const interval = setInterval(() => {
      if (checkMapReady()) {
        clearInterval(interval);
      }
    }, 200);
    
    return () => clearInterval(interval);
  }, [map]);
  
  // Create and manage marker
  useEffect(() => {
    // Don't proceed until map is ready
    if (!isMapReady || !map) return;
    
    console.log(`Creating cluster marker with ${count} users`);
    
    const createClusterMarker = () => {
      try {
        // Create marker element
        const el = document.createElement('div');
        markerElementRef.current = el;
        el.className = 'custom-marker cluster-marker';
        
        // Style it as a cluster
        el.style.width = '50px';
        el.style.height = '50px';
        el.style.borderRadius = '50%';
        el.style.backgroundColor = 'rgba(230, 255, 244, 0.25)';
        el.style.border = '2px solid #E6FFF4';
        el.style.display = 'flex';
        el.style.alignItems = 'center';
        el.style.justifyContent = 'center';
        el.style.color = '#E6FFF4';
        el.style.fontWeight = 'bold';
        el.style.fontSize = '16px';
        el.style.backdropFilter = 'blur(4px)';
        el.style.boxShadow = '0 0 10px rgba(230, 255, 244, 0.5)';
        el.style.cursor = 'pointer';
        el.style.transition = 'all 0.3s ease';
        
        // Display count of users in cluster
        el.textContent = count.toString();
        
        // Add pulsing animation
        if (!document.getElementById('cluster-animations')) {
          const style = document.createElement('style');
          style.id = 'cluster-animations';
          style.textContent = `
            @keyframes pulse {
              0% { transform: scale(1); opacity: 1; }
              50% { transform: scale(1.05); opacity: 0.8; }
              100% { transform: scale(1); opacity: 1; }
            }
          `;
          document.head.appendChild(style);
        }
        
        el.style.animation = 'pulse 2s infinite';
        
        // Add hexagonal grid pattern for modern look
        const hexGrid = document.createElement('div');
        hexGrid.style.position = 'absolute';
        hexGrid.style.inset = '0';
        hexGrid.style.opacity = '0.2';
        hexGrid.style.borderRadius = '50%';
        hexGrid.style.backgroundImage = 'radial-gradient(circle, rgba(230, 255, 244, 0.2) 1px, transparent 1px)';
        hexGrid.style.backgroundSize = '8px 8px';
        hexGrid.style.pointerEvents = 'none';
        el.appendChild(hexGrid);
        
        // Add hover animation
        el.addEventListener('mouseenter', () => {
          el.style.transform = 'scale(1.1)';
          el.style.boxShadow = '0 0 20px rgba(230, 255, 244, 0.7)';
        });
        
        el.addEventListener('mouseleave', () => {
          el.style.transform = 'scale(1)';
          el.style.boxShadow = '0 0 10px rgba(230, 255, 244, 0.5)';
        });
        
        // Add click handler
        el.addEventListener('click', (e) => {
          e.stopPropagation();
          if (onClusterClick) {
            onClusterClick();
          }
        });
        
        return el;
      } catch (error) {
        console.error("Error creating cluster marker element:", error);
        // Return a fallback element
        const fallback = document.createElement('div');
        fallback.style.width = '50px';
        fallback.style.height = '50px';
        fallback.style.borderRadius = '50%';
        fallback.style.backgroundColor = '#FF3366';
        fallback.textContent = count.toString();
        return fallback;
      }
    };
    
    // Create and add marker to map
    if (!markerRef.current) {
      try {
        const el = createClusterMarker();
        
        // Create and add mapbox marker with safety check
        try {
          if (map.getCanvasContainer()) {
            markerRef.current = new mapboxgl.Marker({
              element: el,
              anchor: 'center'
            })
              .setLngLat(coordinates)
              .addTo(map);
            
            console.log('Cluster marker added successfully');
          } else {
            console.warn('Map container not ready, cannot add cluster marker');
          }
        } catch (error) {
          console.error("Error adding cluster marker to map:", error);
        }
      } catch (error) {
        console.error("Error creating cluster marker:", error);
      }
    } else {
      // Update marker position if it already exists
      try {
        markerRef.current.setLngLat(coordinates);
      } catch (err) {
        console.warn("Error updating cluster marker position:", err);
      }
    }
    
    // Clean up marker when component unmounts
    return () => {
      if (markerRef.current) {
        try {
          markerRef.current.remove();
        } catch (error) {
          console.error("Error removing cluster marker:", error);
        }
        markerRef.current = null;
      }
    };
  }, [coordinates, count, map, isMapReady, onClusterClick]);
  
  // No actual render output since we're working with the map directly
  return null;
};

export default ClusterMarker;
