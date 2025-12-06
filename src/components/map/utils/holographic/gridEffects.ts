
import mapboxgl from 'mapbox-gl';

/**
 * Creates a holographic grid overlay
 */
export const addHolographicGrid = (map: mapboxgl.Map): void => {
  // Create a canvas for the holographic grid
  const gridCanvas = document.createElement('canvas');
  gridCanvas.width = 512;
  gridCanvas.height = 512;
  const ctx = gridCanvas.getContext('2d')!;
  
  // Fill with dark background
  ctx.fillStyle = 'rgba(10, 16, 30, 0.3)';
  ctx.fillRect(0, 0, 512, 512);
  
  // Draw main grid lines - horizontal
  ctx.strokeStyle = 'rgba(0, 255, 196, 0.3)';
  ctx.lineWidth = 1;
  for (let y = 0; y <= 512; y += 64) {
    ctx.beginPath();
    ctx.moveTo(0, y);
    ctx.lineTo(512, y);
    ctx.stroke();
    
    // Add glow effect
    ctx.strokeStyle = 'rgba(0, 255, 196, 0.15)';
    ctx.lineWidth = 2;
    ctx.beginPath();
    ctx.moveTo(0, y);
    ctx.lineTo(512, y);
    ctx.stroke();
    
    ctx.strokeStyle = 'rgba(0, 255, 196, 0.3)';
    ctx.lineWidth = 1;
  }
  
  // Draw main grid lines - vertical
  for (let x = 0; x <= 512; x += 64) {
    ctx.beginPath();
    ctx.moveTo(x, 0);
    ctx.lineTo(x, 512);
    ctx.stroke();
    
    // Add glow effect
    ctx.strokeStyle = 'rgba(0, 255, 196, 0.15)';
    ctx.lineWidth = 2;
    ctx.beginPath();
    ctx.moveTo(x, 0);
    ctx.lineTo(x, 512);
    ctx.stroke();
    
    ctx.strokeStyle = 'rgba(0, 255, 196, 0.3)';
    ctx.lineWidth = 1;
  }
  
  // Draw secondary grid lines - horizontal
  ctx.strokeStyle = 'rgba(0, 255, 196, 0.1)';
  ctx.lineWidth = 0.5;
  for (let y = 0; y <= 512; y += 32) {
    // Skip main lines
    if (y % 64 === 0) continue;
    
    ctx.beginPath();
    ctx.moveTo(0, y);
    ctx.lineTo(512, y);
    ctx.stroke();
  }
  
  // Draw secondary grid lines - vertical
  for (let x = 0; x <= 512; x += 32) {
    // Skip main lines
    if (x % 64 === 0) continue;
    
    ctx.beginPath();
    ctx.moveTo(x, 0);
    ctx.lineTo(x, 512);
    ctx.stroke();
  }
  
  // Add orange accent lines (horizontal)
  ctx.strokeStyle = 'rgba(255, 115, 0, 0.4)';
  ctx.lineWidth = 1;
  for (let y = 0; y <= 512; y += 256) {
    ctx.beginPath();
    ctx.moveTo(0, y);
    ctx.lineTo(512, y);
    ctx.stroke();
    
    // Glow effect
    ctx.strokeStyle = 'rgba(255, 115, 0, 0.2)';
    ctx.lineWidth = 3;
    ctx.beginPath();
    ctx.moveTo(0, y);
    ctx.lineTo(512, y);
    ctx.stroke();
    
    ctx.strokeStyle = 'rgba(255, 115, 0, 0.4)';
    ctx.lineWidth = 1;
  }
  
  // Add orange accent lines (vertical)
  for (let x = 0; x <= 512; x += 256) {
    ctx.beginPath();
    ctx.moveTo(x, 0);
    ctx.lineTo(x, 512);
    ctx.stroke();
    
    // Glow effect
    ctx.strokeStyle = 'rgba(255, 115, 0, 0.2)';
    ctx.lineWidth = 3;
    ctx.beginPath();
    ctx.moveTo(x, 0);
    ctx.lineTo(x, 512);
    ctx.stroke();
    
    ctx.strokeStyle = 'rgba(255, 115, 0, 0.4)';
    ctx.lineWidth = 1;
  }
  
  // Create an image from the canvas
  const imageData = { width: gridCanvas.width, height: gridCanvas.height, data: new Uint8Array(ctx.getImageData(0, 0, gridCanvas.width, gridCanvas.height).data.buffer) };
  
  // Add as a repeating pattern overlay
  if (map.hasImage('grid-pattern')) map.removeImage('grid-pattern');
  map.addImage('grid-pattern', imageData);
  
  // Add grid source if doesn't exist
  if (!map.getSource('grid-pattern')) {
    map.addSource('grid-pattern', {
      type: 'image',
      url: gridCanvas.toDataURL(),
      coordinates: [
        [-180, 85],
        [180, 85],
        [180, -85],
        [-180, -85]
      ]
    });
  } else {
    // If source already exists, update it
    (map.getSource('grid-pattern') as mapboxgl.ImageSource).updateImage({
      url: gridCanvas.toDataURL()
    });
  }
  
  // Remove layer if it exists
  if (map.getLayer('holographic-grid')) {
    map.removeLayer('holographic-grid');
  }
  
  // Add grid layer
  map.addLayer({
    id: 'holographic-grid',
    type: 'raster',
    source: 'grid-pattern',
    paint: {
      'raster-opacity': 0.35,
      'raster-fade-duration': 0
    }
  });
}
