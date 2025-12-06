
import React from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, TrendingUp, HeartHandshake, Eye, Zap, Activity, BarChart4, Users, Star } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { motion } from 'framer-motion';
import { ChartContainer, ChartTooltip, ChartLegend } from '@/components/ui/chart';
import { BarChart, Bar, XAxis, YAxis, ResponsiveContainer } from 'recharts';

const ConnectStatsView: React.FC = () => {
  const navigate = useNavigate();
  
  // Sample data for charts
  const activityData = [
    { name: 'Monday', views: 24, likes: 12, matches: 3 },
    { name: 'Tuesday', views: 18, likes: 8, matches: 1 },
    { name: 'Wednesday', views: 30, likes: 15, matches: 4 },
    { name: 'Thursday', views: 25, likes: 10, matches: 2 },
    { name: 'Friday', views: 45, likes: 25, matches: 6 },
    { name: 'Saturday', views: 50, likes: 28, matches: 7 },
    { name: 'Sunday', views: 35, likes: 17, matches: 3 },
  ];
  
  const compatibilityData = [
    { name: 'Social', value: 78 },
    { name: 'Values', value: 92 },
    { name: 'Interests', value: 65 },
    { name: 'Physical', value: 84 },
  ];
  
  const engagementData = [
    { name: 'Profile Views', value: 227, fill: '#C2FFE6' },
    { name: 'Likes Given', value: 115, fill: '#00FF88' },
    { name: 'Matches', value: 26, fill: '#FF3B5C' },
    { name: 'Messages', value: 84, fill: '#4BEFE0' },
  ];
  
  return (
    <div className="flex flex-col w-full min-h-screen bg-[#0A0A1A] pt-16 pb-24 relative overflow-hidden">
      {/* Neon grid background effect */}
      <div className="absolute inset-0 bg-[#0A0A1A] bg-opacity-90 pointer-events-none" style={{
        backgroundImage: 'linear-gradient(rgba(0, 255, 255, 0.03) 1px, transparent 1px), linear-gradient(90deg, rgba(0, 255, 255, 0.03) 1px, transparent 1px)',
        backgroundSize: '20px 20px',
      }} />
      
      <div className="px-4 py-4 relative z-10">
        <div className="flex items-center mb-6">
          <Button 
            onClick={() => navigate('/connect')}
            variant="ghost" 
            size="icon"
            className="text-[#00BBAA] hover:text-[#4BEFE0] hover:bg-[#4BEFE0]/10 transition-all duration-300 neon-glow"
          >
            <ArrowLeft className="w-5 h-5" />
          </Button>
          <h1 className="text-xl font-bold neon-text-subtle tracking-wider ml-4">Connection Stats</h1>
        </div>
        
        {/* Summary Statistics */}
        <motion.div 
          className="grid grid-cols-2 gap-4 mb-6"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.4 }}
        >
          {/* Enhanced stat boxes with more vibrant neon effects */}
          <div className="bg-[#181830] rounded-lg p-4 border border-[#4BEFE0]/50 transform transition-all duration-300 hover:scale-105 hover:border-[#00BBAA]/80 neon-glow">
            <div className="flex items-center mb-2">
              <HeartHandshake className="w-5 h-5 text-[#FF3B5C] mr-2 animate-pulse" />
              <span className="text-sm text-[#8AFFF0]">Match Rate</span>
            </div>
            <p className="text-2xl font-bold text-[#FACC15] neon-text-subtle">23%</p>
          </div>
          
          {/* Similar styling for other stat boxes */}
          <div className="bg-[#181830] rounded-lg p-4 border border-[#4BEFE0]/50 transform transition-all duration-300 hover:scale-105 hover:border-[#00BBAA]/80 neon-glow">
            <div className="flex items-center mb-2">
              <Eye className="w-5 h-5 text-[#4BEFE0] mr-2 animate-pulse" />
              <span className="text-sm text-[#8AFFF0]">Profile Views</span>
            </div>
            <p className="text-2xl font-bold text-[#FACC15] neon-text-subtle">227</p>
          </div>
          
          <div className="bg-[#181830] rounded-lg p-4 border border-[#4BEFE0]/50 transform transition-all duration-300 hover:scale-105 hover:border-[#00BBAA]/80 neon-glow">
            <div className="flex items-center mb-2">
              <Zap className="w-5 h-5 text-[#FF00FF] mr-2" />
              <span className="text-sm text-[#C2FFE6]">Super Likes</span>
            </div>
            <p className="text-2xl font-bold text-[#E6FFF4] neon-text-subtle">12</p>
          </div>
          
          <div className="bg-[#181830] rounded-lg p-4 border border-[#4BEFE0]/50 transform transition-all duration-300 hover:scale-105 hover:border-[#00BBAA]/80 neon-glow">
            <div className="flex items-center mb-2">
              <Activity className="w-5 h-5 text-[#C2FFE6] mr-2" />
              <span className="text-sm text-[#C2FFE6]">Avg. Compatibility</span>
            </div>
            <p className="text-2xl font-bold text-[#E6FFF4] neon-text-subtle">78%</p>
          </div>
        </motion.div>
        
        {/* Weekly Activity Chart with more neon styling */}
        <motion.div 
          className="mb-6 bg-[#181830] rounded-lg p-4 border border-[#4BEFE0]/50 neon-glow"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.4, delay: 0.1 }}
        >
          <div className="flex items-center mb-4">
            <BarChart4 className="w-5 h-5 text-[#8AFFF0] mr-2 animate-pulse" />
            <h2 className="text-lg font-medium text-[#4BEFE0] neon-text-subtle">Weekly Activity</h2>
          </div>
          
          <div className="h-64">
            <ChartContainer
              config={{
                views: { theme: { light: '#4BEFE0', dark: '#4BEFE0' } },
                likes: { theme: { light: '#00FF88', dark: '#00FF88' } },
                matches: { theme: { light: '#FF3B5C', dark: '#FF3B5C' } },
              }}
            >
              <ResponsiveContainer width="100%" height="100%">
                <BarChart data={activityData}>
                  <XAxis 
                    dataKey="name"
                    axisLine={{ stroke: '#8AFFF0' }}
                    tickLine={false}
                    tick={{ fill: '#4BEFE0', fontSize: 12 }}
                  />
                  <YAxis 
                    axisLine={{ stroke: '#8AFFF0' }}
                    tickLine={false}
                    tick={{ fill: '#4BEFE0', fontSize: 12 }}
                  />
                  <ChartTooltip 
                    contentStyle={{
                      backgroundColor: 'rgba(24, 24, 48, 0.9)',
                      border: '1px solid #4BEFE0',
                      borderRadius: '4px',
                    }}
                  />
                  <Bar dataKey="views" name="Profile Views" fill="#4BEFE0" radius={[4, 4, 0, 0]} />
                  <Bar dataKey="likes" name="Likes" fill="#00FF88" radius={[4, 4, 0, 0]} />
                  <Bar dataKey="matches" name="Matches" fill="#FF3B5C" radius={[4, 4, 0, 0]} />
                  <ChartLegend />
                </BarChart>
              </ResponsiveContainer>
            </ChartContainer>
          </div>
        </motion.div>
        
        {/* AI Compatibility Profile with enhanced neon effects */}
        <motion.div 
          className="mb-6 bg-[#181830] rounded-lg p-4 border border-[#4BEFE0]/50 neon-glow"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.4, delay: 0.2 }}
        >
          <div className="flex items-center mb-4">
            <Star className="w-5 h-5 text-[#FACC15] mr-2 animate-pulse" />
            <h2 className="text-lg font-medium text-[#4BEFE0] neon-text-subtle">AI Compatibility Profile</h2>
          </div>
          
          <div className="space-y-2">
            {compatibilityData.map((item) => (
              <div key={item.name} className="flex items-center">
                <span className="w-24 text-[#8AFFF0]">{item.name}</span>
                <div className="flex-1 h-2 bg-black/50 rounded-full overflow-hidden">
                  <div 
                    className="h-full bg-[#00FF88]"
                    style={{ 
                      width: `${item.value}%`,
                      boxShadow: '0 0 10px #00FF88'
                    }}
                  />
                </div>
                <span className="ml-2 text-[#4BEFE0]">{item.value}%</span>
              </div>
            ))}
          </div>
        </motion.div>
      </div>
    </div>
  );
};

export default ConnectStatsView;
