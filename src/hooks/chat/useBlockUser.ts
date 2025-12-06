
import { useState, useCallback, useEffect } from 'react';
import { toast } from '@/hooks/use-toast';
import { 
  blockUser as blockUserApi,
  unblockUser as unblockUserApi,
  isUserBlocked as checkIsUserBlocked
} from '@/services/chatService';

export const useBlockUser = (otherUserId?: string) => {
  const [isBlocked, setIsBlocked] = useState(false);

  useEffect(() => {
    if (!otherUserId) return;

    const checkBlockStatus = async () => {
      const { data: blockedStatus } = await checkIsUserBlocked(otherUserId);
      setIsBlocked(!!blockedStatus);
    };

    checkBlockStatus();
  }, [otherUserId]);

  const toggleBlockUser = useCallback(async () => {
    if (!otherUserId) return false;
    
    try {
      if (isBlocked) {
        const { error } = await unblockUserApi(otherUserId);
        if (error) throw error;
        setIsBlocked(false);
        toast({
          title: "User Unblocked",
          description: "You can now receive messages from this user"
        });
      } else {
        const { error } = await blockUserApi(otherUserId);
        if (error) throw error;
        setIsBlocked(true);
        toast({
          title: "User Blocked",
          description: "You will no longer receive messages from this user"
        });
      }
      
      return true;
    } catch (err) {
      toast({
        title: "Error updating block status",
        description: err instanceof Error ? err.message : String(err),
        variant: "destructive"
      });
      return false;
    }
  }, [otherUserId, isBlocked]);

  return { isBlocked, toggleBlockUser };
};
