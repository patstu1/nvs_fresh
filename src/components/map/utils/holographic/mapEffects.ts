
import mapboxgl from 'mapbox-gl';
import { addHolographicGrid } from './gridEffects';
import { addHolographicFrame } from './frameEffects';
import { addScanLines } from './scanEffects';

/**
 * Sets up holographic visual effects for the 3D map interface
 * with improved error handling
 */
export const setupHolographicEffects = (map: mapboxgl.Map): void => {
  try {
    // Add dark blue cyberpunk atmosphere with neon highlights
    map.setFog({
      'range': [0.5, 12],
      'color': '#0A101E', // Darker blue for sniffies-like feel
      'horizon-blend': 0.2,
      'high-color': '#0F1B4D', // Deep blue high color
      'space-color': '#000016',
      'star-intensity': 0.6 // Star intensity for night sky effect
    });
  } catch (e) {
    console.warn("Could not set fog effects:", e);
  }
  
  try {
    // Enhanced terrain for 3D effect with higher exaggeration
    map.addSource('enhanced-terrain', {
      type: 'raster-dem',
      url: 'mapbox://mapbox.mapbox-terrain-dem-v1',
      tileSize: 512
    });
    
    // Apply terrain with moderate exaggeration for holographic effect
    map.setTerrain({
      source: 'enhanced-terrain',
      exaggeration: 1.8 // Moderate exaggeration for more subtle 3D effect
    });
  } catch (e) {
    console.warn("Could not set terrain effects:", e);
  }
  
  try {
    // Add blue lighting for cyberpunk neon glow
    map.setLight({
      anchor: 'viewport',
      color: '#1E40AF', // Blue neon light
      intensity: 0.6, // Medium light intensity
      position: [1.15, 210, 30] // Positioned to create dramatic shadows
    });
  } catch (e) {
    console.warn("Could not set lighting effects:", e);
  }
  
  // Add map style modifications
  try {
    map.on('style.load', () => {
      try {
        // Modify water color to match darker theme
        if (map.getLayer('water')) {
          map.setPaintProperty('water', 'fill-color', '#0C1D3D');
        }
        
        // Make land darker
        if (map.getLayer('land')) {
          map.setPaintProperty('land', 'background-color', '#050D1F');
        }
        
        // Darken all buildings
        if (map.getLayer('building')) {
          map.setPaintProperty('building', 'fill-color', '#101830');
          map.setPaintProperty('building', 'fill-opacity', 0.8);
        }
        
        // Style roads for cyberpunk look
        const roadLayers = ['road-minor', 'road-street', 'road-major', 'road-highway'];
        roadLayers.forEach(layer => {
          if (map.getLayer(layer)) {
            map.setPaintProperty(layer, 'line-color', '#2F407C');
          }
        });
      } catch (e) {
        console.warn("Error applying map styles:", e);
      }
    });
  } catch (e) {
    console.warn("Could not set up style load handler:", e);
  }
  
  try {
    // Add holographic grid overlay
    addHolographicGrid(map);
  } catch (e) {
    console.warn("Could not add holographic grid:", e);
  }
  
  try {
    // Add holographic frame/border
    addHolographicFrame(map);
  } catch (e) {
    console.warn("Could not add holographic frame:", e);
  }
  
  try {
    // Add animated scan lines for futuristic effect
    addScanLines();
  } catch (e) {
    console.warn("Could not add scan lines:", e);
  }
  
  try {
    // Add globe rotation for 3D effect when not interacting
    enableGlobeRotation(map);
  } catch (e) {
    console.warn("Could not enable globe rotation:", e);
  }
}

/**
 * Enables subtle globe rotation when map is not being interacted with
 */
const enableGlobeRotation = (map: mapboxgl.Map): void => {
  let isInteracting = false;
  let rotationTimer: number | null = null;
  const rotationSpeed = 0.025; // slower rotation speed for subtle effect
  
  const startRotation = () => {
    if (rotationTimer) return;
    
    rotationTimer = window.setInterval(() => {
      if (!isInteracting && map.getPitch() > 30) {
        try {
          const currentBearing = map.getBearing();
          map.setBearing(currentBearing + rotationSpeed);
        } catch (e) {
          console.warn("Error during rotation:", e);
          stopRotation();
        }
      }
    }, 50);
  };
  
  const stopRotation = () => {
    if (rotationTimer) {
      window.clearInterval(rotationTimer);
      rotationTimer = null;
    }
  };
  
  // Start rotation on load
  map.on('load', startRotation);
  
  // Stop rotation when interacting
  map.on('mousedown', () => { isInteracting = true; });
  map.on('touchstart', () => { isInteracting = true; });
  
  // Resume rotation when done interacting
  map.on('mouseup', () => { 
    isInteracting = false;
    setTimeout(() => {
      if (!isInteracting) startRotation();
    }, 2000);
  });
  
  map.on('touchend', () => { 
    isInteracting = false;
    setTimeout(() => {
      if (!isInteracting) startRotation();
    }, 2000);
  });
  
  // Clean up on map removal
  map.on('remove', stopRotation);
}
