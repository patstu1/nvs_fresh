
import { useState, useEffect, useCallback } from 'react';
import { getUserChatSessions, ChatSession } from '@/services/chatService';
import { supabase } from "@/integrations/supabase/client";
import soundManager from '@/utils/soundManager';

export const useChatSessions = () => {
  const [sessions, setSessions] = useState<ChatSession[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // Fetch chat sessions
  const fetchSessions = useCallback(async () => {
    try {
      setLoading(true);
      const { data, error } = await getUserChatSessions();
      
      if (error) {
        setError(error.toString());
        return;
      }
      
      if (data) {
        // Load last messages and user profiles for each session
        const sessionsWithDetails = await Promise.all(data.map(async (session) => {
          const { data: { user } } = await supabase.auth.getUser();
          if (!user) return session;

          const otherUserId = session.user1_id === user.id ? session.user2_id : session.user1_id;
          
          // Get user profile
          const { data: profiles } = await supabase
            .from('profiles')
            .select('*')
            .eq('id', otherUserId)
            .limit(1);
          
          // Get last message
          const { data: lastMessages } = await supabase
            .from('messages')
            .select('*')
            .eq('chat_session_id', session.id)
            .order('sent_at', { ascending: false })
            .limit(1);
          
          // Count unread messages
          const { count } = await supabase
            .from('messages')
            .select('*', { count: 'exact', head: true })
            .eq('chat_session_id', session.id)
            .eq('sender_id', otherUserId)
            .is('read_at', null);
          
          return {
            ...session,
            other_user: profiles && profiles[0] ? {
              id: otherUserId,
              name: profiles[0].full_name || 'Unknown User',
              image: profiles[0].avatar_url || '',
              isOnline: false, // This would need to be determined separately
              distance: 0, // This would need to be determined separately
              emojis: []
            } : undefined,
            last_message: lastMessages && lastMessages[0] ? lastMessages[0] : undefined,
            unread_count: count || 0
          };
        }));
        
        setSessions(sessionsWithDetails);
      }
    } catch (e) {
      setError(e instanceof Error ? e.message : String(e));
    } finally {
      setLoading(false);
    }
  }, []);

  // Get initial data
  useEffect(() => {
    fetchSessions();
  }, [fetchSessions]);

  // Listen for changes in chat sessions
  useEffect(() => {
    // Subscribe to new messages on all chat sessions
    const channel = supabase
      .channel('public:messages')
      .on(
        'postgres_changes',
        {
          event: 'INSERT',
          schema: 'public',
          table: 'messages'
        },
        (payload) => {
          // Check if this message belongs to one of our sessions
          const sessionId = payload.new.chat_session_id;
          
          // Check if we already have this session
          if (sessions.some(s => s.id === sessionId)) {
            // Update the session with new data
            fetchSessions();
            
            // Play notification sound if message is not from current user
            supabase.auth.getUser().then(({ data: { user } }) => {
              if (user && payload.new.sender_id !== user.id) {
                soundManager.play('notification');
              }
            });
          }
        }
      )
      .subscribe();
    
    return () => {
      supabase.removeChannel(channel);
    };
  }, [sessions, fetchSessions]);

  return {
    sessions,
    loading,
    error,
    refreshSessions: fetchSessions
  };
};
