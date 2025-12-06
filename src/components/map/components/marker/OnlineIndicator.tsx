
/**
 * Creates an online status indicator element
 */
export const createOnlineIndicator = (): HTMLDivElement => {
  const statusIndicator = document.createElement('div');
  statusIndicator.className = 'map-only-marker';
  statusIndicator.style.position = 'absolute';
  statusIndicator.style.bottom = '2px';
  statusIndicator.style.right = '2px';
  statusIndicator.style.width = '12px';
  statusIndicator.style.height = '12px';
  statusIndicator.style.borderRadius = '50%';
  statusIndicator.style.backgroundColor = '#4ADE80';
  statusIndicator.style.border = '2px solid rgba(0,0,0,0.5)';
  statusIndicator.style.boxShadow = '0 0 8px #4ADE80';
  
  return statusIndicator;
};
