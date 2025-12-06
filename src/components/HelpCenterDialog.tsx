
import React, { useState, useRef, useEffect } from 'react';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription } from '@/components/ui/dialog';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { ScrollArea } from '@/components/ui/scroll-area';
import { Send, X, HelpCircle, Shield, AlertTriangle } from 'lucide-react';
import { toast } from '@/hooks/use-toast';

interface HelpCenterDialogProps {
  isOpen: boolean;
  onClose: () => void;
}

interface HelpMessage {
  id: string;
  content: string;
  sender: 'user' | 'ai';
  type?: 'warning' | 'info' | 'alert';
}

const HelpCenterDialog: React.FC<HelpCenterDialogProps> = ({ isOpen, onClose }) => {
  const [query, setQuery] = useState('');
  const [messages, setMessages] = useState<HelpMessage[]>([
    {
      id: '1',
      content: "Hello! I'm your YoBro AI assistant. How can I help you today?",
      sender: 'ai',
    },
  ]);
  const [isProcessing, setIsProcessing] = useState(false);
  const messagesEndRef = useRef<HTMLDivElement>(null);

  // Auto-scroll to bottom when messages change
  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages]);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!query.trim()) return;

    // Add user message
    const userMessage: HelpMessage = {
      id: Date.now().toString(),
      content: query,
      sender: 'user',
    };
    
    setMessages((prev) => [...prev, userMessage]);
    setIsProcessing(true);
    
    // Process query for flagged content
    const lowerCaseQuery = query.toLowerCase();
    const hasPotentialProstitutionContent = checkForProstitutionContent(lowerCaseQuery);
    const hasPotentialDrugContent = checkForDrugContent(lowerCaseQuery);
    
    // Clear input
    setQuery('');
    
    // Simulate AI processing delay
    setTimeout(() => {
      let response: HelpMessage;
      
      if (hasPotentialProstitutionContent) {
        response = {
          id: (Date.now() + 1).toString(),
          content: "I've detected content that may violate our community guidelines regarding solicitation or prostitution. YoBro strictly prohibits any form of solicitation, escort services, or offering sexual services for payment. Users who violate these guidelines may have their accounts suspended or terminated.",
          sender: 'ai',
          type: 'warning'
        };
        
        toast({
          title: "Content Warning",
          description: "Potential violation of community guidelines detected",
        });
      } else if (hasPotentialDrugContent) {
        response = {
          id: (Date.now() + 1).toString(),
          content: "I've detected content that may relate to drug use. Please be aware that YoBro prohibits the use, promotion, or display of drugs during video calls or in Zoom rooms. This is for the safety and wellbeing of all users.",
          sender: 'ai',
          type: 'warning'
        };
        
        toast({
          title: "Content Warning",
          description: "References to prohibited activities detected",
        });
      } else {
        // Generate AI response based on query
        response = generateAIResponse(lowerCaseQuery);
      }
      
      setMessages((prev) => [...prev, response]);
      setIsProcessing(false);
    }, 1000);
  };

  // Check for prostitution-related content
  const checkForProstitutionContent = (text: string): boolean => {
    const prostitutionKeywords = [
      'escort', 'prostitute', 'hooker', 'call girl', 'pay for sex',
      'sexual services', 'happy ending', 'paid companionship', 'solicitation',
      'sell body', 'selling body', 'pay to meet', 'pay to date'
    ];
    
    return prostitutionKeywords.some(keyword => text.includes(keyword));
  };
  
  // Check for drug-related content
  const checkForDrugContent = (text: string): boolean => {
    const drugKeywords = [
      'cocaine', 'heroin', 'meth', 'weed', 'marijuana', 'pot', 'drugs', 'getting high',
      'smoking', 'vaping', 'pills', 'ecstasy', 'mdma', 'lsd', 'acid', 'shrooms'
    ];
    
    return drugKeywords.some(keyword => text.includes(keyword));
  };

  // Generate AI response based on user query
  const generateAIResponse = (query: string): HelpMessage => {
    // Common help topics
    if (query.includes('profile') || query.includes('setup')) {
      return {
        id: Date.now().toString(),
        content: 'To set up or edit your profile, go to your profile page and tap the edit button. Make sure to add clear photos and an engaging bio to increase your chances of making connections!',
        sender: 'ai',
      };
    } else if (query.includes('block') || query.includes('report')) {
      return {
        id: Date.now().toString(),
        content: 'To block or report a user, go to their profile or open your conversation with them, tap the three dots menu, and select "Block User" or "Report User". We take all reports seriously and will review them promptly.',
        sender: 'ai',
      };
    } else if (query.includes('video call') || query.includes('zoom')) {
      return {
        id: Date.now().toString(),
        content: 'To start a video call, open a chat with the user you want to connect with and tap the video icon. For Zoom rooms, you can join city-based rooms from the Connect tab. Remember that drug use is strictly prohibited during video calls and in Zoom rooms.',
        sender: 'ai',
        type: 'info'
      };
    } else if (query.includes('delete') || query.includes('account')) {
      return {
        id: Date.now().toString(),
        content: 'To delete your account, go to Settings > Account > Delete Account. Please note that this action is permanent and all your data will be removed from our systems.',
        sender: 'ai',
      };
    } else if (query.includes('payment') || query.includes('subscription') || query.includes('premium')) {
      return {
        id: Date.now().toString(),
        content: 'For payment or subscription inquiries, please go to Settings > Subscription. There you can manage your subscription plan, payment methods, and billing history.',
        sender: 'ai',
      };
    } else if (query.includes('guidelines') || query.includes('rules') || query.includes('terms')) {
      return {
        id: Date.now().toString(),
        content: 'YoBro has strict community guidelines that prohibit harassment, hate speech, solicitation, prostitution, and drug use. You can review our full terms of service and community guidelines in Settings > Legal > Terms of Service.',
        sender: 'ai',
        type: 'info'
      };
    } else {
      // Generic response for other queries
      return {
        id: Date.now().toString(),
        content: "I'm here to help with any questions about using YoBro! You can ask about profile setup, messaging, video calls, connection features, or reporting problems. How else can I assist you today?",
        sender: 'ai',
      };
    }
  };

  return (
    <Dialog open={isOpen} onOpenChange={(open) => !open && onClose()}>
      <DialogContent className="sm:max-w-[500px] max-h-[80vh] flex flex-col bg-black border border-[#333] p-0 overflow-hidden">
        <DialogHeader className="p-4 border-b border-[#333]">
          <div className="flex items-center justify-between">
            <div className="flex items-center">
              <HelpCircle className="h-5 w-5 text-[#C2FFE6] mr-2" />
              <DialogTitle className="text-[#C2FFE6]">YoBro Help Center</DialogTitle>
            </div>
            <Button variant="ghost" size="icon" onClick={onClose} className="h-8 w-8">
              <X className="h-4 w-4 text-[#C2FFE6]" />
            </Button>
          </div>
          <DialogDescription className="text-[#C2FFE6]/70">
            Ask any questions about using YoBro
          </DialogDescription>
        </DialogHeader>

        <ScrollArea className="flex-1 p-4 overflow-auto">
          <div className="space-y-4">
            {messages.map((message) => (
              <div
                key={message.id}
                className={`flex ${message.sender === 'user' ? 'justify-end' : 'justify-start'}`}
              >
                <div
                  className={`max-w-[80%] rounded-lg p-3 ${
                    message.sender === 'user'
                      ? 'bg-yobro-blue text-white'
                      : message.type === 'warning'
                      ? 'bg-red-900/70 text-white'
                      : message.type === 'info'
                      ? 'bg-blue-900/70 text-white'
                      : 'bg-[#2A2A2A] text-white'
                  }`}
                >
                  {message.type === 'warning' && (
                    <div className="flex items-center mb-2">
                      <Shield className="h-4 w-4 text-red-400 mr-1" />
                      <span className="text-red-400 text-sm font-medium">Content Warning</span>
                    </div>
                  )}
                  {message.type === 'info' && (
                    <div className="flex items-center mb-2">
                      <AlertTriangle className="h-4 w-4 text-blue-400 mr-1" />
                      <span className="text-blue-400 text-sm font-medium">Information</span>
                    </div>
                  )}
                  <p className="text-sm">{message.content}</p>
                </div>
              </div>
            ))}
            <div ref={messagesEndRef} />
          </div>
        </ScrollArea>

        <form onSubmit={handleSubmit} className="p-4 border-t border-[#333] flex items-center">
          <Input
            type="text"
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            placeholder="Type your question..."
            className="flex-1 bg-[#2A2A2A] border border-[#3A3A3A] text-white"
          />
          <Button
            type="submit"
            disabled={!query.trim() || isProcessing}
            className={`ml-2 ${
              !query.trim() || isProcessing ? 'bg-gray-700' : 'bg-[#C2FFE6] hover:bg-[#C2FFE6]/80'
            }`}
            variant="default"
          >
            <Send className={`h-4 w-4 ${!query.trim() || isProcessing ? 'text-gray-400' : 'text-black'}`} />
          </Button>
        </form>
      </DialogContent>
    </Dialog>
  );
};

export default HelpCenterDialog;
