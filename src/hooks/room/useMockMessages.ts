
import { useEffect } from 'react';
import { RoomMessage, RoomUser } from './types';

export function useMockMessages(
  roomUsers: RoomUser[], 
  roomType: 'local' | 'city' | 'forum' = 'city', 
  roomName: string, 
  setMessages: (messages: RoomMessage[]) => void
) {
  // Generate mock messages based on room type
  useEffect(() => {
    if (roomUsers.length === 0) return;
    
    const mockMessages: RoomMessage[] = [];
    const now = new Date();
    
    // Generate different template messages based on room type
    const localMessages = [
      'Anyone in the downtown area tonight?',
      'Just moved to this area, looking to meet people',
      'Any good bars around here?',
      'Hosting a small get-together nearby, DM me',
      'Is that new gym on 3rd street any good?'
    ];
    
    const cityMessages = [
      'Anyone free tonight in the city?',
      'New to the area, looking to connect',
      'Just got here, what\'s up?',
      'Hosting tonight, DM me',
      'Anyone going to the event downtown?'
    ];
    
    const forumMessages = [
      roomType === 'forum' && roomName.includes('Fitness') ? 'What\'s your workout routine?' : '',
      roomType === 'forum' && roomName.includes('Travel') ? 'Anyone been to Japan recently?' : '',
      roomType === 'forum' && roomName.includes('Gaming') ? 'Who\'s playing the new COD?' : '',
      roomType === 'forum' && roomName.includes('Food') ? 'Best recipe you\'ve tried lately?' : '',
      'Any recommendations?',
      'I\'m looking for advice on this topic',
      'Been into this for years, happy to help newbies',
      'Just joined this group, hello everyone!'
    ].filter(Boolean);
    
    const messageTemplates = 
      roomType === 'local' ? localMessages :
      roomType === 'forum' ? forumMessages :
      cityMessages;
    
    for (let i = 0; i < 15; i++) {
      const user = roomUsers[Math.floor(Math.random() * roomUsers.length)];
      const roles = ['top-dom', 'top', 'vers-top', 'vers', 'vers-bottom', 'bottom', 'power-bottom'];
      const isImage = Math.random() > 0.7;
      const time = new Date(now.getTime() - (Math.random() * 60 * 60 * 1000));
      
      mockMessages.push({
        id: `msg-${i}`,
        userId: user.id,
        userName: user.name,
        userImage: user.image,
        userRole: roles[Math.floor(Math.random() * roles.length)],
        content: isImage 
          ? 'https://source.unsplash.com/random/400x300?party'
          : messageTemplates[Math.floor(Math.random() * messageTemplates.length)] || 'Hello!',
        isImage,
        timestamp: time,
        reactions: [
          { emoji: '🔥', count: Math.floor(Math.random() * 10), reacted: Math.random() > 0.7 },
          { emoji: '❤️', count: Math.floor(Math.random() * 5), reacted: Math.random() > 0.7 },
          { emoji: '👍', count: Math.floor(Math.random() * 3), reacted: Math.random() > 0.7 }
        ]
      });
    }
    
    setMessages(mockMessages.sort((a, b) => a.timestamp.getTime() - b.timestamp.getTime()));
  }, [roomUsers, roomType, roomName, setMessages]);
}
