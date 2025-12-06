
import { supabase } from "@/integrations/supabase/client";

// Block a user
export const blockUser = async (blockedUserId: string) => {
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { data: null, error: "Not authenticated" };

  const { data, error } = await supabase
    .from('blocked_users')
    .insert({
      blocker_id: user.id,
      blocked_id: blockedUserId
    })
    .select()
    .single();

  return { data, error };
};

// Unblock a user
export const unblockUser = async (blockedUserId: string) => {
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { data: null, error: "Not authenticated" };

  const { data, error } = await supabase
    .from('blocked_users')
    .delete()
    .eq('blocker_id', user.id)
    .eq('blocked_id', blockedUserId)
    .select()
    .single();

  return { data, error };
};

// Check if a user is blocked
export const isUserBlocked = async (otherUserId: string) => {
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { data: false, error: "Not authenticated" };

  const { data, error } = await supabase
    .from('blocked_users')
    .select('*')
    .eq('blocker_id', user.id)
    .eq('blocked_id', otherUserId)
    .maybeSingle();

  return { data: !!data, error };
};

// Get a list of blocked users
export const getBlockedUsers = async () => {
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { data: [], error: "Not authenticated" };

  const { data, error } = await supabase
    .from('blocked_users')
    .select('*')
    .eq('blocker_id', user.id);

  return { data, error };
};
