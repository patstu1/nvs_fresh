
import React from 'react';
import { BarChart, Bar, PieChart, Pie, Cell, ResponsiveContainer, Tooltip } from 'recharts';
import { AreaChart, Area, XAxis, YAxis, CartesianGrid } from 'recharts';
import { ArrowLeft, Heart, PieChart as PieChartIcon, BarChart2, Users } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { useNavigate } from 'react-router-dom';
import { processProfileForAIMatching } from '@/utils/profileApi';
import { ChartContainer, ChartTooltip, ChartTooltipContent } from '@/components/ui/chart';

interface CompatibilityData {
  name: string;
  value: number;
  color: string;
}

interface ConnectionTrend {
  week: string;
  matches: number;
  messages: number;
}

interface CompatibilityFactor {
  category: string;
  score: number;
}

const StatsView: React.FC = () => {
  const navigate = useNavigate();
  const [activeTab, setActiveTab] = React.useState<'overall' | 'factors' | 'trends'>('overall');
  
  const compatibilityData: CompatibilityData[] = [
    { name: 'Lifestyle', value: 85, color: '#E6FFF4' },
    { name: 'Values', value: 92, color: '#9DE134' },
    { name: 'Interests', value: 78, color: '#33C3F0' },
    { name: 'Communication', value: 88, color: '#D3E4FD' },
  ];
  
  const connectionTrends: ConnectionTrend[] = [
    { week: 'Week 1', matches: 5, messages: 12 },
    { week: 'Week 2', matches: 7, messages: 18 },
    { week: 'Week 3', matches: 3, messages: 8 },
    { week: 'Week 4', matches: 9, messages: 22 },
  ];
  
  const compatibilityFactors: CompatibilityFactor[] = [
    { category: 'Lifestyle', score: 85 },
    { category: 'Values', score: 92 },
    { category: 'Interests', score: 78 },
    { category: 'Communication', score: 88 },
    { category: 'Hobbies', score: 72 },
    { category: 'Entertainment', score: 81 },
  ];
  
  const matchCounts = {
    total: 42,
    liked: 39,
    superLiked: 12,
    reciprocated: 23,
  };
  
  // Function to render the appropriate chart based on activeTab
  const renderChart = () => {
    switch (activeTab) {
      case 'overall':
        return (
          <div className="w-full h-64 flex flex-col">
            <div className="text-center mb-2 text-[#E6FFF4] text-sm">Overall Compatibility</div>
            <ResponsiveContainer width="100%" height="100%">
              <PieChart>
                <Pie
                  data={compatibilityData}
                  cx="50%"
                  cy="50%"
                  innerRadius={60}
                  outerRadius={90}
                  paddingAngle={5}
                  dataKey="value"
                  startAngle={90}
                  endAngle={-270}
                >
                  {compatibilityData.map((entry, index) => (
                    <Cell key={`cell-${index}`} fill={entry.color} />
                  ))}
                </Pie>
                <Tooltip
                  content={({ active, payload }) => {
                    if (active && payload && payload.length) {
                      return (
                        <div className="bg-black border border-[#E6FFF4] p-2 rounded">
                          <p className="text-[#E6FFF4]">{`${payload[0].name} : ${payload[0].value}%`}</p>
                        </div>
                      );
                    }
                    return null;
                  }}
                />
              </PieChart>
            </ResponsiveContainer>
            
            {/* Compatibility Score */}
            <div className="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 text-center">
              <p className="text-[#E6FFF4] text-4xl font-bold">86%</p>
              <p className="text-[#E6FFF4] text-xs">Compatibility</p>
            </div>
          </div>
        );
      
      case 'factors':
        return (
          <div className="w-full h-64">
            <div className="text-center mb-2 text-[#E6FFF4] text-sm">Compatibility Factors</div>
            <ResponsiveContainer width="100%" height="100%">
              <BarChart
                data={compatibilityFactors}
                layout="vertical"
                margin={{ top: 10, right: 10, bottom: 10, left: 80 }}
              >
                <CartesianGrid strokeDasharray="3 3" stroke="#444" />
                <XAxis type="number" domain={[0, 100]} stroke="#E6FFF4" />
                <YAxis dataKey="category" type="category" stroke="#E6FFF4" />
                <Tooltip
                  content={({ active, payload }) => {
                    if (active && payload && payload.length) {
                      return (
                        <div className="bg-black border border-[#E6FFF4] p-2 rounded">
                          <p className="text-[#E6FFF4]">{`${payload[0].name} : ${payload[0].value}%`}</p>
                        </div>
                      );
                    }
                    return null;
                  }}
                />
                <Bar dataKey="score" background={{ fill: '#333' }}>
                  {compatibilityFactors.map((entry, index) => (
                    <Cell key={`cell-${index}`} fill={index % 2 === 0 ? '#E6FFF4' : '#9DE134'} />
                  ))}
                </Bar>
              </BarChart>
            </ResponsiveContainer>
          </div>
        );
      
      case 'trends':
        return (
          <div className="w-full h-64">
            <div className="text-center mb-2 text-[#E6FFF4] text-sm">Connection Trends</div>
            <ResponsiveContainer width="100%" height="100%">
              <AreaChart
                data={connectionTrends}
                margin={{ top: 10, right: 10, bottom: 10, left: 10 }}
              >
                <defs>
                  <linearGradient id="colorMatches" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="5%" stopColor="#E6FFF4" stopOpacity={0.8}/>
                    <stop offset="95%" stopColor="#E6FFF4" stopOpacity={0.1}/>
                  </linearGradient>
                  <linearGradient id="colorMessages" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="5%" stopColor="#9DE134" stopOpacity={0.8}/>
                    <stop offset="95%" stopColor="#9DE134" stopOpacity={0.1}/>
                  </linearGradient>
                </defs>
                <CartesianGrid strokeDasharray="3 3" stroke="#444" />
                <XAxis dataKey="week" stroke="#E6FFF4" />
                <YAxis stroke="#E6FFF4" />
                <Tooltip
                  content={({ active, payload }) => {
                    if (active && payload && payload.length) {
                      return (
                        <div className="bg-black border border-[#E6FFF4] p-2 rounded">
                          {payload.map((entry, index) => (
                            <p key={index} className="text-[#E6FFF4]">
                              {`${entry.name}: ${entry.value}`}
                            </p>
                          ))}
                        </div>
                      );
                    }
                    return null;
                  }}
                />
                <Area type="monotone" dataKey="matches" stroke="#E6FFF4" fillOpacity={1} fill="url(#colorMatches)" />
                <Area type="monotone" dataKey="messages" stroke="#9DE134" fillOpacity={1} fill="url(#colorMessages)" />
              </AreaChart>
            </ResponsiveContainer>
          </div>
        );
      
      default:
        return null;
    }
  };

  return (
    <div className="min-h-screen bg-black text-[#E6FFF4] p-4">
      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <Button 
          variant="ghost" 
          size="icon" 
          onClick={() => navigate(-1)}
          className="text-[#E6FFF4]"
        >
          <ArrowLeft className="h-6 w-6" />
        </Button>
        <h1 className="text-2xl font-bold text-[#E6FFF4]">CONNECT STATS</h1>
        <div className="w-10"></div> {/* Spacer for alignment */}
      </div>
      
      {/* Stats Cards */}
      <div className="grid grid-cols-2 gap-4 mb-6">
        <div 
          className="bg-black border border-[#E6FFF4] rounded-xl p-4 text-center"
          style={{ boxShadow: '0 0 10px rgba(230, 255, 244, 0.3)' }}
        >
          <p className="text-3xl font-bold text-[#E6FFF4]">{matchCounts.total}</p>
          <p className="text-xs text-[#E6FFF4]">Total Profiles</p>
        </div>
        <div 
          className="bg-black border border-[#E6FFF4] rounded-xl p-4 text-center"
          style={{ boxShadow: '0 0 10px rgba(230, 255, 244, 0.3)' }}
        >
          <p className="text-3xl font-bold text-[#E6FFF4]">{matchCounts.liked}</p>
          <p className="text-xs text-[#E6FFF4]">Liked</p>
        </div>
        <div 
          className="bg-black border border-[#E6FFF4] rounded-xl p-4 text-center"
          style={{ boxShadow: '0 0 10px rgba(230, 255, 244, 0.3)' }}
        >
          <p className="text-3xl font-bold text-[#E6FFF4]">{matchCounts.superLiked}</p>
          <p className="text-xs text-[#E6FFF4]">Super Liked</p>
        </div>
        <div 
          className="bg-black border border-[#E6FFF4] rounded-xl p-4 text-center"
          style={{ boxShadow: '0 0 10px rgba(230, 255, 244, 0.3)' }}
        >
          <p className="text-3xl font-bold text-[#E6FFF4]">{matchCounts.reciprocated}</p>
          <p className="text-xs text-[#E6FFF4]">Connections</p>
        </div>
      </div>
      
      {/* Chart Navigation */}
      <div className="flex justify-center space-x-2 mb-6">
        <Button
          variant={activeTab === 'overall' ? 'default' : 'outline'}
          onClick={() => setActiveTab('overall')}
          className={`border border-[#E6FFF4] ${activeTab === 'overall' ? 'bg-[#E6FFF4] text-black' : 'bg-black text-[#E6FFF4]'}`}
        >
          <PieChartIcon className="w-4 h-4 mr-2" />
          Overall
        </Button>
        <Button
          variant={activeTab === 'factors' ? 'default' : 'outline'}
          onClick={() => setActiveTab('factors')}
          className={`border border-[#E6FFF4] ${activeTab === 'factors' ? 'bg-[#E6FFF4] text-black' : 'bg-black text-[#E6FFF4]'}`}
        >
          <BarChart2 className="w-4 h-4 mr-2" />
          Factors
        </Button>
        <Button
          variant={activeTab === 'trends' ? 'default' : 'outline'}
          onClick={() => setActiveTab('trends')}
          className={`border border-[#E6FFF4] ${activeTab === 'trends' ? 'bg-[#E6FFF4] text-black' : 'bg-black text-[#E6FFF4]'}`}
        >
          <Users className="w-4 h-4 mr-2" />
          Trends
        </Button>
      </div>
      
      {/* Chart Section */}
      <div 
        className="relative h-72 border border-[#E6FFF4] rounded-xl p-4 mb-6"
        style={{ boxShadow: '0 0 10px rgba(230, 255, 244, 0.3)' }}
      >
        {renderChart()}
      </div>
      
      {/* Compatibility Rating */}
      <div 
        className="border border-[#E6FFF4] rounded-xl p-4"
        style={{ boxShadow: '0 0 10px rgba(230, 255, 244, 0.3)' }}
      >
        <h3 className="text-lg font-bold text-[#E6FFF4] mb-3">AI Compatibility Rating</h3>
        <p className="text-[#E6FFF4] text-sm mb-3">
          Based on your profile data, our AI has analyzed your compatibility with potential matches.
          Your overall score is <span className="font-bold">86%</span>, which is higher than 72% of users.
        </p>
        <div className="flex justify-between items-center">
          <p className="text-[#E6FFF4] text-xs">Most compatible with: Value-driven, active lifestyles</p>
          <Button 
            variant="outline" 
            size="sm"
            className="border border-[#E6FFF4] text-[#E6FFF4] hover:bg-[#E6FFF4] hover:text-black"
            onClick={() => navigate('/profile-setup')}
          >
            Improve Score
          </Button>
        </div>
      </div>
    </div>
  );
};

export default StatsView;
