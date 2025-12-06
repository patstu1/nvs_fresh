
import { User } from '../../types/markerTypes';
import { createMarkerElement } from '../../utils/markerStyles';
import { createGradientOverlay } from './GradientOverlay';
import { createMarkerImage } from './MarkerImage';
import { createNewUserBadge } from './NewUserBadge';
import { createOnlineIndicator } from './OnlineIndicator';

/**
 * Creates the complete DOM element for a user marker
 */
export const createUserMarkerElement = (user: User): HTMLDivElement => {
  const userType = user.isNew ? 'new' : 'regular';
  const hasPrivateAlbum = user.hasPrivateAlbum || false;
  
  try {
    // Create base marker element
    const el = createMarkerElement(userType, hasPrivateAlbum);
    
    // Create inner content container
    const innerContent = document.createElement('div');
    innerContent.style.position = 'absolute';
    innerContent.style.top = '0';
    innerContent.style.left = '0';
    innerContent.style.width = '100%';
    innerContent.style.height = '100%';
    innerContent.style.borderRadius = '50%';
    innerContent.style.overflow = 'hidden';
    innerContent.style.display = 'flex';
    innerContent.style.alignItems = 'center';
    innerContent.style.justifyContent = 'center';
    innerContent.style.zIndex = '3';
    
    // Add gradient overlay for depth effect
    el.appendChild(createGradientOverlay());
    
    // Add user profile image or placeholder
    if (user.profileImage) {
      const imgContainer = createMarkerImage(user.profileImage);
      innerContent.appendChild(imgContainer);
    } else {
      // Placeholder for users without profile image
      innerContent.style.backgroundColor = '#121212';
      const placeholder = document.createElement('div');
      placeholder.textContent = user.name.charAt(0).toUpperCase();
      placeholder.style.color = '#00EEFF';
      placeholder.style.fontSize = '24px';
      placeholder.style.fontWeight = '600';
      placeholder.style.opacity = '0.8';
      placeholder.style.textShadow = '0 0 10px #00EEFF';
      innerContent.appendChild(placeholder);
    }
    
    // Add online status indicator if user is online
    const isOnline = user.isOnline || false;
    if (isOnline) {
      const statusIndicator = createOnlineIndicator();
      el.appendChild(statusIndicator);
    }
    
    // Add "new" badge for new users
    if (userType === 'new') {
      const newBadge = createNewUserBadge();
      el.appendChild(newBadge);
    }
    
    el.appendChild(innerContent);
    
    // Add entrance animation
    el.animate(
      [
        { opacity: 0, transform: 'translateY(20px) scale(0.8)' },
        { opacity: 1, transform: 'translateY(0) scale(1)' }
      ],
      {
        duration: 600,
        easing: 'cubic-bezier(0.34, 1.56, 0.64, 1)',
        fill: 'forwards'
      }
    );
    
    return el;
  } catch (error) {
    console.error("Error creating user marker element:", error);
    // Return a fallback element if there's an error
    const fallbackEl = document.createElement('div');
    fallbackEl.style.width = '40px';
    fallbackEl.style.height = '40px';
    fallbackEl.style.borderRadius = '50%';
    fallbackEl.style.backgroundColor = '#FF3366';
    return fallbackEl;
  }
};
