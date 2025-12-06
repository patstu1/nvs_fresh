
import mapboxgl from 'mapbox-gl';

/**
 * Creates a futuristic grid pattern
 */
export const createGrid = (map: mapboxgl.Map): void => {
  const bounds = map.getBounds();
  const features = [];
  
  // Create horizontal grid lines with futuristic spacing
  for (let lat = Math.floor(bounds.getSouth()); lat <= Math.ceil(bounds.getNorth()); lat += 0.015) {
    features.push({
      type: 'Feature',
      properties: {
        type: 'horizontal'
      },
      geometry: {
        type: 'LineString',
        coordinates: [
          [bounds.getWest() - 1, lat],
          [bounds.getEast() + 1, lat]
        ]
      }
    });
  }
  
  // Create vertical grid lines
  for (let lng = Math.floor(bounds.getWest()); lng <= Math.ceil(bounds.getEast()); lng += 0.015) {
    features.push({
      type: 'Feature',
      properties: {
        type: 'vertical'
      },
      geometry: {
        type: 'LineString',
        coordinates: [
          [lng, bounds.getSouth() - 1],
          [lng, bounds.getNorth() + 1]
        ]
      }
    });
  }
  
  // Add circular grid elements at intersections
  for (let lat = Math.floor(bounds.getSouth()); lat <= Math.ceil(bounds.getNorth()); lat += 0.06) {
    for (let lng = Math.floor(bounds.getWest()); lng <= Math.ceil(bounds.getEast()); lng += 0.06) {
      features.push({
        type: 'Feature',
        properties: {
          type: 'node',
          size: Math.random() > 0.7 ? 'large' : 'small'
        },
        geometry: {
          type: 'Point',
          coordinates: [lng, lat]
        }
      });
    }
  }
  
  // Update the data source
  (map.getSource('grid-source') as mapboxgl.GeoJSONSource).setData({
    type: 'FeatureCollection',
    features: features
  });
  
  // Add grid node points if they don't exist yet
  if (!map.getLayer('grid-nodes')) {
    map.addLayer({
      id: 'grid-nodes',
      type: 'circle',
      source: 'grid-source',
      filter: ['==', ['get', 'type'], 'node'],
      paint: {
        'circle-radius': [
          'case',
          ['==', ['get', 'size'], 'large'],
          3,
          1.5
        ],
        'circle-color': 'rgba(76, 201, 255, 0.7)',
        'circle-opacity': 0.7,
        'circle-blur': 0.5
      }
    });
  }
};
