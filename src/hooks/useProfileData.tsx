
import { useState, useEffect } from 'react';
import { useParams, useLocation } from 'react-router-dom';
import { DetailedUserProfile } from '@/types/ProfileTypes';
import { TabType } from '@/types/TabTypes';

const userProfiles: Record<string, DetailedUserProfile> = {
  '1': {
    id: '1',
    image: 'https://images.unsplash.com/photo-1504257432389-52343af06ae3?w=500&h=500&fit=crop',
    name: 'Alex',
    emojis: ['🔥', '💪'],
    distance: 0.8,
    age: 28,
    lastActive: '2 min ago',
    bio: 'Gym rat looking for workout buddies',
    metrics: {
      height: 183,
      weight: 82,
      position: 'vers',
      bodyType: 'muscular',
      ethnicity: 'white',
    },
    preferences: {
      lookingFor: ['dates', 'friends', 'networking'],
      tribes: ['jock', 'muscle'],
      acceptsNsfw: true,
      meetingPreference: 'dates',
    },
    social: {
      instagram: '@alex_fit',
    },
    isOnline: true,
    verifiedPhotos: true,
    nowContent: {
      nsfwAvatar: 'https://images.unsplash.com/photo-1543610892-0b1f7e6d8ac1?w=500&h=500&fit=crop',
      nsfwBio: 'Looking for right now. Hit me up if interested.',
      nsfwAlbum: [
        'https://images.unsplash.com/photo-1623091411395-09e79fdbfcf3?w=500&h=500&fit=crop',
        'https://images.unsplash.com/photo-1543610892-0b1f7e6d8ac1?w=500&h=500&fit=crop',
      ]
    },
    sectionPreferences: {
      lineup: {
        showFace: true,
        showBio: true,
        showTags: true,
        showMetrics: true
      },
      now: {
        showFace: false,
        showBio: true,
        anonymousMode: true,
        allowNsfw: true,
        useAlternateAvatar: true
      },
      connect: {
        curatedPhotosOnly: true,
        emphasizeCompatibility: true,
        showDetailedBio: true
      },
      live: {
        showBio: true,
        showTags: true,
        useCasualPhotos: true,
        anonymousMode: false
      }
    }
  },
  '2': {
    id: '2',
    image: 'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=500&h=500&fit=crop',
    name: 'Brandon',
    emojis: ['💦', '🍑'],
    distance: 1.2,
    age: 23,
    lastActive: 'Online',
    bio: 'Recent grad, new to the area',
    metrics: {
      height: 175,
      weight: 68,
      position: 'vers',
      bodyType: 'slim',
      ethnicity: 'latino',
    },
    preferences: {
      lookingFor: ['chat', 'right now'],
      tribes: ['twink'],
      acceptsNsfw: false,
      meetingPreference: 'chat',
    },
    social: {
      instagram: '@brandon_fit',
    },
    isOnline: false,
    verifiedPhotos: false,
    sectionPreferences: {
      lineup: {
        showFace: true,
        showBio: true,
        showTags: true,
        showMetrics: true
      },
      now: {
        showFace: true,
        showBio: false,
        anonymousMode: false,
        allowNsfw: false,
        useAlternateAvatar: false
      },
      connect: {
        curatedPhotosOnly: true,
        emphasizeCompatibility: true,
        showDetailedBio: false
      },
      live: {
        showBio: false,
        showTags: false,
        useCasualPhotos: true,
        anonymousMode: true
      }
    }
  },
};

export const useProfileData = () => {
  const { id } = useParams<{ id: string }>();
  const location = useLocation();
  const [isBlocked, setIsBlocked] = useState(false);
  const [isFavorite, setIsFavorite] = useState(false);
  const [currentCity, setCurrentCity] = useState({ name: 'Your Location', country: '' });
  const [showPrivateAlbumRequest, setShowPrivateAlbumRequest] = useState(false);
  const [activeSection, setActiveSection] = useState<TabType>('grid');
  
  useEffect(() => {
    const params = new URLSearchParams(location.search);
    const section = params.get('section');
    if (section === 'map') setActiveSection('map');
    else if (section === 'connect') setActiveSection('connect');
    else if (section === 'rooms') setActiveSection('rooms');
    else setActiveSection('grid');
  }, [location]);

  const profile = userProfiles[id || '1'];

  return {
    profile,
    isBlocked,
    setIsBlocked,
    isFavorite,
    setIsFavorite,
    currentCity,
    setCurrentCity,
    showPrivateAlbumRequest,
    setShowPrivateAlbumRequest,
    activeSection,
    setActiveSection
  };
};
