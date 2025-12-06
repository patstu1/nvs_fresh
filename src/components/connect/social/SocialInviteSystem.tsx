
import React, { useState } from 'react';
import { Copy, Share, Instagram, Twitter, Facebook } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { toast } from '@/hooks/use-toast';
import { analytics } from '@/services/analytics';

interface SocialInviteSystemProps {
  username?: string;
}

const SocialInviteSystem: React.FC<SocialInviteSystemProps> = ({ username = 'friend' }) => {
  const [copied, setCopied] = useState(false);
  
  const appUrl = window.location.origin;
  const referralCode = username ? `?ref=${encodeURIComponent(username)}` : '';
  const inviteUrl = `${appUrl}${referralCode}`;
  
  const inviteText = `Hey! Join me on YoBro, an awesome community app. Check it out: ${inviteUrl}`;
  const instagramCaption = `Join me on @yobro_app!\n\n${inviteUrl}\n\n#YoBro #CommunityApp #Connect`;
  
  const handleCopyLink = () => {
    navigator.clipboard.writeText(inviteUrl).then(() => {
      setCopied(true);
      toast({
        title: "Link copied!",
        description: "Share it with your friends"
      });
      
      analytics.trackEvent('feature_usage', { 
        feature: 'referral_link_copy',
        platform: 'clipboard'
      });
      
      setTimeout(() => setCopied(false), 2000);
    });
  };
  
  const handleShareToInstagram = () => {
    // For mobile devices, we can try to open Instagram with the caption
    if (/Android|iPhone|iPad|iPod/i.test(navigator.userAgent)) {
      // Instagram doesn't support direct story sharing via URL on all devices
      // So we'll copy the caption to clipboard and open Instagram
      navigator.clipboard.writeText(instagramCaption).then(() => {
        toast({
          title: "Caption copied!",
          description: "Now create a new post in Instagram and paste"
        });
        
        // Try to open Instagram app
        window.location.href = 'instagram://';
        
        // Fallback to website after a short delay
        setTimeout(() => {
          window.location.href = 'https://instagram.com';
        }, 2000);
      });
    } else {
      // For desktop, just copy the text
      navigator.clipboard.writeText(instagramCaption).then(() => {
        toast({
          title: "Instagram caption copied!",
          description: "Paste it when creating a post on Instagram"
        });
      });
    }
    
    analytics.trackEvent('feature_usage', { 
      feature: 'referral_share',
      platform: 'instagram'
    });
  };
  
  const handleShareToTwitter = () => {
    const twitterUrl = `https://twitter.com/intent/tweet?text=${encodeURIComponent(inviteText)}`;
    window.open(twitterUrl, '_blank');
    
    analytics.trackEvent('feature_usage', { 
      feature: 'referral_share',
      platform: 'twitter'
    });
  };
  
  const handleShareToFacebook = () => {
    const facebookUrl = `https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(inviteUrl)}`;
    window.open(facebookUrl, '_blank');
    
    analytics.trackEvent('feature_usage', { 
      feature: 'referral_share',
      platform: 'facebook'
    });
  };
  
  const handleShareNative = () => {
    if (navigator.share) {
      navigator.share({
        title: 'Join me on YoBro!',
        text: inviteText,
        url: inviteUrl,
      })
      .then(() => {
        analytics.trackEvent('feature_usage', { 
          feature: 'referral_share',
          platform: 'native'
        });
      })
      .catch((error) => console.log('Error sharing', error));
    } else {
      handleCopyLink();
    }
  };

  return (
    <div className="w-full space-y-4 p-4 border border-[#E6FFF4]/10 rounded-md bg-black/30">
      <h3 className="text-lg font-medium text-[#E6FFF4]">Invite Friends</h3>
      <p className="text-sm text-[#E6FFF4]/70">
        Share YoBro with friends to help grow our community
      </p>
      
      <div className="flex items-center space-x-2">
        <Input 
          value={inviteUrl} 
          readOnly 
          className="bg-[#1A1A1A] border-[#E6FFF4]/20"
        />
        <Button 
          onClick={handleCopyLink} 
          className="bg-[#AAFF50] text-black hover:bg-[#AAFF50]/90 transition-all"
        >
          <Copy className="w-4 h-4 mr-2" />
          {copied ? 'Copied' : 'Copy'}
        </Button>
      </div>
      
      <div className="grid grid-cols-4 gap-2">
        <Button 
          onClick={handleShareToInstagram}
          variant="outline" 
          className="flex flex-col items-center justify-center p-3 h-auto border-[#E6FFF4]/10 hover:border-[#E6FFF4]/30 hover:bg-[#E6FFF4]/5"
        >
          <Instagram className="w-5 h-5 mb-2 text-[#E6FFF4]" />
          <span className="text-xs">Instagram</span>
        </Button>
        <Button 
          onClick={handleShareToTwitter} 
          variant="outline" 
          className="flex flex-col items-center justify-center p-3 h-auto border-[#E6FFF4]/10 hover:border-[#E6FFF4]/30 hover:bg-[#E6FFF4]/5"
        >
          <Twitter className="w-5 h-5 mb-2 text-[#E6FFF4]" />
          <span className="text-xs">Twitter</span>
        </Button>
        <Button 
          onClick={handleShareToFacebook} 
          variant="outline" 
          className="flex flex-col items-center justify-center p-3 h-auto border-[#E6FFF4]/10 hover:border-[#E6FFF4]/30 hover:bg-[#E6FFF4]/5"
        >
          <Facebook className="w-5 h-5 mb-2 text-[#E6FFF4]" />
          <span className="text-xs">Facebook</span>
        </Button>
        <Button 
          onClick={handleShareNative} 
          variant="outline" 
          className="flex flex-col items-center justify-center p-3 h-auto border-[#E6FFF4]/10 hover:border-[#E6FFF4]/30 hover:bg-[#E6FFF4]/5"
        >
          <Share className="w-5 h-5 mb-2 text-[#E6FFF4]" />
          <span className="text-xs">Share</span>
        </Button>
      </div>
    </div>
  );
};

export default SocialInviteSystem;
