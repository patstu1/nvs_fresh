
import React from 'react';
import { FormField, FormItem, FormLabel, FormControl, FormDescription, FormMessage } from '@/components/ui/form';
import { Input } from '@/components/ui/input';
import { useFormContext } from 'react-hook-form';
import { Instagram, Twitter, Facebook, Linkedin, Github } from 'lucide-react';

const SocialMediaSection: React.FC = () => {
  const form = useFormContext();

  return (
    <div className="space-y-6">
      <FormField
        control={form.control}
        name="socialMedia.instagram"
        render={({ field }) => (
          <FormItem>
            <FormLabel className="text-[#E6FFF4]">
              <div className="flex items-center">
                <Instagram className="mr-2 h-4 w-4 text-[#E6FFF4]" />
                Instagram
              </div>
            </FormLabel>
            <FormControl>
              <Input 
                placeholder="Instagram username" 
                {...field} 
                className="bg-black border-2 border-[#E6FFF4] text-[#E6FFF4] placeholder-[#E6FFF4]/50"
              />
            </FormControl>
            <FormDescription className="text-[#E6FFF4]/70">
              Your Instagram account helps us analyze your lifestyle preferences
            </FormDescription>
            <FormMessage className="text-[#FFC107]" />
          </FormItem>
        )}
      />
      
      <FormField
        control={form.control}
        name="socialMedia.twitter"
        render={({ field }) => (
          <FormItem>
            <FormLabel className="text-[#E6FFF4]">
              <div className="flex items-center">
                <Twitter className="mr-2 h-4 w-4 text-[#E6FFF4]" />
                Twitter
              </div>
            </FormLabel>
            <FormControl>
              <Input 
                placeholder="Twitter username" 
                {...field} 
                className="bg-black border-2 border-[#E6FFF4] text-[#E6FFF4] placeholder-[#E6FFF4]/50"
              />
            </FormControl>
            <FormMessage className="text-[#FFC107]" />
          </FormItem>
        )}
      />
      
      <FormField
        control={form.control}
        name="socialMedia.facebook"
        render={({ field }) => (
          <FormItem>
            <FormLabel className="text-[#E6FFF4]">
              <div className="flex items-center">
                <Facebook className="mr-2 h-4 w-4 text-[#E6FFF4]" />
                Facebook
              </div>
            </FormLabel>
            <FormControl>
              <Input 
                placeholder="Facebook profile url" 
                {...field} 
                className="bg-black border-2 border-[#E6FFF4] text-[#E6FFF4] placeholder-[#E6FFF4]/50"
              />
            </FormControl>
            <FormDescription className="text-[#E6FFF4]/70">
              Helps us understand your social connections and friend groups
            </FormDescription>
            <FormMessage className="text-[#FFC107]" />
          </FormItem>
        )}
      />
      
      <FormField
        control={form.control}
        name="socialMedia.linkedin"
        render={({ field }) => (
          <FormItem>
            <FormLabel className="text-[#E6FFF4]">
              <div className="flex items-center">
                <Linkedin className="mr-2 h-4 w-4 text-[#E6FFF4]" />
                LinkedIn
              </div>
            </FormLabel>
            <FormControl>
              <Input 
                placeholder="LinkedIn profile url" 
                {...field} 
                className="bg-black border-2 border-[#E6FFF4] text-[#E6FFF4] placeholder-[#E6FFF4]/50"
              />
            </FormControl>
            <FormDescription className="text-[#E6FFF4]/70">
              Helps analyze career and professional compatibility
            </FormDescription>
            <FormMessage className="text-[#FFC107]" />
          </FormItem>
        )}
      />
      
      <FormField
        control={form.control}
        name="socialMedia.other"
        render={({ field }) => (
          <FormItem>
            <FormLabel className="text-[#E6FFF4]">Other Social Media</FormLabel>
            <FormControl>
              <Input 
                placeholder="Other profiles (TikTok, etc.)" 
                {...field} 
                className="bg-black border-2 border-[#E6FFF4] text-[#E6FFF4] placeholder-[#E6FFF4]/50"
              />
            </FormControl>
            <FormMessage className="text-[#FFC107]" />
          </FormItem>
        )}
      />
    </div>
  );
};

export default SocialMediaSection;
