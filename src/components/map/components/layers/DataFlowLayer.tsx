
import mapboxgl from 'mapbox-gl';
import { addDataFlowLines } from '../../utils/layers/dataFlowLayer';

const DataFlowLayer = {
  add: (map: mapboxgl.Map) => {
    addDataFlowLines(map);
  }
};

export default DataFlowLayer;
