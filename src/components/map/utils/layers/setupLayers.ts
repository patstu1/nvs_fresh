
import mapboxgl from 'mapbox-gl';
import { GridLayer, HexagonLayer, DataFlowLayer } from '../../components/layers';

/**
 * Sets up the modern minimal layers and digital elements
 */
export const setupMapLayers = (map: mapboxgl.Map): void => {
  // Add grid layer
  GridLayer.add(map);
  
  // Add hexagonal overlay pattern
  HexagonLayer.add(map);
  
  // Add data flow line effects
  DataFlowLayer.add(map);
};
