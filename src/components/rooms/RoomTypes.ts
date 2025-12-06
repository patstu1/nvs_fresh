
export interface Room {
  id: string;
  name: string;
  country: string;
  userCount: number;
  capacity: number;
  isNearYou: boolean;
  type?: 'local' | 'city' | 'forum';
  distance?: number;
  topic?: string;
}

export type LocalRoom = Room & {
  type: 'local';
  distance: number;
};

export type CityRoom = Room & {
  type: 'city';
};

export type ForumRoom = Room & {
  type: 'forum';
  topic: string;
};

export interface ConnectProfile {
  id: string;
  name: string;
  image: string;
  distance: number;
}
