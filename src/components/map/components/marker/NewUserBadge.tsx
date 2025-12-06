
/**
 * Creates a "NEW" badge element for new users
 */
export const createNewUserBadge = (): HTMLDivElement => {
  const newBadge = document.createElement('div');
  newBadge.className = 'map-only-marker';
  newBadge.style.position = 'absolute';
  newBadge.style.top = '0px';
  newBadge.style.right = '0px';
  newBadge.style.backgroundColor = '#3B82F6';
  newBadge.style.color = 'white';
  newBadge.style.fontSize = '9px';
  newBadge.style.fontWeight = 'bold';
  newBadge.style.padding = '3px 6px';
  newBadge.style.borderRadius = '8px';
  newBadge.style.boxShadow = '0 2px 5px rgba(59, 130, 246, 0.5)';
  newBadge.textContent = 'NEW';
  
  return newBadge;
};
