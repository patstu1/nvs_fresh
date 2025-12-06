
/**
 * Creates the image container and image element for user markers
 */
export const createMarkerImage = (imageSrc: string): HTMLDivElement => {
  const imgContainer = document.createElement('div');
  imgContainer.style.width = '100%';
  imgContainer.style.height = '100%';
  imgContainer.style.borderRadius = '50%';
  imgContainer.style.overflow = 'hidden';
  imgContainer.style.position = 'relative';
  
  const img = document.createElement('img');
  img.src = imageSrc;
  img.style.width = '100%';
  img.style.height = '100%';
  img.style.objectFit = 'cover';
  img.style.transition = 'transform 0.3s ease';
  
  // Error handling for image
  img.onerror = () => {
    img.src = '/placeholder.svg';
  };
  
  imgContainer.appendChild(img);
  return imgContainer;
};
