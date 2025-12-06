
import mapboxgl from 'mapbox-gl';

/**
 * Sets up visual effects like fog, terrain, and lighting
 */
export const setupMapEffects = (map: mapboxgl.Map): void => {
  // Add atmospheric fog with futuristic colors
  map.setFog({
    'range': [0.5, 10],
    'color': '#0f1428',
    'horizon-blend': 0.15,
    'high-color': '#162b5a',
    'space-color': '#000016',
    'star-intensity': 0.5
  });
  
  // Add terrain effect for enhanced depth perception
  map.addSource('terrain-data', {
    type: 'raster-dem',
    url: 'mapbox://mapbox.mapbox-terrain-dem-v1',
    tileSize: 512
  });
  
  // Apply terrain settings with increased exaggeration
  map.setTerrain({
    source: 'terrain-data',
    exaggeration: 1.5 // Increased for more dramatic 3D visualization
  });
  
  // Add enhanced light effect for better 3D visualization
  map.setLight({
    anchor: 'viewport',
    color: '#60c6ff', // Blue light for futuristic feel
    intensity: 0.25,
    position: [1, 0, 1]
  });
  
  // Add reflective water effect
  addReflectiveWaterEffect(map);
}

/**
 * Adds reflective water effect to 3D map
 */
const addReflectiveWaterEffect = (map: mapboxgl.Map): void => {
  map.addSource('water-source', {
    'type': 'vector',
    'url': 'mapbox://mapbox.mapbox-streets-v8'
  });
  
  // Add futuristic water styling
  map.addLayer({
    'id': 'water-3d',
    'type': 'fill',
    'source': 'water-source',
    'source-layer': 'water',
    'paint': {
      'fill-color': '#0d47a1',
      'fill-opacity': 0.8,
      'fill-outline-color': '#4fc3f7'
    }
  });
  
  // Add animated water pattern
  if (!document.getElementById('water-animation')) {
    const style = document.createElement('style');
    style.id = 'water-animation';
    style.innerHTML = `
      @keyframes waterFlow {
        0% {
          background-position: 0 0;
        }
        100% {
          background-position: 100px 100px;
        }
      }
    `;
    document.head.appendChild(style);
  }
};
