import { useState, useEffect, useCallback } from 'react';
import { toast } from '@/hooks/use-toast';
import { Profile } from '../types/ConnectTypes';
import soundManager from '@/utils/soundManager';
import { useNavigate } from 'react-router-dom';
import { Shield, Activity, Radar, Database } from 'lucide-react';

const testProfiles: Profile[] = [
  {
    id: '1',
    name: 'Michael',
    age: 28,
    image: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=500&h=500&fit=crop',
    compatibility: 87,
    interests: ['Gym', 'Gaming', 'Hiking', 'Photography'],
    bio: 'Looking for meaningful connections and fun times. Big into fitness and outdoor activities.',
    emojis: ['🏋️', '🎮', '🍻'],
    distance: 2.4,
    role: 'Vers Top',
    attributes: [
      { icon: <Shield className="w-4 h-4 text-[#AAFF50]" />, label: 'Values', value: 'High Match', color: 'text-[#AAFF50]' },
      { icon: <Activity className="w-4 h-4 text-[#C2FFE6]" />, label: 'Energy', value: '92%', color: 'text-[#C2FFE6]' },
      { icon: <Radar className="w-4 h-4 text-purple-400" />, label: 'Interests', value: '78%', color: 'text-purple-400' },
      { icon: <Database className="w-4 h-4 text-blue-400" />, label: 'Compatibility', value: '87%', color: 'text-blue-400' }
    ]
  },
  {
    id: '2',
    name: 'David',
    age: 31,
    image: 'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=500&h=500&fit=crop',
    compatibility: 92,
    interests: ['Travel', 'Cooking', 'Music', 'Film'],
    bio: 'Adventure seeker with a passion for cooking and exploring new places. Always looking for new experiences.',
    emojis: ['✈️', '🍳', '🎵'],
    distance: 4.7,
    role: 'Vers',
    attributes: [
      { icon: <Shield className="w-4 h-4 text-[#AAFF50]" />, label: 'Values', value: 'Very High', color: 'text-[#AAFF50]' },
      { icon: <Activity className="w-4 h-4 text-[#C2FFE6]" />, label: 'Energy', value: '86%', color: 'text-[#C2FFE6]' },
      { icon: <Radar className="w-4 h-4 text-purple-400" />, label: 'Interests', value: '95%', color: 'text-purple-400' },
      { icon: <Database className="w-4 h-4 text-blue-400" />, label: 'Compatibility', value: '92%', color: 'text-blue-400' }
    ]
  },
  {
    id: '3',
    name: 'Alex',
    age: 26,
    image: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=500&h=500&fit=crop',
    compatibility: 73,
    interests: ['Tech', 'Reading', 'Fitness', 'Coffee'],
    bio: 'Tech enthusiast working in AI. Love a good book and my daily workout routine. Let\'s grab coffee!',
    emojis: ['💻', '📚', '☕'],
    distance: 1.8,
    role: 'Bottom',
    attributes: [
      { icon: <Shield className="w-4 h-4 text-yellow-400" />, label: 'Values', value: 'Medium', color: 'text-yellow-400' },
      { icon: <Activity className="w-4 h-4 text-[#C2FFE6]" />, label: 'Energy', value: '78%', color: 'text-[#C2FFE6]' },
      { icon: <Radar className="w-4 h-4 text-purple-400" />, label: 'Interests', value: '68%', color: 'text-purple-400' },
      { icon: <Database className="w-4 h-4 text-blue-400" />, label: 'Compatibility', value: '73%', color: 'text-blue-400' }
    ]
  }
];

export const useProfileManagement = () => {
  const navigate = useNavigate();
  const [profileIndex, setProfileIndex] = useState(0);
  const [currentProfile, setCurrentProfile] = useState<Profile | null>(null);
  const [showConnectionConfirmation, setShowConnectionConfirmation] = useState(false);
  const [isTransitioning, setIsTransitioning] = useState(false);

  useEffect(() => {
    if (testProfiles && testProfiles.length > 0) {
      setCurrentProfile(testProfiles[profileIndex]);
      console.log("Set current profile:", testProfiles[profileIndex]);
    } else {
      console.warn("No test profiles available!");
    }
  }, [profileIndex]);

  const nextProfile = useCallback(() => {
    if (!testProfiles || testProfiles.length === 0) {
      console.error("No profiles available");
      return;
    }
    
    setIsTransitioning(true);
    setTimeout(() => {
      const newIndex = (profileIndex + 1) % testProfiles.length;
      setProfileIndex(newIndex);
      setIsTransitioning(false);
    }, 300);
  }, [profileIndex]);

  const handleLike = useCallback(() => {
    toast({
      title: "Liked!",
      description: `You liked ${currentProfile?.name}`,
    });
    
    if (Math.random() < 0.3) {
      setShowConnectionConfirmation(true);
      try {
        soundManager.play('yo', 0.5);
      } catch (error) {
        console.error('Error playing sound:', error);
      }
    } else {
      nextProfile();
    }
  }, [currentProfile, nextProfile]);

  const handlePass = useCallback(() => {
    if (currentProfile) {
      toast({
        title: "Passed",
        description: `You passed on ${currentProfile.name}`,
      });
    }
    nextProfile();
  }, [currentProfile, nextProfile]);

  const handleSuperLike = useCallback(() => {
    try {
      soundManager.play('yo', 0.5);
    } catch (error) {
      console.error('Error playing sound:', error);
    }
    
    if (currentProfile) {
      toast({
        title: "Super Like!",
        description: `You super liked ${currentProfile.name}!`,
      });
    }
    
    if (Math.random() < 0.7) {
      setShowConnectionConfirmation(true);
    } else {
      nextProfile();
    }
  }, [currentProfile, nextProfile]);

  const handleCloseConfirmation = useCallback(() => {
    setShowConnectionConfirmation(false);
    nextProfile();
  }, [nextProfile]);

  const handleMessageMatch = useCallback(() => {
    if (currentProfile) {
      toast({
        title: "Message Sent",
        description: `Opening chat with ${currentProfile.name}`,
      });
      navigate(`/chat/${currentProfile.id}`);
    }
  }, [currentProfile, navigate]);

  return {
    currentProfile,
    showConnectionConfirmation,
    isTransitioning,
    handleLike,
    handlePass,
    handleSuperLike,
    handleCloseConfirmation,
    handleMessageMatch,
    nextProfile
  };
};
