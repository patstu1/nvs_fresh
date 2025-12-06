
/**
 * Creates a gradient overlay for depth effect
 */
export const createGradientOverlay = (): HTMLDivElement => {
  const overlay = document.createElement('div');
  overlay.style.position = 'absolute';
  overlay.style.inset = '0';
  overlay.style.background = 'radial-gradient(circle at center, rgba(255,255,255,0.15) 0%, rgba(0,0,0,0.2) 100%)';
  overlay.style.pointerEvents = 'none';
  
  return overlay;
};
