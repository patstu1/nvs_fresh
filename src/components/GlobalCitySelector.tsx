
import React, { useState } from 'react';
import { Dialog, DialogContent, DialogHeader, DialogTitle } from '@/components/ui/dialog';
import { Button } from '@/components/ui/button';
import { Globe, Search, MapPin, Users } from 'lucide-react';
import { toast } from '@/hooks/use-toast';
import ZoomRoomButton from './ZoomRoomButton';

interface City {
  id: string;
  name: string;
  country: string;
  onlineCount: number;
}

// Sample cities data - in a real app, this would come from an API
const popularCities: City[] = [
  { id: '1', name: 'New York', country: 'USA', onlineCount: 243 },
  { id: '2', name: 'London', country: 'UK', onlineCount: 187 },
  { id: '3', name: 'Tokyo', country: 'Japan', onlineCount: 156 },
  { id: '4', name: 'Paris', country: 'France', onlineCount: 132 },
  { id: '5', name: 'Berlin', country: 'Germany', onlineCount: 98 },
  { id: '6', name: 'Sydney', country: 'Australia', onlineCount: 89 },
  { id: '7', name: 'Rio de Janeiro', country: 'Brazil', onlineCount: 76 },
  { id: '8', name: 'Cape Town', country: 'South Africa', onlineCount: 41 },
  { id: '9', name: 'Mumbai', country: 'India', onlineCount: 129 },
  { id: '10', name: 'Toronto', country: 'Canada', onlineCount: 95 },
];

interface GlobalCitySelectorProps {
  onCitySelect: (city: City) => void;
}

const GlobalCitySelector: React.FC<GlobalCitySelectorProps> = ({ onCitySelect }) => {
  const [isOpen, setIsOpen] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');
  
  const filteredCities = searchQuery 
    ? popularCities.filter(city => 
        city.name.toLowerCase().includes(searchQuery.toLowerCase()) || 
        city.country.toLowerCase().includes(searchQuery.toLowerCase())
      )
    : popularCities;
    
  const handleCitySelect = (city: City) => {
    onCitySelect(city);
    setIsOpen(false);
    toast({
      title: "City Selected",
      description: `You're now virtually in ${city.name}, ${city.country} with ${city.onlineCount} users online`,
    });
  };

  return (
    <>
      <button 
        onClick={() => setIsOpen(true)}
        className="flex flex-col items-center"
      >
        <div className="w-12 h-12 rounded-full bg-[#2A2A2A] flex items-center justify-center mb-1">
          <Globe className="w-6 h-6 text-[#C2FFE6]" />
        </div>
        <span className="text-xs text-gray-300">Global</span>
      </button>
      
      <Dialog open={isOpen} onOpenChange={setIsOpen}>
        <DialogContent className="bg-[#121212] text-white border border-[#333] max-w-md w-full">
          <DialogHeader>
            <DialogTitle className="text-xl text-[#E6FFF4]">Explore Global Cities</DialogTitle>
          </DialogHeader>
          
          <div className="relative mb-4">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-4 w-4" />
            <input
              type="text"
              placeholder="Search cities..."
              className="w-full bg-[#1A1A1A] border border-[#333] rounded-md pl-10 pr-4 py-2 text-white focus:outline-none focus:ring-1 focus:ring-[#C2FFE6]"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
            />
          </div>
          
          <div className="grid grid-cols-1 gap-2 max-h-[60vh] overflow-y-auto">
            {filteredCities.map((city) => (
              <div
                key={city.id}
                className="flex items-center justify-between p-3 bg-[#1A1A1A] rounded-md hover:bg-[#252525] transition-colors"
              >
                <button
                  className="flex items-center text-left flex-1"
                  onClick={() => handleCitySelect(city)}
                >
                  <MapPin className="w-4 h-4 text-[#C2FFE6] mr-2" />
                  <div>
                    <div className="font-medium text-[#E6FFF4]">{city.name}</div>
                    <div className="text-xs text-gray-400">{city.country}</div>
                  </div>
                </button>
                
                <div className="flex items-center space-x-3">
                  <div className="text-xs bg-[#C2FFE6] text-black px-2 py-1 rounded-full">
                    {city.onlineCount} online
                  </div>
                  
                  <ZoomRoomButton 
                    cityName={`${city.name}, ${city.country}`}
                    userCount={city.onlineCount}
                  />
                </div>
              </div>
            ))}
          </div>
        </DialogContent>
      </Dialog>
    </>
  );
};

export default GlobalCitySelector;
