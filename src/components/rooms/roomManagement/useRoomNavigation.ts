
import { useState } from 'react';
import { toast } from '@/hooks/use-toast';
import { Room } from '../RoomTypes';

export function useRoomNavigation(roomsData: Room[]) {
  const [activeView, setActiveView] = useState<'rooms' | 'feed'>('rooms');
  const [selectedRoom, setSelectedRoom] = useState<string | null>(null);
  const [activeRoomUsers, setActiveRoomUsers] = useState(0);

  const handleOpenZoomRoom = (roomId: string, allRooms: Room[]) => {
    setSelectedRoom(roomId);
    setActiveView('feed');
    
    // Find the selected room to display user count
    const room = allRooms.find(room => room.id === roomId);
    if (room) {
      setActiveRoomUsers(room.userCount);
      
      if (room.type === 'forum') {
        toast({
          title: `Joining ${room.topic || room.name} Forum`,
          description: `You're connecting to the forum group with ${room.userCount} participants`
        });
      } else if (room.type === 'local') {
        toast({
          title: "Joining Local Room",
          description: `Connecting you to the ${room.userCount} bros nearest to you`
        });
      } else {
        toast({
          title: `Joining ${room.name} Room`,
          description: `Connecting to ${room.name} with ${room.userCount} active users`
        });
      }
    }
  };

  const handleBackToRooms = () => {
    setActiveView('rooms');
    setSelectedRoom(null);
  };

  const getSelectedRoomDetails = (citiesWithRooms: Room[], forumRooms: Room[]) => {
    if (!selectedRoom) return { name: 'Zoom Room', type: 'city' as const };
    
    // Check if this is a city room
    const cityRoom = citiesWithRooms.find(c => c.id === selectedRoom);
    if (cityRoom) {
      return { 
        name: cityRoom.name, 
        type: cityRoom.type || 'city' as const
      };
    }
    
    // Check if this is a forum room
    const forum = forumRooms.find(f => f.id === selectedRoom);
    if (forum) {
      return { 
        name: forum.topic || forum.name,
        type: 'forum' as const
      };
    }
    
    // Default return
    return { name: 'Zoom Room', type: 'city' as const };
  };

  return {
    activeView,
    selectedRoom,
    activeRoomUsers,
    setActiveRoomUsers,
    handleOpenZoomRoom,
    handleBackToRooms,
    getSelectedRoomDetails
  };
}
