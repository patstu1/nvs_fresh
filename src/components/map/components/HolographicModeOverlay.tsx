
import React, { useEffect, useRef } from 'react';
import { holographicOverlayStyles } from '../styles/holographicStyles';
import '@/components/map/styles/holographicAnimations.css';

interface HolographicModeOverlayProps {
  active: boolean;
}

const HolographicModeOverlay: React.FC<HolographicModeOverlayProps> = ({ active }) => {
  const overlayRef = useRef<HTMLDivElement>(null);
  
  useEffect(() => {
    if (active && overlayRef.current) {
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
      
      return () => clearInterval(pulseInterval);
    }
  }, [active]);
  
  if (!active) return null;
  
  return (
    <div 
      ref={overlayRef} 
      className={holographicOverlayStyles.container} 
      aria-hidden="true"
      data-high-tech="true"
    >
      <div className="absolute inset-0 pointer-events-none z-10 opacity-70">
        <div className="hologram-scan-line"></div>
        <div className="hologram-flicker"></div>
        <div className="cyberpunk-noise"></div>
        
        {/* New advanced holographic elements */}
        <div className="digital-hexgrid"></div>
        <div className="data-flow-particles"></div>
        <div className="neon-pulse-border"></div>
        <div className="neon-edges"></div>
        
        {/* High-tech corners */}
        <div className="tech-corner top-left"></div>
        <div className="tech-corner top-right"></div>
        <div className="tech-corner bottom-left"></div>
        <div className="tech-corner bottom-right"></div>
      </div>
    </div>
  );
};

export default HolographicModeOverlay;
