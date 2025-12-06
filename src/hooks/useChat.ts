
import { useChatSession } from './chat/useChatSession';
import { useChatMessages } from './chat/useChatMessages';
import { useBlockUser } from './chat/useBlockUser';

export const useChat = (otherUserId?: string, chatSessionId?: string) => {
  const { loading: sessionLoading, chatSession, error } = useChatSession(otherUserId, chatSessionId);
  const { messages, loading: messagesLoading, sendMessage } = useChatMessages(chatSession);
  const { isBlocked, toggleBlockUser } = useBlockUser(otherUserId);

  return {
    loading: sessionLoading || messagesLoading,
    messages,
    chatSession,
    isBlocked,
    error,
    sendMessage,
    toggleBlockUser
  };
};
