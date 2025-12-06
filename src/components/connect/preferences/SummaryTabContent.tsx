
import React from 'react';
import { User } from 'lucide-react';
import { usePreferences } from './PreferencesContext';
import { getImportanceLabel } from './PreferencesTypes';

export const SummaryTabContent: React.FC = () => {
  const { preferences, socialMedia } = usePreferences();

  return (
    <>
      <div className="mb-6">
        <h3 className="text-[#E6FFF4] mb-3 text-lg font-medium">Matching Preferences Summary</h3>
        
        <div className="space-y-5 text-[#E6FFF4]">
          <div>
            <h4 className="font-medium">Looking For:</h4>
            <div className="mt-1 flex flex-wrap gap-2">
              {preferences.lookingFor.length > 0 
                ? preferences.lookingFor.map((type, index) => (
                    <span key={index} className="bg-[#E6FFF4]/20 text-[#E6FFF4] text-sm px-3 py-1 rounded-full">
                      {type}
                    </span>
                  ))
                : <span className="text-[#E6FFF4]/50 text-sm">None selected</span>
              }
            </div>
          </div>
          
          <div>
            <h4 className="font-medium">Deal Breakers:</h4>
            <div className="mt-1 flex flex-wrap gap-2">
              {preferences.dealBreakers.length > 0 
                ? preferences.dealBreakers.map((item, index) => (
                    <span key={index} className="bg-[#E6FFF4]/20 text-[#E6FFF4] text-sm px-3 py-1 rounded-full">
                      {item}
                    </span>
                  ))
                : <span className="text-[#E6FFF4]/50 text-sm">None selected</span>
              }
            </div>
          </div>
          
          <div className="grid grid-cols-2 gap-4">
            <div>
              <h4 className="font-medium">Factor Importance:</h4>
              <ul className="mt-1 space-y-1 text-sm">
                {Object.entries(preferences.importanceValues).map(([key, value]) => (
                  <li key={key} className="flex justify-between">
                    <span className="capitalize">{key}:</span>
                    <span className="text-[#AAFF50]">{getImportanceLabel(value)}</span>
                  </li>
                ))}
              </ul>
            </div>
            
            <div>
              <h4 className="font-medium">Social Media:</h4>
              <ul className="mt-1 space-y-1 text-sm">
                {Object.entries(socialMedia).map(([key, value]) => (
                  <li key={key} className="flex justify-between">
                    <span className="capitalize">{key}:</span>
                    <span className="truncate max-w-[120px] text-[#AAFF50]">
                      {value ? value : 'Not provided'}
                    </span>
                  </li>
                ))}
              </ul>
            </div>
          </div>
          
          {/* Personal Traits Summary */}
          <div>
            <h4 className="font-medium">Selected Hobbies & Interests:</h4>
            <div className="mt-1 flex flex-wrap gap-2">
              {[...preferences.hobbies, ...preferences.interests].slice(0, 10).map((item, index) => (
                <span key={index} className="bg-[#E6FFF4]/20 text-[#E6FFF4] text-sm px-3 py-1 rounded-full">
                  {item}
                </span>
              ))}
              {([...preferences.hobbies, ...preferences.interests].length > 10) && (
                <span className="bg-[#E6FFF4]/20 text-[#E6FFF4] text-sm px-3 py-1 rounded-full">
                  +{[...preferences.hobbies, ...preferences.interests].length - 10} more
                </span>
              )}
              {[...preferences.hobbies, ...preferences.interests].length === 0 && (
                <span className="text-[#E6FFF4]/50 text-sm">None selected</span>
              )}
            </div>
          </div>
          
          <div className="p-4 bg-[#1A1A1A] border border-[#E6FFF4]/30 rounded-lg">
            <div className="flex items-start space-x-3">
              <User className="w-5 h-5 text-[#AAFF50] flex-shrink-0 mt-1" />
              <div>
                <h4 className="font-medium text-[#E6FFF4]">AI Matching Report</h4>
                <p className="text-sm text-[#E6FFF4]/70 mt-1">
                  Our AI will analyze your preferences, social connections, and personality traits to generate high-quality matches. The more information you provide, the better your matches will be.
                </p>
                
                <div className="mt-3 text-sm">
                  <span className="text-[#AAFF50] font-medium">Analysis includes:</span>
                  <ul className="mt-1 space-y-1 list-disc pl-5">
                    <li>Relationship preference alignment</li>
                    <li>Personality compatibility assessment</li>
                    <li>Social network graph analysis</li>
                    <li>Interest and values matching</li>
                    <li>Communication style prediction</li>
                  </ul>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </>
  );
};
