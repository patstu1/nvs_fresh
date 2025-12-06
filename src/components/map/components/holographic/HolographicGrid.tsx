
import React from 'react';

const HolographicGrid = () => {
  return (
    <div className="absolute inset-0 z-10">
      <div className="w-full h-full" style={{
        backgroundImage: 'linear-gradient(0deg, rgba(0, 255, 196, 0.05) 1px, transparent 1px), linear-gradient(90deg, rgba(0, 255, 196, 0.05) 1px, transparent 1px)',
        backgroundSize: '20px 20px',
        animation: 'holographic-pulse 4s ease-in-out infinite'
      }} />
    </div>
  );
};

export default HolographicGrid;
