
import React, { createContext, useState, useContext, useEffect } from 'react';
import { Preferences, SocialMediaConnections, ImportanceValues, PreferencesTabType } from './PreferencesTypes';
import { useAuth } from '@/hooks/useAuth';

interface PreferencesContextType {
  preferences: Preferences;
  setPreferences: React.Dispatch<React.SetStateAction<Preferences>>;
  socialMedia: SocialMediaConnections;
  setSocialMedia: React.Dispatch<React.SetStateAction<SocialMediaConnections>>;
  allowSocialMediaAnalysis: boolean;
  setAllowSocialMediaAnalysis: React.Dispatch<React.SetStateAction<boolean>>;
  activeTab: PreferencesTabType;
  setActiveTab: React.Dispatch<React.SetStateAction<PreferencesTabType>>;
  isProcessing: boolean;
  setIsProcessing: React.Dispatch<React.SetStateAction<boolean>>;
  toggleRelationshipType: (type: string) => void;
  toggleDealBreaker: (dealBreaker: string) => void;
  toggleItem: (item: string, category: 'hobbies' | 'interests' | 'personalityTraits' | 'valueAlignments') => void;
  handleImportanceChange: (key: keyof ImportanceValues, value: number[]) => void;
  handleSocialMediaChange: (platform: keyof SocialMediaConnections, value: string) => void;
  updatePreferences: (update: Partial<Preferences>) => void;
  user: any;
  hasChanges: boolean;
  resetChanges: () => void;
  savePreferences: () => Promise<boolean>;
}

const defaultImportanceValues: ImportanceValues = {
  appearance: 50,
  personality: 50,
  interests: 50,
  lifestyle: 50,
};

const defaultPreferences: Preferences = {
  lookingFor: [],
  ageRange: [18, 50],
  distance: 25,
  showMe: true,
  notifications: {
    matches: true,
    messages: true,
    nearby: true,
  },
  importanceValues: defaultImportanceValues,
  dealBreakers: [],
  hobbies: [],
  interests: [],
  personalityTraits: [],
  valueAlignments: [],
};

const defaultSocialMedia: SocialMediaConnections = {
  instagram: '',
  twitter: '',
  facebook: '',
  linkedin: '',
};

const PreferencesContext = createContext<PreferencesContextType | undefined>(undefined);

