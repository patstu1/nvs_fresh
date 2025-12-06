
import React, { useState } from 'react';
import { Button } from '@/components/ui/button';
import { MessageCircle } from 'lucide-react';

interface Message {
  user: string;
  text: string;
  fromSelf: boolean;
}

interface ChatOverlayProps {
  showChatOverlay: boolean;
  setShowChatOverlay: (show: boolean) => void;
}

const ChatOverlay: React.FC<ChatOverlayProps> = ({ 
  showChatOverlay, 
  setShowChatOverlay 
}) => {
  const [messages, setMessages] = useState<Message[]>([]);
  const [newMessage, setNewMessage] = useState('');

  const handleSendMessage = () => {
    if (newMessage.trim()) {
      setMessages([...messages, { 
        user: 'You', 
        text: newMessage, 
        fromSelf: true 
      }]);
      setNewMessage('');
      
      // Simulate a response after a delay
      setTimeout(() => {
        setMessages(prev => [...prev, {
          user: 'MapUser23',
          text: 'Anyone at Venue A tonight?',
          fromSelf: false
        }]);
      }, 3000);
    }
  };

  return (
    <>
      <div className="absolute bottom-24 left-4 z-10">
        <Button
          onClick={() => setShowChatOverlay(!showChatOverlay)}
          className="bg-[#C2FFE6] text-black hover:bg-[#C2FFE6]/90 rounded-full w-12 h-12 flex items-center justify-center"
        >
          <MessageCircle className="w-5 h-5" />
        </Button>
      </div>
      
      {showChatOverlay && (
        <div className="absolute bottom-24 left-16 z-10 w-72 bg-black border border-[#C2FFE6]/30 rounded-lg shadow-lg p-3 backdrop-blur-lg">
          <h3 className="font-medium text-[#C2FFE6] mb-2">Area Chat</h3>
          <div className="max-h-40 overflow-y-auto mb-2 space-y-2">
            {messages.length === 0 ? (
              <p className="text-xs text-[#C2FFE6]/50 italic">No messages yet. Start the conversation!</p>
            ) : (
              messages.map((msg, i) => (
                <div key={i} className={`flex ${msg.fromSelf ? 'justify-end' : 'justify-start'}`}>
                  <div className={`rounded-lg px-3 py-1.5 max-w-[80%] ${msg.fromSelf ? 'bg-[#C2FFE6]/20 text-white' : 'bg-[#1A2332] text-[#C2FFE6]/90'}`}>
                    <p className="text-xs">{!msg.fromSelf && <span className="font-medium">{msg.user}: </span>}{msg.text}</p>
                  </div>
                </div>
              ))
            )}
          </div>
          <div className="flex">
            <input
              type="text"
              value={newMessage}
              onChange={(e) => setNewMessage(e.target.value)}
              placeholder="Type a message..."
              className="flex-1 bg-[#1A2332] text-[#C2FFE6] text-sm border border-[#C2FFE6]/30 rounded-l-md px-2 py-1 focus:outline-none"
            />
            <Button 
              size="sm"
              onClick={handleSendMessage}
              className="bg-[#C2FFE6] text-black hover:bg-[#C2FFE6]/90 rounded-r-md"
            >
              Send
            </Button>
          </div>
        </div>
      )}
    </>
  );
};

export default ChatOverlay;
