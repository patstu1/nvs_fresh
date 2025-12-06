
import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useWaitlist } from '@/hooks/useWaitlist';
import { useAuth } from '@/hooks/useAuth';
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Switch } from '@/components/ui/switch';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { toast } from '@/hooks/use-toast';
import { BarChart, Bar, XAxis, YAxis, ResponsiveContainer, Tooltip } from 'recharts';
import { File, Users, Search, MapPin, RefreshCw } from 'lucide-react';

const WaitlistAdmin = () => {
  const { user, loading } = useAuth();
  const { isWaitlistActive, toggleWaitlist, approveUser, getAdminWaitlistStats } = useWaitlist();
  const [stats, setStats] = useState<any>(null);
  const [searchQuery, setSearchQuery] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const navigate = useNavigate();
  
  // Mock data for waitlisted users
  const [waitlistedUsers] = useState([
    { id: '1', email: 'user1@example.com', username: 'user1', joinedAt: '2023-04-01', location: 'New York' },
    { id: '2', email: 'user2@example.com', username: 'user2', joinedAt: '2023-04-02', location: 'Los Angeles' },
    { id: '3', email: 'user3@example.com', username: 'user3', joinedAt: '2023-04-03', location: 'Chicago' },
    { id: '4', email: 'user4@example.com', username: 'user4', joinedAt: '2023-04-04', location: 'Miami' },
    { id: '5', email: 'user5@example.com', username: 'user5', joinedAt: '2023-04-05', location: 'Seattle' },
  ]);
  
  // Fetch stats on component mount
  useEffect(() => {
    const loadStats = async () => {
      try {
        setIsLoading(true);
        const adminStats = await getAdminWaitlistStats();
        setStats(adminStats);
        setIsLoading(false);
      } catch (error) {
        console.error('Error loading admin stats:', error);
        toast({
          title: 'Error loading stats',
          description: 'There was a problem fetching waitlist statistics.',
          variant: 'destructive',
        });
        setIsLoading(false);
      }
    };
    
    loadStats();
  }, [getAdminWaitlistStats]);
  
  // Redirect non-admins
  useEffect(() => {
    // In a real app, you would check if the user has admin role
    // For now, we'll just simulate this check
    const isAdmin = user && user.email && (
      user.email.includes('admin') || 
      user.email === 'test@example.com'
    );
    
    if (!loading && !isAdmin) {
      toast({
        title: 'Access denied',
        description: 'You do not have permission to access the admin panel.',
        variant: 'destructive',
      });
      navigate('/');
    }
  }, [user, loading, navigate]);
  
  const handleApproveUser = (userId: string) => {
    approveUser(userId);
  };
  
  const handleExportWaitlist = () => {
    toast({
      title: 'Waitlist exported',
      description: 'The waitlist data has been exported to CSV.',
    });
  };
  
  const filteredUsers = searchQuery
    ? waitlistedUsers.filter(user => 
        user.email.toLowerCase().includes(searchQuery.toLowerCase()) ||
        user.username.toLowerCase().includes(searchQuery.toLowerCase())
      )
    : waitlistedUsers;
  
  if (loading || isLoading) {
    return (
      <div className="flex items-center justify-center min-h-screen bg-black">
        <div className="text-[#E6FFF4]">Loading...</div>
      </div>
    );
  }
  
  return (
    <div className="min-h-screen bg-black text-[#E6FFF4] p-4">
      <div className="max-w-6xl mx-auto">
        <h1 className="text-2xl font-bold mb-6">Waitlist Administration</h1>
        
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
          {/* Waitlist Status */}
          <Card className="bg-[#1A1A1A] border-[#333] text-[#E6FFF4]">
            <CardHeader>
              <CardTitle className="text-[#AAFF50]">Waitlist Status</CardTitle>
              <CardDescription className="text-[#E6FFF4]/70">
                Control user access to the app
              </CardDescription>
            </CardHeader>
            <CardContent>
              <div className="flex items-center space-x-2">
                <Switch
                  checked={isWaitlistActive}
                  onCheckedChange={toggleWaitlist}
                  id="waitlist-mode"
                />
                <Label htmlFor="waitlist-mode">
                  {isWaitlistActive ? 'Waitlist Active' : 'Waitlist Disabled'}
                </Label>
              </div>
              <p className="text-sm mt-4 text-[#E6FFF4]/70">
                {isWaitlistActive 
                  ? 'All new users are being placed on the waitlist.' 
                  : 'New users get immediate access to all features.'}
              </p>
            </CardContent>
          </Card>
          
          {/* Stats Overview */}
          <Card className="bg-[#1A1A1A] border-[#333] text-[#E6FFF4]">
            <CardHeader>
              <CardTitle className="text-[#AAFF50]">Waitlist Overview</CardTitle>
              <CardDescription className="text-[#E6FFF4]/70">
                Current statistics
              </CardDescription>
            </CardHeader>
            <CardContent>
              <dl className="grid grid-cols-2 gap-4 text-center">
                <div className="bg-[#111] p-3 rounded-lg">
                  <dt className="text-xs text-[#E6FFF4]/70">Total Waitlisted</dt>
                  <dd className="text-2xl font-bold">{stats?.totalWaitlisted || 0}</dd>
                </div>
                <div className="bg-[#111] p-3 rounded-lg">
                  <dt className="text-xs text-[#E6FFF4]/70">Approved Today</dt>
                  <dd className="text-2xl font-bold">{stats?.approvedToday || 0}</dd>
                </div>
              </dl>
            </CardContent>
          </Card>
        </div>
        
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-4 mb-6">
          {/* Location Data */}
          <Card className="bg-[#1A1A1A] border-[#333] text-[#E6FFF4] lg:col-span-2">
            <CardHeader>
              <div className="flex justify-between items-center">
                <CardTitle className="text-[#AAFF50]">Location Distribution</CardTitle>
                <MapPin className="text-[#AAFF50]" size={18} />
              </div>
            </CardHeader>
            <CardContent>
              <div className="h-64">
                {stats && (
                  <ResponsiveContainer width="100%" height="100%">
                    <BarChart data={stats.topLocations}>
                      <XAxis dataKey="city" stroke="#E6FFF4" />
                      <YAxis stroke="#E6FFF4" />
                      <Tooltip 
                        contentStyle={{ 
                          backgroundColor: '#1A1A1A', 
                          borderColor: '#333',
                          color: '#E6FFF4'
                        }}
                      />
                      <Bar dataKey="count" fill="#AAFF50" />
                    </BarChart>
                  </ResponsiveContainer>
                )}
              </div>
            </CardContent>
          </Card>
          
          {/* Referral Stats */}
          <Card className="bg-[#1A1A1A] border-[#333] text-[#E6FFF4]">
            <CardHeader>
              <div className="flex justify-between items-center">
                <CardTitle className="text-[#AAFF50]">Referral Activity</CardTitle>
                <Users className="text-[#AAFF50]" size={18} />
              </div>
            </CardHeader>
            <CardContent>
              <dl className="space-y-4">
                <div>
                  <dt className="text-xs text-[#E6FFF4]/70">Total Referrals</dt>
                  <dd className="text-2xl font-bold">{stats?.referralStats?.totalReferrals || 0}</dd>
                </div>
                <div>
                  <dt className="text-xs text-[#E6FFF4]/70">Conversion Rate</dt>
                  <dd className="text-2xl font-bold">{stats?.referralStats?.conversionRate || '0%'}</dd>
                </div>
              </dl>
            </CardContent>
          </Card>
        </div>
        
        {/* User Management */}
        <Card className="bg-[#1A1A1A] border-[#333] text-[#E6FFF4] mb-6">
          <CardHeader>
            <div className="flex justify-between items-center">
              <CardTitle className="text-[#AAFF50]">User Management</CardTitle>
              <div className="flex space-x-2">
                <Button size="sm" variant="outline" onClick={handleExportWaitlist}>
                  <File size={16} className="mr-1" />
                  Export
                </Button>
                <Button size="sm" variant="outline">
                  <RefreshCw size={16} className="mr-1" />
                  Refresh
                </Button>
              </div>
            </div>
          </CardHeader>
          <CardContent>
            <div className="mb-4">
              <div className="relative">
                <Search className="absolute left-2 top-2.5 h-4 w-4 text-[#E6FFF4]/50" />
                <Input
                  placeholder="Search by email or username"
                  className="pl-8"
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                />
              </div>
            </div>
            
            <div className="overflow-x-auto">
              <table className="w-full">
                <thead>
                  <tr className="border-b border-[#333]">
                    <th className="text-left py-2 px-2">User</th>
                    <th className="text-left py-2 px-2">Joined</th>
                    <th className="text-left py-2 px-2">Location</th>
                    <th className="text-left py-2 px-2">Actions</th>
                  </tr>
                </thead>
                <tbody>
                  {filteredUsers.map((user) => (
                    <tr key={user.id} className="border-b border-[#333] hover:bg-[#222]">
                      <td className="py-2 px-2">
                        <div>
                          <div className="font-medium">{user.username}</div>
                          <div className="text-xs text-[#E6FFF4]/70">{user.email}</div>
                        </div>
                      </td>
                      <td className="py-2 px-2">{user.joinedAt}</td>
                      <td className="py-2 px-2">{user.location || 'Unknown'}</td>
                      <td className="py-2 px-2">
                        <Button 
                          size="sm"
                          variant="outline"
                          onClick={() => handleApproveUser(user.id)}
                        >
                          Approve
                        </Button>
                      </td>
                    </tr>
                  ))}
                  
                  {filteredUsers.length === 0 && (
                    <tr>
                      <td colSpan={4} className="py-4 text-center text-[#E6FFF4]/70">
                        No users found
                      </td>
                    </tr>
                  )}
                </tbody>
              </table>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
};

export default WaitlistAdmin;
