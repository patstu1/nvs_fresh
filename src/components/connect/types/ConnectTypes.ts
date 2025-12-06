
export interface RecentMatch {
  id: string;
  name: string;
  image: string;
  compatibility: number;
  isNew: boolean;
  interests: string[];
  lastActive?: string;
  connectionStrength?: number;
}

export interface Profile {
  id: string;
  name: string;
  age: number;
  image: string;
  compatibility: number;
  interests: string[];
  bio: string;
  emojis: string[];
  distance: number;
  role: string;
  attributes: {
    icon: React.ReactNode;
    label: string;
    value: string;
    color: string;
  }[];
}

export interface ConnectMatchProps {
  profile: Profile;
  onLike: () => void;
  onPass: () => void;
  onSuperLike: () => void;
  // Added missing properties
  isLoading?: boolean;
  onProfileMatch?: () => void;
  onVideoCall?: (id: string) => void;
  forceRender?: boolean;
}

export interface ProfileStatsProps {
  stats?: {
    neuralSync: number;
    quantumCoherence: number;
  };
  // Added missing property
  userProfileData?: any;
}
