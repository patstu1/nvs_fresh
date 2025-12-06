
import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { ChevronLeft, ChevronRight } from 'lucide-react';
import { Switch } from '@/components/ui/switch';
import { toast } from '@/hooks/use-toast';
import { useAuth } from '@/hooks/useAuth';

const PrivacySettings = () => {
  const navigate = useNavigate();
  const { user } = useAuth();
  
  // Privacy settings states
  const [discreetAppIcon, setDiscreetAppIcon] = useState(false);
  const [appPin, setAppPin] = useState(false);
  const [incognitoMode, setIncognitoMode] = useState(false);
  const [unitSystem, setUnitSystem] = useState<'imperial' | 'metric'>('imperial');
  
  const blockedUsers = 0;
  const hiddenUsers = 0;
  
  const handleIncognitoChange = (checked: boolean) => {
    setIncognitoMode(checked);
    toast({
      title: checked ? "Incognito Mode On" : "Incognito Mode Off",
      description: checked 
        ? "Your profile is now hidden from the grid" 
        : "Your profile is now visible on the grid"
    });
  };
  
  const handleUnitSystemChange = (system: 'imperial' | 'metric') => {
    setUnitSystem(system);
    toast({
      title: "Unit System Changed",
      description: `Units now displayed in ${system} system`
    });
  };

  return (
    <div className="min-h-screen bg-black text-white pb-20">
      {/* Header */}
      <div className="fixed top-0 left-0 right-0 z-50 bg-black border-b border-white/10 flex items-center px-4 h-16"
           style={{ paddingTop: 'env(safe-area-inset-top)' }}>
        <button 
          onClick={() => navigate(-1)}
          className="p-2 rounded-full active:bg-white/10"
        >
          <ChevronLeft className="w-5 h-5" />
        </button>
        <h1 className="text-xl font-semibold ml-2 flex-1 text-center">Privacy Settings</h1>
        <div className="w-9"></div>
      </div>
      
      <div className="pt-20 px-4">
        <p className="text-sm text-gray-400 mb-6">
          Control your privacy and customize your experience.
        </p>
        
        {/* App Security */}
        <div className="bg-[#121212] rounded-md overflow-hidden mb-6">
          <button 
            onClick={() => navigate('/discreet-app-icon')}
            className="w-full flex items-center justify-between p-4 border-b border-white/10"
          >
            <span>Discreet App Icon</span>
            <ChevronRight className="w-5 h-5 text-gray-500" />
          </button>
          
          <button 
            onClick={() => navigate('/app-pin')}
            className="w-full flex items-center justify-between p-4 border-b border-white/10"
          >
            <span>PIN</span>
            <ChevronRight className="w-5 h-5 text-gray-500" />
          </button>
          
          <button 
            onClick={() => navigate('/blocked-users')}
            className="w-full flex items-center justify-between p-4 border-b border-white/10"
          >
            <span>Unblock Users</span>
            <div className="flex items-center">
              {blockedUsers > 0 && (
                <span className="text-gray-400 mr-2">{blockedUsers}</span>
              )}
              <ChevronRight className="w-5 h-5 text-gray-500" />
            </div>
          </button>
          
          <button 
            onClick={() => navigate('/hidden-users')}
            className="w-full flex items-center justify-between p-4 border-b border-white/10"
          >
            <span>Unhide Users</span>
            <div className="flex items-center">
              {hiddenUsers > 0 && (
                <span className="text-gray-400 mr-2">{hiddenUsers}</span>
              )}
              <ChevronRight className="w-5 h-5 text-gray-500" />
            </div>
          </button>
          
          <button 
            onClick={() => navigate('/consent-preferences')}
            className="w-full flex items-center justify-between p-4 border-b border-white/10"
          >
            <span>Consent Preference Center</span>
            <ChevronRight className="w-5 h-5 text-gray-500" />
          </button>
          
          <button 
            onClick={() => navigate('/download-data')}
            className="w-full flex items-center justify-between p-4"
          >
            <span>Download My Data</span>
            <ChevronRight className="w-5 h-5 text-gray-500" />
          </button>
        </div>
        
        <h2 className="font-semibold text-sm text-gray-200 uppercase mb-3">DISPLAY PREFERENCES</h2>
        
        <div className="bg-[#121212] rounded-md overflow-hidden mb-6">
          <div className="p-4 border-b border-white/10">
            <div className="flex items-center justify-between mb-2">
              <span>Go Incognito</span>
              <Switch 
                checked={incognitoMode}
                onCheckedChange={handleIncognitoChange}
                className="data-[state=checked]:bg-[#AAFF50]"
              />
            </div>
            <p className="text-xs text-gray-400">
              Your profile will be hidden from the grid but you can still browse, message, and tap. 
              You will appear as offline to recipients and to anyone who has saved you as a favorite.
            </p>
          </div>
          
          <div className="p-4">
            <span className="block mb-3">Unit System</span>
            <div className="flex gap-3">
              <button 
                onClick={() => handleUnitSystemChange('imperial')}
                className={`flex-1 py-2 rounded-md ${
                  unitSystem === 'imperial' ? 'bg-[#AAFF50] text-black' : 'bg-[#222] text-white'
                }`}
              >
                Imperial (U.S.)
              </button>
              <button 
                onClick={() => handleUnitSystemChange('metric')}
                className={`flex-1 py-2 rounded-md ${
                  unitSystem === 'metric' ? 'bg-[#AAFF50] text-black' : 'bg-[#222] text-white'
                }`}
              >
                Metric
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default PrivacySettings;
