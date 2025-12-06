
import mapboxgl from 'mapbox-gl';

/**
 * Adds cyberpunk-inspired data flow lines to the map
 */
export const addDataFlowLines = (map: mapboxgl.Map): void => {
  // Create a canvas for the flow effect
  const canvas = document.createElement('canvas');
  canvas.width = 256;
  canvas.height = 256;
  const ctx = canvas.getContext('2d')!;
  
  // Create flow pattern
  const drawPattern = () => {
    // Clear canvas
    ctx.clearRect(0, 0, 256, 256);
    
    // Random number of flow lines
    const lineCount = Math.floor(Math.random() * 5) + 3;
    
    for (let i = 0; i < lineCount; i++) {
      // Random starting points
      const x1 = Math.random() * 256;
      const y1 = Math.random() * 256;
      
      // Random lengths and angles
      const length = 30 + Math.random() * 100;
      const angle = Math.random() * Math.PI * 2;
      
      const x2 = x1 + Math.cos(angle) * length;
      const y2 = y1 + Math.sin(angle) * length;
      
      // Create gradient for neon glow effect
      const isOrange = Math.random() > 0.7;
      const gradient = ctx.createLinearGradient(x1, y1, x2, y2);
      
      if (isOrange) {
        gradient.addColorStop(0, 'rgba(255, 115, 0, 0)');
        gradient.addColorStop(0.5, 'rgba(255, 115, 0, 0.8)');
        gradient.addColorStop(1, 'rgba(255, 115, 0, 0)');
      } else {
        gradient.addColorStop(0, 'rgba(0, 255, 196, 0)');
        gradient.addColorStop(0.5, 'rgba(0, 255, 196, 0.8)');
        gradient.addColorStop(1, 'rgba(0, 255, 196, 0)');
      }
      
      // Draw the line
      ctx.beginPath();
      ctx.moveTo(x1, y1);
      ctx.lineTo(x2, y2);
      ctx.lineWidth = 1 + Math.random() * 2;
      ctx.strokeStyle = gradient;
      ctx.stroke();
      
      // Add glow effect
      ctx.beginPath();
      ctx.moveTo(x1, y1);
      ctx.lineTo(x2, y2);
      ctx.lineWidth = 4;
      ctx.strokeStyle = isOrange ? 
        'rgba(255, 115, 0, 0.1)' : 
        'rgba(0, 255, 196, 0.1)';
      ctx.stroke();
    }
  };
  
  // Initialize data flow animation
  let animationFrame: number;
  let flowSource: mapboxgl.ImageSource | null = null;
  
  // Initial draw
  drawPattern();
  
  // Add image source to map
  if (map.getSource('data-flow')) {
    // Update existing source
    flowSource = map.getSource('data-flow') as mapboxgl.ImageSource;
    flowSource.updateImage({
      url: canvas.toDataURL()
    });
  } else {
    // Create new source
    map.addSource('data-flow', {
      type: 'image',
      url: canvas.toDataURL(),
      coordinates: [
        [-180, 85],
        [180, 85],
        [180, -85],
        [-180, -85]
      ]
    });
    
    flowSource = map.getSource('data-flow') as mapboxgl.ImageSource;
    
    // Add layer
    map.addLayer({
      id: 'data-flow-layer',
      source: 'data-flow',
      type: 'raster',
      paint: {
        'raster-opacity': 0.3,
        'raster-fade-duration': 0
      }
    });
  }
  
  // Animate the flow pattern
  const animateFlow = () => {
    drawPattern();
    if (flowSource) {
      flowSource.updateImage({
        url: canvas.toDataURL()
      });
    }
    animationFrame = requestAnimationFrame(animateFlow);
  };
  
  // Start animation
  animationFrame = requestAnimationFrame(animateFlow);
  
  // Clean up on map remove
  map.once('remove', () => {
    cancelAnimationFrame(animationFrame);
  });
};

