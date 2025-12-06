
/**
 * Utility functions for styling venue markers with modern aesthetics
 */
import { Venue } from '../types/markerTypes';

/**
 * Creates base styles for venue marker container
 */
export const createVenueMarkerElement = (): HTMLDivElement => {
  const el = document.createElement('div');
  el.className = 'venue-marker map-only-marker';
  el.style.width = '54px';
  el.style.height = '54px';
  el.style.backgroundColor = 'rgba(26, 26, 46, 0.85)';
  el.style.borderRadius = '14px';
  el.style.border = '2px solid #F97316';
  el.style.boxShadow = '0 0 20px #F97316, 0 0 35px rgba(249, 115, 22, 0.5)';
  el.style.backdropFilter = 'blur(10px)';
  el.style.cursor = 'pointer';
  el.style.overflow = 'hidden';
  el.style.display = 'flex';
  el.style.alignItems = 'center';
  el.style.justifyContent = 'center';
  el.style.transition = 'transform 0.2s ease, box-shadow 0.2s ease';
  el.style.position = 'relative';
  
  // Add entrance animation
  el.animate(
    [
      { opacity: 0, transform: 'translateY(15px) scale(0.8)' },
      { opacity: 1, transform: 'translateY(0) scale(1)' }
    ],
    {
      duration: 400,
      easing: 'cubic-bezier(0.34, 1.56, 0.64, 1)',
      fill: 'forwards'
    }
  );
  
  return el;
};

/**
 * Add hover effects to venue marker
 */
export const addVenueMarkerHoverEffects = (el: HTMLDivElement): void => {
  el.onmouseenter = () => {
    if (!el) return;
    el.style.transform = 'scale(1.1)';
    el.style.boxShadow = '0 0 30px #F97316, 0 0 50px rgba(249, 115, 22, 0.7)';
  };
  
  el.onmouseleave = () => {
    if (!el) return;
    el.style.transform = 'scale(1)';
    el.style.boxShadow = '0 0 20px #F97316, 0 0 35px rgba(249, 115, 22, 0.5)';
  };
};

/**
 * Create grid overlay for venue marker
 */
export const createHexGrid = (): HTMLDivElement => {
  const hexGrid = document.createElement('div');
  hexGrid.style.position = 'absolute';
  hexGrid.style.top = '0';
  hexGrid.style.left = '0';
  hexGrid.style.width = '100%';
  hexGrid.style.height = '100%';
  hexGrid.style.opacity = '0.4';
  hexGrid.style.backgroundImage = 'url("data:image/svg+xml,%3Csvg width=\'30\' height=\'30\' viewBox=\'0 0 30 30\' xmlns=\'http://www.w3.org/2000/svg\'%3E%3Cpath d=\'M0 15 V7.5 L7.5 0 L15 7.5 L7.5 15z\' fill=\'none\' stroke=\'%23F97316\' stroke-width=\'1\'/%3E%3Cpath d=\'M15 15 V7.5 L22.5 0 L30 7.5 L22.5 15z\' fill=\'none\' stroke=\'%23F97316\' stroke-width=\'1\'/%3E%3Cpath d=\'M0 30 V22.5 L7.5 15 L15 22.5 L7.5 30z\' fill=\'none\' stroke=\'%23F97316\' stroke-width=\'1\'/%3E%3Cpath d=\'M15 30 V22.5 L22.5 15 L30 22.5 L22.5 30z\' fill=\'none\' stroke=\'%23F97316\' stroke-width=\'1\'/%3E%3C/svg%3E")';
  
  return hexGrid;
};

/**
 * Create scan line effect
 */
export const createScanLine = (): HTMLDivElement => {
  const scanLine = document.createElement('div');
  scanLine.style.position = 'absolute';
  scanLine.style.top = '0';
  scanLine.style.left = '-100%';
  scanLine.style.width = '200%';
  scanLine.style.height = '100%';
  scanLine.style.background = 'linear-gradient(90deg, transparent, rgba(249, 115, 22, 0.3), transparent)';
  scanLine.style.animation = 'cyber-scan 3s linear infinite';
  
  return scanLine;
};

/**
 * Create gradient overlay
 */
export const createHologramEffect = (): HTMLDivElement => {
  const hologramEffect = document.createElement('div');
  hologramEffect.style.position = 'absolute';
  hologramEffect.style.top = '0';
  hologramEffect.style.left = '0';
  hologramEffect.style.width = '100%';
  hologramEffect.style.height = '100%';
  hologramEffect.style.background = 'linear-gradient(135deg, rgba(249, 115, 22, 0) 0%, rgba(249, 115, 22, 0.1) 50%, rgba(249, 115, 22, 0) 100%)';
  hologramEffect.style.borderRadius = '14px';
  hologramEffect.style.zIndex = '1';
  
  return hologramEffect;
};

/**
 * Create icon container with glow effect
 */
export const createIconContainer = (): HTMLDivElement => {
  const iconContainer = document.createElement('div');
  iconContainer.style.position = 'relative';
  iconContainer.style.zIndex = '2';
  iconContainer.style.fontSize = '22px';
  iconContainer.style.textShadow = '0 0 10px #F97316, 0 0 15px #F97316';
  
  return iconContainer;
};

/**
 * Create glowing background for icon
 */
export const createIconGlow = (): HTMLDivElement => {
  const iconGlow = document.createElement('div');
  iconGlow.style.position = 'absolute';
  iconGlow.style.top = '50%';
  iconGlow.style.left = '50%';
  iconGlow.style.transform = 'translate(-50%, -50%)';
  iconGlow.style.width = '34px';
  iconGlow.style.height = '34px';
  iconGlow.style.borderRadius = '50%';
  iconGlow.style.background = 'radial-gradient(circle, rgba(249, 115, 22, 0.7) 0%, rgba(249, 115, 22, 0.2) 60%, transparent 70%)';
  iconGlow.style.filter = 'blur(4px)';
  
  return iconGlow;
};

/**
 * Create user count badge
 */
export const createUserCountBadge = (userCount: number): HTMLDivElement => {
  const badge = document.createElement('div');
  badge.style.position = 'absolute';
  badge.style.bottom = '-5px';
  badge.style.right = '-5px';
  badge.style.backgroundColor = '#FF3B5C';
  badge.style.color = 'white';
  badge.style.fontSize = '11px';
  badge.style.fontWeight = 'bold';
  badge.style.padding = '2px 5px';
  badge.style.borderRadius = '10px';
  badge.style.boxShadow = '0 0 10px #FF3B5C, 0 0 15px rgba(255, 59, 92, 0.7)';
  badge.style.border = '1px solid rgba(255, 255, 255, 0.3)';
  badge.style.textShadow = '0 0 2px rgba(0, 0, 0, 0.5)';
  badge.textContent = userCount.toString();
  
  return badge;
};

/**
 * Get appropriate icon for venue type
 */
export const getVenueTypeIcon = (type: string): string => {
  switch(type) {
    case 'club': return '🪩';
    case 'bar': return '🥂';
    case 'cruise': return '👁️';
    case 'gym': return '💪';
    default: return '📍';
  }
};
