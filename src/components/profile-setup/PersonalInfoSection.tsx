
import React from 'react';
import { FormField, FormItem, FormLabel, FormControl } from '@/components/ui/form';
import { Input } from '@/components/ui/input';
import { Switch } from '@/components/ui/switch';
import { ChevronRight } from 'lucide-react';
import { useFormContext } from 'react-hook-form';
import { bodyTypes, roles } from '@/types/ProfileSetupTypes';

const PersonalInfoSection: React.FC = () => {
  const form = useFormContext();
  const showAge = form.watch('showAge');
  const displayName = form.watch('displayName') || '';

  return (
    <div className="space-y-4">
      {/* Display Name */}
      <div className="mb-4">
        <FormLabel className="text-sm font-medium mb-2 text-[#E6FFF4]/70">Display Name</FormLabel>
        <FormField
          control={form.control}
          name="displayName"
          render={({ field }) => (
            <FormItem>
              <FormControl>
                <Input
                  {...field}
                  className="bg-[#121212] border-[#333] text-white"
                  maxLength={15}
                  placeholder="Enter display name"
                />
              </FormControl>
            </FormItem>
          )}
        />
        <div className="flex justify-end mt-1">
          <span className="text-xs text-[#E6FFF4]/50">{displayName.length || 0}/15</span>
        </div>
      </div>

      {/* Stats Section */}
      <div className="rounded-lg overflow-hidden">
        <div className="bg-[#121212] p-4 border-b border-[#333]">
          <div className="flex items-center justify-between">
            <span className="text-[#E6FFF4]">Show Age</span>
            <Switch 
              checked={showAge}
              onCheckedChange={(checked) => form.setValue('showAge', checked)}
              className="data-[state=checked]:bg-[#AAFF50]"
            />
          </div>
        </div>

        <div className="bg-[#121212] divide-y divide-[#333]">
          <FormField
            control={form.control}
            name="age"
            render={({ field }) => (
              <div className="p-4 flex justify-between items-center">
                <span className="text-[#E6FFF4]">Age</span>
                <Input
                  {...field}
                  type="number"
                  className="w-20 bg-[#121212] border-[#333] text-right text-[#E6FFF4]"
                />
              </div>
            )}
          />

          <FormField
            control={form.control}
            name="height"
            render={({ field }) => (
              <div className="p-4 flex justify-between items-center">
                <span className="text-[#E6FFF4]">Height</span>
                <div className="flex items-center">
                  <span className="text-[#E6FFF4]/50 mr-2">{field.value || "6'0\""}</span>
                  <ChevronRight className="w-5 h-5 text-[#E6FFF4]/30" />
                </div>
              </div>
            )}
          />

          <FormField
            control={form.control}
            name="weight"
            render={({ field }) => (
              <div className="p-4 flex justify-between items-center">
                <span className="text-[#E6FFF4]">Weight</span>
                <div className="flex items-center">
                  <span className="text-[#E6FFF4]/50 mr-2">{field.value || "175 lb"}</span>
                  <ChevronRight className="w-5 h-5 text-[#E6FFF4]/30" />
                </div>
              </div>
            )}
          />

          <FormField
            control={form.control}
            name="bodyType"
            render={({ field }) => (
              <div className="p-4 flex justify-between items-center">
                <span className="text-[#E6FFF4]">Body Type</span>
                <div className="flex items-center">
                  <span className="text-[#E6FFF4]/50 mr-2">{field.value || "Select"}</span>
                  <ChevronRight className="w-5 h-5 text-[#E6FFF4]/30" />
                </div>
              </div>
            )}
          />

          <FormField
            control={form.control}
            name="position"
            render={({ field }) => (
              <div className="p-4 flex justify-between items-center">
                <span className="text-[#E6FFF4]">Position</span>
                <div className="flex items-center">
                  <span className="text-[#E6FFF4]/50 mr-2">{field.value || "Vers Top"}</span>
                  <ChevronRight className="w-5 h-5 text-[#E6FFF4]/30" />
                </div>
              </div>
            )}
          />
        </div>
      </div>

      {/* Expectations Section */}
      <div className="mt-6">
        <h3 className="text-sm font-semibold mb-3 text-[#E6FFF4] uppercase tracking-wider">Expectations</h3>
        <div className="bg-[#121212] rounded-lg divide-y divide-[#333]">
          <FormField
            control={form.control}
            name="lookingFor"
            render={({ field }) => (
              <div className="p-4 flex justify-between items-center">
                <span className="text-[#E6FFF4]">I'm Looking For</span>
                <div className="flex items-center">
                  <span className="text-[#E6FFF4]/50 mr-2">{field.value || "Hookups"}</span>
                  <ChevronRight className="w-5 h-5 text-[#E6FFF4]/30" />
                </div>
              </div>
            )}
          />

          <FormField
            control={form.control}
            name="meetAt"
            render={({ field }) => (
              <div className="p-4 flex justify-between items-center">
                <span className="text-[#E6FFF4]">Meet At</span>
                <div className="flex items-center">
                  <span className="text-[#E6FFF4]/50 mr-2">{field.value || "My Place"}</span>
                  <ChevronRight className="w-5 h-5 text-[#E6FFF4]/30" />
                </div>
              </div>
            )}
          />

          <FormField
            control={form.control}
            name="acceptsNSFW"
            render={({ field }) => (
              <div className="p-4 flex justify-between items-center">
                <span className="text-[#E6FFF4]">Accepts NSFW Pics</span>
                <Switch
                  checked={field.value}
                  onCheckedChange={field.onChange}
                  className="data-[state=checked]:bg-[#AAFF50]"
                />
              </div>
            )}
          />
        </div>
      </div>
    </div>
  );
};

export default PersonalInfoSection;
