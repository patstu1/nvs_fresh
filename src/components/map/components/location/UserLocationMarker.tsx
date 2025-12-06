
import React, { useEffect, useRef } from 'react';
import mapboxgl from 'mapbox-gl';

interface UserLocationMarkerProps {
  userLocation: [number, number] | null;
  locationAccuracy: number | null;
}

/**
 * Component to render the user's current location on the map
 */
const UserLocationMarker: React.FC<UserLocationMarkerProps> = ({
  userLocation,
  locationAccuracy
}) => {
  const markerRef = useRef<mapboxgl.Marker | null>(null);
  
  // Create and clean up marker element
  useEffect(() => {
    return () => {
      if (markerRef.current) {
        markerRef.current.remove();
      }
    };
  }, []);
  
  return null; // This component doesn't render anything in the React DOM
};

export default UserLocationMarker;

/**
 * Create a HTML element for the user's location marker
 */
export const createUserLocationMarkerElement = (locationAccuracy: number | null): HTMLDivElement => {
  const el = document.createElement('div');
  el.className = 'user-location-marker map-only-marker';
  el.style.width = '24px';
  el.style.height = '24px';
  el.style.borderRadius = '50%';
  el.style.backgroundColor = '#3B82F6';
  el.style.border = '3px solid white';
  el.style.boxShadow = '0 0 15px rgba(59, 130, 246, 0.6)';
  el.style.position = 'relative';
  el.style.zIndex = '300'; // Keep user location above all markers
  
  // Create multiple pulse rings for better effect
  for (let i = 0; i < 2; i++) {
    const pulse = document.createElement('div');
    pulse.className = 'user-location-pulse map-only-marker';
    pulse.style.position = 'absolute';
    pulse.style.width = '50px';
    pulse.style.height = '50px';
    pulse.style.borderRadius = '50%';
    pulse.style.backgroundColor = 'rgba(59, 130, 246, 0.2)';
    pulse.style.border = '2px solid rgba(59, 130, 246, 0.4)';
    pulse.style.animation = `pulse-${i} ${1.5 + i * 0.5}s infinite`;
    pulse.style.transform = 'translate(-50%, -50%)';
    pulse.style.top = '50%';
    pulse.style.left = '50%';
    el.appendChild(pulse);
  }
  
  // Add accuracy indicator if available
  if (locationAccuracy) {
    const accuracyRing = document.createElement('div');
    accuracyRing.className = 'location-accuracy map-only-marker';
    accuracyRing.style.position = 'absolute';
    accuracyRing.style.top = '50%';
    accuracyRing.style.left = '50%';
    
    // Calculate size based on accuracy but cap it
    const maxSizeInPixels = 200;
    const accuracyInPixels = Math.min(locationAccuracy * 5, maxSizeInPixels);
    
    accuracyRing.style.width = `${accuracyInPixels}px`;
    accuracyRing.style.height = `${accuracyInPixels}px`;
    accuracyRing.style.borderRadius = '50%';
    accuracyRing.style.backgroundColor = 'rgba(59, 130, 246, 0.1)';
    accuracyRing.style.border = '1px solid rgba(59, 130, 246, 0.3)';
    accuracyRing.style.transform = 'translate(-50%, -50%)';
    accuracyRing.style.zIndex = '-1';
    el.appendChild(accuracyRing);
  }
  
  // Create glow dot in center
  const centerDot = document.createElement('div');
  centerDot.className = 'location-center map-only-marker';
  centerDot.style.position = 'absolute';
  centerDot.style.top = '50%';
  centerDot.style.left = '50%';
  centerDot.style.width = '8px';
  centerDot.style.height = '8px';
  centerDot.style.borderRadius = '50%';
  centerDot.style.backgroundColor = 'white';
  centerDot.style.transform = 'translate(-50%, -50%)';
  centerDot.style.boxShadow = '0 0 10px rgba(255, 255, 255, 0.8)';
  el.appendChild(centerDot);
  
  // Create pulse animation styles
  setupPulseAnimations();
  
  return el;
};

/**
 * Set up pulse animations if they don't exist
 */
export const setupPulseAnimations = (): void => {
  if (!document.getElementById('enhanced-pulse-animations')) {
    const style = document.createElement('style');
    style.id = 'enhanced-pulse-animations';
    style.innerHTML = `
      @keyframes pulse-0 {
        0% {
          transform: translate(-50%, -50%) scale(0.5);
          opacity: 1;
        }
        100% {
          transform: translate(-50%, -50%) scale(2);
          opacity: 0;
        }
      }
      
      @keyframes pulse-1 {
        0% {
          transform: translate(-50%, -50%) scale(0.5);
          opacity: 0.8;
        }
        100% {
          transform: translate(-50%, -50%) scale(2.5);
          opacity: 0;
        }
      }
    `;
    document.head.appendChild(style);
  }
};