export const PreferencesProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [preferences, setPreferences] = useState<Preferences>(defaultPreferences);
  const [originalPreferences, setOriginalPreferences] = useState<Preferences>(defaultPreferences);
  const [socialMedia, setSocialMedia] = useState<SocialMediaConnections>(defaultSocialMedia);
  const [originalSocialMedia, setOriginalSocialMedia] = useState<SocialMediaConnections>(defaultSocialMedia);
  const [allowSocialMediaAnalysis, setAllowSocialMediaAnalysis] = useState(true);
  const [originalAllowSocialMediaAnalysis, setOriginalAllowSocialMediaAnalysis] = useState(true);
  const [activeTab, setActiveTab] = useState<PreferencesTabType>('basics');
  const [isProcessing, setIsProcessing] = useState(false);
  const [hasChanges, setHasChanges] = useState(false);
  const { user } = useAuth();

  // Load saved preferences from localStorage on mount
  useEffect(() => {
    const savedPreferences = localStorage.getItem('connect-preferences');
    
    if (savedPreferences) {
      try {
        const parsedData = JSON.parse(savedPreferences);
        
        if (parsedData.preferences) {
          setPreferences(parsedData.preferences);
          setOriginalPreferences(parsedData.preferences);
        }
        
        if (parsedData.socialMedia) {
          setSocialMedia(parsedData.socialMedia);
          setOriginalSocialMedia(parsedData.socialMedia);
        }
        
        if (parsedData.allowSocialMediaAnalysis !== undefined) {
          setAllowSocialMediaAnalysis(parsedData.allowSocialMediaAnalysis);
          setOriginalAllowSocialMediaAnalysis(parsedData.allowSocialMediaAnalysis);
        }
        
      } catch (error) {
        console.error('Error loading preferences:', error);
      }
    }
  }, []);

  // Check for changes when preferences or social media state updates
  useEffect(() => {
    const preferencesChanged = JSON.stringify(preferences) !== JSON.stringify(originalPreferences);
    const socialMediaChanged = JSON.stringify(socialMedia) !== JSON.stringify(originalSocialMedia);
    const analysisSettingChanged = allowSocialMediaAnalysis !== originalAllowSocialMediaAnalysis;
    
    setHasChanges(preferencesChanged || socialMediaChanged || analysisSettingChanged);
  }, [preferences, socialMedia, allowSocialMediaAnalysis, originalPreferences, originalSocialMedia, originalAllowSocialMediaAnalysis]);

  const toggleRelationshipType = (type: string) => {
    setPreferences(prev => ({
      ...prev,
      lookingFor: prev.lookingFor.includes(type) 
        ? prev.lookingFor.filter(t => t !== type)
        : [...prev.lookingFor, type]
    }));
  };

  const toggleDealBreaker = (dealBreaker: string) => {
    setPreferences(prev => ({
      ...prev,
      dealBreakers: prev.dealBreakers.includes(dealBreaker)
        ? prev.dealBreakers.filter(d => d !== dealBreaker)
        : [...prev.dealBreakers, dealBreaker]
    }));
  };

  const toggleItem = (item: string, category: 'hobbies' | 'interests' | 'personalityTraits' | 'valueAlignments') => {
    setPreferences(prev => ({
      ...prev,
      [category]: prev[category].includes(item)
        ? prev[category].filter(i => i !== item)
        : [...prev[category], item]
    }));
  };

  const handleImportanceChange = (key: keyof ImportanceValues, value: number[]) => {
    setPreferences(prev => ({
      ...prev,
      importanceValues: {
        ...prev.importanceValues,
        [key]: value[0]
      }
    }));
  };

  const handleSocialMediaChange = (platform: keyof SocialMediaConnections, value: string) => {
    setSocialMedia(prev => ({
      ...prev,
      [platform]: value
    }));
  };

  const updatePreferences = (update: Partial<Preferences>) => {
    setPreferences(prev => ({
      ...prev,
      ...update
    }));
  };

  const resetChanges = () => {
    setPreferences(originalPreferences);
    setSocialMedia(originalSocialMedia);
    setAllowSocialMediaAnalysis(originalAllowSocialMediaAnalysis);
  };

  const savePreferences = async (): Promise<boolean> => {
    setIsProcessing(true);
    
    try {
      // In a real app, you would save to a database here
      // For demo purposes, we're saving to localStorage
      localStorage.setItem('connect-preferences', JSON.stringify({
        preferences,
        socialMedia,
        allowSocialMediaAnalysis
      }));
      
      // Update the original state to reflect the saved values
      setOriginalPreferences(preferences);
      setOriginalSocialMedia(socialMedia);
      setOriginalAllowSocialMediaAnalysis(allowSocialMediaAnalysis);
      
      setHasChanges(false);
      return true;
    } catch (error) {
      console.error('Error saving preferences:', error);
      return false;
    } finally {
      setIsProcessing(false);
    }
  };

  return (
    <PreferencesContext.Provider value={{
      preferences,
      setPreferences,
      socialMedia,
      setSocialMedia,
      allowSocialMediaAnalysis,
      setAllowSocialMediaAnalysis,
      activeTab,
      setActiveTab,
      isProcessing,
      setIsProcessing,
      toggleRelationshipType,
      toggleDealBreaker,
      toggleItem,
      handleImportanceChange,
      handleSocialMediaChange,
      updatePreferences,
      user,
      hasChanges,
      resetChanges,
      savePreferences
    }}>
      {children}
    </PreferencesContext.Provider>
  );
};

export const usePreferences = () => {
  const context = useContext(PreferencesContext);
  if (context === undefined) {
    throw new Error('usePreferences must be used within a PreferencesProvider');
  }
  return context;
};
