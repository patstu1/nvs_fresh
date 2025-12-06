
import { useCallback } from 'react';
import mapboxgl from 'mapbox-gl';
import { User } from '../types/markerTypes';

interface UseMarkerEventsProps {
  map: mapboxgl.Map;
  onUserClick?: (user: User) => void;
}

/**
 * Hook to handle marker events with enhanced 3D effects
 */
export const useMarkerEvents = ({ map, onUserClick }: UseMarkerEventsProps) => {
  /**
   * Attaches click handler to marker element with holographic effects
   */
  const attachClickHandler = useCallback((
    el: HTMLDivElement,
    user: User
  ) => {
    if (onUserClick) {
      // Add hover effects for 3D holographic appearance
      el.addEventListener('mouseenter', () => {
        el.style.transform = 'scale(1.1) translateY(-5px)';
        el.style.boxShadow = `0 10px 25px -5px rgba(76, 201, 240, 0.9), 
                             0 0 15px rgba(76, 201, 240, 0.5)`;
        el.style.zIndex = '1000';
        
        // Add dynamic pulse effect
        const pulse = document.createElement('div');
        pulse.className = 'marker-pulse';
        pulse.style.position = 'absolute';
        pulse.style.top = '0';
        pulse.style.left = '0';
        pulse.style.width = '100%';
        pulse.style.height = '100%';
        pulse.style.borderRadius = '50%';
        pulse.style.boxShadow = '0 0 0 rgba(76, 201, 240, 0.7)';
        pulse.style.animation = 'marker-pulse 1.5s infinite';
        pulse.style.zIndex = '-1';
        
        // Add pulse animation if it doesn't exist
        if (!document.getElementById('marker-pulse-animation')) {
          const style = document.createElement('style');
          style.id = 'marker-pulse-animation';
          style.innerHTML = `
            @keyframes marker-pulse {
              0% {
                transform: scale(1);
                box-shadow: 0 0 0 0 rgba(76, 201, 240, 0.7);
              }
              70% {
                transform: scale(1.3);
                box-shadow: 0 0 0 15px rgba(76, 201, 240, 0);
              }
              100% {
                transform: scale(1);
                box-shadow: 0 0 0 0 rgba(76, 201, 240, 0);
              }
            }
          `;
          document.head.appendChild(style);
        }
        
        el.appendChild(pulse);
      });
      
      el.addEventListener('mouseleave', () => {
        el.style.transform = 'scale(1) translateY(0)';
        el.style.boxShadow = '';
        el.style.zIndex = '';
        
        // Remove pulse effect
        const pulse = el.querySelector('.marker-pulse');
        if (pulse) {
          el.removeChild(pulse);
        }
      });
      
      // Add click handler with ripple effect
      el.addEventListener('click', () => {
        // Create ripple effect
        const ripple = document.createElement('div');
        ripple.className = 'marker-click-ripple';
        ripple.style.position = 'absolute';
        ripple.style.top = '50%';
        ripple.style.left = '50%';
        ripple.style.transform = 'translate(-50%, -50%)';
        ripple.style.width = '10px';
        ripple.style.height = '10px';
        ripple.style.borderRadius = '50%';
        ripple.style.backgroundColor = 'rgba(76, 201, 240, 0.8)';
        ripple.style.zIndex = '1000';
        
        // Add ripple animation
        ripple.animate([
          { opacity: 1, transform: 'translate(-50%, -50%) scale(1)' },
          { opacity: 0, transform: 'translate(-50%, -50%) scale(20)' }
        ], {
          duration: 600,
          easing: 'cubic-bezier(0.4, 0, 0.2, 1)'
        });
        
        el.appendChild(ripple);
        
        // Remove ripple after animation
        setTimeout(() => {
          if (ripple.parentNode === el) {
            el.removeChild(ripple);
          }
        }, 700);
        
        onUserClick(user);
      });
    }
  }, [onUserClick]);
  
  return {
    attachClickHandler
  };
};
