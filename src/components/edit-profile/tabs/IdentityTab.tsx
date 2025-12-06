
import React from 'react';
import { Input } from "@/components/ui/input";

interface IdentityTabProps {
  socialLinks: {
    instagram: string;
    twitter: string;
    facebook: string;
    spotify: string;
  };
  setSocialLinks: (links: any) => void;
}

const IdentityTab: React.FC<IdentityTabProps> = ({
  socialLinks,
  setSocialLinks
}) => {
  return (
    <div className="p-4">
      <div className="space-y-6">
        <div>
          <label className="block text-sm font-medium mb-2">Instagram</label>
          <Input
            value={socialLinks.instagram}
            onChange={(e) => setSocialLinks({...socialLinks, instagram: e.target.value})}
            placeholder="@username"
            className="bg-[#222]"
          />
        </div>
        
        <div>
          <label className="block text-sm font-medium mb-2">Twitter</label>
          <Input
            value={socialLinks.twitter}
            onChange={(e) => setSocialLinks({...socialLinks, twitter: e.target.value})}
            placeholder="@username"
            className="bg-[#222]"
          />
        </div>
        
        <div>
          <label className="block text-sm font-medium mb-2">Facebook</label>
          <Input
            value={socialLinks.facebook}
            onChange={(e) => setSocialLinks({...socialLinks, facebook: e.target.value})}
            placeholder="Username or profile URL"
            className="bg-[#222]"
          />
        </div>
        
        <div>
          <label className="block text-sm font-medium mb-2">Spotify</label>
          <Input
            value={socialLinks.spotify}
            onChange={(e) => setSocialLinks({...socialLinks, spotify: e.target.value})}
            placeholder="Profile URL"
            className="bg-[#222]"
          />
        </div>
      </div>
    </div>
  );
};

export default IdentityTab;
