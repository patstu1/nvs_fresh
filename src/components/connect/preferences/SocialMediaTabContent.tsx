
import React from 'react';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Switch } from '@/components/ui/switch';
import { ConnectUserProfile } from './ConnectPreferencesTypes';

interface SocialMediaTabContentProps {
  formData: ConnectUserProfile;
  handleSocialMediaChange: (platform: keyof ConnectUserProfile['socialMedia'], value: string | boolean) => void;
}

const SocialMediaTabContent: React.FC<SocialMediaTabContentProps> = ({ 
  formData, 
  handleSocialMediaChange 
}) => {
  return (
    <div>
      <h2 className="text-lg font-semibold text-[#E6FFF4] mb-2">Social Media</h2>
      <p className="text-[#E6FFF4]/70 mb-4">Connect your social accounts (optional):</p>
      
      <div className="space-y-4">
        <div className="space-y-2">
          <Label htmlFor="instagram" className="text-[#E6FFF4]">Instagram</Label>
          <Input
            id="instagram"
            type="text"
            placeholder="@username"
            value={formData.socialMedia.instagram}
            onChange={(e) => handleSocialMediaChange('instagram', e.target.value)}
            className="bg-[#1A1A1A] border-[#2A2A2A] text-[#E6FFF4]"
          />
        </div>
        
        <div className="space-y-2">
          <Label htmlFor="twitter" className="text-[#E6FFF4]">Twitter</Label>
          <Input
            id="twitter"
            type="text"
            placeholder="@username"
            value={formData.socialMedia.twitter}
            onChange={(e) => handleSocialMediaChange('twitter', e.target.value)}
            className="bg-[#1A1A1A] border-[#2A2A2A] text-[#E6FFF4]"
          />
        </div>
        
        <div className="space-y-2">
          <Label htmlFor="tiktok" className="text-[#E6FFF4]">TikTok</Label>
          <Input
            id="tiktok"
            type="text"
            placeholder="@username"
            value={formData.socialMedia.tiktok}
            onChange={(e) => handleSocialMediaChange('tiktok', e.target.value)}
            className="bg-[#1A1A1A] border-[#2A2A2A] text-[#E6FFF4]"
          />
        </div>
        
        <div className="flex items-center justify-between pt-2">
          <Label htmlFor="displayOnProfile" className="text-[#E6FFF4]">
            Display social media on profile
          </Label>
          <Switch
            id="displayOnProfile"
            checked={formData.socialMedia.displayOnProfile}
            onCheckedChange={(checked) => handleSocialMediaChange('displayOnProfile', checked)}
          />
        </div>
      </div>
    </div>
  );
};

export default SocialMediaTabContent;
