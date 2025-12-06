import React, { useState, useRef, useEffect, useCallback } from 'react';
import { useParams, useNavigate, useLocation } from 'react-router-dom';
import { ArrowDownCircle, MapPin, Heart, HeartOff } from 'lucide-react';
import { toast } from '@/hooks/use-toast';
import VideoCallDialog from './VideoCallDialog';
import soundManager from '@/utils/soundManager';
import { useChat } from '@/hooks/useChat';
import { Spinner } from '@/components/ui/spinner';
import { supabase } from '@/integrations/supabase/client';
import ChatHeader from './chat/ChatHeader';
import MessageItem from './chat/MessageItem';
import ChatInput from './chat/ChatInput';
import { ChatOriginSection } from '@/services/chat/types';

const ChatView = () => {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const location = useLocation();
  const messagesEndRef = useRef<HTMLDivElement>(null);
  
  const [newMessage, setNewMessage] = useState('');
  const [showOptions, setShowOptions] = useState(false);
  const [isVideoCallOpen, setIsVideoCallOpen] = useState(false);
  const [incomingCall, setIncomingCall] = useState(false);
  const [showEmojiPicker, setShowEmojiPicker] = useState(false);
  const [uploadingImage, setUploadingImage] = useState(false);
  const [otherUser, setOtherUser] = useState<any>(null);
  const [scrollToBottomVisible, setScrollToBottomVisible] = useState(false);
  const [currentUserId, setCurrentUserId] = useState<string | null>(null);
  const [sectionOrigin, setSectionOrigin] = useState<ChatOriginSection>('unknown');
  const [isFavorited, setIsFavorited] = useState(false);
  const [isTyping, setIsTyping] = useState(false);
  
  const {
    loading,
    messages,
    chatSession,
    isBlocked,
    error,
    sendMessage,
    toggleBlockUser
  } = useChat(undefined, id);

  useEffect(() => {
    // Parse origin section from URL
    const params = new URLSearchParams(location.search);
    const origin = params.get('origin_section') as ChatOriginSection;
    if (origin) {
      setSectionOrigin(origin);
    } else if (chatSession?.origin_section) {
      setSectionOrigin(chatSession.origin_section);
    }
  }, [location.search, chatSession]);

  const handleStartChat = useCallback((userId: string) => {
    toast({
      title: "Starting chat",
      description: `Opening conversation with user from NOW`
    });
    navigate(`/messages/${userId}?origin_section=map`);
  }, [navigate]);

  useEffect(() => {
    const fetchCurrentUser = async () => {
      const { data: { user } } = await supabase.auth.getUser();
      if (user) {
        setCurrentUserId(user.id);
      }
    };
    fetchCurrentUser();
  }, []);

  useEffect(() => {
    const fetchUserData = async () => {
      if (!chatSession) return;
      
      try {
        const { data } = await supabase.auth.getUser();
        if (!data.user) return;
        
        const otherUserId = chatSession.user1_id === data.user.id ? chatSession.user2_id : chatSession.user1_id;
        
        const { data: profileData } = await supabase
          .from('profiles')
          .select('*')
          .eq('id', otherUserId)
          .single();
        
        // Simulating favorite status since we don't have a favorites table
        setIsFavorited(false);
        
        if (profileData) {
          setOtherUser({
            id: otherUserId,
            name: profileData.full_name || 'Unknown User',
            avatar: profileData.avatar_url,
            isOnline: false,
            lastActive: 'Recently'
          });
        }
      } catch (error) {
        console.error("Error fetching user data:", error);
      }
    };
    
    fetchUserData();
  }, [chatSession]);
  
  const handleBack = () => {
    navigate('/messages');
  };
  
  const handleSendMessage = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!newMessage.trim()) return;
    
    if (isBlocked) {
      soundManager.play('notification');
      toast({
        title: "Blocked User",
        description: "You cannot send messages to blocked users",
      });
      return;
    }
    
    const success = await sendMessage(newMessage.trim());
    if (success) {
      setNewMessage('');
    }
  };

  const handleSendYo = async () => {
    if (isBlocked) {
      soundManager.play('notification');
      toast({
        title: "Blocked User",
        description: "You cannot send Yo to blocked users",
      });
      return;
    }
    
    const success = await sendMessage("YO!", "yo");
    if (success) {
      toast({
        title: "Yo Sent!",
        description: "You sent a Yo to this user"
      });
    }
  };

  const handleSendLocation = async () => {
    if (isBlocked) {
      soundManager.play('notification');
      toast({
        title: "Blocked User",
        description: "You cannot send location to blocked users",
      });
      return;
    }

    try {
      navigator.geolocation.getCurrentPosition(
        async (position) => {
          const locationData = {
            latitude: position.coords.latitude,
            longitude: position.coords.longitude
          };
          
          const locationMessage = `📍 Location: ${position.coords.latitude}, ${position.coords.longitude}`;
          const success = await sendMessage(locationMessage, "location");
          
          if (success) {
            toast({
              title: "Location Shared",
              description: "Your current location has been sent"
            });
          }
        },
        (error) => {
          toast({
            title: "Location Error",
            description: "Unable to access your location. Please check permissions.",
            variant: "destructive"
          });
        }
      );
    } catch (error) {
      toast({
        title: "Location Sharing Failed",
        description: "There was a problem sharing your location",
        variant: "destructive"
      });
    }
  };

  const handleSendVoice = () => {
    toast({
      title: "Voice Messages",
      description: "Voice message feature coming soon!",
    });
  };
  
  const handleUploadImage = async (e: React.ChangeEvent<HTMLInputElement>) => {
    if (!e.target.files || e.target.files.length === 0) return;
    
    if (isBlocked) {
      soundManager.play('notification');
      toast({
        title: "Blocked User",
        description: "You cannot send images to blocked users",
      });
      return;
    }
    
    try {
      setUploadingImage(true);
      
      const file = e.target.files[0];
      const fileExt = file.name.split('.').pop();
      const fileName = `${crypto.randomUUID()}.${fileExt}`;
      const filePath = `chat-images/${fileName}`;
      
      const { error: uploadError } = await supabase.storage
        .from('chat-media')
        .upload(filePath, file);
      
      if (uploadError) throw uploadError;
      
      const { data } = supabase.storage
        .from('chat-media')
        .getPublicUrl(filePath);
      
      await sendMessage(data.publicUrl, 'image');
      
    } catch (error) {
      toast({
        title: "Upload failed",
        description: error instanceof Error ? error.message : "Could not upload image",
        variant: "destructive"
      });
    } finally {
      setUploadingImage(false);
    }
  };
  
  const handleEmojiSelect = (emoji: string) => {
    setNewMessage(prev => prev + emoji);
    setShowEmojiPicker(false);
  };
  
  const handleStartVideoCall = () => {
    if (!otherUser) return;
    
    if (isBlocked) {
      soundManager.play('notification');
      toast({
        title: "Blocked User",
        description: "You cannot call blocked users",
      });
      return;
    }

    soundManager.play('match');
    setIsVideoCallOpen(true);
    toast({
      title: "Calling",
      description: `Starting video call with ${otherUser.name}`,
    });
  };

  const handleIncomingCall = () => {
    if (!otherUser || isBlocked) return;
    
    if (Math.random() > 0.7) {
      const timeout = Math.floor(Math.random() * 10000) + 5000;
      setTimeout(() => {
        soundManager.play('match');
        setIncomingCall(true);
        setIsVideoCallOpen(true);
      }, timeout);
    }
  };

  const toggleFavorite = async () => {
    try {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user || !otherUser) return;

      // Simulate toggling favorite status since we don't have a favorites table
      setIsFavorited(!isFavorited);
      
      toast({
        title: isFavorited ? "Removed from Favorites" : "Added to Favorites",
        description: `${otherUser.name} has been ${isFavorited ? 'removed from' : 'added to'} your favorites`
      });
    } catch (error) {
      toast({
        title: "Error",
        description: "Failed to update favorites",
        variant: "destructive"
      });
    }
  };

  useEffect(() => {
    if (otherUser && !loading) {
      handleIncomingCall();
    }
  }, [otherUser, loading]);
  
  useEffect(() => {
    if (!loading && messagesEndRef.current) {
      messagesEndRef.current.scrollIntoView({ behavior: 'smooth' });
    }
  }, [messages, loading]);
  
  const handleScroll = (e: React.UIEvent<HTMLDivElement>) => {
    const { scrollTop, scrollHeight, clientHeight } = e.currentTarget;
    setScrollToBottomVisible(scrollHeight - scrollTop - clientHeight > 100);
  };

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  };
  
  if (loading) {
    return (
      <div className="flex flex-col h-screen bg-yobro-dark text-white items-center justify-center">
        <Spinner />
        <div className="text-lg mt-4">Loading conversation...</div>
      </div>
    );
  }
  
  if (error || !chatSession) {
    return (
      <div className="flex flex-col h-screen bg-yobro-dark text-white items-center justify-center">
        <div className="text-lg">Conversation not found</div>
        <button onClick={handleBack} className="mt-4 px-4 py-2 bg-yobro-blue rounded-lg">
          Go Back
        </button>
      </div>
    );
  }

  return (
    <div className="flex flex-col h-screen bg-yobro-dark text-white">
      <ChatHeader
        otherUser={otherUser}
        onBack={handleBack}
        isBlocked={isBlocked}
        onStartVideoCall={handleStartVideoCall}
        onToggleOptions={setShowOptions}
        showOptions={showOptions}
        onBlockUser={toggleBlockUser}
        onNavigateToProfile={(userId) => navigate(`/profile/${userId}`)}
        sectionOrigin={sectionOrigin}
      />

      <div className="flex justify-between px-4 py-2 pt-16">
        <div className="flex items-center">
          {isTyping && (
            <div className="text-sm text-gray-400">
              {otherUser?.name} is typing...
            </div>
          )}
        </div>
        
        <button 
          onClick={toggleFavorite}
          className="text-gray-300 hover:text-pink-500"
        >
          {isFavorited ? (
            <Heart className="w-5 h-5 fill-pink-500 text-pink-500" />
          ) : (
            <Heart className="w-5 h-5" />
          )}
        </button>
      </div>

      <div 
        className="flex-1 overflow-y-auto pb-20 px-4"
        onScroll={handleScroll}
      >
        {isBlocked && (
          <div className="bg-[#2A2A2A] rounded-lg p-3 mb-4 text-center">
            <p className="text-sm text-white">You've blocked this user</p>
            <button 
              onClick={toggleBlockUser}
              className="text-xs text-yobro-amber mt-1"
            >
              Unblock to message
            </button>
          </div>
        )}

        {messages.map((message) => (
          <MessageItem
            key={message.id}
            message={message}
            isOwnMessage={message.sender_id === currentUserId}
            sectionOrigin={sectionOrigin}
          />
        ))}
        <div ref={messagesEndRef} />
      </div>

      {scrollToBottomVisible && (
        <button
          onClick={scrollToBottom}
          className="fixed bottom-24 right-4 z-20 bg-[#403E43] p-2 rounded-full shadow-lg"
        >
          <ArrowDownCircle className="w-5 h-5 text-white" />
        </button>
      )}

      <ChatInput
        newMessage={newMessage}
        setNewMessage={setNewMessage}
        handleSendMessage={handleSendMessage}
        handleUploadImage={handleUploadImage}
        handleEmojiSelect={handleEmojiSelect}
        handleSendYo={handleSendYo}
        handleSendLocation={handleSendLocation}
        handleSendVoice={handleSendVoice}
        isBlocked={isBlocked}
        uploadingImage={uploadingImage}
        showEmojiPicker={showEmojiPicker}
        setShowEmojiPicker={setShowEmojiPicker}
        sectionOrigin={sectionOrigin}
      />

      <VideoCallDialog 
        isOpen={isVideoCallOpen}
        onClose={() => {
          setIsVideoCallOpen(false);
          setIncomingCall(false);
        }}
        user={otherUser}
        isIncoming={incomingCall}
        onAccept={() => setIncomingCall(false)}
        onReject={() => {
          setIsVideoCallOpen(false);
          setIncomingCall(false);
        }}
      />
    </div>
  );
};

export default ChatView;
