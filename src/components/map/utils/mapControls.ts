
import mapboxgl from 'mapbox-gl';

/**
 * Adds navigation controls and any other UI controls to the map
 */
export const setupMapControls = (map: mapboxgl.Map): void => {
  // Add modern minimalist navigation controls
  const navControl = new mapboxgl.NavigationControl({
    showCompass: true,
    visualizePitch: true,
    showZoom: true
  });
  map.addControl(navControl, 'bottom-right');
  
  // Add scale control with metric and imperial units
  const scaleControl = new mapboxgl.ScaleControl({
    maxWidth: 100,
    unit: 'metric'
  });
  map.addControl(scaleControl, 'bottom-left');
  
  // Add fullscreen control for immersive experience
  const fullscreenControl = new mapboxgl.FullscreenControl();
  map.addControl(fullscreenControl, 'top-right');
};
