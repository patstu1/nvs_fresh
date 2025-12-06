
/**
 * Helper functions for styling map markers with modern aesthetics
 */

/**
 * Creates the pulse animation style element if it doesn't exist
 */
export const createPulseAnimation = () => {
  // Check if style already exists to prevent duplicates
  if (!document.getElementById('marker-animations')) {
    const style = document.createElement('style');
    style.id = 'marker-animations';
    style.innerHTML = `
      @keyframes float {
        0% { transform: translateY(0px); }
        50% { transform: translateY(-5px); }
        100% { transform: translateY(0px); }
      }
      
      @keyframes pulse-ring {
        0% { transform: scale(1); opacity: 0.4; }
        100% { transform: scale(1.5); opacity: 0; }
      }
      
      @keyframes modern-glow {
        0% { box-shadow: 0 0 4px rgba(0, 238, 255, 0.3); }
        50% { box-shadow: 0 0 8px rgba(0, 238, 255, 0.5); }
        100% { box-shadow: 0 0 4px rgba(0, 238, 255, 0.3); }
      }
      
      @keyframes border-pulse {
        0% { border-color: rgba(0, 238, 255, 0.5); }
        50% { border-color: rgba(0, 238, 255, 0.9); }
        100% { border-color: rgba(0, 238, 255, 0.5); }
      }

      @keyframes scan-line {
        0% { transform: translateY(-100%); }
        100% { transform: translateY(100%); }
      }

      .floating-marker {
        animation: float 4s ease-in-out infinite;
        will-change: transform;
      }
      
      .modern-border {
        animation: border-pulse 4s infinite;
      }
      
      .modern-glow {
        animation: modern-glow 3s infinite;
      }
      
      .scan-effect {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: linear-gradient(to bottom, rgba(0, 238, 255, 0), rgba(0, 238, 255, 0.15), rgba(0, 238, 255, 0));
        opacity: 0.5;
        pointer-events: none;
        animation: scan-line 2s infinite linear;
      }
    `;
    document.head.appendChild(style);
  }
};

/**
 * Create marker styling based on user type
 */
export const getMarkerBorderStyles = (userType: string, hasPrivateAlbum: boolean) => {
  if (hasPrivateAlbum) {
    // Modern mint styling for private album users
    return {
      border: '2px solid rgba(194, 255, 230, 0.7)',
      boxShadow: '0 0 10px rgba(194, 255, 230, 0.4)'
    };
  } else if (userType === 'new') {
    // Modern purple styling for new users
    return {
      border: '2px solid rgba(139, 92, 246, 0.7)',
      boxShadow: '0 0 10px rgba(139, 92, 246, 0.4)'
    };
  } else {
    // Modern blue styling for regular users
    return {
      border: '2px solid rgba(14, 165, 233, 0.7)',
      boxShadow: '0 0 10px rgba(14, 165, 233, 0.4)'
    };
  }
};

/**
 * Get base size of marker based on user type
 */
export const getMarkerSize = (userType: string): string => {
  return userType === 'new' ? '50px' : '44px';
};

/**
 * Create a marker element with modern styling
 */
export const createMarkerElement = (userType: string, hasPrivateAlbum: boolean): HTMLDivElement => {
  const element = document.createElement('div');
  element.className = 'custom-marker map-only-marker floating-marker modern-border modern-glow';
  
  const baseSize = getMarkerSize(userType);
  element.style.width = baseSize;
  element.style.height = baseSize;
  element.style.borderRadius = '50%';
  element.style.overflow = 'hidden';
  element.style.cursor = 'pointer';
  element.style.backgroundColor = 'rgba(16, 24, 40, 0.85)';
  element.style.backdropFilter = 'blur(8px)';
  // Fix for TypeScript error - use standard property
  element.style.backdropFilter = 'blur(8px)';
  element.style.position = 'relative';
  element.style.transition = 'transform 0.2s ease, box-shadow 0.2s ease';
  
  // Apply border styles
  const borderStyles = getMarkerBorderStyles(userType, hasPrivateAlbum);
  element.style.border = borderStyles.border;
  element.style.boxShadow = borderStyles.boxShadow;
  
  // Add scan effect
  const scanEffect = document.createElement('div');
  scanEffect.className = 'scan-effect';
  element.appendChild(scanEffect);
  
  // Add hover effect
  element.onmouseenter = () => {
    element.style.transform = 'scale(1.05)';
    element.style.boxShadow = borderStyles.boxShadow.replace('10px', '15px');
  };
  
  element.onmouseleave = () => {
    element.style.transform = 'scale(1)';
    element.style.boxShadow = borderStyles.boxShadow;
  };
  
  return element;
};
