
import React, { useState } from 'react';
import ConnectLocationControls from '../ConnectLocationControls';
import { toast } from '@/hooks/use-toast';
import soundManager from '@/utils/soundManager';
import { motion } from 'framer-motion';

const ConnectLocationWrapper = () => {
  const [isLocationMatchingEnabled, setIsLocationMatchingEnabled] = useState(true);
  const [currentCity, setCurrentCity] = useState({ name: 'Your Location', country: '' });

  const handleCitySelect = (city: { name: string; country: string }) => {
    setCurrentCity(city);
    setIsLocationMatchingEnabled(false);
    try {
      soundManager.play('notification', 0.5);
    } catch (error) {
      console.error('Error playing sound:', error);
    }
    toast({
      title: "Virtual Location Changed",
      description: `You're now connecting in ${city.name}, ${city.country}`,
    });
  };
  
  const handleLocationMatchingToggle = (enabled: boolean) => {
    setIsLocationMatchingEnabled(enabled);
    if (enabled && currentCity.name !== 'Your Location') {
      setCurrentCity({ name: 'Your Location', country: '' });
      toast({
        title: "Location Matching Enabled",
        description: "You're now connecting in your current location",
      });
    }
  };

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay: 0.1 }}
      className="w-full"
    >
      <ConnectLocationControls
        isLocationMatchingEnabled={isLocationMatchingEnabled}
        currentCity={currentCity}
        onLocationMatchingToggle={handleLocationMatchingToggle}
        onCitySelect={handleCitySelect}
      />
    </motion.div>
  );
};

export default ConnectLocationWrapper;
