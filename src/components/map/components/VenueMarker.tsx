
import React from 'react';
import mapboxgl from 'mapbox-gl';
import { VenueMarkerProps, Venue } from '../types/markerTypes';
import { 
  createVenueMarkerElement,
  addVenueMarkerHoverEffects,
  createHexGrid,
  createScanLine,
  createHologramEffect,
  createIconContainer,
  createIconGlow,
  createUserCountBadge,
  getVenueTypeIcon
} from '../utils/venueMarkerStyles';
import { createMarkerAnimations } from '../utils/markerAnimations';

class VenueMarker extends React.Component<VenueMarkerProps> {
  markerRef: mapboxgl.Marker | null = null;
  
  componentDidMount() {
    this.createMarker();
  }
  
  componentDidUpdate(prevProps: VenueMarkerProps) {
    if (prevProps.venue.position.lng !== this.props.venue.position.lng || 
        prevProps.venue.position.lat !== this.props.venue.position.lat) {
      if (this.markerRef) {
        this.markerRef.setLngLat([this.props.venue.position.lng, this.props.venue.position.lat]);
      }
    }
    
    if (!this.markerRef) {
      this.createMarker();
    }
  }
  
  createMarker() {
    const { venue, map, onVenueClick } = this.props;
    
    try {
      // Initialize animations
      createMarkerAnimations();
      
      // Create base marker element
      const el = createVenueMarkerElement();
      
      // Add hover effects
      addVenueMarkerHoverEffects(el);
      
      // Add hexagonal grid pattern
      const hexGrid = createHexGrid();
      
      // Add scan line effect
      const scanLine = createScanLine();
      
      // Add holographic effect
      const hologramEffect = createHologramEffect();
      
      // Create icon container
      const iconContainer = createIconContainer();
      
      // Create icon glow effect
      const iconGlow = createIconGlow();
      
      // Set icon based on venue type
      iconContainer.innerHTML = getVenueTypeIcon(venue.type);
      
      // Add user count badge if needed
      if (venue.userCount > 0) {
        const badge = createUserCountBadge(venue.userCount);
        el.appendChild(badge);
      }
      
      // Assemble elements
      el.appendChild(hexGrid);
      el.appendChild(scanLine);
      el.appendChild(hologramEffect);
      el.appendChild(iconGlow);
      el.appendChild(iconContainer);
      
      // Add marker to map
      this.markerRef = new mapboxgl.Marker({
        element: el,
        anchor: 'center'
      })
        .setLngLat([venue.position.lng, venue.position.lat])
        .addTo(map);
      
      // Add click event handler
      el.addEventListener('click', () => {
        onVenueClick && onVenueClick(venue);
      });
      
    } catch (error) {
      console.error("Error creating venue marker:", error);
    }
  }
  
  componentWillUnmount() {
    if (this.markerRef) {
      this.markerRef.remove();
    }
  }
  
  render() {
    return null;
  }
}

export default VenueMarker;
