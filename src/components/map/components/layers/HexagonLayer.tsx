
import mapboxgl from 'mapbox-gl';
import { addHexagonalPattern } from '../../utils/layers/hexagonLayer';

const HexagonLayer = {
  add: (map: mapboxgl.Map) => {
    addHexagonalPattern(map);
  }
};

export default HexagonLayer;
