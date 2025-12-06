import React from 'react';
import { Button } from '@/components/ui/button';
import { Check, BookOpen, Heart, Target, Users } from 'lucide-react';
import { 
  PoliticalLeaning, 
  FamilyValues,
  DietPreference, 
  ReligiousView, 
  DrugUse,
  FamilyViews,
  LifeGoal,
  CoreValue,
  ReligiousBackground,
  ReligiousLevel
} from './ConnectPreferencesTypes';

interface ValuesTabContentProps {
  formData: {
    politicalLeaning?: PoliticalLeaning;
    familyValues?: FamilyValues;
    dietPreference?: DietPreference;
    religiousView?: ReligiousView;
    drugUse?: DrugUse;
    familyViews?: FamilyViews;
    lifeGoals: LifeGoal[];
    coreValues: CoreValue[];
    religiousBackground?: ReligiousBackground;
    religiousLevel?: ReligiousLevel;
  };
  handleSelectOption: <T extends string>(field: keyof ValuesTabContentProps['formData'], value: T) => void;
  handleToggleArrayOption: (field: 'lifeGoals' | 'coreValues', value: string) => void;
  isOptionSelected: <T extends string>(field: keyof ValuesTabContentProps['formData'], value: T) => boolean;
}

const ValuesTabContent: React.FC<ValuesTabContentProps> = ({ 
  formData, 
  handleSelectOption,
  handleToggleArrayOption,
  isOptionSelected 
}) => {
  return (
    <div className="space-y-8">
      <div>
        <h2 className="text-xl font-bold text-[#E6FFF4] mb-4 flex items-center">
          <BookOpen className="w-5 h-5 mr-2" />
          Values & Life Goals
        </h2>
        
        <div className="space-y-6">
          {/* Core Values Section */}
          <div>
            <h3 className="text-md font-medium text-[#E6FFF4] mb-2">Core Values</h3>
            <p className="text-[#E6FFF4]/70 text-sm mb-3">Select the values that matter most to you</p>
            <div className="grid grid-cols-2 gap-2">
              {([
                { value: 'honesty', label: 'Honesty' },
                { value: 'loyalty', label: 'Loyalty' },
                { value: 'ambition', label: 'Ambition' },
                { value: 'compassion', label: 'Compassion' },
                { value: 'tradition', label: 'Tradition' },
                { value: 'innovation', label: 'Innovation' },
                { value: 'adventure', label: 'Adventure' },
                { value: 'stability', label: 'Stability' },
                { value: 'independence', label: 'Independence' },
                { value: 'community', label: 'Community' },
              ] as const).map(option => (
                <Button 
                  key={option.value}
                  type="button"
                  variant={formData.coreValues.includes(option.value) ? 'ring-active' : 'ring'}
                  onClick={() => handleToggleArrayOption('coreValues', option.value)}
                  className="justify-start"
                >
                  {formData.coreValues.includes(option.value) && <Check className="w-4 h-4 mr-2" />}
                  {option.label}
                </Button>
              ))}
            </div>
          </div>

          {/* Life Goals Section */}
          <div>
            <h3 className="text-md font-medium text-[#E6FFF4] mb-2 flex items-center">
              <Target className="w-4 h-4 mr-2" />
              Life Goals
            </h3>
            <p className="text-[#E6FFF4]/70 text-sm mb-3">What are your primary goals in life?</p>
            <div className="grid grid-cols-2 gap-2">
              {([
                { value: 'career-focused', label: 'Career Growth' },
                { value: 'education', label: 'Education' },
                { value: 'travel', label: 'Travel & Adventure' },
                { value: 'settling-down', label: 'Settling Down' },
                { value: 'entrepreneurship', label: 'Entrepreneurship' },
                { value: 'creative-pursuits', label: 'Creative Pursuits' },
                { value: 'financial-stability', label: 'Financial Stability' },
                { value: 'personal-growth', label: 'Personal Growth' },
                { value: 'community-building', label: 'Community Building' },
              ] as const).map(option => (
                <Button 
                  key={option.value}
                  type="button"
                  variant={formData.lifeGoals.includes(option.value) ? 'ring-active' : 'ring'}
                  onClick={() => handleToggleArrayOption('lifeGoals', option.value)}
                  className="justify-start"
                >
                  {formData.lifeGoals.includes(option.value) && <Check className="w-4 h-4 mr-2" />}
                  {option.label}
                </Button>
              ))}
            </div>
          </div>

          {/* Family Views Section */}
          <div>
            <h3 className="text-md font-medium text-[#E6FFF4] mb-2 flex items-center">
              <Users className="w-4 h-4 mr-2" />
              Family Views
            </h3>
            <p className="text-[#E6FFF4]/70 text-sm mb-3">Your perspective on family and children</p>
            <div className="grid grid-cols-2 gap-2">
              {([
                { value: 'wants-children', label: 'Wants Children' },
                { value: 'has-children', label: 'Has Children' },
                { value: 'no-children', label: 'No Children' },
                { value: 'open-to-children', label: 'Open to Children' },
                { value: 'prefers-no-children', label: 'Prefers No Children' },
              ] as const).map(option => (
                <Button 
                  key={option.value}
                  type="button"
                  variant={isOptionSelected('familyViews', option.value) ? 'ring-active' : 'ring'}
                  onClick={() => handleSelectOption('familyViews', option.value)}
                  className="justify-start"
                >
                  {isOptionSelected('familyViews', option.value) && <Check className="w-4 h-4 mr-2" />}
                  {option.label}
                </Button>
              ))}
            </div>
          </div>

          {/* Religious Background Section */}
          <div>
            <h3 className="text-md font-medium text-[#E6FFF4] mb-2 flex items-center">
              <Heart className="w-4 h-4 mr-2" />
              Religious Views
            </h3>
            <div className="space-y-4">
              <div>
                <p className="text-[#E6FFF4]/70 text-sm mb-2">Religious Background</p>
                <div className="grid grid-cols-2 gap-2">
                  {([
                    { value: 'christian', label: 'Christian' },
                    { value: 'catholic', label: 'Catholic' },
                    { value: 'jewish', label: 'Jewish' },
                    { value: 'muslim', label: 'Muslim' },
                    { value: 'buddhist', label: 'Buddhist' },
                    { value: 'hindu', label: 'Hindu' },
                    { value: 'spiritual', label: 'Spiritual' },
                    { value: 'agnostic', label: 'Agnostic' },
                    { value: 'atheist', label: 'Atheist' },
                    { value: 'other', label: 'Other' },
                  ] as const).map(option => (
                    <Button 
                      key={option.value}
                      type="button"
                      variant={isOptionSelected('religiousBackground', option.value) ? 'ring-active' : 'ring'}
                      onClick={() => handleSelectOption('religiousBackground', option.value)}
                      className="justify-start"
                    >
                      {isOptionSelected('religiousBackground', option.value) && <Check className="w-4 h-4 mr-2" />}
                      {option.label}
                    </Button>
                  ))}
                </div>
              </div>
              
              <div>
                <p className="text-[#E6FFF4]/70 text-sm mb-2">Religious Level</p>
                <div className="grid grid-cols-2 gap-2">
                  {([
                    { value: 'very-religious', label: 'Very Religious' },
                    { value: 'moderately-religious', label: 'Moderately Religious' },
                    { value: 'somewhat-religious', label: 'Somewhat Religious' },
                    { value: 'not-religious', label: 'Not Religious' },
                    { value: 'spiritual-not-religious', label: 'Spiritual but Not Religious' },
                  ] as const).map(option => (
                    <Button 
                      key={option.value}
                      type="button"
                      variant={isOptionSelected('religiousLevel', option.value) ? 'ring-active' : 'ring'}
                      onClick={() => handleSelectOption('religiousLevel', option.value)}
                      className="justify-start"
                    >
                      {isOptionSelected('religiousLevel', option.value) && <Check className="w-4 h-4 mr-2" />}
                      {option.label}
                    </Button>
                  ))}
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <div className="mb-6">
        <h2 className="text-lg font-semibold text-[#E6FFF4] mb-2">Values & Lifestyle</h2>
        <p className="text-[#E6FFF4]/70 mb-4">Tell us about your values:</p>
        
        <div className="mb-6">
          <h3 className="text-md font-medium text-[#E6FFF4] mb-2">Politics</h3>
          <div className="grid grid-cols-2 gap-2 mb-4">
            {([
              { value: 'liberal', label: 'Liberal' },
              { value: 'moderate', label: 'Moderate' },
              { value: 'conservative', label: 'Conservative' },
              { value: 'apolitical', label: 'Apolitical' },
            ] as const).map(option => (
              <Button 
                key={option.value}
                type="button"
                variant={isOptionSelected('politicalLeaning', option.value) ? 'ring-active' : 'ring'}
                onClick={() => handleSelectOption('politicalLeaning', option.value)}
                className="justify-start"
              >
                {isOptionSelected('politicalLeaning', option.value) && <Check className="w-4 h-4 mr-2" />}
                {option.label}
              </Button>
            ))}
          </div>

          <h3 className="text-md font-medium text-[#E6FFF4] mb-2">Family Values</h3>
          <div className="grid grid-cols-2 gap-2 mb-4">
            {([
              { value: 'traditional', label: 'Traditional' },
              { value: 'modern', label: 'Modern' },
              { value: 'none', label: 'Not Important' },
            ] as const).map(option => (
              <Button 
                key={option.value}
                type="button"
                variant={isOptionSelected('familyValues', option.value) ? 'ring-active' : 'ring'}
                onClick={() => handleSelectOption('familyValues', option.value)}
                className="justify-start"
              >
                {isOptionSelected('familyValues', option.value) && <Check className="w-4 h-4 mr-2" />}
                {option.label}
              </Button>
            ))}
          </div>
          
          <h3 className="text-md font-medium text-[#E6FFF4] mb-2">Diet</h3>
          <div className="grid grid-cols-2 gap-2 mb-4">
            {([
              { value: 'omnivore', label: 'Omnivore' },
              { value: 'vegetarian', label: 'Vegetarian' },
              { value: 'vegan', label: 'Vegan' },
              { value: 'keto', label: 'Keto' },
              { value: 'paleo', label: 'Paleo' },
            ] as const).map(option => (
              <Button 
                key={option.value}
                type="button"
                variant={isOptionSelected('dietPreference', option.value) ? 'ring-active' : 'ring'}
                onClick={() => handleSelectOption('dietPreference', option.value)}
                className="justify-start"
              >
                {isOptionSelected('dietPreference', option.value) && <Check className="w-4 h-4 mr-2" />}
                {option.label}
              </Button>
            ))}
          </div>
          
          <h3 className="text-md font-medium text-[#E6FFF4] mb-2">Substance Use</h3>
          <div className="grid grid-cols-2 gap-2 mb-4">
            {([
              { value: 'never', label: 'Never' },
              { value: 'socially', label: 'Socially' },
              { value: 'regularly', label: 'Regularly' },
            ] as const).map(option => (
              <Button 
                key={option.value}
                type="button"
                variant={isOptionSelected('drugUse', option.value) ? 'ring-active' : 'ring'}
                onClick={() => handleSelectOption('drugUse', option.value)}
                className="justify-start"
              >
                {isOptionSelected('drugUse', option.value) && <Check className="w-4 h-4 mr-2" />}
                {option.label}
              </Button>
            ))}
          </div>
          
          <h3 className="text-md font-medium text-[#E6FFF4] mb-2">Religious Views</h3>
          <div className="grid grid-cols-2 gap-2 mb-4">
            {([
              { value: 'religious', label: 'Religious' },
              { value: 'spiritual', label: 'Spiritual' },
              { value: 'agnostic', label: 'Agnostic' },
              { value: 'atheist', label: 'Atheist' },
            ] as const).map(option => (
              <Button 
                key={option.value}
                type="button"
                variant={isOptionSelected('religiousView', option.value) ? 'ring-active' : 'ring'}
                onClick={() => handleSelectOption('religiousView', option.value)}
                className="justify-start"
              >
                {isOptionSelected('religiousView', option.value) && <Check className="w-4 h-4 mr-2" />}
                {option.label}
              </Button>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
};

export default ValuesTabContent;
