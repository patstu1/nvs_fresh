import React from 'react';

interface YoBroLogoProps extends React.SVGProps<SVGSVGElement> {
  size?: 'small' | 'medium' | 'large';
}

const YoBroLogo: React.FC<YoBroLogoProps> = ({ size = 'medium', ...props }) => {
  // Set dimensions based on size
  const getSizeDimensions = () => {
    switch(size) {
      case 'small':
        return { width: 24, height: 24 };
      case 'large':
        return { width: 64, height: 64 };
      case 'medium':
      default:
        return { width: 48, height: 48 };
    }
  };
  
  const lightMint = "#8AFF56";  // Light neon mint
  const darkMint = "#1EAEDB";   // Dark mint from color palette
  const lightGreen = "#8AFF56"; // Light green from the reference image
  const darkGreen = "#40E0D0";  // Darker green from the reference image

  const { width, height } = props.width && props.height 
    ? { width: props.width, height: props.height } 
    : getSizeDimensions();

  return (
    <svg 
      xmlns="http://www.w3.org/2000/svg" 
      viewBox="0 0 24 24" 
      fill="none" 
      width={width}
      height={height}
      {...props}
      className={`${props.className || ''}`}
    >
      <defs>
        <linearGradient id="waistbandGradient" x1="0%" y1="0%" x2="100%" y2="0%">
          <stop offset="0%" stopColor={lightMint} />
          <stop offset="100%" stopColor={darkMint} />
        </linearGradient>
      </defs>

      <rect 
        x="2" 
        y="7" 
        width="20" 
        height="3" 
        rx="1" 
        fill="url(#waistbandGradient)"
      />
      
      <path 
        d="M4 8.5C4 8.5 3.5 10 6 12C8 13.5 10 15 12 16" 
        stroke="#40E0D0" 
        strokeWidth="1.2" 
        fill="none" 
      />
      
      <path 
        d="M20 8.5C20 8.5 20.5 10 18 12C16 13.5 14 15 12 16" 
        stroke="#40E0D0" 
        strokeWidth="1.2" 
        fill="none" 
      />
      
      <path 
        d="M9 9C9 9 9 14.5 9 17.5C9 17.5 10 20 12 20C14 20 15 17.5 15 17.5C15 14.5 15 9 15 9H9Z" 
        fill={lightGreen}
      />
      <path 
        d="M12 9C12 13 12 15 12 20C14 20 15 17.5 15 17.5C15 14.5 15 9 15 9H12Z" 
        fill={darkGreen} 
      />
      
      <path 
        d="M9 9C9 9 9 14.5 9 17.5C9 17.5 10 20 12 20C14 20 15 17.5 15 17.5C15 14.5 15 9 15 9" 
        stroke="#40E0D0" 
        strokeWidth="0.5" 
        fill="none"
      />
      
      <path 
        d="M12 9C12 10.5 12 15 12 20" 
        stroke="#40E0D0" 
        strokeWidth="0.5"
      />
    </svg>
  );
};

export default YoBroLogo;
