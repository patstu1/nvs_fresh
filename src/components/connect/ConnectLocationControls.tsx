
import React, { useState, useEffect } from 'react';
import { MapPin, Globe, ChevronDown, Search, Radar, Zap } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Switch } from '@/components/ui/switch';
import { motion, AnimatePresence } from 'framer-motion';

interface ConnectLocationControlsProps {
  isLocationMatchingEnabled: boolean;
  currentCity: { name: string; country: string };
  onLocationMatchingToggle: (enabled: boolean) => void;
  onCitySelect: (city: { name: string; country: string }) => void;
}

// Enhanced sample cities with more options
const popularCities = [
  { name: 'New York', country: 'USA' },
  { name: 'Los Angeles', country: 'USA' },
  { name: 'Miami', country: 'USA' },
  { name: 'London', country: 'UK' },
  { name: 'Paris', country: 'France' },
  { name: 'Berlin', country: 'Germany' },
  { name: 'Tokyo', country: 'Japan' },
  { name: 'Sydney', country: 'Australia' },
  { name: 'Amsterdam', country: 'Netherlands' },
  { name: 'Barcelona', country: 'Spain' },
  { name: 'Bangkok', country: 'Thailand' },
  { name: 'Rio de Janeiro', country: 'Brazil' },
];

const ConnectLocationControls: React.FC<ConnectLocationControlsProps> = ({
  isLocationMatchingEnabled,
  currentCity,
  onLocationMatchingToggle,
  onCitySelect,
}) => {
  const [showCityDropdown, setShowCityDropdown] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');
  const [isAnimating, setIsAnimating] = useState(false);
  
  const filteredCities = popularCities.filter(city => 
    city.name.toLowerCase().includes(searchQuery.toLowerCase()) || 
    city.country.toLowerCase().includes(searchQuery.toLowerCase())
  );
  
  useEffect(() => {
    if (isLocationMatchingEnabled) {
      setIsAnimating(true);
      const timer = setTimeout(() => setIsAnimating(false), 2000);
      return () => clearTimeout(timer);
    }
  }, [isLocationMatchingEnabled]);

  return (
    <div className="w-full max-w-md bg-gradient-to-b from-gray-900 to-black rounded-lg p-4 mb-6 backdrop-blur-sm border border-gray-800 shadow-lg">
      <div className="flex items-center justify-between mb-4">
        <div className="flex items-center">
          {isLocationMatchingEnabled ? (
            <div className="relative">
              <Radar className={`w-5 h-5 text-[#AAFF50] ${isAnimating ? 'animate-pulse' : ''}`} />
              {isAnimating && (
                <motion.div
                  className="absolute -inset-1"
                  initial={{ scale: 0.8, opacity: 0.8 }}
                  animate={{ 
                    scale: [1, 1.5, 1],
                    opacity: [0.5, 0, 0.5]
                  }}
                  transition={{ 
                    duration: 2,
                    repeat: Infinity,
                    repeatType: "loop"
                  }}
                >
                  <Radar className="w-5 h-5 text-[#AAFF50]/50" />
                </motion.div>
              )}
            </div>
          ) : (
            <Globe className="w-5 h-5 text-[#C2FFE6]" />
          )}
          <span className="text-white font-medium ml-2 flex items-center">
            Location Matching
            {isLocationMatchingEnabled && (
              <span className="ml-2 text-xs bg-[#AAFF50]/20 text-[#AAFF50] px-1.5 py-0.5 rounded-full flex items-center">
                <Zap className="w-3 h-3 mr-0.5" />
                Active
              </span>
            )}
          </span>
        </div>
        <Switch 
          checked={isLocationMatchingEnabled}
          onCheckedChange={onLocationMatchingToggle}
          className="data-[state=checked]:bg-[#AAFF50]"
        />
      </div>
      
      <div className="relative">
        <Button
          variant="outline"
          className="w-full flex items-center justify-between bg-gray-800/80 border-gray-700 text-white hover:bg-gray-700/80"
          onClick={() => setShowCityDropdown(!showCityDropdown)}
        >
          <div className="flex items-center">
            <MapPin className={`w-4 h-4 mr-2 ${isLocationMatchingEnabled ? 'text-[#AAFF50]' : 'text-[#C2FFE6]'}`} />
            <span>{currentCity.name}{currentCity.country ? `, ${currentCity.country}` : ''}</span>
          </div>
          <ChevronDown className={`w-4 h-4 transition-transform ${showCityDropdown ? 'rotate-180' : ''}`} />
        </Button>
        
        <AnimatePresence>
          {showCityDropdown && (
            <motion.div 
              className="absolute top-full left-0 right-0 mt-2 bg-gray-800 border border-gray-700 rounded-lg shadow-lg z-10"
              initial={{ opacity: 0, y: -10 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -10 }}
              transition={{ duration: 0.2 }}
            >
              <div className="p-2">
                <div className="relative">
                  <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-4 h-4" />
                  <Input 
                    placeholder="Search cities..." 
                    className="pl-9 bg-gray-700 border-gray-600 text-white"
                    value={searchQuery}
                    onChange={(e) => setSearchQuery(e.target.value)}
                  />
                </div>
              </div>
              
              <div className="max-h-48 overflow-y-auto scrollbar-thin scrollbar-thumb-gray-600 scrollbar-track-gray-800">
                {filteredCities.length > 0 ? (
                  filteredCities.map((city, index) => (
                    <motion.div
                      key={index}
                      className="px-4 py-2 hover:bg-gray-700 cursor-pointer flex items-center"
                      onClick={() => {
                        onCitySelect(city);
                        setShowCityDropdown(false);
                        setSearchQuery('');
                      }}
                      initial={{ opacity: 0, y: -5 }}
                      animate={{ opacity: 1, y: 0 }}
                      transition={{ delay: index * 0.03 }}
                      whileHover={{ backgroundColor: 'rgba(170, 255, 80, 0.1)' }}
                    >
                      <MapPin className="w-4 h-4 text-[#C2FFE6] mr-2" />
                      <span className="text-white">{city.name}, {city.country}</span>
                    </motion.div>
                  ))
                ) : (
                  <div className="px-4 py-6 text-center text-gray-400">
                    No cities found matching your search
                  </div>
                )}
              </div>
            </motion.div>
          )}
        </AnimatePresence>
      </div>
    </div>
  );
};

export default ConnectLocationControls;
