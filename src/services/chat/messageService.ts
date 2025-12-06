
import { supabase } from "@/integrations/supabase/client";
import { Message } from "./types";

// Get messages for a chat session
export const getChatMessages = async (chatSessionId: string) => {
  const { data, error } = await supabase
    .from('messages')
    .select(`
      *,
      message_reactions (*)
    `)
    .eq('chat_session_id', chatSessionId)
    .order('sent_at', { ascending: true });

  return { data, error };
};

// Send a message
export const sendMessage = async (
  chatSessionId: string, 
  content: string, 
  messageType: 'text' | 'image' | 'location' | 'emoji' | 'yo' | 'voice' | 'video' = 'text',
  mediaUrl?: string,
  locationData?: { latitude: number; longitude: number; address?: string }
) => {
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { data: null, error: "Not authenticated" };

  // Insert the message
  const messageData: any = {
    chat_session_id: chatSessionId,
    sender_id: user.id,
    content,
    message_type: messageType
  };

  // Add optional fields if provided
  if (mediaUrl) {
    messageData.media_url = mediaUrl;
  }
  
  if (locationData) {
    messageData.location_data = locationData;
  }

  const { data, error } = await supabase
    .from('messages')
    .insert(messageData)
    .select()
    .single();

  // Update the last_message_at timestamp in the chat session
  if (data) {
    await supabase
      .from('chat_sessions')
      .update({ last_message_at: new Date().toISOString() })
      .eq('id', chatSessionId);
  }

  return { data, error };
};

// Mark messages as read
export const markMessagesAsRead = async (chatSessionId: string, senderId: string) => {
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { error: "Not authenticated" };

  const { error } = await supabase
    .from('messages')
    .update({ read_at: new Date().toISOString() })
    .eq('chat_session_id', chatSessionId)
    .eq('sender_id', senderId)
    .is('read_at', null);

  return { error };
};

// Send typing indicator
export const sendTypingIndicator = async (chatSessionId: string, isTyping: boolean) => {
  // In a real app, this would likely be implemented with Supabase realtime or websockets
  // For now, we'll just simulate this behavior
  console.log(`User is ${isTyping ? 'typing' : 'not typing'} in chat ${chatSessionId}`);
  return { success: true };
};

// Subscribe to new messages for a chat session
export const subscribeToMessages = (
  chatSessionId: string, 
  callback: (message: any) => void
) => {
  const channel = supabase
    .channel(`messages:${chatSessionId}`)
    .on(
      'postgres_changes',
      {
        event: 'INSERT',
        schema: 'public',
        table: 'messages',
        filter: `chat_session_id=eq.${chatSessionId}`
      },
      (payload) => {
        callback(payload.new);
      }
    )
    .subscribe();

  return () => {
    supabase.removeChannel(channel);
  };
};

// Subscribe to typing indicators for a chat session
export const subscribeToTypingIndicators = (
  chatSessionId: string, 
  callback: (isTyping: boolean, userId: string) => void
) => {
  // In a real app, this would be implemented with a proper realtime subscription
  // For now, we're just returning a dummy unsubscribe function
  return () => {};
};
