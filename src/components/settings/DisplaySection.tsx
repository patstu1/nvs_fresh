
import React from 'react';
import { ChevronRight } from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import { Switch } from '@/components/ui/switch';

interface DisplaySectionProps {
  keepPhoneAwake: boolean;
  setKeepPhoneAwake: (value: boolean) => void;
}

const DisplaySection = ({ keepPhoneAwake, setKeepPhoneAwake }: DisplaySectionProps) => {
  const navigate = useNavigate();

  return (
    <div className="mb-6">
      <h2 className="text-sm font-semibold text-[#AAFF50] mb-2">DISPLAY PREFERENCES</h2>
      
      <div className="bg-[#121212] rounded-md overflow-hidden">
        <div className="flex items-center justify-between p-4 border-b border-white/10">
          <span>Keep Phone Awake</span>
          <Switch 
            checked={keepPhoneAwake}
            onCheckedChange={setKeepPhoneAwake}
            className="data-[state=checked]:bg-[#AAFF50]"
          />
        </div>
        
        <button 
          onClick={() => navigate('/privacy-settings')}
          className="w-full flex items-center justify-between p-4"
        >
          <span>Go Incognito</span>
          <ChevronRight className="w-5 h-5 text-gray-500" />
        </button>
      </div>
    </div>
  );
};

export default DisplaySection;
