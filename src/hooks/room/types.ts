
export interface RoomMessage {
  id: string;
  userId: string;
  userName: string;
  userImage?: string;
  userRole?: string;
  content: string;
  isImage: boolean;
  timestamp: Date;
  reactions: {
    emoji: string;
    count: number;
    reacted: boolean;
  }[];
  isFlagged?: boolean;
}

export interface RoomUser {
  id: string;
  name: string;
  image?: string;
  isOnline: boolean;
  isMuted?: boolean;
  isCameraOff?: boolean;
  isSpeaking?: boolean;
  role?: string;
}

export interface UseZoomRoomOptions {
  roomName: string;
  activeUsers: number;
  roomType?: 'local' | 'city' | 'forum';
}
