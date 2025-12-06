
import React, { useEffect, useRef } from 'react';
import mapboxgl from 'mapbox-gl';
import { User } from '../types/markerTypes';

interface BlurrableUserMarkerProps {
  user: User;
  map: mapboxgl.Map;
  onUserClick: (user: User) => void;
}

const BlurrableUserMarker: React.FC<BlurrableUserMarkerProps> = ({ 
  user, 
  map, 
  onUserClick 
}) => {
  const markerRef = useRef<mapboxgl.Marker | null>(null);
  const elementRef = useRef<HTMLDivElement | null>(null);

  useEffect(() => {
    if (!map || !user.position) return;

    try {
      // Only create marker if it doesn't exist
      if (!markerRef.current) {
        console.log(`Creating blurrable marker for user ${user.id}`);
        
        // Create marker element with modern styling
        const element = document.createElement('div');
        elementRef.current = element;
        
        // Style the marker container
        element.className = 'blurred-user-marker';
        element.style.width = '40px';
        element.style.height = '40px';
        element.style.borderRadius = '50%';
        element.style.border = '2px solid rgba(0, 255, 196, 0.6)';
        element.style.boxShadow = '0 0 10px rgba(0, 255, 196, 0.5)';
        element.style.cursor = 'pointer';
        element.style.overflow = 'hidden';
        element.style.backgroundColor = '#121212';
        element.style.display = 'flex';
        element.style.alignItems = 'center';
        element.style.justifyContent = 'center';
        element.style.position = 'relative';
        
        // Create image container
        const imageContainer = document.createElement('div');
        imageContainer.style.width = '100%';
        imageContainer.style.height = '100%';
        imageContainer.style.position = 'relative';
        imageContainer.style.borderRadius = '50%';
        imageContainer.style.overflow = 'hidden';
        
        // Create profile image with blur effect
        const img = document.createElement('img');
        img.src = user.profileImage || '/placeholder.svg';
        img.alt = user.name || 'User';
        img.style.width = '100%';
        img.style.height = '100%';
        img.style.objectFit = 'cover';
        img.style.filter = 'blur(8px)';
        img.style.transition = 'filter 0.3s ease';
        
        // Add blur overlay with scan line effect
        const blurOverlay = document.createElement('div');
        blurOverlay.style.position = 'absolute';
        blurOverlay.style.inset = '0';
        blurOverlay.style.backgroundColor = 'rgba(0, 255, 196, 0.1)';
        blurOverlay.style.backgroundImage = 'linear-gradient(transparent 50%, rgba(0, 255, 196, 0.1) 50%)';
        blurOverlay.style.backgroundSize = '100% 4px';
        blurOverlay.style.animation = 'scanline 2s linear infinite';
        blurOverlay.style.pointerEvents = 'none';
        
        // Create the CSS animation for scan lines
        if (!document.getElementById('marker-animations')) {
          const style = document.createElement('style');
          style.id = 'marker-animations';
          style.textContent = `
            @keyframes scanline {
              0% { background-position: 0 0; }
              100% { background-position: 0 100%; }
            }
            @keyframes pulse {
              0% { transform: scale(1); opacity: 1; }
              50% { transform: scale(1.05); opacity: 0.8; }
              100% { transform: scale(1); opacity: 1; }
            }
          `;
          document.head.appendChild(style);
        }
        
        // Add "new" badge if applicable
        if (user.isNew) {
          const newBadge = document.createElement('div');
          newBadge.style.position = 'absolute';
          newBadge.style.top = '0';
          newBadge.style.right = '0';
          newBadge.style.backgroundColor = '#FF3366';
          newBadge.style.color = 'white';
          newBadge.style.borderRadius = '50%';
          newBadge.style.width = '16px';
          newBadge.style.height = '16px';
          newBadge.style.display = 'flex';
          newBadge.style.alignItems = 'center';
          newBadge.style.justifyContent = 'center';
          newBadge.style.fontSize = '10px';
          newBadge.style.fontWeight = 'bold';
          newBadge.style.zIndex = '2';
          newBadge.textContent = 'N';
          element.appendChild(newBadge);
        }
        
        // Add online indicator if applicable
        if (user.isOnline) {
          const onlineIndicator = document.createElement('div');
          onlineIndicator.style.position = 'absolute';
          onlineIndicator.style.bottom = '0';
          onlineIndicator.style.right = '0';
          onlineIndicator.style.backgroundColor = '#00FF66';
          onlineIndicator.style.borderRadius = '50%';
          onlineIndicator.style.width = '10px';
          onlineIndicator.style.height = '10px';
          onlineIndicator.style.border = '2px solid rgba(0, 0, 0, 0.3)';
          onlineIndicator.style.zIndex = '2';
          element.appendChild(onlineIndicator);
        }
        
        // Assemble all elements
        imageContainer.appendChild(img);
        imageContainer.appendChild(blurOverlay);
        element.appendChild(imageContainer);
        
        // Toggle blur on click
        let isBlurred = true;
        element.addEventListener('click', (e) => {
          e.stopPropagation();
          isBlurred = !isBlurred;
          
          if (isBlurred) {
            img.style.filter = 'blur(8px)';
            blurOverlay.style.opacity = '1';
          } else {
            img.style.filter = 'none';
            blurOverlay.style.opacity = '0';
            
            // Also open the user profile
            onUserClick(user);
          }
        });
        
        // Add entrance animation
        element.animate(
          [
            { opacity: 0, transform: 'translateY(10px) scale(0.8)' },
            { opacity: 1, transform: 'translateY(0) scale(1)' }
          ],
          {
            duration: 500,
            easing: 'cubic-bezier(0.34, 1.56, 0.64, 1)',
            fill: 'forwards'
          }
        );
        
        // Ensure map is ready before adding marker
        // Check if container is available
        if (map && map.getCanvas() && map.getCanvasContainer()) {
          markerRef.current = new mapboxgl.Marker({
            element,
            anchor: 'center'
          })
            .setLngLat([user.position.lng, user.position.lat])
            .addTo(map);
          
          console.log(`Blurrable marker added for user ${user.id}`);
        } else {
          console.warn('Map container not ready, cannot add marker');
        }
      } else {
        // Update marker position if it already exists
        markerRef.current.setLngLat([user.position.lng, user.position.lat]);
      }
    } catch (error) {
      console.error('Error creating blurrable user marker:', error);
    }
    
    // Clean up
    return () => {
      if (markerRef.current) {
        try {
          markerRef.current.remove();
          markerRef.current = null;
        } catch (error) {
          console.error('Error removing blurrable user marker:', error);
        }
      }
    };
  }, [user, map, onUserClick]);
  
  return null;
};

export default BlurrableUserMarker;
