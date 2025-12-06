import React, { useState } from 'react';
import { usePreferencesForm } from './preferences/hooks/usePreferencesForm';
import ValuesTabContent from './preferences/ValuesTabContent';
import { ConnectUserProfile } from './preferences/ConnectPreferencesTypes';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Button } from '@/components/ui/button';
import { ArrowLeft, ArrowRight, Check } from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import { toast } from '@/hooks/use-toast';
import { motion } from 'framer-motion';
import BasicTabContent from './preferences/BasicTabContent';
import SocialTabContent from './preferences/SocialTabContent';
import LifestyleTabContent from './preferences/LifestyleTabContent';
import SocialMediaTabContent from './preferences/SocialMediaTabContent';

interface ConnectPreferencesProps {
  onComplete?: () => void;
}

const ConnectPreferences: React.FC<ConnectPreferencesProps> = ({ onComplete }) => {
  const { 
    formData, 
    handleSelectOption, 
    handleToggleArrayOption,
    handleSocialMediaChange 
  } = usePreferencesForm();
  
  const navigate = useNavigate();
  const [activeTab, setActiveTab] = useState('basic');
  
  const handleTabChange = (value: string) => {
    setActiveTab(value);
  };
  
  const handleNext = () => {
    const tabOrder = ['basic', 'social', 'lifestyle', 'values', 'social-media'];
    const currentIndex = tabOrder.indexOf(activeTab);
    if (currentIndex < tabOrder.length - 1) {
      setActiveTab(tabOrder[currentIndex + 1]);
    } else {
      handleSavePreferences();
    }
  };
  
  const handleBack = () => {
    const tabOrder = ['basic', 'social', 'lifestyle', 'values', 'social-media'];
    const currentIndex = tabOrder.indexOf(activeTab);
    if (currentIndex > 0) {
      setActiveTab(tabOrder[currentIndex - 1]);
    }
  };
  
  const handleSavePreferences = () => {
    // Save preferences to localStorage
    localStorage.setItem('connect-user-profile', JSON.stringify({
      ...formData,
      profileSetupComplete: true
    }));
    
    toast({
      title: "Preferences Saved",
      description: "Your preferences have been updated successfully.",
    });
    
    if (onComplete) {
      onComplete();
    } else {
      navigate('/connect');
    }
  };
  
  const isOptionSelected = <T extends string>(field: keyof ConnectUserProfile, value: T): boolean => {
    const fieldValue = formData[field];
    if (Array.isArray(fieldValue)) {
      return (fieldValue as readonly string[]).includes(value);
    }
    return fieldValue === value;
  };

  return (
    <div className="p-4 max-w-md mx-auto">
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5 }}
      >
        <h1 className="text-2xl font-bold mb-6 text-center text-[#00FFCC]">Your Preferences</h1>
        
        <Tabs value={activeTab} onValueChange={handleTabChange} className="w-full">
          <TabsList className="grid grid-cols-5 mb-6 bg-black border border-[#FF00FF] rounded-lg">
            <TabsTrigger 
              value="basic" 
              className="data-[state=active]:bg-[#FF00FF]/20 data-[state=active]:text-[#FF00FF] data-[state=active]:shadow-none"
            >
              Basic
            </TabsTrigger>
            <TabsTrigger 
              value="social" 
              className="data-[state=active]:bg-[#FF00FF]/20 data-[state=active]:text-[#FF00FF] data-[state=active]:shadow-none"
            >
              Social
            </TabsTrigger>
            <TabsTrigger 
              value="lifestyle" 
              className="data-[state=active]:bg-[#FF00FF]/20 data-[state=active]:text-[#FF00FF] data-[state=active]:shadow-none"
            >
              Lifestyle
            </TabsTrigger>
            <TabsTrigger 
              value="values" 
              className="data-[state=active]:bg-[#FF00FF]/20 data-[state=active]:text-[#FF00FF] data-[state=active]:shadow-none"
            >
              Values
            </TabsTrigger>
            <TabsTrigger 
              value="social-media" 
              className="data-[state=active]:bg-[#FF00FF]/20 data-[state=active]:text-[#FF00FF] data-[state=active]:shadow-none"
            >
              Links
            </TabsTrigger>
          </TabsList>
          
          <TabsContent value="basic" className="mt-0">
            <BasicTabContent 
              formData={formData}
              handleSelectOption={handleSelectOption}
              handleToggleArrayOption={handleToggleArrayOption}
              isOptionSelected={isOptionSelected}
            />
          </TabsContent>
          
          <TabsContent value="social" className="mt-0">
            <SocialTabContent 
              formData={formData}
              handleSelectOption={handleSelectOption}
              handleToggleArrayOption={handleToggleArrayOption}
              isOptionSelected={isOptionSelected}
            />
          </TabsContent>
          
          <TabsContent value="lifestyle" className="mt-0">
            <LifestyleTabContent 
              formData={formData}
              handleSelectOption={handleSelectOption}
              isOptionSelected={isOptionSelected}
            />
          </TabsContent>
          
          <TabsContent value="values" className="mt-0">
            <ValuesTabContent 
              formData={formData}
              handleSelectOption={handleSelectOption}
              handleToggleArrayOption={handleToggleArrayOption}
              isOptionSelected={isOptionSelected}
            />
          </TabsContent>
          
          <TabsContent value="social-media" className="mt-0">
            <SocialMediaTabContent 
              formData={formData}
              handleSocialMediaChange={handleSocialMediaChange}
            />
          </TabsContent>
        </Tabs>
        
        <div className="flex justify-between mt-8">
          <Button 
            variant="outline" 
            onClick={handleBack}
            disabled={activeTab === 'basic'}
            className="border-[#FF00FF] text-[#FF00FF] hover:bg-[#FF00FF]/10"
          >
            <ArrowLeft className="mr-2 h-4 w-4" /> Back
          </Button>
          
          {activeTab === 'social-media' ? (
            <Button 
              onClick={handleSavePreferences}
              className="bg-[#FF00FF] hover:bg-[#FF00FF]/80 text-white"
            >
              Save <Check className="ml-2 h-4 w-4" />
            </Button>
          ) : (
            <Button 
              onClick={handleNext}
              className="bg-[#FF00FF] hover:bg-[#FF00FF]/80 text-white"
            >
              Next <ArrowRight className="ml-2 h-4 w-4" />
            </Button>
          )}
        </div>
      </motion.div>
    </div>
  );
};

export default ConnectPreferences;
