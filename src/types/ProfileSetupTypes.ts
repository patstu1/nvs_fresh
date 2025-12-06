
import { z } from 'zod';

export type SocialMediaAccounts = {
  instagram?: string;
  twitter?: string;
  facebook?: string;
  linkedin?: string;
  github?: string;
  other?: string;
};

export type PersonalDetails = {
  name: string;
  age: number;
  bio: string;
  height?: number;
  bodyType?: string;
  ethnicity?: string;
  role?: string;
  profession?: string;
  education?: string;
};

export type CompatibilityPreferences = {
  wantsKids: boolean;
  hasKids: boolean;
  isFamilyOriented: boolean;
  isDrinker: boolean;
  isSmoker: boolean;
  isReligious: boolean;
  openToLongDistance: boolean;
  politicalView?: string;
  relationshipType?: string[];
  dealBreakers?: string[];
};

export type InterestsHobbies = {
  hobbies: string[];
  interests: string[];
  favoriteActivities: string[];
  music: string[];
  movies: string[];
  food: string[];
};

export type MediaData = {
  profilePictures: string[];
  profileVideo?: string;
  publicAlbum: string[];
  privateAlbum: string[];
};

export type ProfileFormValues = {
  personalDetails: PersonalDetails;
  socialMedia: SocialMediaAccounts;
  compatibility: CompatibilityPreferences;
  interests: InterestsHobbies;
  media: MediaData;
  allowAiAnalysis: boolean;
};

export const profileFormSchema = z.object({
  personalDetails: z.object({
    name: z.string().min(2, "Name is required"),
    age: z.number().min(18, "You must be at least 18 years old"),
    bio: z.string().min(10, "Please write at least 10 characters"),
    height: z.number().optional(),
    bodyType: z.string().optional(),
    role: z.string().optional(),
    profession: z.string().optional(),
    education: z.string().optional(),
  }),
  interests: z.object({
    hobbies: z.array(z.string()).default([]),
    interests: z.array(z.string()).default([]),
    favoriteActivities: z.array(z.string()).default([]),
    music: z.array(z.string()).default([]),
    movies: z.array(z.string()).default([]),
  }),
  compatibility: z.object({
    wantsKids: z.boolean().default(false),
    hasKids: z.boolean().default(false),
    isFamilyOriented: z.boolean().default(false),
    isDrinker: z.boolean().default(false),
    isSmoker: z.boolean().default(false),
    isReligious: z.boolean().default(false),
    openToLongDistance: z.boolean().default(false),
    politicalView: z.string().optional(),
    relationshipType: z.array(z.string()).default([]),
    dealBreakers: z.array(z.string()).default([]),
  }),
  media: z.object({
    profilePictures: z.array(z.string()).default([]),
    profileVideo: z.string().optional(),
    publicAlbum: z.array(z.string()).default([]),
    privateAlbum: z.array(z.string()).default([]),
  }),
  socialMedia: z.object({
    instagram: z.string().optional(),
    twitter: z.string().optional(),
    facebook: z.string().optional(),
    linkedin: z.string().optional(),
    other: z.string().optional(),
  }),
  allowAiAnalysis: z.boolean().default(false),
});

export const bodyTypes = [
  "Slim",
  "Athletic",
  "Average",
  "Muscular",
  "Curvy",
  "Large",
];

export const roles = [
  "Top",
  "Bottom",
  "Vers",
  "Top-Vers",
  "Bottom-Vers",
  "Dom",
  "Sub",
];

export const relationshipTypes = [
  "Long-term",
  "Short-term",
  "Casual",
  "Friends",
  "Hookups",
  "Open-relationship",
];
