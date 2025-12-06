
import React from 'react';
import { FormField, FormItem, FormLabel, FormControl, FormDescription, FormMessage } from '@/components/ui/form';
import { Checkbox } from '@/components/ui/checkbox';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import { useFormContext } from 'react-hook-form';
import { relationshipTypes } from '@/types/ProfileSetupTypes';

const CompatibilitySection: React.FC = () => {
  const form = useFormContext();

  return (
    <div className="space-y-6">
      <div className="grid grid-cols-2 gap-4">
        <FormField
          control={form.control}
          name="compatibility.wantsKids"
          render={({ field }) => (
            <FormItem className={`flex flex-row items-start space-x-3 space-y-0 rounded-md p-4 border-2 ${field.value ? 'border-[#E6FFF4] bg-[#E6FFF4]/10' : 'border-[#E6FFF4]/30'}`}>
              <FormControl>
                <Checkbox
                  checked={field.value}
                  onCheckedChange={field.onChange}
                  className={field.value ? "data-[state=checked]:bg-[#E6FFF4] data-[state=checked]:text-black" : ""}
                />
              </FormControl>
              <div className="space-y-1 leading-none">
                <FormLabel className="text-[#E6FFF4]">Wants Kids</FormLabel>
                <FormDescription className="text-[#E6FFF4]/70">
                  Do you want to have children in the future?
                </FormDescription>
              </div>
            </FormItem>
          )}
        />
        
        <FormField
          control={form.control}
          name="compatibility.hasKids"
          render={({ field }) => (
            <FormItem className={`flex flex-row items-start space-x-3 space-y-0 rounded-md p-4 border-2 ${field.value ? 'border-[#E6FFF4] bg-[#E6FFF4]/10' : 'border-[#E6FFF4]/30'}`}>
              <FormControl>
                <Checkbox
                  checked={field.value}
                  onCheckedChange={field.onChange}
                  className={field.value ? "data-[state=checked]:bg-[#E6FFF4] data-[state=checked]:text-black" : ""}
                />
              </FormControl>
              <div className="space-y-1 leading-none">
                <FormLabel className="text-[#E6FFF4]">Has Kids</FormLabel>
                <FormDescription className="text-[#E6FFF4]/70">
                  Do you currently have children?
                </FormDescription>
              </div>
            </FormItem>
          )}
        />
      </div>
      
      <div className="grid grid-cols-2 gap-4">
        <FormField
          control={form.control}
          name="compatibility.isFamilyOriented"
          render={({ field }) => (
            <FormItem className={`flex flex-row items-start space-x-3 space-y-0 rounded-md p-4 border-2 ${field.value ? 'border-[#E6FFF4] bg-[#E6FFF4]/10' : 'border-[#E6FFF4]/30'}`}>
              <FormControl>
                <Checkbox
                  checked={field.value}
                  onCheckedChange={field.onChange}
                  className={field.value ? "data-[state=checked]:bg-[#E6FFF4] data-[state=checked]:text-black" : ""}
                />
              </FormControl>
              <div className="space-y-1 leading-none">
                <FormLabel className="text-[#E6FFF4]">Family Oriented</FormLabel>
                <FormDescription className="text-[#E6FFF4]/70">
                  Is family important to you?
                </FormDescription>
              </div>
            </FormItem>
          )}
        />
        
        <FormField
          control={form.control}
          name="compatibility.isDrinker"
          render={({ field }) => (
            <FormItem className={`flex flex-row items-start space-x-3 space-y-0 rounded-md p-4 border-2 ${field.value ? 'border-[#E6FFF4] bg-[#E6FFF4]/10' : 'border-[#E6FFF4]/30'}`}>
              <FormControl>
                <Checkbox
                  checked={field.value}
                  onCheckedChange={field.onChange}
                  className={field.value ? "data-[state=checked]:bg-[#E6FFF4] data-[state=checked]:text-black" : ""}
                />
              </FormControl>
              <div className="space-y-1 leading-none">
                <FormLabel className="text-[#E6FFF4]">Drinks Alcohol</FormLabel>
                <FormDescription className="text-[#E6FFF4]/70">
                  Do you drink alcohol?
                </FormDescription>
              </div>
            </FormItem>
          )}
        />
      </div>
      
      <div className="grid grid-cols-2 gap-4">
        <FormField
          control={form.control}
          name="compatibility.isSmoker"
          render={({ field }) => (
            <FormItem className={`flex flex-row items-start space-x-3 space-y-0 rounded-md p-4 border-2 ${field.value ? 'border-[#E6FFF4] bg-[#E6FFF4]/10' : 'border-[#E6FFF4]/30'}`}>
              <FormControl>
                <Checkbox
                  checked={field.value}
                  onCheckedChange={field.onChange}
                  className={field.value ? "data-[state=checked]:bg-[#E6FFF4] data-[state=checked]:text-black" : ""}
                />
              </FormControl>
              <div className="space-y-1 leading-none">
                <FormLabel className="text-[#E6FFF4]">Smokes</FormLabel>
                <FormDescription className="text-[#E6FFF4]/70">
                  Do you smoke?
                </FormDescription>
              </div>
            </FormItem>
          )}
        />
        
        <FormField
          control={form.control}
          name="compatibility.isReligious"
          render={({ field }) => (
            <FormItem className={`flex flex-row items-start space-x-3 space-y-0 rounded-md p-4 border-2 ${field.value ? 'border-[#E6FFF4] bg-[#E6FFF4]/10' : 'border-[#E6FFF4]/30'}`}>
              <FormControl>
                <Checkbox
                  checked={field.value}
                  onCheckedChange={field.onChange}
                  className={field.value ? "data-[state=checked]:bg-[#E6FFF4] data-[state=checked]:text-black" : ""}
                />
              </FormControl>
              <div className="space-y-1 leading-none">
                <FormLabel className="text-[#E6FFF4]">Religious</FormLabel>
                <FormDescription className="text-[#E6FFF4]/70">
                  Are you religious?
                </FormDescription>
              </div>
            </FormItem>
          )}
        />
      </div>
      
      <FormField
        control={form.control}
        name="compatibility.openToLongDistance"
        render={({ field }) => (
          <FormItem className={`flex flex-row items-start space-x-3 space-y-0 rounded-md p-4 border-2 ${field.value ? 'border-[#E6FFF4] bg-[#E6FFF4]/10' : 'border-[#E6FFF4]/30'}`}>
            <FormControl>
              <Checkbox
                checked={field.value}
                onCheckedChange={field.onChange}
                className={field.value ? "data-[state=checked]:bg-[#E6FFF4] data-[state=checked]:text-black" : ""}
              />
            </FormControl>
            <div className="space-y-1 leading-none">
              <FormLabel className="text-[#E6FFF4]">Open to Long Distance</FormLabel>
              <FormDescription className="text-[#E6FFF4]/70">
                Would you consider a long-distance relationship for the right mate?
              </FormDescription>
            </div>
          </FormItem>
        )}
      />
      
      <FormField
        control={form.control}
        name="compatibility.politicalView"
        render={({ field }) => (
          <FormItem>
            <FormLabel className="text-[#E6FFF4]">Political Views</FormLabel>
            <FormControl>
              <select 
                className="w-full h-10 px-3 py-2 text-base bg-black border-2 border-[#E6FFF4]/30 text-[#E6FFF4] rounded-md focus:border-[#E6FFF4] focus:ring-1 focus:ring-[#E6FFF4]"
                {...field}
              >
                <option value="" className="bg-black text-[#E6FFF4]">Select political view</option>
                <option value="liberal" className="bg-black text-[#E6FFF4]">Liberal</option>
                <option value="conservative" className="bg-black text-[#E6FFF4]">Conservative</option>
                <option value="moderate" className="bg-black text-[#E6FFF4]">Moderate</option>
                <option value="progressive" className="bg-black text-[#E6FFF4]">Progressive</option>
                <option value="libertarian" className="bg-black text-[#E6FFF4]">Libertarian</option>
                <option value="apolitical" className="bg-black text-[#E6FFF4]">Apolitical</option>
              </select>
            </FormControl>
            <FormMessage className="text-[#FFC107]" />
          </FormItem>
        )}
      />
      
      <div>
        <FormLabel className="text-[#E6FFF4]">Looking For</FormLabel>
        <div className="grid grid-cols-2 gap-2 mt-2">
          {relationshipTypes.map((type) => {
            const isChecked = (form.getValues("compatibility.relationshipType") || [])
              .includes(type.toLowerCase());
            
            return (
              <Label 
                key={type}
                className={`flex items-center space-x-2 p-3 rounded-md border-2 cursor-pointer ${
                  isChecked ? 'border-[#E6FFF4] bg-[#E6FFF4]/10 text-[#E6FFF4]' : 'border-[#E6FFF4]/30 text-[#E6FFF4]/80 hover:bg-[#E6FFF4]/5'
                }`}
              >
                <Checkbox 
                  value={type.toLowerCase()}
                  onCheckedChange={(checked) => {
                    const currentTypes = form.getValues("compatibility.relationshipType") || [];
                    const value = type.toLowerCase();
                    
                    if (checked) {
                      form.setValue("compatibility.relationshipType", 
                        [...currentTypes, value]);
                    } else {
                      form.setValue("compatibility.relationshipType", 
                        currentTypes.filter(t => t !== value));
                    }
                  }}
                  checked={isChecked}
                  className={isChecked ? "data-[state=checked]:bg-[#E6FFF4] data-[state=checked]:text-black border-[#E6FFF4]" : "border-[#E6FFF4]"}
                />
                <span>{type}</span>
              </Label>
            );
          })}
        </div>
      </div>
      
      <FormField
        control={form.control}
        name="compatibility.dealBreakers"
        render={({ field }) => (
          <FormItem>
            <FormLabel className="text-[#E6FFF4]">Deal Breakers</FormLabel>
            <FormControl>
              <Textarea 
                placeholder="List your deal breakers, separated by commas"
                className="min-h-[80px] bg-black border-2 border-[#E6FFF4]/30 text-[#E6FFF4] placeholder-[#E6FFF4]/50 focus:border-[#E6FFF4]"
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
            <FormDescription className="text-[#E6FFF4]/70">
              Things that would make you instantly pass on a match
            </FormDescription>
            <FormMessage className="text-[#FFC107]" />
          </FormItem>
        )}
      />
    </div>
  );
};

export default CompatibilitySection;
