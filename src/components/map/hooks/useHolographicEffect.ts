
import { useEffect, RefObject } from 'react';
import mapboxgl from 'mapbox-gl';
import { applyHolographicStyles } from '../utils/holographic';

export const useHolographicEffect = (
  overlayRef: RefObject<HTMLDivElement>,
  map?: mapboxgl.Map
) => {
  // Apply holographic styling when component mounts or map changes
  useEffect(() => {
    if (overlayRef.current) {
      try {
        // Apply cyberpunk holographic styling to the overlay
        applyHolographicStyles(overlayRef.current, map);
        
        // Add entrance animation
        overlayRef.current.animate(
          [
            { opacity: 0, filter: 'blur(10px)' },
            { opacity: 1, filter: 'blur(0px)' }
          ],
          {
            duration: 800,
            easing: 'cubic-bezier(0.16, 1, 0.3, 1)',
            fill: 'forwards'
          }
        );
        
        // Add periodic pulse effect
        const pulseInterval = setInterval(() => {
          if (overlayRef.current) {
            overlayRef.current.animate(
              [
                { filter: 'brightness(1) contrast(1)' },
                { filter: 'brightness(1.2) contrast(1.05)' },
                { filter: 'brightness(1) contrast(1)' }
              ],
              {
                duration: 2000,
                easing: 'ease-in-out'
              }
            );
          }
        }, 5000);
        
        return () => {
          clearInterval(pulseInterval);
          
          // Exit animation
          if (overlayRef.current) {
            const animation = overlayRef.current.animate(
              [
                { opacity: 1, filter: 'blur(0px)' },
                { opacity: 0, filter: 'blur(10px)' }
              ],
              {
                duration: 500,
                easing: 'cubic-bezier(0.16, 1, 0.3, 1)',
                fill: 'forwards'
              }
            );
            
            animation.onfinish = () => {
              if (overlayRef.current) {
                overlayRef.current.style.display = 'none';
              }
            };
          }
        };
      } catch (error) {
        console.error("Error applying holographic effect:", error);
        return undefined;
      }
    }
    
    return undefined;
  }, [overlayRef, map]);
};
