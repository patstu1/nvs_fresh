import React, { useState, useEffect } from 'react';
import { TrendingUp, Clock } from 'lucide-react';
import { cn } from '@/lib/utils';
import { toast } from '@/hooks/use-toast';
import soundManager from '@/utils/soundManager';
import { format, formatDistanceToNow } from 'date-fns';

interface ProfileView {
  id: string;
  name: string;
  image: string;
  timestamp: string;
}

interface YoViewProps {
  onYoSend: (id: string) => void;
}

const YoView: React.FC<YoViewProps> = ({ onYoSend }) => {
  const recentUsers = [
    { id: '1', name: 'Alex', image: 'https://images.unsplash.com/photo-1504257432389-52343af06ae3?w=500&h=500&fit=crop' },
    { id: '2', name: 'Brandon', image: 'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=500&h=500&fit=crop' },
    { id: '3', name: 'Carlos', image: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=500&h=500&fit=crop' },
  ];
  
  const [profileViews, setProfileViews] = useState<ProfileView[]>([]);
  
  useEffect(() => {
    // Initialize sound manager when component mounts
    try {
      soundManager.initialize();
      // Try to preload the sound to check if it's available
      soundManager.play('yo', 0); // Play at 0 volume to preload
    } catch (error) {
      console.error('Sound initialization error:', error);
    }
    
    const loadProfileViews = () => {
      const viewHistory = JSON.parse(localStorage.getItem('profileViewHistory') || '[]');
      setProfileViews(viewHistory);
    };
    
    loadProfileViews();
    
    const intervalId = setInterval(() => {
      loadProfileViews();
    }, 60000);
    
    return () => clearInterval(intervalId);
  }, []);

  const handleSendYo = (id: string) => {
    try {
      soundManager.play('yo');
      
      toast({
        title: "YO!",
        description: `You sent a YO!`,
      });
      
      onYoSend(id);
    } catch (error) {
      console.error('Error playing YO sound:', error);
      toast({
        title: "YO!",
        description: `You sent a YO! (sound unavailable)`,
      });
      
      onYoSend(id);
    }
  };
  
  const formatTimestamp = (timestamp: string) => {
    try {
      const date = new Date(timestamp);
      return formatDistanceToNow(date, { addSuffix: true });
    } catch (error) {
      return "recently";
    }
  };
  
  return (
    <div className="w-full h-full pt-16 pb-20 px-4">
      <div className="mb-8">
        <h2 className="text-xl font-bold text-[#C2FFE6] mb-4 font-lelabo">Say YO</h2>
        <p className="text-[#C2FFE6]/70 mb-6 font-lelabo">Get someone's attention with a quick YO!</p>
        
        <div className="grid grid-cols-3 gap-4">
          {recentUsers.map((user) => (
            <div key={user.id} className="text-center">
              <div className="relative mb-2">
                <img 
                  src={user.image} 
                  alt={user.name}
                  className="w-20 h-20 rounded-full object-cover mx-auto border-2 border-[#C2FFE6] shadow-[0_0_3px_rgba(194,255,230,0.3),0_0_3px_rgba(194,255,230,0.2),inset_0_0_2px_rgba(194,255,230,0.2)]"
                />
                <button 
                  onClick={() => handleSendYo(user.id)}
                  className={cn(
                    "absolute -bottom-2 -right-2 w-8 h-8 rounded-full flex items-center justify-center",
                    "border-2 border-[#FDE1D3] bg-black shadow-[0_0_8px_rgba(253,225,211,0.6)]"
                  )}
                >
                  <TrendingUp className="w-4 h-4 text-[#FDE1D3]" />
                </button>
              </div>
              <p className="text-sm text-[#C2FFE6] font-lelabo">{user.name}</p>
            </div>
          ))}
        </div>
      </div>
      
      <div className="mb-6">
        <div className="flex items-center mb-4">
          <Clock className="w-5 h-5 text-[#C2FFE6] mr-2" />
          <h3 className="text-lg font-medium text-[#C2FFE6] font-lelabo">Profile Views</h3>
        </div>
        
        {profileViews.length === 0 ? (
          <p className="text-[#C2FFE6]/50 text-sm italic">No one has viewed your profile yet</p>
        ) : (
          <div className="space-y-3">
            {profileViews.map((view) => (
              <div key={`${view.id}-${view.timestamp}`} className="flex items-center bg-black/40 rounded-lg p-3 border border-[#C2FFE6]/10">
                <div className="w-12 h-12 rounded-full overflow-hidden border-2 border-[#C2FFE6]/30 mr-3">
                  <img 
                    src={view.image} 
                    alt={view.name}
                    className="w-full h-full object-cover"
                  />
                </div>
                <div className="flex-1">
                  <p className="text-sm text-[#C2FFE6] font-lelabo">{view.name}</p>
                  <p className="text-xs text-[#C2FFE6]/50">{formatTimestamp(view.timestamp)}</p>
                </div>
                <button 
                  onClick={() => handleSendYo(view.id)}
                  className="ml-2 w-8 h-8 rounded-full flex items-center justify-center border border-[#FDE1D3]/30 bg-black/50 hover:bg-[#FDE1D3]/10"
                >
                  <TrendingUp className="w-4 h-4 text-[#FDE1D3]" />
                </button>
              </div>
            ))}
          </div>
        )}
      </div>
      
      <div>
        <h3 className="text-lg font-medium text-[#C2FFE6] mb-3 font-lelabo">Recent YO's</h3>
        <div className="divide-y divide-[#C2FFE6]/10">
          <div className="py-3 flex items-center">
            <div className="w-10 h-10 rounded-full overflow-hidden border-2 border-[#C2FFE6] bg-black shadow-[0_0_3px_rgba(194,255,230,0.3),0_0_3px_rgba(194,255,230,0.2),inset_0_0_2px_rgba(194,255,230,0.2)] mr-3">
              <img 
                src="https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=500&h=500&fit=crop" 
                alt="Brandon"
                className="w-full h-full object-cover"
              />
            </div>
            <div>
              <p className="text-sm text-[#C2FFE6] font-lelabo">Brandon sent you a YO!</p>
              <p className="text-xs text-[#C2FFE6]/50 font-lelabo">2 hours ago</p>
            </div>
          </div>
          <div className="py-3 flex items-center">
            <div className="w-10 h-10 rounded-full overflow-hidden border-2 border-[#C2FFE6] bg-black shadow-[0_0_3px_rgba(194,255,230,0.3),0_0_3px_rgba(194,255,230,0.2),inset_0_0_2px_rgba(194,255,230,0.2)] mr-3">
              <img 
                src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=500&h=500&fit=crop" 
                alt="Carlos"
                className="w-full h-full object-cover"
              />
            </div>
            <div>
              <p className="text-sm text-[#C2FFE6] font-lelabo">You sent Carlos a YO!</p>
              <p className="text-xs text-[#C2FFE6]/50 font-lelabo">Yesterday</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default YoView;
