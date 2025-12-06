
import React, { useState, useEffect } from 'react';
import { MessageCircle, User, Search, Trash2, UserX, Filter } from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import { toast } from '@/hooks/use-toast';
import soundManager from '@/utils/soundManager';
import { useChatSessions } from '@/hooks/useChatSessions';
import { format, isToday, isYesterday, formatDistanceToNow } from 'date-fns';
import { supabase } from '@/integrations/supabase/client';
import { Spinner } from '@/components/ui/spinner';
import { ChatOriginSection } from '@/services/chatService';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Badge } from "./ui/badge";

const MessagesView: React.FC = () => {
  const navigate = useNavigate();
  const [searchQuery, setSearchQuery] = useState('');
  const { sessions, loading, error, refreshSessions } = useChatSessions();
  const [isAuthenticated, setIsAuthenticated] = useState<boolean | null>(null);
  const [sectionFilter, setSectionFilter] = useState<ChatOriginSection | 'all'>('all');
  
  useEffect(() => {
    const checkAuth = async () => {
      const { data: { user } } = await supabase.auth.getUser();
      setIsAuthenticated(!!user);
      
      if (!user) {
        navigate('/auth');
      }
    };
    
    checkAuth();
  }, [navigate]);
  
  useEffect(() => {
    soundManager.initialize();
  }, []);
  
  const formatMessageTime = (timestamp: string) => {
    const date = new Date(timestamp);
    
    if (isToday(date)) {
      return format(date, 'p'); // e.g., 12:30 PM
    } else if (isYesterday(date)) {
      return 'Yesterday';
    } else {
      return formatDistanceToNow(date, { addSuffix: true }); // e.g., 2 days ago
    }
  };

  const getSectionDisplayName = (section?: ChatOriginSection) => {
    switch (section) {
      case 'grid': return 'GRID';
      case 'now': return 'NOW';
      case 'connect': return 'CONNECT';
      case 'live': return 'LIVE';
      default: return 'Direct';
    }
  };

  const getSectionBadgeClass = (section?: ChatOriginSection) => {
    switch (section) {
      case 'grid': return 'bg-[#0066FF] text-white';
      case 'now': return 'bg-[#FF3366] text-white';
      case 'connect': return 'bg-[#33FF99] text-black';
      case 'live': return 'bg-[#9933FF] text-white';
      default: return 'bg-gray-600 text-white';
    }
  };
  
  const filteredSessions = sessions.filter(session => {
    if (sectionFilter !== 'all' && session.origin_section !== sectionFilter) {
      return false;
    }
    
    if (!searchQuery) {
      return true;
    }
    
    return (
      (session.other_user?.name || '')
        .toLowerCase()
        .includes(searchQuery.toLowerCase()) ||
      (session.last_message?.content || '')
        .toLowerCase()
        .includes(searchQuery.toLowerCase())
    );
  });
  
  const handleOpenChat = (chatSessionId: string) => {
    soundManager.play('message');
    navigate(`/messages/${chatSessionId}`);
  };
  
  const handleDeleteConversation = (e: React.MouseEvent, sessionId: string) => {
    e.stopPropagation();
    
    toast({
      title: "Chat deletion not implemented",
      description: "This feature requires administrative permissions",
    });
    
    soundManager.play('notification');
  };
  
  const toggleBlockUser = async (e: React.MouseEvent, userId: string) => {
    e.stopPropagation();
    
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) {
      toast({
        title: "Authentication required",
        description: "Please log in to block users",
        variant: "destructive"
      });
      return;
    }
    
    try {
      const { data: isAlreadyBlocked } = await supabase
        .rpc('is_user_blocked', {
          blocker_id: user.id,
          blocked_id: userId
        });
      
      if (isAlreadyBlocked) {
        await supabase
          .from('blocked_users')
          .delete()
          .eq('blocker_id', user.id)
          .eq('blocked_id', userId);
        
        toast({
          title: "User Unblocked",
          description: "You can now receive messages from this user"
        });
      } else {
        await supabase
          .from('blocked_users')
          .insert({
            blocker_id: user.id,
            blocked_id: userId
          });
        
        toast({
          title: "User Blocked",
          description: "You will no longer receive messages from this user"
        });
      }
      
      soundManager.play('notification');
      refreshSessions();
      
    } catch (error) {
      toast({
        title: "Error",
        description: "Failed to update block status",
        variant: "destructive"
      });
    }
  };
  
  if (isAuthenticated === null) {
    return (
      <div className="flex items-center justify-center h-screen">
        <Spinner />
      </div>
    );
  }
  
  return (
    <div className="w-full h-full pt-16 pb-20">
      <div className="px-4 py-2 sticky top-16 bg-yobro-dark z-10 space-y-3">
        <div className="relative">
          <input
            type="text"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            placeholder="Search messages..."
            className="w-full py-2 pl-10 pr-3 bg-[#2A2A2A] border border-[#3A3A3A] rounded-full text-white text-sm"
          />
          <Search className="absolute left-3 top-2.5 w-4 h-4 text-gray-400" />
        </div>
        
        <div className="flex items-center space-x-2 overflow-x-auto py-2 no-scrollbar">
          <Badge 
            variant="outline" 
            className={`rounded-full px-3 py-1 cursor-pointer ${sectionFilter === 'all' ? 'bg-gray-700 text-white' : 'bg-[#2A2A2A] text-gray-300'}`}
            onClick={() => setSectionFilter('all')}
          >
            All Chats
          </Badge>
          
          <Badge 
            variant="outline" 
            className={`rounded-full px-3 py-1 cursor-pointer ${sectionFilter === 'grid' ? 'bg-[#0066FF] text-white' : 'bg-[#2A2A2A] text-gray-300'}`}
            onClick={() => setSectionFilter('grid')}
          >
            GRID
          </Badge>
          
          <Badge 
            variant="outline" 
            className={`rounded-full px-3 py-1 cursor-pointer ${sectionFilter === 'now' ? 'bg-[#FF3366] text-white' : 'bg-[#2A2A2A] text-gray-300'}`}
            onClick={() => setSectionFilter('now')}
          >
            NOW
          </Badge>
          
          <Badge 
            variant="outline" 
            className={`rounded-full px-3 py-1 cursor-pointer ${sectionFilter === 'live' ? 'bg-[#9933FF] text-white' : 'bg-[#2A2A2A] text-gray-300'}`}
            onClick={() => setSectionFilter('live')}
          >
            LIVE
          </Badge>
          
          <Badge 
            variant="outline" 
            className={`rounded-full px-3 py-1 cursor-pointer ${sectionFilter === 'connect' ? 'bg-[#33FF99] text-black' : 'bg-[#2A2A2A] text-gray-300'}`}
            onClick={() => setSectionFilter('connect')}
          >
            CONNECT
          </Badge>
        </div>
      </div>
      
      {loading ? (
        <div className="flex flex-col items-center justify-center h-48">
          <Spinner />
          <p className="text-gray-400 mt-2">Loading conversations...</p>
        </div>
      ) : error ? (
        <div className="flex flex-col items-center justify-center h-48 p-4">
          <MessageCircle className="w-12 h-12 text-gray-500 mb-4" />
          <p className="text-gray-400 text-center">Error loading messages. Please try again.</p>
        </div>
      ) : (
        <div className="divide-y divide-gray-800">
          {filteredSessions.length > 0 ? (
            filteredSessions.map((session) => (
              <div 
                key={session.id} 
                className="flex items-center py-3 px-4 cursor-pointer hover:bg-[#2A2A2A]/30"
                onClick={() => handleOpenChat(session.id)}
              >
                <div className="relative w-12 h-12 rounded-full overflow-hidden mr-4">
                  {session.other_user?.image ? (
                    <img src={session.other_user.image} alt={session.other_user.name} className="w-full h-full object-cover" />
                  ) : (
                    <div className="w-full h-full bg-gray-800 flex items-center justify-center">
                      <User className="w-6 h-6 text-gray-400" />
                    </div>
                  )}
                  {session.other_user?.isOnline && (
                    <div className="absolute bottom-0 right-0 w-3 h-3 rounded-full bg-green-400 border-2 border-[#2A2A2A]"></div>
                  )}
                </div>
                <div className="flex-1">
                  <div className="flex justify-between">
                    <div className="flex items-center space-x-2">
                      <h3 className={`font-medium ${session.unread_count ? 'text-yobro-white' : 'text-gray-300'}`}>
                        {session.other_user?.name || 'Unknown User'}
                      </h3>
                      
                      {session.origin_section && (
                        <span className={`text-xs px-1.5 py-0.5 rounded ${getSectionBadgeClass(session.origin_section)}`}>
                          {getSectionDisplayName(session.origin_section)}
                        </span>
                      )}
                    </div>
                    <span className="text-xs text-gray-400">
                      {session.last_message?.sent_at 
                        ? formatMessageTime(session.last_message.sent_at)
                        : ''}
                    </span>
                  </div>
                  <p className={`text-sm ${session.unread_count ? 'text-gray-300' : 'text-gray-500'} line-clamp-1`}>
                    {session.last_message?.content || 'No messages yet'}
                  </p>
                </div>
                {session.unread_count > 0 && (
                  <div className="min-w-[18px] h-[18px] rounded-full bg-yobro-pink flex items-center justify-center ml-2">
                    <span className="text-xs text-white">{session.unread_count}</span>
                  </div>
                )}
                
                <div className="flex space-x-2 ml-2">
                  <button 
                    onClick={(e) => session.other_user?.id && toggleBlockUser(e, session.other_user.id)}
                    className="text-gray-400 hover:text-white p-1"
                  >
                    <UserX className="w-4 h-4" />
                  </button>
                  <button 
                    onClick={(e) => handleDeleteConversation(e, session.id)}
                    className="text-gray-400 hover:text-white p-1"
                  >
                    <Trash2 className="w-4 h-4" />
                  </button>
                </div>
              </div>
            ))
          ) : (
            <div className="flex flex-col items-center justify-center h-48 p-4">
              <MessageCircle className="w-12 h-12 text-gray-500 mb-4" />
              <p className="text-gray-400 text-center">
                {searchQuery || sectionFilter !== 'all' ? 'No messages match your search' : 'No messages yet'}
              </p>
              {!searchQuery && sectionFilter === 'all' && (
                <p className="text-gray-500 text-center text-sm mt-2">
                  Start chatting with users from GRID, NOW, Connect or LIVE
                </p>
              )}
            </div>
          )}
        </div>
      )}
    </div>
  );
};

export default MessagesView;
