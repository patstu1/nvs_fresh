
import React, { useEffect, useRef, useState } from 'react';
import mapboxgl from 'mapbox-gl';
import { UserMarkerProps } from '../types/markerTypes';

/**
 * UserMarker component - Creates and manages a mapbox marker for user locations
 * with improved initialization and error handling
 */
const UserMarker: React.FC<UserMarkerProps> = ({
  user,
  map,
  onUserClick
}) => {
  // Reference to mapbox marker instance
  const markerRef = useRef<mapboxgl.Marker | null>(null);
  const [isMapReady, setIsMapReady] = useState(false);
  
  // Check if map is fully initialized and ready for markers
  useEffect(() => {
    if (!map) return;
    
    console.log(`UserMarker: Checking if map is ready for user ${user.id}`);
    
    // Create a function to check map readiness
    const checkMapReady = () => {
      try {
        const isReady = map && 
          map.loaded() && 
          map.getCanvas() && 
          map.getCanvasContainer();
        
        if (isReady && !isMapReady) {
          console.log(`UserMarker: Map is ready for user ${user.id}`);
          setIsMapReady(true);
        }
        
        return isReady;
      } catch (err) {
        console.warn('Map not fully initialized yet:', err);
        return false;
      }
    };
    
    // Check immediately
    if (checkMapReady()) {
      setIsMapReady(true);
      return;
    }
    
    // If not ready, set up an interval to check periodically
    const readyCheckInterval = setInterval(() => {
      if (checkMapReady()) {
        clearInterval(readyCheckInterval);
      }
    }, 200);
    
    // Clean up interval
    return () => clearInterval(readyCheckInterval);
  }, [map, user.id, isMapReady]);
  
  // Create marker element
  const createUserMarkerElement = (user: any) => {
    try {
      const el = document.createElement('div');
      el.className = 'user-marker';
      el.style.width = '40px';
      el.style.height = '40px';
      el.style.borderRadius = '50%';
      el.style.overflow = 'hidden';
      el.style.border = '2px solid rgba(0, 255, 196, 0.7)';
      el.style.boxShadow = '0 0 10px rgba(0, 255, 196, 0.4)';
      el.style.cursor = 'pointer';
      el.style.transition = 'all 0.3s ease';
      
      // Background container
      const innerContent = document.createElement('div');
      innerContent.style.width = '100%';
      innerContent.style.height = '100%';
      innerContent.style.borderRadius = '50%';
      innerContent.style.overflow = 'hidden';
      innerContent.style.display = 'flex';
      innerContent.style.alignItems = 'center';
      innerContent.style.justifyContent = 'center';
      innerContent.style.backgroundColor = '#121212';
      
      // Image or placeholder
      if (user.profileImage) {
        const img = document.createElement('img');
        img.src = user.profileImage;
        img.alt = user.name || 'User';
        img.style.width = '100%';
        img.style.height = '100%';
        img.style.objectFit = 'cover';
        innerContent.appendChild(img);
      } else {
        const initial = document.createElement('div');
        initial.textContent = (user.name || 'U').charAt(0).toUpperCase();
        initial.style.color = '#00EEFF';
        initial.style.fontSize = '24px';
        initial.style.fontWeight = '600';
        innerContent.appendChild(initial);
      }
      
      // Add online indicator if user is online
      if (user.isOnline) {
        const statusDot = document.createElement('div');
        statusDot.style.position = 'absolute';
        statusDot.style.bottom = '2px';
        statusDot.style.right = '2px';
        statusDot.style.width = '10px';
        statusDot.style.height = '10px';
        statusDot.style.backgroundColor = '#00FF66';
        statusDot.style.borderRadius = '50%';
        statusDot.style.border = '2px solid rgba(0, 0, 0, 0.3)';
        el.appendChild(statusDot);
      }
      
      // Add "new" indicator if user is new
      if (user.isNew) {
        const newBadge = document.createElement('div');
        newBadge.style.position = 'absolute';
        newBadge.style.top = '0';
        newBadge.style.right = '0';
        newBadge.style.width = '16px';
        newBadge.style.height = '16px';
        newBadge.style.backgroundColor = '#FF3366';
        newBadge.style.borderRadius = '50%';
        newBadge.style.display = 'flex';
        newBadge.style.alignItems = 'center';
        newBadge.style.justifyContent = 'center';
        newBadge.style.fontSize = '10px';
        newBadge.style.fontWeight = 'bold';
        newBadge.style.color = 'white';
        newBadge.textContent = 'N';
        el.appendChild(newBadge);
      }
      
      el.appendChild(innerContent);
      
      // Animate on hover
      el.addEventListener('mouseenter', () => {
        el.style.transform = 'scale(1.1)';
        el.style.boxShadow = '0 0 20px rgba(0, 255, 196, 0.6)';
      });
      
      el.addEventListener('mouseleave', () => {
        el.style.transform = 'scale(1)';
        el.style.boxShadow = '0 0 10px rgba(0, 255, 196, 0.4)';
      });
      
      return el;
    } catch (error) {
      console.error('Error creating user marker element:', error);
      // Return a basic fallback marker
      const fallback = document.createElement('div');
      fallback.style.width = '40px';
      fallback.style.height = '40px';
      fallback.style.backgroundColor = '#FF3366';
      fallback.style.borderRadius = '50%';
      return fallback;
    }
  };
  
  // Attach click handler to marker
  const attachClickHandler = (element: HTMLElement, user: any) => {
    element.addEventListener('click', (e) => {
      e.stopPropagation();
      if (onUserClick) {
        onUserClick(user);
      }
    });
  };
  
  // Set up marker when component mounts or user position changes
  useEffect(() => {
    // Don't proceed until the map is fully ready for markers
    if (!isMapReady || !map || !user.position) {
      return;
    }
    
    console.log(`Creating marker for user ${user.id}`);
    
    // Create marker if it doesn't exist yet
    if (!markerRef.current) {
      try {
        // Create marker element
        const el = createUserMarkerElement(user);
        
        // Attach click event handler
        attachClickHandler(el, user);
        
        // Create and add mapbox marker with additional safety checks
        try {
          // Verify container again just before adding marker
          if (map.getCanvasContainer()) {
            markerRef.current = new mapboxgl.Marker({
              element: el,
              anchor: 'center'
            })
              .setLngLat([user.position.lng, user.position.lat])
              .addTo(map);
            
            console.log(`Marker added for user ${user.id}`);
          } else {
            console.warn('Map container not ready, cannot add marker');
          }
        } catch (error) {
          console.error("Error adding marker to map:", error);
        }
      } catch (error) {
        console.error("Error creating user marker:", error);
      }
    } else {
      // Update marker position if it already exists
      try {
        markerRef.current.setLngLat([user.position.lng, user.position.lat]);
      } catch (err) {
        console.warn("Error updating marker position:", err);
      }
    }
    
    // Clean up marker when component unmounts
    return () => {
      if (markerRef.current) {
        try {
          markerRef.current.remove();
        } catch (error) {
          console.error("Error removing marker:", error);
        }
        markerRef.current = null;
      }
    };
  }, [user, map, isMapReady]);
  
  // No actual render output since we're working with the map directly
  return null;
};

export default UserMarker;
