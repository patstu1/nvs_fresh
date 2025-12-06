
/**
 * Creates the venue marker animation style element if it doesn't exist
 */
export const createMarkerAnimations = (): void => {
  // Check if style already exists to prevent duplicates
  if (!document.getElementById('venue-marker-animations')) {
    const style = document.createElement('style');
    style.id = 'venue-marker-animations';
    style.innerHTML = `
      @keyframes float {
        0% { transform: translateY(0px); }
        50% { transform: translateY(-5px); }
        100% { transform: translateY(0px); }
      }
      
      @keyframes cyber-scan {
        0% { transform: translateX(-100%); }
        100% { transform: translateX(100%); }
      }
      
      @keyframes electric-shadow {
        0% { filter: drop-shadow(0 0 5px #F97316); }
        50% { filter: drop-shadow(0 0 15px #F97316); }
        100% { filter: drop-shadow(0 0 5px #F97316); }
      }
      
      @keyframes data-pulse {
        0% { transform: scale(1); }
        50% { transform: scale(1.1); }
        100% { transform: scale(1); }
      }
    `;
    document.head.appendChild(style);
  }
};
