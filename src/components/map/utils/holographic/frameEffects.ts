
import mapboxgl from 'mapbox-gl';

/**
 * Creates a holographic frame around the map
 */
export const addHolographicFrame = (map: mapboxgl.Map): void => {
  // Remove existing frame if present
  const existingFrame = document.getElementById('holo-frame');
  if (existingFrame && existingFrame.parentNode) {
    existingFrame.parentNode.removeChild(existingFrame);
  }
  
  // Create frame container
  const container = map.getContainer();
  const frame = document.createElement('div');
  frame.id = 'holo-frame';
  frame.style.position = 'absolute';
  frame.style.top = '0';
  frame.style.left = '0';
  frame.style.right = '0';
  frame.style.bottom = '0';
  frame.style.pointerEvents = 'none';
  frame.style.zIndex = '1';
  frame.style.boxShadow = 'inset 0 0 40px rgba(0, 255, 196, 0.3)';
  frame.style.border = '1px solid rgba(0, 255, 196, 0.5)';
  frame.style.borderRadius = '4px';
  
  // Add corner accents
  const corners = ['top-left', 'top-right', 'bottom-left', 'bottom-right'];
  corners.forEach(corner => {
    const cornerEl = document.createElement('div');
    cornerEl.className = `corner ${corner}`;
    cornerEl.style.position = 'absolute';
    cornerEl.style.width = '60px';
    cornerEl.style.height = '60px';
    
    // Position the corner
    if (corner.includes('top')) {
      cornerEl.style.top = '0';
    } else {
      cornerEl.style.bottom = '0';
    }
    
    if (corner.includes('left')) {
      cornerEl.style.left = '0';
    } else {
      cornerEl.style.right = '0';
    }
    
    // Add cyberpunk corner styling
    if (corner === 'top-left') {
      cornerEl.style.borderTop = '3px solid #00FFC4';
      cornerEl.style.borderLeft = '3px solid #00FFC4';
      cornerEl.style.boxShadow = '0 0 15px rgba(0, 255, 196, 0.7)';
    } else if (corner === 'top-right') {
      cornerEl.style.borderTop = '3px solid #00FFC4';
      cornerEl.style.borderRight = '3px solid #00FFC4';
      cornerEl.style.boxShadow = '0 0 15px rgba(0, 255, 196, 0.7)';
    } else if (corner === 'bottom-left') {
      cornerEl.style.borderBottom = '3px solid #FF7300';
      cornerEl.style.borderLeft = '3px solid #FF7300';
      cornerEl.style.boxShadow = '0 0 15px rgba(255, 115, 0, 0.7)';
    } else {
      cornerEl.style.borderBottom = '3px solid #FF7300';
      cornerEl.style.borderRight = '3px solid #FF7300';
      cornerEl.style.boxShadow = '0 0 15px rgba(255, 115, 0, 0.7)';
    }
    
    frame.appendChild(cornerEl);
  });
  
  // Add diagonal accents
  const diagonalAccentsCount = 4;
  for (let i = 0; i < diagonalAccentsCount; i++) {
    const accent = document.createElement('div');
    accent.className = 'diagonal-accent';
    accent.style.position = 'absolute';
    accent.style.width = '3px';
    accent.style.height = '30px';
    accent.style.background = i % 2 === 0 ? '#00FFC4' : '#FF7300';
    accent.style.boxShadow = `0 0 8px ${i % 2 === 0 ? 'rgba(0, 255, 196, 0.7)' : 'rgba(255, 115, 0, 0.7)'}`;
    accent.style.transform = 'rotate(45deg)';
    
    // Position diagonals in different corners
    switch(i) {
      case 0: 
        accent.style.top = '20px';
        accent.style.right = '70px';
        break;
      case 1:
        accent.style.bottom = '20px';
        accent.style.left = '70px';
        break;
      case 2:
        accent.style.top = '70px';
        accent.style.left = '20px';
        accent.style.transform = 'rotate(-45deg)';
        break;
      case 3:
        accent.style.bottom = '70px';
        accent.style.right = '20px';
        accent.style.transform = 'rotate(-45deg)';
        break;
    }
    
    frame.appendChild(accent);
  }
  
  // Add animated border effect
  const animatedBorder = document.createElement('div');
  animatedBorder.className = 'animated-border';
  animatedBorder.style.position = 'absolute';
  animatedBorder.style.inset = '0';
  animatedBorder.style.pointerEvents = 'none';
  animatedBorder.style.border = '1px solid transparent';
  
  // Add style for the animated border if not exists
  if (!document.getElementById('animated-border-style')) {
    const style = document.createElement('style');
    style.id = 'animated-border-style';
    style.innerHTML = `
      @keyframes borderAnimation {
        0%, 100% { 
          border-image: linear-gradient(90deg, transparent, #00FFC4, transparent) 1;
          border-image-slice: 1;
        }
        25% {
          border-image: linear-gradient(180deg, transparent, #00FFC4, transparent) 1;
          border-image-slice: 1;
        }
        50% {
          border-image: linear-gradient(270deg, transparent, #FF7300, transparent) 1;
          border-image-slice: 1;
        }
        75% {
          border-image: linear-gradient(360deg, transparent, #FF7300, transparent) 1;
          border-image-slice: 1;
        }
      }
      
      .animated-border {
        animation: borderAnimation 8s infinite linear;
      }
    `;
    document.head.appendChild(style);
  }
  
  frame.appendChild(animatedBorder);
  container.appendChild(frame);
}

