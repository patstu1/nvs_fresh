
import React from 'react';
import { Button } from '@/components/ui/button';
import { PhoneOff, Video } from 'lucide-react';

interface IncomingCallViewProps {
  user: {
    id: string;
    name: string;
    avatar?: string;
  };
  onReject: () => void;
  onAccept: () => void;
}

const IncomingCallView: React.FC<IncomingCallViewProps> = ({ 
  user,
  onReject,
  onAccept
}) => {
  return (
    <div className="flex flex-col items-center justify-center">
      <div className="w-24 h-24 rounded-full overflow-hidden mb-4">
        {user.avatar ? (
          <img src={user.avatar} alt={user.name} className="w-full h-full object-cover" />
        ) : (
          <div className="w-full h-full bg-yobro-blue flex items-center justify-center text-2xl">
            {user.name.charAt(0)}
          </div>
        )}
      </div>
      <h3 className="text-xl font-semibold mb-2">{user.name}</h3>
      <p className="text-[#90EE90] animate-pulse mb-8">Incoming video call...</p>
      
      <div className="flex space-x-4">
        <Button
          onClick={onReject}
          className="bg-red-500 hover:bg-red-600 rounded-full w-14 h-14 flex items-center justify-center"
        >
          <PhoneOff className="h-6 w-6" />
        </Button>
        <Button
          onClick={onAccept}
          className="bg-green-500 hover:bg-green-600 rounded-full w-14 h-14 flex items-center justify-center"
        >
          <Video className="h-6 w-6" />
        </Button>
      </div>
    </div>
  );
};

export default IncomingCallView;
