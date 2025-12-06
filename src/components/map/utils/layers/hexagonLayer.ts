
import mapboxgl from 'mapbox-gl';

/**
 * Adds hexagonal pattern overlay for cyberpunk aesthetic
 */
export const addHexagonalPattern = (map: mapboxgl.Map): void => {
  // Create a canvas for the hexagon pattern
  const canvas = document.createElement('canvas');
  canvas.width = 100;
  canvas.height = 100;
  const ctx = canvas.getContext('2d')!;
  
  // Define hexagon parameters
  const size = 30; // Size of hexagon
  const h = size * Math.sqrt(3);
  
  // Function to draw a single hexagon
  const drawHexagon = (x: number, y: number, color: string) => {
    ctx.beginPath();
    for (let i = 0; i < 6; i++) {
      const angle = (i * Math.PI) / 3;
      const xPos = x + size * Math.cos(angle);
      const yPos = y + size * Math.sin(angle);
      
      if (i === 0) {
        ctx.moveTo(xPos, yPos);
      } else {
        ctx.lineTo(xPos, yPos);
      }
    }
    ctx.closePath();
    ctx.strokeStyle = color;
    ctx.lineWidth = 1;
    ctx.stroke();
  };
  
  // Draw hexagon pattern
  for (let row = 0; row < 3; row++) {
    for (let col = 0; col < 3; col++) {
      const x = col * 1.5 * size;
      const y = row * h + (col % 2) * (h / 2);
      
      // Alternate between cyan and orange for cyberpunk feel
      const color = (row + col) % 2 === 0 ? 
        'rgba(0, 255, 196, 0.2)' : 
        'rgba(255, 115, 0, 0.2)';
      
      drawHexagon(x, y, color);
    }
  }
  
  // Create an image from the canvas
  const imageData = { width: canvas.width, height: canvas.height, data: new Uint8Array(ctx.getImageData(0, 0, canvas.width, canvas.height).data.buffer) };
  
  // Add pattern to map
  if (map.hasImage('hexagon-pattern')) {
    map.removeImage('hexagon-pattern');
  }
  map.addImage('hexagon-pattern', imageData);
  
  // Add pattern source
  map.addSource('hexagon-overlay', {
    type: 'image',
    url: canvas.toDataURL(),
    coordinates: [
      [-180, 85],
      [180, 85],
      [180, -85],
      [-180, -85]
    ]
  });
  
  // Add pattern layer
  map.addLayer({
    id: 'hexagon-pattern-layer',
    source: 'hexagon-overlay',
    type: 'raster',
    paint: {
      'raster-opacity': 0.15,
      'raster-fade-duration': 0
    }
  }, 'data-flow-layer'); // Place below data flow lines
};
