
export interface MapUser {
  id: string;
  name: string;
  position: {
    lat: number;
    lng: number;
  };
  profileImage: string;
  isOnline: boolean;
  isNew?: boolean;
  hasPrivateAlbum?: boolean;
  distance?: string;
  lastActive?: string;
  compatibilityScore?: number;
  age?: number;
  isBlurred?: boolean;
}

export interface FilterSettings {
  showOnline: boolean;
  showNew: boolean;
  distance: number;
  ageRange: [number, number];
  hasPhotos: boolean;
  hostingType?: 'all' | 'hosting' | 'traveling';
}

export interface MapSettings {
  is3DMode: boolean;
  showHeatMap: boolean;
  showClusters: boolean;
  anonymousMode: boolean;
  blurUserImages: boolean;
  mapStyle: 'dark' | 'light' | 'satellite';
}
