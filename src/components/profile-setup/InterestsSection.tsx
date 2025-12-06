
import React, { useState } from 'react';
import { FormField, FormItem, FormLabel, FormControl, FormMessage, FormDescription } from '@/components/ui/form';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Textarea } from '@/components/ui/textarea';
import { useFormContext } from 'react-hook-form';

const InterestsSection: React.FC = () => {
  const form = useFormContext();
  const [newHobby, setNewHobby] = useState<string>("");
  const [newInterest, setNewInterest] = useState<string>("");
  
  const addHobby = () => {
    if (newHobby.trim() !== "") {
      const currentHobbies = form.getValues("interests.hobbies") || [];
      form.setValue("interests.hobbies", [...currentHobbies, newHobby.trim()]);
      setNewHobby("");
    }
  };
  
  const addInterest = () => {
    if (newInterest.trim() !== "") {
      const currentInterests = form.getValues("interests.interests") || [];
      form.setValue("interests.interests", [...currentInterests, newInterest.trim()]);
      setNewInterest("");
    }
  };

  return (
    <div className="space-y-6">
      <div>
        <FormLabel className="text-[#E6FFF4]">Hobbies</FormLabel>
        <div className="flex flex-wrap gap-2 mt-2">
          {(form.getValues("interests.hobbies") || []).map((hobby, index) => (
            <div 
              key={index}
              className="bg-[#E6FFF4]/10 text-[#E6FFF4] rounded-full px-3 py-1 flex items-center"
            >
              <span>{hobby}</span>
              <button
                type="button"
                className="ml-2 text-[#E6FFF4]/60 hover:text-[#E6FFF4]"
                onClick={() => {
                  const currentHobbies = form.getValues("interests.hobbies") || [];
                  form.setValue("interests.hobbies", 
                    currentHobbies.filter((_, i) => i !== index));
                }}
              >
                ×
              </button>
            </div>
          ))}
        </div>
        <div className="flex mt-2">
          <Input
            value={newHobby}
            onChange={(e) => setNewHobby(e.target.value)}
            placeholder="Add a hobby"
            className="flex-1 bg-black border-2 border-[#E6FFF4]/30 text-[#E6FFF4] placeholder-[#E6FFF4]/50"
            onKeyDown={(e) => {
              if (e.key === 'Enter') {
                e.preventDefault();
                addHobby();
              }
            }}
          />
          <Button 
            type="button" 
            onClick={addHobby}
            variant="outline"
            className="ml-2 border-[#E6FFF4] text-[#E6FFF4] hover:bg-[#E6FFF4]/10"
          >
            Add
          </Button>
        </div>
        <FormDescription className="mt-2 text-[#E6FFF4]/70">
          Hobbies help our AI find matches with similar interests
        </FormDescription>
      </div>
      
      <div>
        <FormLabel className="text-[#E6FFF4]">Interests</FormLabel>
        <div className="flex flex-wrap gap-2 mt-2">
          {(form.getValues("interests.interests") || []).map((interest, index) => (
            <div 
              key={index}
              className="bg-[#E6FFF4]/10 text-[#E6FFF4] rounded-full px-3 py-1 flex items-center"
            >
              <span>{interest}</span>
              <button
                type="button"
                className="ml-2 text-[#E6FFF4]/60 hover:text-[#E6FFF4]"
                onClick={() => {
                  const currentInterests = form.getValues("interests.interests") || [];
                  form.setValue("interests.interests", 
                    currentInterests.filter((_, i) => i !== index));
                }}
              >
                ×
              </button>
            </div>
          ))}
        </div>
        <div className="flex mt-2">
          <Input
            value={newInterest}
            onChange={(e) => setNewInterest(e.target.value)}
            placeholder="Add an interest"
            className="flex-1 bg-black border-2 border-[#E6FFF4]/30 text-[#E6FFF4] placeholder-[#E6FFF4]/50"
            onKeyDown={(e) => {
              if (e.key === 'Enter') {
                e.preventDefault();
                addInterest();
              }
            }}
          />
          <Button 
            type="button" 
            onClick={addInterest}
            variant="outline"
            className="ml-2 border-[#E6FFF4] text-[#E6FFF4] hover:bg-[#E6FFF4]/10"
          >
            Add
          </Button>
        </div>
      </div>
      
      <FormField
        control={form.control}
        name="interests.favoriteActivities"
        render={({ field }) => (
          <FormItem>
            <FormLabel className="text-[#E6FFF4]">Favorite Activities</FormLabel>
            <FormControl>
              <Textarea 
                placeholder="What do you enjoy doing? Separate with commas"
                className="min-h-[80px] bg-black border-2 border-[#E6FFF4]/30 text-[#E6FFF4] placeholder-[#E6FFF4]/50"
                {...field}
                value={(field.value || []).join(", ")}
                onChange={(e) => {
                  const values = e.target.value
                    .split(",")
                    .map(item => item.trim())
                    .filter(item => item !== "");
                  field.onChange(values);
                }}
              />
            </FormControl>
            <FormMessage className="text-[#FFC107]" />
          </FormItem>
        )}
      />
      
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        <FormField
          control={form.control}
          name="interests.music"
          render={({ field }) => (
            <FormItem>
              <FormLabel className="text-[#E6FFF4]">Music Preferences</FormLabel>
              <FormControl>
                <Textarea 
                  placeholder="What music do you like? Separate with commas"
                  className="min-h-[80px] bg-black border-2 border-[#E6FFF4]/30 text-[#E6FFF4] placeholder-[#E6FFF4]/50"
                  {...field}
                  value={(field.value || []).join(", ")}
                  onChange={(e) => {
                    const values = e.target.value
                      .split(",")
                      .map(item => item.trim())
                      .filter(item => item !== "");
                    field.onChange(values);
                  }}
                />
              </FormControl>
              <FormMessage className="text-[#FFC107]" />
            </FormItem>
          )}
        />
        
        <FormField
          control={form.control}
          name="interests.movies"
          render={({ field }) => (
            <FormItem>
              <FormLabel className="text-[#E6FFF4]">Movie/TV Preferences</FormLabel>
              <FormControl>
                <Textarea 
                  placeholder="What movies or shows do you like? Separate with commas"
                  className="min-h-[80px] bg-black border-2 border-[#E6FFF4]/30 text-[#E6FFF4] placeholder-[#E6FFF4]/50"
                  {...field}
                  value={(field.value || []).join(", ")}
                  onChange={(e) => {
                    const values = e.target.value
                      .split(",")
                      .map(item => item.trim())
                      .filter(item => item !== "");
                    field.onChange(values);
                  }}
                />
              </FormControl>
              <FormMessage className="text-[#FFC107]" />
            </FormItem>
          )}
        />
      </div>
    </div>
  );
};

export default InterestsSection;
