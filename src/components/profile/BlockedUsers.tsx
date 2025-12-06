
import React, { useState, useEffect } from 'react';
import { Button } from '@/components/ui/button';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription } from '@/components/ui/dialog';
import { UserX, Check, Search, Loader2 } from 'lucide-react';
import { toast } from '@/hooks/use-toast';
import { Input } from '@/components/ui/input';
import { supabase } from '@/integrations/supabase/client';
import { format } from 'date-fns';

interface BlockedUser {
  id: string;
  name: string;
  image: string;
  blockedAt: string;
  blockedUserId: string;
}

const BlockedUsers: React.FC = () => {
  const [isOpen, setIsOpen] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');
  const [blockedUsers, setBlockedUsers] = useState<BlockedUser[]>([]);
  const [loading, setLoading] = useState(false);
  
  // Load blocked users from database
  useEffect(() => {
    if (!isOpen) return;
    
    const fetchBlockedUsers = async () => {
      setLoading(true);
      
      try {
        const { data: { user } } = await supabase.auth.getUser();
        if (!user) {
          toast({
            title: "Authentication required",
            description: "Please log in to view blocked users",
            variant: "destructive"
          });
          setIsOpen(false);
          return;
        }
        
        // Get all blocked users
        const { data: blockedData, error: blockedError } = await supabase
          .from('blocked_users')
          .select('*')
          .eq('blocker_id', user.id);
        
        if (blockedError) throw blockedError;
        
        if (blockedData) {
          // For each blocked user, get their profile data
          const blockedUserDetails = await Promise.all(
            blockedData.map(async (blocked) => {
              // Get profile data
              const { data: profile } = await supabase
                .from('profiles')
                .select('*')
                .eq('id', blocked.blocked_id)
                .single();
              
              return {
                id: blocked.id,
                blockedUserId: blocked.blocked_id,
                name: profile?.full_name || 'Unknown User',
                image: profile?.avatar_url || 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=500&h=500&fit=crop',
                blockedAt: format(new Date(blocked.created_at), 'yyyy-MM-dd')
              };
            })
          );
          
          setBlockedUsers(blockedUserDetails);
        }
        
      } catch (error) {
        console.error('Error fetching blocked users:', error);
        toast({
          title: "Error",
          description: "Failed to load blocked users",
          variant: "destructive"
        });
      } finally {
        setLoading(false);
      }
    };
    
    fetchBlockedUsers();
  }, [isOpen]);

  const handleUnblock = async (blockId: string, userId: string) => {
    try {
      // In a real application, call API endpoint
      const { error } = await supabase
        .from('blocked_users')
        .delete()
        .eq('id', blockId);
      
      if (error) throw error;
      
      // Update local state
      setBlockedUsers(blockedUsers.filter(user => user.id !== blockId));
      
      toast({
        title: "User Unblocked",
        description: "You can now see this user's profile again"
      });
    } catch (error) {
      toast({
        title: "Error",
        description: "Failed to unblock user",
        variant: "destructive"
      });
    }
  };

  const filteredUsers = blockedUsers.filter(user => 
    user.name.toLowerCase().includes(searchQuery.toLowerCase())
  );

  return (
    <>
      <Button
        variant="outline"
        className="border-[#E6FFF4]/30 text-[#E6FFF4] hover:bg-[#E6FFF4]/10"
        onClick={() => setIsOpen(true)}
      >
        <UserX className="w-4 h-4 mr-2" />
        Blocked Users
      </Button>

      <Dialog open={isOpen} onOpenChange={setIsOpen}>
        <DialogContent className="bg-black border border-[#E6FFF4]/30 text-white max-w-md">
          <DialogHeader>
            <DialogTitle className="text-[#E6FFF4]">Blocked Users</DialogTitle>
            <DialogDescription className="text-[#E6FFF4]/70">
              Manage users you've blocked from contacting you
            </DialogDescription>
          </DialogHeader>

          <div className="relative mb-4">
            <Search className="absolute left-2 top-2.5 h-4 w-4 text-[#E6FFF4]/50" />
            <Input
              placeholder="Search blocked users..."
              className="pl-8 bg-[#1A1A1A] border-[#E6FFF4]/30 text-[#E6FFF4]"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
            />
          </div>

          <div className="space-y-3 max-h-[300px] overflow-y-auto pr-1">
            {loading ? (
              <div className="flex flex-col items-center justify-center py-8">
                <Loader2 className="w-8 h-8 text-[#E6FFF4]/50 animate-spin" />
                <p className="text-[#E6FFF4]/50 mt-2">Loading blocked users...</p>
              </div>
            ) : filteredUsers.length === 0 ? (
              <div className="text-center py-6 text-[#E6FFF4]/50">
                {blockedUsers.length === 0 
                  ? "You haven't blocked any users yet" 
                  : "No blocked users match your search"}
              </div>
            ) : (
              filteredUsers.map(user => (
                <div 
                  key={user.id} 
                  className="flex items-center justify-between bg-[#1A1A1A] p-3 rounded-md border border-[#E6FFF4]/10"
                >
                  <div className="flex items-center">
                    <div className="w-10 h-10 rounded-full overflow-hidden mr-3">
                      <img src={user.image} alt={user.name} className="w-full h-full object-cover" />
                    </div>
                    <div>
                      <p className="font-medium text-[#E6FFF4]">{user.name}</p>
                      <p className="text-xs text-[#E6FFF4]/50">Blocked on {user.blockedAt}</p>
                    </div>
                  </div>
                  <Button
                    size="sm"
                    variant="outline" 
                    className="border-[#E6FFF4]/30 text-[#E6FFF4] hover:bg-[#E6FFF4]/10"
                    onClick={() => handleUnblock(user.id, user.blockedUserId)}
                  >
                    <Check className="w-3 h-3 mr-1" />
                    Unblock
                  </Button>
                </div>
              ))
            )}
          </div>
        </DialogContent>
      </Dialog>
    </>
  );
};

export default BlockedUsers;
