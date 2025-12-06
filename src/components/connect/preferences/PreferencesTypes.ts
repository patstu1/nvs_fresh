
export interface SocialMediaConnections {
  instagram?: string;
  twitter?: string;
  facebook?: string;
  snapchat?: string;
  tiktok?: string;
  linkedin?: string;
  referralCode?: string;
  inviteLink?: string;
}

export interface ImportanceValues {
  appearance: number;
  personality: number;
  interests: number;
  lifestyle: number;
}

export type PreferencesTabType = 'basics' | 'personality' | 'social' | 'summary';

export interface Preferences {
  lookingFor: string[];
  ageRange: number[];
  distance: number;
  showMe: boolean;
  notifications: {
    matches: boolean;
    messages: boolean;
    nearby: boolean;
  };
  socialMedia?: SocialMediaConnections;
  displayName?: string;
  interests?: string[];
  personality?: {
    traits: string[];
    values: string[];
  };
  // New fields
  importanceValues: ImportanceValues;
  dealBreakers: string[];
  hobbies: string[];
  personalityTraits: string[];
  valueAlignments: string[];
}

export const getImportanceLabel = (value: number): string => {
  if (value <= 33) return "Less Important";
  if (value <= 66) return "Important";
  return "Very Important";
};
