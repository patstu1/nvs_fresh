
import { Room, ConnectProfile } from '../RoomTypes';

export interface RoomManagementState {
  isLocationMatchingEnabled: boolean;
  currentCity: { name: string; country: string };
  activeView: 'rooms' | 'feed';
  selectedRoom: string | null;
  activeRoomUsers: number;
  userLocation: {lat: number, lng: number} | null;
  userLocalRoomId: string;
  popularConnects: ConnectProfile[];
  citiesWithRooms: Room[];
  forumRooms: Room[];
}
