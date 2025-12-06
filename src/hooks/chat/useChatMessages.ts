
import { useState, useEffect, useCallback } from 'react';
import { supabase } from '@/integrations/supabase/client';
import { toast } from '@/hooks/use-toast';
import soundManager from '@/utils/soundManager';
import { 
  getChatMessages, 
  sendMessage as sendMessageApi,
  subscribeToMessages,
  markMessagesAsRead,
  Message,
  ChatSession 
} from '@/services/chatService';

export const useChatMessages = (chatSession: ChatSession | null) => {
  const [messages, setMessages] = useState<Message[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!chatSession) return;

    const fetchMessages = async () => {
      try {
        const { data: messagesData, error: messagesError } = await getChatMessages(chatSession.id);
        if (messagesError) throw messagesError;
        
        setMessages(messagesData || []);
        
        // Mark messages from other user as read
        const { data: { user } } = await supabase.auth.getUser();
        if (user) {
          const otherUserInChat = chatSession.user1_id === user.id ? chatSession.user2_id : chatSession.user1_id;
          await markMessagesAsRead(chatSession.id, otherUserInChat);
        }
      } catch (err) {
        toast({
          title: "Error loading messages",
          description: err instanceof Error ? err.message : String(err),
          variant: "destructive"
        });
      } finally {
        setLoading(false);
      }
    };

    fetchMessages();
  }, [chatSession]);

  // Subscribe to new messages
  useEffect(() => {
    if (!chatSession) return;
    
    const unsubscribe = subscribeToMessages(chatSession.id, (newMessage) => {
      setMessages(prev => [...prev, newMessage]);
      
      // Get current user
      supabase.auth.getUser().then(({ data: { user } }) => {
        if (user && newMessage.sender_id !== user.id) {
          soundManager.play('message');
          markMessagesAsRead(chatSession.id, newMessage.sender_id);
        }
      });
    });
    
    return () => {
      unsubscribe();
    };
  }, [chatSession]);

  const sendMessage = useCallback(async (content: string, type: 'text' | 'image' | 'location' | 'emoji' | 'yo' | 'voice' | 'video' = 'text') => {
    if (!chatSession) return null;
    
    try {
      const { data, error } = await sendMessageApi(chatSession.id, content, type);
      if (error) throw error;
      soundManager.play('message');
      return data;
    } catch (err) {
      toast({
        title: "Error sending message",
        description: err instanceof Error ? err.message : String(err),
        variant: "destructive"
      });
      return null;
    }
  }, [chatSession]);

  return {
    messages,
    loading,
    sendMessage
  };
};
