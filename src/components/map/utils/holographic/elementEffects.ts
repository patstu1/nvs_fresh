
import mapboxgl from 'mapbox-gl';

/**
 * Applies holographic styling to an HTML element with optional map context
 */
export const applyHolographicStyles = (element: HTMLElement, map?: mapboxgl.Map): void => {
  // Enhanced cyberpunk styling with darker tones and neon accents
  element.classList.add('hologram-container');

  // Add scan line for cyberpunk effect if not already present
  if (!element.querySelector('.hologram-scan-line')) {
    const scanLine = document.createElement('div');
    scanLine.className = 'hologram-scan-line';
    element.appendChild(scanLine);
  }
  
  // Add horizontal flickering line effect
  if (!element.querySelector('.hologram-flicker')) {
    const flicker = document.createElement('div');
    flicker.className = 'hologram-flicker';
    element.appendChild(flicker);
  }
  
  // Add cyberpunk digital noise overlay
  if (!element.querySelector('.cyberpunk-noise')) {
    const noise = document.createElement('div');
    noise.className = 'cyberpunk-noise';
    element.appendChild(noise);
  }
  
  // Add neon edge glow
  if (!element.querySelector('.neon-edges')) {
    const edges = document.createElement('div');
    edges.className = 'neon-edges';
    element.appendChild(edges);
  }
  
  // Add data particles effect for high-tech appearance
  if (!element.querySelector('.data-particles')) {
    const particles = document.createElement('div');
    particles.className = 'data-flow-particles';
    particles.style.opacity = '0.2';
    element.appendChild(particles);
  }
  
  // Add technicolor glitch effect for advanced visuals
  const createGlitch = () => {
    setTimeout(() => {
      try {
        const glitch = document.createElement('div');
        glitch.className = 'glitch-effect';
        glitch.style.position = 'absolute';
        glitch.style.inset = '0';
        glitch.style.backgroundColor = 'rgba(255, 0, 128, 0.1)';
        glitch.style.mixBlendMode = 'overlay';
        glitch.style.zIndex = '10';
        element.appendChild(glitch);
        
        // Remove after short duration
        setTimeout(() => {
          if (element.contains(glitch)) {
            element.removeChild(glitch);
          }
        }, 150);
        
        if (Math.random() > 0.7) {
          createGlitch();
        }
      } catch (e) {
        console.warn("Could not create glitch effect:", e);
      }
    }, Math.random() * 5000 + 2000);
  };
  
  createGlitch();
};
