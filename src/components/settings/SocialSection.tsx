
import React from 'react';
import { Instagram, Facebook, AtSign, Youtube, Linkedin } from 'lucide-react';

const SocialSection = () => {
  return (
    <div className="mb-6">
      <h2 className="text-sm font-semibold text-[#AAFF50] mb-2">FOLLOW US</h2>
      
      <div className="bg-[#121212] rounded-md overflow-hidden">
        <button className="w-full flex items-center p-4 border-b border-white/10">
          <Instagram className="w-5 h-5 mr-3" />
          <span>Instagram</span>
        </button>
        
        <button className="w-full flex items-center p-4 border-b border-white/10">
          <Facebook className="w-5 h-5 mr-3" />
          <span>Facebook</span>
        </button>
        
        <button className="w-full flex items-center p-4 border-b border-white/10">
          <AtSign className="w-5 h-5 mr-3" />
          <span>X</span>
        </button>
        
        <button className="w-full flex items-center p-4 border-b border-white/10">
          <Youtube className="w-5 h-5 mr-3" />
          <span>Youtube</span>
        </button>
        
        <button className="w-full flex items-center p-4">
          <Linkedin className="w-5 h-5 mr-3" />
          <span>LinkedIn</span>
        </button>
      </div>
    </div>
  );
};

export default SocialSection;
