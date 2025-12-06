
import { useState } from 'react';
import { toast } from '@/hooks/use-toast';
import { moderateContent } from '@/utils/contentModeration';
import { RoomMessage } from './types';

export function useMessageHandling() {
  const [message, setMessage] = useState('');
  const [messages, setMessages] = useState<RoomMessage[]>([]);
  const [moderationWarning, setModerationWarning] = useState<string | null>(null);

  const handleSendMessage = () => {
    if (!message.trim()) return;
    
    // Apply AI moderation
    const moderationResult = moderateContent(message);
    
    if (moderationResult.isFlagged) {
      setModerationWarning(`Your message contains prohibited content and cannot be sent. Please review our community guidelines.`);
      toast({
        title: "Message Blocked",
        description: "Your message contains prohibited content and wasn't sent.",
        variant: "destructive"
      });
      return;
    }
    
    // Clear any previous warnings
    setModerationWarning(null);
    
    // Add new message
    const newMessage: RoomMessage = {
      id: `msg-${Date.now()}`,
      userId: 'current-user',
      userName: 'You',
      userImage: '/placeholder.svg',
      userRole: 'vers',
      content: message,
      isImage: false,
      timestamp: new Date(),
      reactions: []
    };
    
    setMessages([...messages, newMessage]);
    setMessage('');
    
    toast({
      title: "Message Sent",
      description: "Your message has been posted to the Zoom Room."
    });
  };
  
  const handleReact = (messageId: string, emoji: string) => {
    setMessages(prev => 
      prev.map(msg => {
        if (msg.id === messageId) {
          const reactionIndex = msg.reactions.findIndex(r => r.emoji === emoji);
          if (reactionIndex >= 0) {
            const wasReacted = msg.reactions[reactionIndex].reacted;
            const updatedReactions = [...msg.reactions];
            updatedReactions[reactionIndex] = {
              ...updatedReactions[reactionIndex],
              count: wasReacted 
                ? updatedReactions[reactionIndex].count - 1 
                : updatedReactions[reactionIndex].count + 1,
              reacted: !wasReacted
            };
            return { ...msg, reactions: updatedReactions };
          }
          return msg;
        }
        return msg;
      })
    );
  };
  
  const handleDeleteMessage = (messageId: string) => {
    setMessages(prev => prev.filter(msg => msg.id !== messageId));
    toast({
      title: "Message Deleted",
      description: "Your message has been removed from the Zoom Room."
    });
  };

  return {
    message,
    setMessage,
    messages,
    setMessages,
    moderationWarning,
    setModerationWarning,
    handleSendMessage,
    handleReact,
    handleDeleteMessage
  };
}
