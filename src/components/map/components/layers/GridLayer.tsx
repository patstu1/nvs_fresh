
import mapboxgl from 'mapbox-gl';
import { createGrid } from '../../utils/layers/gridLayer';

const GridLayer = {
  add: (map: mapboxgl.Map) => {
    // Add grid source if it doesn't exist
    if (!map.getSource('grid-source')) {
      map.addSource('grid-source', {
        type: 'geojson',
        data: {
          type: 'FeatureCollection',
          features: []
        }
      });
    }

    // Add grid layer if it doesn't exist
    if (!map.getLayer('grid-layer')) {
      map.addLayer({
        id: 'grid-layer',
        type: 'line',
        source: 'grid-source',
        layout: {
          'line-join': 'round',
          'line-cap': 'round'
        },
        paint: {
          'line-color': [
            'interpolate',
            ['linear'],
            ['zoom'],
            10, 'rgba(76, 201, 255, 0.25)',
            13, 'rgba(76, 201, 255, 0.20)',
            16, 'rgba(76, 201, 255, 0.15)'
          ],
          'line-width': [
            'interpolate',
            ['linear'],
            ['zoom'],
            10, 0.5,
            16, 1.2
          ],
          'line-opacity': 0.7,
          'line-blur': 0.5
        }
      });
    }

    // Create initial grid
    createGrid(map);

    // Setup event listener if not already set
    if (!map.getLayer('grid-layer-update-listener')) {
      map.on('moveend', () => createGrid(map));
      // Mark that we've set the listener by adding a dummy layer
      map.addLayer({
        id: 'grid-layer-update-listener',
        type: 'custom',
        render: () => {}
      });
    }
  }
};

export default GridLayer;
