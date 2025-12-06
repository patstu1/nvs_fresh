import React from 'react';
import { Switch } from '@/components/ui/switch';
import { ChevronRight } from 'lucide-react';

interface StatsTabProps {
  showAge: boolean;
  setShowAge: (show: boolean) => void;
  profileDetails: {
    age: number;
    height: string;
    weight: string;
    bodyType: string;
    position: string;
    ethnicity: string;
    relationshipStatus: string;
    lookingFor: string;
    meetAt: string;
    acceptsNSFW: boolean;
  };
  setProfileDetails: (details: any) => void;
}

const StatsTab: React.FC<StatsTabProps> = ({
  showAge,
  setShowAge,
  profileDetails,
  setProfileDetails,
}) => {
  return (
    <div className="p-4">
      <div className="bg-[#121212] rounded-md overflow-hidden mb-6">
        <div className="flex items-center justify-between p-4 border-b border-white/10">
          <span>Show Age</span>
          <Switch 
            checked={showAge}
            onCheckedChange={setShowAge}
            className="data-[state=checked]:bg-[#AAFF50]"
          />
        </div>
        
        <div className="p-4 border-b border-white/10">
          <label className="block text-sm mb-2">Age</label>
          <input
            type="number"
            value={profileDetails.age}
            onChange={(e) => setProfileDetails({...profileDetails, age: parseInt(e.target.value)})}
            className="w-full bg-[#222] rounded-md p-3 text-white"
          />
        </div>
        
        <div className="p-4 border-b border-white/10">
          <label className="block text-sm mb-2">Height</label>
          <input
            type="text"
            value={profileDetails.height}
            onChange={(e) => setProfileDetails({...profileDetails, height: e.target.value})}
            className="w-full bg-[#222] rounded-md p-3 text-white"
          />
        </div>
        
        <div className="p-4 border-b border-white/10">
          <label className="block text-sm mb-2">Weight</label>
          <input
            type="text"
            value={profileDetails.weight}
            onChange={(e) => setProfileDetails({...profileDetails, weight: e.target.value})}
            className="w-full bg-[#222] rounded-md p-3 text-white"
          />
        </div>
        
        <div className="p-4 border-b border-white/10">
          <label className="block text-sm mb-2">Body Type</label>
          <select
            value={profileDetails.bodyType}
            onChange={(e) => setProfileDetails({...profileDetails, bodyType: e.target.value})}
            className="w-full bg-[#222] rounded-md p-3 text-white"
          >
            <option value="Athletic">Athletic</option>
            <option value="Average">Average</option>
            <option value="Large">Large</option>
            <option value="Muscular">Muscular</option>
            <option value="Slim">Slim</option>
            <option value="Stocky">Stocky</option>
          </select>
        </div>
        
        <div className="p-4 border-b border-white/10">
          <label className="block text-sm mb-2">Position</label>
          <select
            value={profileDetails.position}
            onChange={(e) => setProfileDetails({...profileDetails, position: e.target.value})}
            className="w-full bg-[#222] rounded-md p-3 text-white"
          >
            <option value="Top">Top</option>
            <option value="Bottom">Bottom</option>
            <option value="Vers">Vers</option>
            <option value="Vers Top">Vers Top</option>
            <option value="Vers Bottom">Vers Bottom</option>
            <option value="Side">Side</option>
          </select>
        </div>
        
        <div className="p-4 border-b border-white/10">
          <label className="block text-sm mb-2">Ethnicity</label>
          <select
            value={profileDetails.ethnicity}
            onChange={(e) => setProfileDetails({...profileDetails, ethnicity: e.target.value})}
            className="w-full bg-[#222] rounded-md p-3 text-white"
          >
            <option value="Asian">Asian</option>
            <option value="Black">Black</option>
            <option value="Latino">Latino</option>
            <option value="Middle Eastern">Middle Eastern</option>
            <option value="Mixed">Mixed</option>
            <option value="Native American">Native American</option>
            <option value="South Asian">South Asian</option>
            <option value="White">White</option>
            <option value="Other">Other</option>
          </select>
        </div>
        
        <div className="p-4 border-b border-white/10">
          <label className="block text-sm mb-2">Relationship Status</label>
          <select
            value={profileDetails.relationshipStatus}
            onChange={(e) => setProfileDetails({...profileDetails, relationshipStatus: e.target.value})}
            className="w-full bg-[#222] rounded-md p-3 text-white"
          >
            <option value="Single">Single</option>
            <option value="Dating">Dating</option>
            <option value="Exclusive">Exclusive</option>
            <option value="Committed">Committed</option>
            <option value="Partnered">Partnered</option>
            <option value="Engaged">Engaged</option>
            <option value="Married">Married</option>
            <option value="Open Relationship">Open Relationship</option>
          </select>
        </div>
      </div>
      
      <h3 className="text-white font-semibold mb-3 flex items-center">
        EXPECTATIONS
      </h3>
      
      <div className="bg-[#121212] rounded-md overflow-hidden mb-6">
        <button className="w-full flex items-center justify-between p-4 border-b border-white/10">
          <span>I'm Looking For</span>
          <div className="flex items-center">
            <span className="text-gray-400 mr-2">{profileDetails.lookingFor}</span>
            <ChevronRight className="w-5 h-5 text-gray-500" />
          </div>
        </button>
        
        <button className="w-full flex items-center justify-between p-4 border-b border-white/10">
          <span>Meet At</span>
          <div className="flex items-center">
            <span className="text-gray-400 mr-2">{profileDetails.meetAt}</span>
            <ChevronRight className="w-5 h-5 text-gray-500" />
          </div>
        </button>
        
        <div className="flex items-center justify-between p-4">
          <span>Accepts NSFW Pics</span>
          <Switch 
            checked={profileDetails.acceptsNSFW}
            onCheckedChange={(checked) => setProfileDetails({...profileDetails, acceptsNSFW: checked})}
            className="data-[state=checked]:bg-[#AAFF50]"
          />
        </div>
      </div>
    </div>
  );
};

export default StatsTab;
