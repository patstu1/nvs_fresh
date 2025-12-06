
// Define types for the Connect Preferences feature

export type PersonalityTrait = 
  | 'gym-rat' 
  | 'traveler' 
  | 'homebody' 
  | 'party-boy' 
  | 'bookish' 
  | 'wildcard' 
  | 'clean-cut' 
  | 'kinky' 
  | 'spiritual' 
  | 'entrepreneurial' 
  | 'artsy' 
  | 'hustler' 
  | 'low-key' 
  | 'drama-free' 
  | 'daddy' 
  | 'boy' 
  | 'masc' 
  | 'soft-masc' 
  | 'faggy-proud';

export type SexualRole = 
  | 'top-dom-breeder'
  | 'top'
  | 'vers-top'
  | 'vers'
  | 'vers-bottom'
  | 'bottom'
  | 'power-bottom';

export type DatingIntent = 
  | 'hookup-only' 
  | 'casual' 
  | 'relationship' 
  | 'exploring';

export type SexualPreference =
  | 'dom-sub'
  | 'kink-friendly'
  | 'masculine-energy'
  | 'romantic'
  | 'video-cam'
  | 'groups-voyeur'
  | 'slow-build';

export type PoliticalLeaning =
  | 'liberal'
  | 'moderate'
  | 'conservative'
  | 'apolitical';

export type FamilyValues =
  | 'traditional'
  | 'modern'
  | 'none';

export type DietPreference =
  | 'omnivore'
  | 'vegetarian'
  | 'vegan'
  | 'keto'
  | 'paleo';

export type ReligiousView =
  | 'religious'
  | 'spiritual'
  | 'agnostic'
  | 'atheist';

export type DrugUse =
  | 'never'
  | 'socially'
  | 'regularly';

export type FamilyViews = 
  | 'wants-children'
  | 'has-children'
  | 'no-children'
  | 'open-to-children'
  | 'prefers-no-children';

export type LifeGoal = 
  | 'career-focused'
  | 'education'
  | 'travel'
  | 'settling-down'
  | 'entrepreneurship'
  | 'creative-pursuits'
  | 'financial-stability'
  | 'personal-growth'
  | 'community-building';

export type CoreValue = 
  | 'honesty'
  | 'loyalty'
  | 'ambition'
  | 'compassion'
  | 'tradition'
  | 'innovation'
  | 'adventure'
  | 'stability'
  | 'independence'
  | 'community';

export type ReligiousBackground = 
  | 'christian'
  | 'catholic'
  | 'jewish'
  | 'muslim'
  | 'buddhist'
  | 'hindu'
  | 'spiritual'
  | 'agnostic'
  | 'atheist'
  | 'other';

export type ReligiousLevel =
  | 'very-religious'
  | 'moderately-religious'
  | 'somewhat-religious'
  | 'not-religious'
  | 'spiritual-not-religious';

export interface SocialMedia {
  instagram: string;
  twitter: string;
  tiktok: string;
  displayOnProfile: boolean;
}

export interface ConnectUserProfile {
  sexualRole?: SexualRole;
  datingIntent?: DatingIntent;
  sexualPreferences: SexualPreference[];
  personalityTraits: PersonalityTrait[];
  politicalLeaning?: PoliticalLeaning;
  familyValues?: FamilyValues;
  dietPreference?: DietPreference;
  religiousView?: ReligiousView;
  drugUse?: DrugUse;
  familyViews?: FamilyViews;
  lifeGoals: LifeGoal[];
  coreValues: CoreValue[];
  religiousBackground?: ReligiousBackground;
  religiousLevel?: ReligiousLevel;
  socialMedia: SocialMedia;
  profileSetupComplete: boolean;
}
