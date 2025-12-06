
import React from 'react';

const GlowEffect = () => {
  return (
    <div className="absolute inset-0 z-30 pointer-events-none">
      <div className="w-full h-full" style={{
        boxShadow: 'inset 0 0 50px rgba(0, 255, 196, 0.3)',
        animation: 'holographic-glow 4s ease-in-out infinite'
      }} />
    </div>
  );
};

export default GlowEffect;
