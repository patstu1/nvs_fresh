
import { useEffect } from 'react';
import mapboxgl from 'mapbox-gl';

export const useMap3DMode = (map: mapboxgl.Map | null, is3DMode: boolean) => {
  useEffect(() => {
    if (!map) return;
    
    if (is3DMode) {
      map.setPitch(60);
      map.setBearing(30);
    } else {
      map.setPitch(0);
      map.setBearing(0);
      if (map.touchZoomRotate) map.touchZoomRotate.disableRotation();
      if (map.dragRotate) map.dragRotate.disable();
    }
  }, [map, is3DMode]);
};
