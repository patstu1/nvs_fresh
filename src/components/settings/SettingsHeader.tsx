
import React from 'react';
import { ChevronLeft } from 'lucide-react';
import { useNavigate } from 'react-router-dom';

const SettingsHeader = () => {
  const navigate = useNavigate();
  
  return (
    <div 
      className="fixed top-0 left-0 right-0 z-50 bg-black border-b border-white/10 flex items-center px-4 h-16"
      style={{ paddingTop: 'env(safe-area-inset-top)' }}
    >
      <button 
        onClick={() => navigate(-1)}
        className="p-2 rounded-full active:bg-white/10"
      >
        <ChevronLeft className="w-5 h-5" />
      </button>
      <h1 className="text-xl font-semibold ml-2 flex-1 text-center">Settings</h1>
      <div className="w-9"></div>
    </div>
  );
};

export default SettingsHeader;
