
import React, { useRef } from 'react';
import mapboxgl from 'mapbox-gl';
import { useHolographicEffect } from '../hooks/useHolographicEffect';
import { holographicOverlayStyles as styles } from '../styles/holographicStyles';

export interface HolographicOverlayProps {
  map?: mapboxgl.Map;
}

const HolographicOverlay: React.FC<HolographicOverlayProps> = ({ map }) => {
  const overlayRef = useRef<HTMLDivElement>(null);
  
  useHolographicEffect(overlayRef, map);

  return (
    <div ref={overlayRef} className={styles.container}>
      <div className={styles.grid}></div>
      <div className={styles.scan}></div>
      <div className={styles.glow}></div>
    </div>
  );
};

export default HolographicOverlay;
