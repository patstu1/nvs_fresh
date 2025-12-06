
import mapboxgl from 'mapbox-gl';

export interface Location {
  lng: number;
  lat: number;
  zoom?: number;
}

export interface User {
  id: string;
  name: string;
  position: Location;
  profileImage?: string;
  isNew?: boolean;
  hasPrivateAlbum?: boolean;
  isOnline?: boolean;
  age?: number;  // Added age property
  tags?: string[];  // Added tags property
  online?: boolean; // Support for the existing code that uses online instead of isOnline
  image?: string;   // Support for the existing code that uses image
}

export interface Venue {
  id: string;
  name: string;
  position: Location;
  type: 'club' | 'bar' | 'cruise' | 'gym' | 'other';
  userCount?: number;
  description?: string;
  image?: string;
  activeUsers?: number;
}

export interface UserMarkerProps {
  user: User;
  map: mapboxgl.Map;
  onUserClick?: (user: User) => void;
}

export interface VenueMarkerProps {
  venue: Venue;
  map: mapboxgl.Map;
  onVenueClick?: (venue: Venue) => void;
}

export interface MapboxMapProps {
  userLocation: Location | null;
  selectedLocation: Location | null;
  onUserClick: (user: User) => void;
  onVenueClick: (venue: Venue) => void;
  showHeatMap?: boolean;
  hideUserLocation?: boolean;
  is3DMode?: boolean;
  onMapInitialized?: (map: mapboxgl.Map) => void;
  filters?: Record<string, any>;
}

export interface MapboxTokenInputProps {
  onSubmit: (token: string) => void;
  onSkip: () => void;
  open: boolean;
}
