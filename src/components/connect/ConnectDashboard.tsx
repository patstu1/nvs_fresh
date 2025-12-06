
import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { motion, AnimatePresence } from 'framer-motion';
import { RecentMatch } from './types/ConnectTypes';
import ConnectHeader from './components/ConnectHeader';
import ProfileStats from './components/ProfileStats';
import RecentMatchCard from './components/RecentMatchCard';
import ConnectInsights from './components/ConnectInsights';
import { cn } from '@/lib/utils';
import { BarChart2, Heart, Star, Zap, User, Clock, MessageSquare, Shield, Target, Wifi } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Progress } from '@/components/ui/progress'; 
import { Card, CardContent } from '@/components/ui/card';
import AIIcebreaker from './AIIcebreaker';

interface ConnectDashboardProps {
  onStartMatching?: () => void;
}

const ConnectDashboard: React.FC<ConnectDashboardProps> = ({ onStartMatching }) => {
  const navigate = useNavigate();
  const [selectedMatch, setSelectedMatch] = useState<RecentMatch | null>(null);
  const [showPulse, setShowPulse] = useState(true);
  const [activeTab, setActiveTab] = useState<'matches' | 'insights'>('matches');
  const [icebreaker, setIcebreaker] = useState('');
  
  const userProfileData = React.useMemo(() => {
    const storedProfile = localStorage.getItem('connect-user-profile');
    if (storedProfile) {
      return JSON.parse(storedProfile);
    }
    return null;
  }, []);

  // Define default stats for the user profile
  const defaultStats = {
    neuralSync: 85,
    quantumCoherence: 92
  };

  const recentMatches: RecentMatch[] = [
    { 
      id: '1',
      name: 'Alex', 
      image: 'https://images.unsplash.com/photo-1504257432389-52343af06ae3?w=500&h=500&fit=crop', 
      compatibility: 92,
      isNew: true,
      interests: ['Gym', 'Travel', 'Music'],
      lastActive: '2h ago',
      connectionStrength: 87
    },
    { 
      id: '2',
      name: 'Jordan', 
      image: 'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=500&h=500&fit=crop', 
      compatibility: 88,
      isNew: true,
      interests: ['Art', 'Food', 'Hiking'],
      lastActive: '5m ago',
      connectionStrength: 76
    },
    { 
      id: '3',
      name: 'Taylor', 
      image: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=500&h=500&fit=crop', 
      compatibility: 85,
      isNew: false,
      interests: ['Books', 'Tech', 'Movies'],
      lastActive: '1d ago',
      connectionStrength: 65
    },
  ];
  
  useEffect(() => {
    // Pulse effect for scanning animation
    const pulseInterval = setInterval(() => {
      setShowPulse(prev => !prev);
    }, 3000);
    
    // Generate initial icebreaker
    if (selectedMatch) {
      setIcebreaker(getAiIcebreaker(selectedMatch));
    }
    
    return () => clearInterval(pulseInterval);
  }, [selectedMatch]);
  
  const handleViewStats = () => {
    navigate('/connect-stats');
  };
  
  const handleStartMatching = () => {
    if (onStartMatching) {
      onStartMatching();
    } else {
      navigate('/');
    }
  };
  
  const handleViewMatch = (match: RecentMatch) => {
    setSelectedMatch(match);
    setIcebreaker(getAiIcebreaker(match));
  };
  
  const handleMessageMatch = (id: string) => {
    navigate(`/messages/${id}`);
  };
  
  const refreshIcebreaker = () => {
    if (selectedMatch) {
      setIcebreaker(getAiIcebreaker(selectedMatch));
    }
  };

  const getAiIcebreaker = (match: RecentMatch | null) => {
    if (!match) return "";
    
    const icebreakers = [
      `You both love ${match.interests[0]}. Ask about their favorite ${match.interests[0]} spots.`,
      `The AI sees a ${match.compatibility}% neural sync match! Your digital signatures resonate at complementary frequencies.`,
      `Try asking about their experience with ${match.interests[Math.floor(Math.random() * match.interests.length)]}.`,
      `Your mutual wavelength is strongest in the ${match.interests[0]} dimension. Explore this connection.`,
      `Quantum analysis suggests opening with a question about ${match.interests[Math.floor(Math.random() * match.interests.length)]}.`
    ];
    
    return icebreakers[Math.floor(Math.random() * icebreakers.length)];
  };

  const getRadialProgressBackground = (value: number) => {
    return `conic-gradient(from 0deg, #00FFCC ${value}%, transparent ${value}%, transparent 100%)`;
  };

  return (
    <div className="p-4 max-w-md mx-auto bg-black overflow-hidden">
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        className="relative"
      >
        <div className="absolute inset-0 pointer-events-none z-0 opacity-20">
          <div className="absolute inset-0 bg-[url('data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPjxkZWZzPjxwYXR0ZXJuIGlkPSJncmlkIiB3aWR0aD0iMjAiIGhlaWdodD0iMjAiIHBhdHRlcm5Vbml0cz0idXNlclNwYWNlT25Vc2UiPjxwYXRoIGQ9Ik0gMjAgMCBMIDAgMCAwIDIwIiBmaWxsPSJub25lIiBzdHJva2U9IiMwMEZGQ0MiIHN0cm9rZS13aWR0aD0iMC41Ii8+PC9wYXR0ZXJuPjwvZGVmcz48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSJ1cmwoI2dyaWQpIiAvPjwvc3ZnPg==')] opacity-20"></div>
          <motion.div 
            className="absolute top-0 left-0 right-0 h-[2px] bg-[#00FFCC]/40"
            animate={{ 
              y: ["0%", "100%", "0%"],
            }}
            transition={{ 
              repeat: Infinity, 
              duration: 8,
              ease: "linear"
            }}
          />
          <div className="cyberpunk-noise"></div>
        </div>

        <div className="relative z-10">
          <ConnectHeader 
            userProfileData={userProfileData}
            onViewStats={handleViewStats}
            onStartMatching={handleStartMatching}
          />

          {userProfileData && (
            <ProfileStats 
              userProfileData={userProfileData} 
              stats={defaultStats}
            />
          )}

          <div className="flex border-b border-[#00FFCC]/20 mb-4">
            <button 
              className={cn(
                "flex-1 py-2 text-sm font-medium",
                activeTab === 'matches' 
                  ? "text-[#00FFCC] border-b-2 border-[#00FFCC]" 
                  : "text-[#B4FFE0]/60 hover:text-[#B4FFE0]"
              )}
              onClick={() => setActiveTab('matches')}
            >
              Neural Connections
            </button>
            <button 
              className={cn(
                "flex-1 py-2 text-sm font-medium",
                activeTab === 'insights' 
                  ? "text-[#00FFCC] border-b-2 border-[#00FFCC]" 
                  : "text-[#B4FFE0]/60 hover:text-[#B4FFE0]"
              )}
              onClick={() => setActiveTab('insights')}
            >
              Quantum Insights
            </button>
          </div>
          
          <AnimatePresence mode="wait">
            {activeTab === 'matches' && (
              <motion.div
                key="matches"
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                exit={{ opacity: 0, y: -10 }}
                transition={{ duration: 0.2 }}
              >
                <h3 className="text-lg font-bold text-[#00FFCC] mb-3 neon-text-subtle">Recent Connections</h3>
                <div className="space-y-3 mb-6">
                  {recentMatches.map(match => (
                    <RecentMatchCard
                      key={match.id}
                      match={match}
                      isSelected={selectedMatch?.id === match.id}
                      onClick={() => handleViewMatch(match)}
                      getRadialProgressBackground={getRadialProgressBackground}
                    />
                  ))}
                </div>
              </motion.div>
            )}
            
            {activeTab === 'insights' && (
              <motion.div
                key="insights"
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                exit={{ opacity: 0, y: -10 }}
                transition={{ duration: 0.2 }}
              >
                <ConnectInsights userProfileData={userProfileData} />
              </motion.div>
            )}
          </AnimatePresence>
        </div>
      </motion.div>
    </div>
  );
};

export default ConnectDashboard;
