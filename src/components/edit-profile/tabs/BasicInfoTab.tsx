
import React from 'react';
import { toast } from '@/hooks/use-toast';

interface BasicInfoTabProps {
  userProfile: {
    avatar_url: string;
    username: string;
    displayName: string;
    aboutMe: string;
  };
  profileDetails: {
    displayName: string;
    aboutMe: string;
  };
  selectedTribes: string[];
  setProfileDetails: (details: any) => void;
  setSelectedTribes: (tribes: string[]) => void;
}

const BasicInfoTab: React.FC<BasicInfoTabProps> = ({
  userProfile,
  profileDetails,
  selectedTribes,
  setProfileDetails,
  setSelectedTribes,
}) => {
  const tribeOptions = ['Bear', 'Clean-Cut', 'Daddy', 'Discreet', 'Geek', 'Jock', 'Leather', 'Otter', 'Poz', 'Rugged', 'Trans', 'Twink'];
  
  const handlePhotoUpload = () => {
    toast({
      title: "Photo uploaded",
      description: "Your profile photo has been updated",
    });
  };

  return (
    <div className="p-4">
      {/* Profile Pictures */}
      <div className="grid grid-cols-3 gap-2 mb-6">
        <div className="aspect-square bg-[#222] rounded-md flex items-center justify-center overflow-hidden">
          <img 
            src={userProfile.avatar_url || "https://images.unsplash.com/photo-1581092795360-fd1ca04f0952?w=200&h=200&fit=crop"} 
            alt="Profile"
            className="w-full h-full object-cover"
          />
        </div>
        
        <div 
          className="aspect-square bg-[#222] rounded-md flex items-center justify-center cursor-pointer border-2 border-dashed border-white/20"
          onClick={handlePhotoUpload}
        >
          <span className="text-2xl text-white/40">+</span>
        </div>
        
        {Array.from({ length: 7 }).map((_, i) => (
          <div 
            key={i}
            className="aspect-square bg-[#222] rounded-md flex items-center justify-center cursor-pointer"
            onClick={handlePhotoUpload}
          >
            <span className="text-2xl text-white/40">+</span>
          </div>
        ))}
      </div>
      
      {/* Display Name */}
      <div className="mb-6">
        <label className="block text-sm font-medium mb-2">Display Name</label>
        <input
          type="text"
          value={profileDetails.displayName}
          onChange={(e) => setProfileDetails({...profileDetails, displayName: e.target.value})}
          className="w-full bg-[#222] rounded-md p-3 text-white"
          maxLength={15}
        />
        <div className="flex justify-end mt-1">
          <span className="text-xs text-gray-400">1/15</span>
        </div>
      </div>
      
      {/* About Me */}
      <div className="mb-6">
        <label className="block text-sm font-medium mb-2">About Me</label>
        <textarea
          value={profileDetails.aboutMe}
          onChange={(e) => setProfileDetails({...profileDetails, aboutMe: e.target.value})}
          className="w-full bg-[#222] rounded-md p-3 text-white h-32"
          maxLength={255}
        />
        <div className="flex justify-end mt-1">
          <span className="text-xs text-gray-400">0/255</span>
        </div>
      </div>
      
      {/* My Tags */}
      <div className="mb-6">
        <label className="block text-sm font-medium mb-2">My Tags</label>
        <input
          type="text"
          placeholder="Add keywords to get found easier"
          className="w-full bg-[#222] rounded-md p-3 text-white"
        />
      </div>
      
      {/* My Tribes */}
      <div className="mb-6">
        <div className="flex justify-between items-center mb-2">
          <label className="block text-sm font-medium">My Tribes</label>
          <span className="text-xs text-[#AAFF50]">{selectedTribes.length}/3</span>
        </div>
        <div className="flex flex-wrap gap-2">
          {tribeOptions.map((tribe) => (
            <button
              key={tribe}
              className={`px-3 py-1 rounded-full text-sm ${
                selectedTribes.includes(tribe) 
                  ? 'bg-[#AAFF50] text-black' 
                  : 'bg-[#222] text-white'
              }`}
              onClick={() => {
                if (selectedTribes.includes(tribe)) {
                  setSelectedTribes(selectedTribes.filter(t => t !== tribe));
                } else if (selectedTribes.length < 3) {
                  setSelectedTribes([...selectedTribes, tribe]);
                } else {
                  toast({
                    title: "Maximum tribes reached",
                    description: "You can only select up to 3 tribes",
                  });
                }
              }}
            >
              {tribe}
            </button>
          ))}
        </div>
      </div>
    </div>
  );
};

export default BasicInfoTab;
