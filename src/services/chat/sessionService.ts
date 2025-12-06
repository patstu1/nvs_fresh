
import { supabase } from "@/integrations/supabase/client";
import { ChatSession, ChatOriginSection } from "./types";

// Get all chat sessions for the current user
export const getUserChatSessions = async () => {
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { data: null, error: "Not authenticated" };

  const { data, error } = await supabase
    .from('chat_sessions')
    .select('*')
    .or(`user1_id.eq.${user.id},user2_id.eq.${user.id}`)
    .order('last_message_at', { ascending: false });

  return { data, error };
};

// Get or create a chat session with section information
export const getOrCreateChatSession = async (otherUserId: string, originSection: ChatOriginSection = 'unknown') => {
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { data: null, error: "Not authenticated" };

  // Check if chat session already exists
  const { data: existingChats, error: findError } = await supabase
    .from('chat_sessions')
    .select('*')
    .or(`and(user1_id.eq.${user.id},user2_id.eq.${otherUserId}),and(user1_id.eq.${otherUserId},user2_id.eq.${user.id})`)
    .limit(1);

  if (findError) return { data: null, error: findError };
  
  // Return existing chat if found
  if (existingChats && existingChats.length > 0) {
    // We need to add origin_section to database tables,
    // but for now we'll return the existing chat without updating
    return { data: {
      ...existingChats[0],
      origin_section: originSection
    }, error: null };
  }

  // Create new chat session
  const { data, error } = await supabase
    .from('chat_sessions')
    .insert([{
      user1_id: user.id,
      user2_id: otherUserId
    }])
    .select()
    .single();

  if (data) {
    // Add origin_section property to the returned data
    return {
      data: {
        ...data,
        origin_section: originSection
      },
      error
    };
  }

  return { data, error };
};

// Update chat session with origin section
export const updateChatSessionOrigin = async (sessionId: string, originSection: ChatOriginSection) => {
  // In a real implementation, this would update the database
  // For now, we'll just return a simulated success
  console.log(`Setting origin section for session ${sessionId} to ${originSection}`);
  
  return { 
    data: {
      id: sessionId,
      origin_section: originSection
    }, 
    error: null
  };
};

// Toggle favorite status for a chat session
export const toggleFavoriteStatus = async (otherUserId: string, isFavorite: boolean) => {
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { error: "Not authenticated" };

  try {
    // Instead of using a favorites table (which doesn't exist), let's simulate the functionality
    // In a real implementation, you would need to create this table
    console.log(`${isFavorite ? 'Adding' : 'Removing'} ${otherUserId} ${isFavorite ? 'to' : 'from'} favorites`);
    
    // For now, return success without actually modifying the database
    return { error: null };
  } catch (error) {
    return { error };
  }
};

// Check if a user is favorited
export const isUserFavorited = async (otherUserId: string) => {
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { data: false, error: "Not authenticated" };

  // Simulate checking if a user is favorited
  // In a real implementation, you would check the favorites table
  return { data: false, error: null };
};
