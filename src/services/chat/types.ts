
import { UserProfile } from "@/types/UserProfile";

export type ChatOriginSection = 'grid' | 'now' | 'connect' | 'live' | 'unknown';

export interface Message {
  id: string;
  content: string;
  sender_id: string;
  sent_at: string;
  read_at: string | null;
  is_deleted: boolean;
  message_type: 'text' | 'image' | 'location' | 'emoji' | 'yo' | 'voice' | 'video';
  reactions?: MessageReaction[];
  media_url?: string;
  location_data?: {
    latitude: number;
    longitude: number;
    address?: string;
  };
  is_typing?: boolean;
}

export interface MessageReaction {
  id: string;
  message_id: string;
  user_id: string;
  emoji: string;
}

export interface ChatSession {
  id: string;
  user1_id: string;
  user2_id: string;
  created_at: string;
  last_message_at: string;
  is_active: boolean;
  origin_section: ChatOriginSection;
  other_user?: UserProfile;
  last_message?: Message;
  unread_count?: number;
  is_favorited?: boolean;
}
