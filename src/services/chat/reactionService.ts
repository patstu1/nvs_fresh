
import { supabase } from "@/integrations/supabase/client";

// Add a reaction to a message
export const addReaction = async (messageId: string, emoji: string) => {
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { data: null, error: "Not authenticated" };

  const { data, error } = await supabase
    .from('message_reactions')
    .insert({
      message_id: messageId,
      user_id: user.id,
      emoji: emoji
    })
    .select()
    .single();

  return { data, error };
};

// Remove a reaction from a message
export const removeReaction = async (reactionId: string) => {
  const { data, error } = await supabase
    .from('message_reactions')
    .delete()
    .eq('id', reactionId)
    .select()
    .single();

  return { data, error };
};

// Get reactions for a message
export const getMessageReactions = async (messageId: string) => {
  const { data, error } = await supabase
    .from('message_reactions')
    .select('*')
    .eq('message_id', messageId);

  return { data, error };
};

// Check if the current user has reacted with a specific emoji
export const hasReacted = async (messageId: string, emoji: string) => {
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { data: false, error: "Not authenticated" };

  const { data, error } = await supabase
    .from('message_reactions')
    .select('*')
    .eq('message_id', messageId)
    .eq('user_id', user.id)
    .eq('emoji', emoji)
    .maybeSingle();

  return { data: !!data, error };
};
