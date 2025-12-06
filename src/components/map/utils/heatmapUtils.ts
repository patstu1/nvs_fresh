
import mapboxgl from 'mapbox-gl';

/**
 * Creates a modern heatmap layer for visualizing popular areas
 */
export const createHeatmap = (map: mapboxgl.Map): void => {
  // Mock data for heatmap visualization - would be replaced with real data
  const mockData = [
    { lng: -74.0060, lat: 40.7128, weight: 1.0 },
    { lng: -74.0160, lat: 40.7228, weight: 0.8 },
    { lng: -73.9860, lat: 40.7328, weight: 0.6 },
    { lng: -73.9960, lat: 40.7028, weight: 0.9 },
    { lng: -74.0260, lat: 40.7328, weight: 0.7 },
    { lng: -73.9760, lat: 40.7128, weight: 0.5 }
  ];
  
  // Add heatmap source with weighted points
  map.addSource('heatmap-source', {
    type: 'geojson',
    data: {
      type: 'FeatureCollection',
      features: mockData.map(point => ({
        type: 'Feature',
        properties: {
          weight: point.weight
        },
        geometry: {
          type: 'Point',
          coordinates: [point.lng, point.lat]
        }
      }))
    }
  });
  
  // Add modern gradient heatmap layer
  map.addLayer({
    id: 'heatmap-layer',
    type: 'heatmap',
    source: 'heatmap-source',
    maxzoom: 18,
    paint: {
      // Weight expression based on point weight property
      'heatmap-weight': [
        'interpolate',
        ['linear'],
        ['get', 'weight'],
        0, 0,
        1, 1
      ],
      'heatmap-intensity': [
        'interpolate',
        ['linear'],
        ['zoom'],
        10, 0.8,
        15, 1.5
      ],
      // Modern color gradient
      'heatmap-color': [
        'interpolate',
        ['linear'],
        ['heatmap-density'],
        0, 'rgba(0,0,0,0)',
        0.2, 'rgba(0,170,255,0.3)',
        0.4, 'rgba(0,200,255,0.5)',
        0.6, 'rgba(21,137,255,0.7)',
        0.8, 'rgba(132,28,255,0.8)',
        1, 'rgba(247,0,255,0.9)'
      ],
      'heatmap-radius': [
        'interpolate',
        ['linear'],
        ['zoom'],
        10, 15,
        15, 35
      ],
      'heatmap-opacity': [
        'interpolate',
        ['linear'],
        ['zoom'],
        10, 0.6,
        15, 0.7,
        17, 0.4
      ]
    }
  });
  
  // Add point layer for highest intensity locations
  map.addLayer({
    id: 'heatmap-points',
    type: 'circle',
    source: 'heatmap-source',
    minzoom: 14,
    paint: {
      'circle-radius': [
        'interpolate',
        ['linear'],
        ['zoom'],
        14, 4,
        17, 8
      ],
      'circle-color': [
        'interpolate',
        ['linear'],
        ['get', 'weight'],
        0.5, '#00CCFF',
        1, '#9900FF'
      ],
      'circle-stroke-color': 'white',
      'circle-stroke-width': 1,
      'circle-opacity': [
        'interpolate',
        ['linear'],
        ['zoom'],
        14, 0,
        15, 0.5
      ]
    }
  });
};
