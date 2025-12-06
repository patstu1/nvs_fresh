
import React from 'react';
import { ChevronRight } from 'lucide-react';
import { useNavigate } from 'react-router-dom';

const AboutSection = () => {
  const navigate = useNavigate();
  
  const navigateTo = (path: string) => {
    navigate(path);
  };

  return (
    <div className="mb-6">
      <h2 className="text-sm font-semibold text-[#AAFF50] mb-2">ABOUT</h2>
      
      <div className="bg-[#121212] rounded-md overflow-hidden">
        <button 
          onClick={() => navigateTo('/feature-requests')}
          className="w-full flex items-center justify-between p-4 border-b border-white/10"
        >
          <span>Feature Requests</span>
          <ChevronRight className="w-5 h-5 text-gray-500" />
        </button>
        
        <button 
          onClick={() => navigateTo('/help')}
          className="w-full flex items-center justify-between p-4 border-b border-white/10"
        >
          <span>Help</span>
          <ChevronRight className="w-5 h-5 text-gray-500" />
        </button>
        
        <button 
          onClick={() => navigateTo('/contact')}
          className="w-full flex items-center justify-between p-4 border-b border-white/10"
        >
          <span>Contact</span>
          <ChevronRight className="w-5 h-5 text-gray-500" />
        </button>
        
        <button 
          onClick={() => navigateTo('/community-guidelines')}
          className="w-full flex items-center justify-between p-4 border-b border-white/10"
        >
          <span>Community Guidelines</span>
          <ChevronRight className="w-5 h-5 text-gray-500" />
        </button>
        
        <button 
          onClick={() => navigateTo('/careers')}
          className="w-full flex items-center justify-between p-4 border-b border-white/10"
        >
          <span>Careers</span>
          <ChevronRight className="w-5 h-5 text-gray-500" />
        </button>
        
        <button 
          onClick={() => navigateTo('/terms-of-service')}
          className="w-full flex items-center justify-between p-4 border-b border-white/10"
        >
          <span>Terms of Service</span>
          <ChevronRight className="w-5 h-5 text-gray-500" />
        </button>
        
        <button 
          onClick={() => navigateTo('/privacy-policy')}
          className="w-full flex items-center justify-between p-4"
        >
          <span>Privacy Policy</span>
          <ChevronRight className="w-5 h-5 text-gray-500" />
        </button>
      </div>
    </div>
  );
};

export default AboutSection;
