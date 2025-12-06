
import { useState, useEffect } from 'react';
import { RoomUser } from './types';

export function useRoomUsers(activeUsers: number, roomType: string, roomName: string) {
  const [roomUsers, setRoomUsers] = useState<RoomUser[]>([]);

  // Generate mock room users
  useEffect(() => {
    const roles = ['top-dom', 'top', 'vers-top', 'vers', 'vers-bottom', 'bottom', 'power-bottom'];
    const mockUsers = Array.from({ length: Math.min(activeUsers, 50) }, (_, i) => ({
      id: `user-${i}`,
      name: `Bro${i + 1}`,
      image: Math.random() > 0.3 ? `https://source.unsplash.com/random/100x100?face&${i}` : undefined,
      isOnline: Math.random() > 0.3,
      isMuted: Math.random() > 0.6,
      isCameraOff: Math.random() > 0.5,
      isSpeaking: Math.random() > 0.8,
      role: Math.random() > 0.7 ? roles[Math.floor(Math.random() * roles.length)] : undefined
    }));
    setRoomUsers(mockUsers);
    
  }, [activeUsers]);

  return {
    roomUsers,
    setRoomUsers
  };
}
