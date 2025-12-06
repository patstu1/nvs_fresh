
import React from 'react';

const ScanLineEffect = () => {
  return (
    <div className="absolute inset-x-0 h-[2px] z-20" style={{
      background: 'linear-gradient(90deg, transparent, rgba(0, 255, 196, 0.2), rgba(0, 255, 196, 0.8), rgba(0, 255, 196, 0.2), transparent)',
      animation: 'holographic-scan 3s linear infinite',
      boxShadow: '0 0 15px rgba(0, 255, 196, 0.5)'
    }} />
  );
};

export default ScanLineEffect;
