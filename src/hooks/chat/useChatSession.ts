
import { useState, useEffect } from 'react';
import { supabase } from '@/integrations/supabase/client';
import { getOrCreateChatSession } from '@/services/chatService';
import { ChatSession } from '@/services/chatService';
import { toast } from '@/hooks/use-toast';
import { PostgrestError } from '@supabase/supabase-js';

export const useChatSession = (otherUserId?: string, chatSessionId?: string) => {
  const [loading, setLoading] = useState(true);
  const [chatSession, setChatSession] = useState<ChatSession | null>(null);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!otherUserId && !chatSessionId) return;
    
    const initializeChatSession = async () => {
      setLoading(true);
      try {
        let session = null;
        if (chatSessionId) {
          const { data } = await supabase
            .from('chat_sessions')
            .select('*')
            .eq('id', chatSessionId)
            .single();
          session = data;
        } else if (otherUserId) {
          const { data, error } = await getOrCreateChatSession(otherUserId);
          if (error) throw error;
          session = data;
        }

        if (session) {
          setChatSession(session);
        }
      } catch (err) {
        const errorMessage = err instanceof Error ? err.message : String(err);
        setError(errorMessage);
        toast({
          title: "Error loading chat",
          description: errorMessage,
          variant: "destructive"
        });
      } finally {
        setLoading(false);
      }
    };

    initializeChatSession();
  }, [otherUserId, chatSessionId]);

  return { loading, chatSession, error };
};
