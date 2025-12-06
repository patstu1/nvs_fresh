
import { useState, useCallback, useEffect } from 'react';
import { toast } from '@/hooks/use-toast';
import soundManager from '@/utils/soundManager';
import { FilterSettings } from '@/types/MapTypes';

export const useMapState = () => {
  const [selectedUser, setSelectedUser] = useState<any>(null);
  const [selectedVenue, setSelectedVenue] = useState<any>(null);
  const [showHeatMap, setShowHeatMap] = useState(false);
  const [anonymousMode, setAnonymousMode] = useState(true); // Default to true for NOW section
  const [is3DMode, setIs3DMode] = useState(true);
  const [showAnonymousSetup, setShowAnonymousSetup] = useState(false);
  const [showAnonymousProfileDialog, setShowAnonymousProfileDialog] = useState(false);
  const [isAnonymousProfileCreated, setIsAnonymousProfileCreated] = useState(false);
  const [showChatOverlay, setShowChatOverlay] = useState(false);
  // Initialize profileFilters with all required properties from the FilterSettings interface
  const [profileFilters, setProfileFilters] = useState<FilterSettings>({
    showOnline: false,
    showNew: false,
    distance: 50,
    ageRange: [18, 50],
    hasPhotos: false,
    hostingType: 'all'
  });
  const [showNOWWarning, setShowNOWWarning] = useState(false);
  const [showProfileEditor, setShowProfileEditor] = useState(false);
  
  // Load anonymous mode preference from localStorage
  useEffect(() => {
    const savedMode = localStorage.getItem('anonymousMode');
    if (savedMode) {
      setAnonymousMode(savedMode === 'true');
    } else {
      // Default to anonymous mode in NOW section
      setAnonymousMode(true);
      localStorage.setItem('anonymousMode', 'true');
    }
  }, []);

  const toggleAnonymousMode = useCallback(() => {
    if (!isAnonymousProfileCreated && !anonymousMode) {
      setShowProfileEditor(true);
      return;
    }
    
    const newMode = !anonymousMode;
    setAnonymousMode(newMode);
    localStorage.setItem('anonymousMode', newMode.toString());
    
    try {
      soundManager.play('yo');
    } catch (error) {
      console.error('Error playing sound:', error);
    }
    
    toast({
      title: newMode ? "Anonymous Mode On" : "Visibility On",
      description: newMode 
        ? "You are now hidden from other users on the map" 
        : "Other users can now see you on the map",
      variant: newMode ? "destructive" : "default",
    });
  }, [anonymousMode, isAnonymousProfileCreated]);

  const toggle3DMode = useCallback(() => {
    setIs3DMode(!is3DMode);
    toast({
      title: !is3DMode ? "3D Mode Enabled" : "3D Mode Disabled",
      description: !is3DMode 
        ? "Enhanced 3D visualization activated" 
        : "Switched to standard map view",
    });
  }, [is3DMode]);

  return {
    selectedUser,
    setSelectedUser,
    selectedVenue,
    setSelectedVenue,
    showHeatMap,
    setShowHeatMap,
    anonymousMode,
    setAnonymousMode,
    is3DMode,
    setIs3DMode,
    showAnonymousSetup,
    setShowAnonymousSetup,
    showAnonymousProfileDialog,
    setShowAnonymousProfileDialog,
    isAnonymousProfileCreated,
    setIsAnonymousProfileCreated,
    showChatOverlay,
    setShowChatOverlay,
    profileFilters,
    setProfileFilters,
    showNOWWarning,
    setShowNOWWarning,
    showProfileEditor,
    setShowProfileEditor,
    toggleAnonymousMode,
    toggle3DMode
  };
};
